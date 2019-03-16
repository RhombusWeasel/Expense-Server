local function get_entity_bounds(e)
  local hw = (e.collider.w * .5)
  return e.body.x - hw, e.body.y - hw, e.collider.w
end

return function(e1, e2)
  local x1, y1, w1 = get_entity_bounds(e1)
  local x2, y2, w2 = get_entity_bounds(e2)
  if x1 < x2+w2 and x2 < x1+w1 and y1 < y2+w2 and y2 < y1+w1 then
    local dist = math.abs(engine.math.get_distance(e1.body, e2.body))
    if dist < w1 + w2 then
      return true
    end
  end
  return false
end