local pl = {}

function pl.new(size, texture)
  return {
    ground = texture or "rock",
    clouds = "white",
    cloud_angle = 0,
    ground_id = math.ceil(love.math.random(1, engine.texture_variation)),
    clouds_id = math.ceil(love.math.random(1, engine.texture_variation)),
    shade_id = math.ceil(love.math.random(1, engine.texture_variation)),
    size = size,
  }
end

return pl