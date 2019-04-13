local m = 60
local h = 60 * 60

return function (seconds)
  seconds = tonumber(seconds)
  if seconds <= 0 then
    return "00:00:00";
  else
    local hours = string.format("%02.f", math.floor(seconds / h));
    local mins = string.format("%02.f", math.floor(seconds / m - (hours * m)));
    local secs = string.format("%02.f", math.floor(seconds - hours * h - mins * m));
    return hours..":"..mins..":"..secs
  end
end