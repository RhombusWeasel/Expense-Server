local planet = {}

function planet.new(texture, star, parent, radius, size)
  local r = size == nil and math.random(15, 20) / 100 or size / 100
  local p = game.ecs:get_entity(parent)
  return {
    class = "planet",
    body = engine.component.body.new(p.body.x, p.body.y, r, r),
    collider = engine.component.collider.new("planet", 10, 0),
    orbit = engine.component.orbit.new(star, parent, radius),
    planet = engine.component.planet.new(r, texture),
  }
end

return planet