--[[
  An ECS system by Pete Hunter.
  Each update the ECS will sequentially step through each system in the order added and update each entity assigned to that system.
]]

local ecs = engine.class:extend()

--[[ECS Init:
  Initialize the entity list and the system list.
]]
function ecs:init()
  self.entity_list = {}
  self.system_list = {}
  self.selected_list = {}
  self.max_entities = 0
end

--[[Add a new system:
  Each system is a self contained class.
  
  Each system must contain an indexed list of requirements: - sys.requirements = {"body", "collider", "etc"}
      This table will be iterated when a new entity is added to the system
      to determine if this system needs to update the entity
  
  Each system must contain an update method which will receive the arguments:
      dt  - The current delta time.
      ent - The entity to update.
  
  Each system may contain a pre_update method which is called once at the start of each update cycle
]]

function ecs:add_system(sys, ...)
  local s = sys:new(...)
  if s.setup ~= nil then
    s:setup()
  end
  table.insert(self.system_list, s)
  self.system_list[#self.system_list].update_list = {}
end

function ecs:check_system(sys, obj)
  if sys.requirements == nil then return false end
  for i = 1, #sys.requirements do
    found = false
    for k, _ in pairs(obj) do
      if k == sys.requirements[i] then
        found = true
        break
      end
    end
    if not found then return false end
  end
  return true
end

function ecs:update_system(dt, sys)
  if sys.pre_update ~= nil then
    sys:pre_update(dt)
  end
  if sys.update_list[1] ~= nil then
    for i = 1, #sys.update_list do
      sys:update(dt, self.entity_list[sys.update_list[i]])
    end
  end
  if sys.post_update ~= nil then
    sys:post_update(dt)
  end
end

--[[Add a new Entity:
  Each entity added to the system must be a flat table with no functions inside.
  This follows the Objects as Data paradigm where the methods you would usually attach are the systems you add above
]]
function ecs:next_id()
  local id = 0
  for i = 1, #self.entity_list + 1 do
    if self.entity_list[i] == nil or self.entity_list == "none" then
      id = i
    end
  end
  if id > self.max_entities then
    self.max_entities = id
  end
  return id
end

function ecs:add_entity(obj, ...)
  local id = self:next_id()
  self.entity_list[id] = obj.new(...)
  self.entity_list[id].id = id
  self.entity_list[id].is_dead = false
  self.selected_list[id] = false
  for i = 1, #self.system_list do
    if self:check_system(self.system_list[i], self.entity_list[id]) then
      table.insert(self.system_list[i].update_list, id)
    end
  end
  return id
end

function ecs:remove_entity(id)
  for s = 1, #self.system_list do
    if self.system_list[s].update_list[1] ~= nil then
      for e = #self.system_list[s].update_list, 1, -1 do
        if self.system_list[s].update_list[e] == id then
          table.remove(self.system_list[s].update_list, e)
        end
      end
    end
  end
  self.entity_list[id] = "none"
end

function ecs:update(dt)
  --if self.system_list[1] == nil then return end
  --if self.entity_list[1] == nil then return end
  print(self.max_entities)
  print(type(self.max_entities))
  for i = 1, self.max_entities do
    if self.entity_list[i] ~= "none" then
      if self.entity_list[i].is_dead then
        self:remove_entity(i)
      end
    end
  end
  for i = 1, engine.game_speed do
    for i = 1, #self.system_list do
      self:update_system(dt, self.system_list[i])
    end
  end
end

--[[Get Entity:
  Returns the entity at [id]
]]
function ecs:get_entity(id)
  return self.entity_list[id]
end

--[[Clear Selection:
  Clears the is_selected tag from all entities.
]]
function ecs:clear_selection()
  for i = 1, #self.selected_list do
    self.selected_list[i] = false
  end
end

--[[Select Entity:
  Sets the is_selected tag for entity [id].
]]
function ecs:select_entity(id)
  self.selected_list[id] = true
end

return ecs