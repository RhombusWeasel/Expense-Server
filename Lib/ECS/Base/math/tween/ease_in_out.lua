return function (time, start, chg, duration)
  time = time / (duration / 2)
  if time < 1 then
    return chg / 2 * time * time + start
  end
  return -chg / 2 * ((time - 1) * (time - 2) - time) + start
end