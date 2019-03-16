local abs = math.abs
local sqrt = math.sqrt
local min = math.min
local atan2 = math.atan2

local thruster = engine.class:extend()
      thruster.requirements = {"body", "engine"}

function thruster:update(dt, ent)
  --Update position if entity is docked..
  if ent.engine.travel_time == nil then
    ent.engine.travel_time = 0
    ent.engine.time = 0
  end
  if ent.engine.docked ~= -1 then
    local dok = game.ecs:get_entity(ent.engine.docked)
    ent.body.x = dok.body.x
    ent.body.y = dok.body.y
    ent.engine.target_id = -1
    return
  end
  local target_object = game.ecs:get_entity(ent.engine.target_id)
  if ent.engine.travel_time == 0 then
    local distance = engine.commands.get_distance(ent, target_object)
    ent.engine.start = {
      x = ent.body.x,
      y = ent.body.y,
    }
    ent.engine.change = {
      x = target_object.body.x - ent.body.x,
      y = target_object.body.y - ent.body.y,
    }
    ent.engine.travel_time = distance / ent.engine.max
    ent.engine.time = dt
  end
  if ent.engine.time < ent.engine.travel_time then
    ent.body.x = engine.tween.ease_in_out(ent.engine.time, ent.engine.start.x, ent.engine.change.x, ent.engine.travel_time)
    ent.body.y = engine.tween.ease_in_out(ent.engine.time, ent.engine.start.y, ent.engine.change.y, ent.engine.travel_time)
    ent.body.r = engine.math.angle_between(ent.body, target_object.body)
    ent.engine.time = ent.engine.time + dt
  else
    ent.engine.docked = ent.engine.target_id
    ent.engine.travel_time = 0
  end
end

return thruster