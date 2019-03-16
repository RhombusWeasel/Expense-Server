local sqrt = math.sqrt

return function(e1, e2)
  local dx = e2.body.x - e1.body.x
  local dy = e2.body.y - e1.body.y
  local dist = sqrt((dx * dx) + (dy * dy))
  return dist
end