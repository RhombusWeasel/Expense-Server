return function(args)
  if #args < 3 then
    engine.log("Error: Insufficient arguments provided.")
    engine.log("Usage: spawn_star [INT x_pos] [INT y_pos] [STR template]")
    return
  end
  if not tonumber(args[1]) or not tonumber(args[2]) then
    engine.log("Error: Incorrect arguments given.")
    engine.log("Usage: spawn_star [INT x_pos] [INT y_pos] [STR template]")
    return
  end
  if engine.solar_templates[args[3]] == nil then
    engine.log("Error: Invalid template given.")
    engine.log("Usage: spawn_star [INT x_pos] [INT y_pos] [STR template]")
    return
  end
  local x = tonumber(args[1])
  local y = tonumber(args[2])
  local name =args[3]
  local temp = engine.solar_templates[name]
  local star_name = engine.string.capital(name)
  local star_id = game.ecs:add_entity(engine.entity.white_dwarf, x, y, star_name)
  for p = 1, #temp do
    if temp[p].class == "planet" then
      local p_id = game.ecs:add_entity(engine.entity.test_planet, temp[p].texture, star_id, star_id, temp[p].radius, temp[p].size)
      for m = 1, #temp[p].moons do
        local moon = temp[p].moons[m]
        game.ecs:add_entity(engine.entity.test_moon, moon.texture, star_id, p_id, moon.radius, moon.size)
      end
    elseif temp[p].class == "asteroids" then
      local belt = temp[p]
      local ores = {}
      for k, v in pairs(engine.ores) do
        table.insert(ores, k)
      end
      for i = 1, belt.max do
        local r = math.floor(love.math.random(1, #ores))
        local flux = belt.radius * 0.1
        local r_mod = love.math.random(-flux, flux)
        game.ecs:add_entity(engine.entity.asteroid, star_id, belt.radius + r_mod, ores[r], amt)
      end
    end
  end
end