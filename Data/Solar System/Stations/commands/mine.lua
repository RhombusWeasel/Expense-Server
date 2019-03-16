return function (args)
  if #args < 2 then
    engine.log("Error: Insufficient arguments given.")
    engine.log("Usage: mine [STR product] [INT cargo_amount]")
    return
  end
  if not tonumber(args[2]) then
    engine.log("Error: Incorrect arguments given.")
    engine.log("Usage: mine [STR product] [INT cargo_amount]")
    return
  end
  if engine.recipes[args[1]] == nil then
    engine.log("Error: Incorrect product given.")
    engine.log("Usage: mine [STR product] [INT cargo_amount]")
  end
  local product = args[1]
  local hold = tonumber(args[2])
  for i = 1, #game.ecs.entity_list do
    local ent = game.ecs:get_entity(i)
    if ent.class == "asteroid" then
      if ent.resource.name == product then
        if not ent.has_mine then
          game.ecs:add_entity(engine.entity.mine, i, product, hold, 2)
          ent.has_mine = true
          return
        end
      end
    end
  end
  engine.log("No "..product.." asteroids available.")
end