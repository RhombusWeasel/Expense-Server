return function(pkt)
  local p = engine.string.serialize(pkt)
  engine.host:broadcast(p)
end