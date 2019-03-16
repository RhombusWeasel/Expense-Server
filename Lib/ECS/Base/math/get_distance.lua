return function(e1, e2)
  local dx = e2.x - e1.x
  local dy = e2.y - e1.y
  return math.sqrt((dx * dx) + (dy * dy))
end