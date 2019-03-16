local cargo = {}

function cargo.new(max)
  return {
    total = 0,
    max = max,
    goods = {},
  }
end

return cargo