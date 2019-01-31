return function (p1, p2)
  local dx = p2.x - p1.x
  local dy = p2.y - p1.y
  return math.atan2(dy, dx)
end