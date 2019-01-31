local alpha = {
  a = true,
  b = true,
  c = true,
  d = true,
  e = true,
  f = true,
  g = true,
  h = true,
  i = true,
  j = true,
  k = true,
  l = true,
  m = true,
  n = true,
  o = true,
  p = true,
  q = true,
  r = true,
  s = true,
  t = true,
  u = true,
  v = true,
  w = true,
  c = true,
  x = true,
  y = true,
  z = true,
  A = true,
  B = true,
  C = true,
  D = true,
  E = true,
  F = true,
  G = true,
  H = true,
  I = true,
  J = true,
  K = true,
  L = true,
  M = true,
  N = true,
  O = true,
  P = true,
  Q = true,
  R = true,
  S = true,
  T = true,
  U = true,
  V = true,
  W = true,
  X = true,
  Y = true,
  Z = true,
}
alpha["0"] = true
alpha["1"] = true
alpha["2"] = true
alpha["3"] = true
alpha["4"] = true
alpha["5"] = true
alpha["6"] = true
alpha["7"] = true
alpha["8"] = true
alpha["9"] = true

return function (code)
  local char_list = {}
  local str = ""
  for c = 1, #code do
    local char = string.sub(code, c, c)
    if alpha[char] then
      str = str..char
    else
      table.insert(char_list, str)
      table.insert(char_list, char)
      str = ""
    end
  end
  table.insert(char_list, str)
  return char_list
end