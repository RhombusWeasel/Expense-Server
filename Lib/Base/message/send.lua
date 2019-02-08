return function(event, pkt)
  if engine.hosts[pkt.token].name == "NOT_SET" then
    event.peer:send(engine.packet.error('You have not set a name.  type "/name [name]" to set your name.'))
  else
    pkt.command = "message"
    engine.message.broadcast(pkt)
  end
end