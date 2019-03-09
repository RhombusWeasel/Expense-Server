return function(data, path, name)
  love.filesystem.createDirectory(path)
  local save = io.open(path.."/"..name..".lua", "w")
  save:write("return "..engine.string.serialize(data))
  save:close()
  engine.log("Data saved to "..path.."/"..name..".lua")
end