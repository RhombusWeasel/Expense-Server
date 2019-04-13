local orbiter = engine.class:extend()
      orbiter.requirements = {"body", "orbit"}

function orbiter:update(dt, ent)
  local parent = game.ecs:get_entity(ent.orbit.parent)
  local x, y = parent.body.x, parent.body.y
  ent.orbit.angle = (ent.orbit.angle + ent.orbit.speed) % 360
  ent.body.x = x + (ent.orbit.radius * math.cos(math.rad(ent.orbit.angle)))
  ent.body.y = y + (ent.orbit.radius * math.sin(math.rad(ent.orbit.angle)))
end

return orbiter