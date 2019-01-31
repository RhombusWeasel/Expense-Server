return function (str)
  local words = {}
  for w in str:gmatch("%S+") do
    table.insert(words, w)
  end
  return words
end