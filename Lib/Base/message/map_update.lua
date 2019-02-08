return function(event)
  local m_str = engine.string.serialize(game.ecs.entity_list)
  engine.message.broadcast(m_str)
end