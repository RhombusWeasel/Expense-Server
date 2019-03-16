local mine = {}

function mine.new(asteroid_id, product, cargo_amt, owner, ports)
  owner = owner or -1
  ports = ports or 4
  local p = game.ecs:get_entity(asteroid_id)
  local stat = {
    
    owner           = owner,
    class           = "station",
    model           = "mine",
    asteroid_id     = asteroid_id,
    cash            = 1000000,
    ports           = ports,
    home_star       = p.orbit.star,
    product         = product,
    
    body            = engine.component.body.new(p.body.x, p.body.y, 64, 64, 0),
    image           = engine.component.image.new(product.."_mine", 64, 64, 0, .1),
    collider        = engine.component.collider.new("station", 16, 0),
    crafting        = engine.component.crafting.new(product, cargo_amt),
    hangar          = engine.component.hangar.new(#engine.recipes[product].ingredients)
    
  }
  if owner ~= 1 then
    stat.ai = true
  end
  return stat
end

return mine