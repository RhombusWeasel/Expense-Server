--Extend the base class:
local move = engine.class:extend()
      --All systems must have a list of required components
      move.requirements = {"body", "vel", "collider"}
      move.w = engine.screen_width
      move.w = engine.screen_height

--[[Init:
  system:init gets called once when the system is added to the ECS
]]
function move:init()
  
end

--[[Pre Update:
  Pre update is called once at the start of each update cycle and is passed delta time as dt
]]
function move:pre_update(dt)
  
end

--[[Update:
  Update gets called once for each entity subscribed to this system per update cycle.
  The Update function is always passed delta time as dt and the current entity to update as ent
]]
function move:update(dt, ent)
  ent.body.x = ent.body.x + ent.vel.x
  ent.body.y = ent.body.y + ent.vel.y
  local hw = (move.w * .5)
  local hh = (move.h * .5)
  local r = ent.body.w * .5
  if ent.body.x - r < -hw or ent.body.x + r > hw then
    ent.vel.x = ent.vel.x * -1
  end
  if ent.body.y - r < -hh or ent.body.y + r > hh then
    ent.vel.y = ent.vel.y * -1
  end
end

--[[Post Update:
  Post Update is called once at the end of the update cycle.
]]
function move:post_update(dt)
  
end

return move