return function(value, iMin, iMax, newMin, newMax)
  return newMin + (newMax - newMin) * ((value - iMin) / (iMax - iMin))
end