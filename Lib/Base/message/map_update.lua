return function(event)
  local pkt = {
    command = "map_update",
    data = game.ecs.entity_list
  }
  event.peer:send(engine.string.serialize(pkt))
end