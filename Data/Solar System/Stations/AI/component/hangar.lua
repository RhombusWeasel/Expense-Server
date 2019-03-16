local hangar = {}

function hangar.new(max)
  return {
    total = 0,
    max   = max,
    ships = {},
  }
end

return hangar