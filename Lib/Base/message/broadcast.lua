return function(pkt)
  local p = engine.string.serialize(pkt)
  for k, v in pairs(engine.hosts) do
    if engine.clients[k] then
      engine.clients[k].peer:send(p)
    end
  end
end