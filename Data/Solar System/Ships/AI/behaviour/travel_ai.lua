local ai = engine.class:extend()
      ai.requirements = {"body", "engine", "ai"}

function ai:update(dt, ent)
  if ent.engine.target_id == -1 then
    if ai.planet_list == nil then
      ai.planet_list = {}
      for i = 1, #game.ecs.entity_list do
        local ent = game.ecs.entity_list[i]
        if ent.collider then
          if ent.collider.coll_type == "planet" then
            table.insert(ai.planet_list, ent.id)
            --engine.log("Adding planet "..i.." to planet list.")
          end
        end
      end
    end
    local target = ai.planet_list[love.math.random(1, #ai.planet_list)]
    --engine.log("Sending "..ent.id.." to "..target)
    engine.commands.set_target(ent, target)
  end
end

return ai