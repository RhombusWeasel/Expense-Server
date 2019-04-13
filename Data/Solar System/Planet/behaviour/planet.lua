local planet = engine.class:extend()
      planet.requirements = {"body", "planet"}

function planet:update(dt, ent)
  ent.body.r = ent.body.r + .001
  ent.planet.cloud_angle = ent.planet.cloud_angle + 0.0015
end

return planet