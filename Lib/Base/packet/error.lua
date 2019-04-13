return function (msg)
  local pkt = {command = "message", name = "SERVER", col = engine.server_col, message = msg}
  return engine.string.serialize(pkt)
end