local star = {}

function star.new()
  return {
    max_planets = math.random(1, 8),
    planets = {},
    step = 1,
    step_inc = math.random(1, 2) / 100,
  }
end

return star