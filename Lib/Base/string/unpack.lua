return function(s)
	local d, result = loadstring("data="..s)
  r_tab = d()
  return data
end