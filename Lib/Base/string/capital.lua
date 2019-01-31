return function(t)
  return string.upper(string.sub(t, 1, 1))..string.sub(t, 2, #t)
end