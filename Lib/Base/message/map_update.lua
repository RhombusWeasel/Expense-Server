return function(event, packet)
  local pkt = {
    command = "map_update",
    data = game.ecs.entity_list,
    e_list = game.entity_grid,
  }
  event.peer:send(engine.string.serialize(pkt))
end