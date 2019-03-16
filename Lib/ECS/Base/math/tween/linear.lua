return function (time, start, chg, duration)
  return (chg * (time / duration)) + start
end