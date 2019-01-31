return function(str, l, char)
  if char == nil then char = ' ' end
  return str..string.rep(char, l - #str)
end