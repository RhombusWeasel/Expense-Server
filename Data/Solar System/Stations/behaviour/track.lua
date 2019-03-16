local track = engine.class:extend()
      track.requirements = {"body", "asteroid_id"}

function track:update(dt, ent)
  local p = game.ecs:get_entity(ent.asteroid_id)
  ent.body.x = p.body.x
  ent.body.y = p.body.y
end

return track