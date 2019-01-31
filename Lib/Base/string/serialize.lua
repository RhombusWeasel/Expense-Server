return function(t, spacing)
  if spacing == nil then spacing = "" end
  local str = "{ \n"
  spacing = spacing.."  "
  for k, v in pairs(t) do
    local key = k.." = "
    if tonumber(k) then
      key = ""
    end
    if type(v) == "string" then
      str = str..spacing..key.."'"..v.."',\n"
    elseif type(v) == "number" then
      str = str..spacing..key..tostring(v)..",\n"
    elseif type(v) == "table" then
      str = str..spacing..key..engine.string.serialize(v, spacing)..",\n"
    end
  end
  spacing = string.sub(spacing, 1, #spacing - 2)
  str = str..spacing.."}"
  return str
end