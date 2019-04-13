local asteroid = {}

function asteroid.new(orbit, radius, resource, amount)
  local p = game.ecs:get_entity(orbit)
  local img_size = 64
  return {
    owner           = "none",
    class           = "asteroid",
    has_mine        = false,
    
    body            = engine.component.body.new(p.body.x, p.body.y, img_size, img_size),
    image           = engine.component.image.new("asteroid", img_size, img_size, 0, 1),
    collider        = engine.component.collider.new("asteroid", 4, 0),
    orbit           = engine.component.orbit.new(orbit, orbit, radius),
    
    health          = engine.component.health.new(100000, 0, 0),
    resource        = engine.component.mine_resource.new(resource, amount)
  }
end

return asteroid