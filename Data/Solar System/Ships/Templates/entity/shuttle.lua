local shuttle = {
  buildTime = 5,
}

function shuttle.new(owner, dock)
  local d = game.ecs:get_entity(dock)
  local s = {
    owner           = owner,
    class           = "ship",
    model           = "shuttle",
    colour          = {0,1,0,1},
    
    body            = engine.component.body.new(d.body.x, d.body.y, 16, 16, 0),
    image           = engine.component.image.new("shuttle", 16, 16, -90, .01),
    collider        = engine.component.collider.new("ship", 4, 0),
    actions         = shuttle.actions,
    
    health          = engine.component.health.new(100, 100, 100),
    engine          = engine.component.thruster.new(dock, 10, 500, {{x = -3, y = -4}, {x = 3, y = -4}}),
    cargo           = engine.component.cargo_bay.new(250)
  }
  return s
end

return shuttle