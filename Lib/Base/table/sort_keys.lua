return function (tab)
  local list = {}
  for k, v in pairs(tab) do
    table.insert(list, k)
  end
  local sort_func = function(a, b) return a<b end
  table.sort(list, sort_func)
  return list
end