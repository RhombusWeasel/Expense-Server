return function(event)
  local time = tostring(os.time())
  local pkt = {command = "authenticate", token = time}
  event.peer:send(engine.string.serialize(pkt))
end