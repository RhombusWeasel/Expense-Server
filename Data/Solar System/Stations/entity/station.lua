local station = {}

function station.new(star, parent, radius, owner, product, cargo_amt, ports)
  ports = ports or 4
  local p = game.ecs:get_entity(parent)
  local stat = {
    owner           = owner,
    class           = "station",
    model           = "factory",
    cash            = 1000000,
    ports           = ports,
    home_star       = star,
    product         = product,
    
    body            = engine.component.body.new(p.body.x, p.body.y, 64, 64, 0),
    image           = engine.component.image.new(product.."_factory", 64, 64, -90, .1),
    collider        = engine.component.collider.new("station", 16, 0),
    orbit           = engine.component.orbit.new(star, parent, radius),
    crafting        = engine.component.crafting.new(product, cargo_amt),
    hangar          = engine.component.hangar.new(#engine.recipes[product].ingredients)
    
  }
  if owner ~= 1 then
    stat.ai = true
  end
  return stat
end

return station