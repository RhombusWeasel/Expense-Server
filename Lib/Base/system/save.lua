return function(data, path, name)
  os.execute("sudo mkdir "..path)
  local save = io.open(path.."/"..name..".lua", "w")
  save:write("return "..engine.string.serialize(data))
  save:close()
  engine.debug_text("Last Message", "Data saved.")
end