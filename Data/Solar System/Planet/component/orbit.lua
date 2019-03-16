local orb = {}

function orb.new(star_id, parent_id, radius, quadrant)
  local a = math.random(0, 359)
  return {
    star = star_id,
    parent = parent_id,
    radius = radius,
    speed = (1 / radius) / 100,
    angle = a,
    logged = false
  }
end

return orb