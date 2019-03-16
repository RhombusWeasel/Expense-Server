--Extend the base class:
local damage = engine.class:extend()
      --All systems must have a list of required components
      damage.requirements = {"collider", "health"}

--[[Init:
  system:init gets called once when the system is added to the ECS
]]
function damage:init()
  
end

--[[Pre Update:
  Pre update is called once at the start of each update cycle and is passed delta time as dt
]]
function damage:pre_update(dt)
  
end

--[[Update:
  Update gets called once for each entity subscribed to this system per update cycle.
  The Update function is always passed delta time as dt and the current entity to update as ent
]]
function damage:update(dt, ent)
  if ent.health == nil then return end
  if ent.health.dmg > 0 then
    local dmg = ent.health.dmg
    if dmg < ent.health.sp then
      ent.health.sp = ent.health.sp - dmg
      return
    else
      dmg = dmg - ent.health.sp
      ent.health.sp = 0
    end
    if dmg < ent.health.ap then
      ent.health.ap = ent.health.ap - dmg
      return
    else
      dmg = dmg - ent.health.ap
      ent.health.ap = 0
    end
    if dmg < ent.health.hp then
      ent.health.hp = ent.health.hp - dmg
      return
    else
      dmg = dmg - ent.health.hp
      ent.health.hp = 0
    end
    if ent.health.hp <= 0 then
      ent.is_dead = true
    end
    ent.health.dmg = 0
  end
end

--[[Post Update:
  Post Update is called once at the end of the update cycle.
]]
function damage:post_update(dt)
  
end

return damage