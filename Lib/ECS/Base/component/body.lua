local body = {}

function body.new(x, y, w, h)
  return {
    x = x,
    y = y,
    w = w,
    h = h,
    r = 0
  }
end

return body