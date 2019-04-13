return function(args)
  if #args < 3 then
    engine.log("Error: Insufficient arguments given.")
    engine.log("Usage: ship [STR class] [INT docked] [INT owner]")
    return
  end
  if not tonumber(args[2]) or not tonumber(args[3]) then
    engine.log("Error: Incorrect arguments given.")
    engine.log("Usage: ship [STR class] [INT docked] [INT owner]")
    return
  end
  local class = args[1]
  local dock_id = tonumber(args[2])
  local docked = game.ecs:get_entity(dock_id)
  local owner = tonumber(args[3])
  local ent_id = game.ecs:add_entity(engine.entity[class], owner, dock_id)
  local ent = game.ecs:get_entity(ent_id)
  ent.engine.docked = dock_id
  if owner == 1 then
    engine.log("Ship "..ent_id.." docked at "..dock_id..".")
  end
end