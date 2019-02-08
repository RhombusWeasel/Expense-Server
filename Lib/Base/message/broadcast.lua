return function(pkt)
  local p = engine.string.serialize(pkt)
  for k, v in pairs(hosts) do
    engine.clients[k].peer:send(p)
  end
end