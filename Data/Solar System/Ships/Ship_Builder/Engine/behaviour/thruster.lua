local abs = math.abs
local sqrt = math.sqrt
local min = math.min
local atan2 = math.atan2

local thruster = engine.class:extend()
      thruster.requirements = {"body", "engine", "disable"}

function thruster:update(dt, ent)
  --Update position if entity is docked..
  if ent.engine.docked ~= -1 then
    local dok = game.ecs:get_entity(ent.engine.docked)
    ent.body.x = dok.body.x
    ent.body.y = dok.body.y
    return
  end
  
  --Bailout if no target set
  if ent.engine.target_id == -1 then return end
  
  --Get values
  local eng = ent.engine
  local tgt = game.ecs:get_entity(eng.target_id)
  
  --Lerp
  ent.body.x = ent.body.x + engine.math.lerp(ent.body.x, tgt.body.x, ent.engine.speed)
  ent.body.y = ent.body.y + engine.math.lerp(ent.body.y, tgt.body.y, ent.engine.speed)
  ent.body.r = engine.math.angle_between(ent.body, tgt.body)
  
  --Check arrival
  if engine.math.intersect(ent, tgt, .1) then
    ent.engine.docked = ent.engine.target_id
    ent.engine.target_id = -1
    ent.engine.speed = 0
    return
  end
  
  --Accelerate
  local new_spd = ent.engine.speed + ent.engine.acc
  ent.engine.speed = min(new_spd, ent.engine.max)
end

return thruster