return function(event, pkt)
  local auth = tostring(pkt.token)
  if engine.hosts[auth] then
    engine.hosts[auth].online = true
    if not engine.clients[auth] then engine.clients[auth] = {} end
    engine.clients[auth].peer = event.peer
  else
    engine.hosts[auth] = {
      name = "NOT_SET",
      room = "world",
      online = true,
    }
    engine.clients[auth] = {
      peer = event.peer
    }
  end
  engine.system.save(engine.hosts, "Saved_Data", "host_data")
  engine.message.broadcast(
    {
      command = "message",
      message = pkt.name.." joined the server.",
      col = engine.server_col,
      room = pkt.room,
      name = "SERVER"
    }
  )
end