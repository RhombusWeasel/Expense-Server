return function(str, l, char)
  if char == nil then char = ' ' end
  local f_len = (l - #str) / 2
  if #str % 2 ~= 0 and l % 2 ~= 0 then
    return string.rep(char, f_len)..str..string.rep(char, f_len)
  elseif #str % 2 == 0 and l % 2 == 0 then
    return string.rep(char, f_len)..str..string.rep(char, f_len)
  end
  return string.rep(char, f_len)..str..string.rep(char, f_len + 1)
end