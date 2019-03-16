return function (args)
  if #args < 4 then
    engine.log("Error: Insufficient arguments given.")
    engine.log("Usage: station [STR product] [INT star_id] [INT parent_id] [INT cargo_amount]")
    return
  end
  if not tonumber(args[2]) or not tonumber(args[3]) or not tonumber(args[4]) then
    engine.log("Error: Incorrect arguments given.")
    engine.log("Usage: station [STR product] [INT star_id] [INT parent_id] [INT cargo_amount]")
    return
  end
  if engine.recipes[args[1]] == nil then
    engine.log("Error: Incorrect product given.")
    engine.log("Usage: station [STR product] [INT star_id] [INT parent_id] [INT cargo_amount]")
  end
  local product = args[1]
  local star = tonumber(args[2])
  local orbit = tonumber(args[3])
  local hold = tonumber(args[4])
  local r_min = 10000
  local r_max = 50000
  local id = game.ecs:add_entity(engine.entity.station, star, orbit, math.random(r_min, r_max), 2, product, hold, 2)
  if not engine.ai_station_list[star] then
    engine.ai_station_list[star] = {}
  end
  if not engine.ai_station_list[star][product] then
    engine.ai_station_list[star][product] = {}
  end
  table.insert(engine.ai_station_list[star][product], id)
end