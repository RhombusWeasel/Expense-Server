local wd = {}

function wd.new(x, y, name)
  return {
    name = name,
    class = "star",
    body = engine.component.body.new(x, y, 96, 96),
    collider = engine.component.collider.new("star", 0, 0),
    star = engine.component.star.new(),
  }
end

return wd