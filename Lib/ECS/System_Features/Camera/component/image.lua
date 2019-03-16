local img = {}

function img.new(name, w, h, r, sc)
  return {
    name = name,
    w = w,
    h = h,
    r = math.rad(r) or math.rad(0),
    sc = sc,
  }
end

return img