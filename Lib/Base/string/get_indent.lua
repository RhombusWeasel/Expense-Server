return function (str, mat)
  for i = 1, #str do
    if string.sub(str, i, i) ~= mat then
      return i - 1
    end
  end
  return #str
end