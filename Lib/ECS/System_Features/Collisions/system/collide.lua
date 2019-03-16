local function get_entity_bounds(e)
  local hw = e.body.w * .5
  local hh = e.body.h * .5
  return e.body.x - hw, e.body.y - hh, e.body.w, e.body.h
end

return function(e1, e2)
  if e1.health == nil or e2.health == nil then return end
  local x1, y1, w1, h1 = get_entity_bounds(e1)
  local x2, y2, w2, h2 = get_entity_bounds(e2)
  if x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1 then
    e2.health.dmg = e1.collider.dmg
  end
end