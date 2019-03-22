local collide = engine.class:extend()
      collide.requirements = {"body", "collider"}

function collide:init()
  game.entity_grid = {engine.system.spatial_hash:new(engine.hash_grid_size)}
end

function collide:pre_update(dt)
  table.insert(game.entity_grid, engine.system.spatial_hash:new(engine.hash_grid_size))
  table.remove(game.entity_grid, 1)
end

function collide:update(dt, ent)
  game.entity_grid[1]:add(ent.body.x, ent.body.y, ent.body.w, ent.body.h, ent.id)
end

function collide:post_update(dt)
  local collision_checks = 0
  local list = game.entity_grid[1].warnings
  if list[1] == nil then return end
  for i = 1, #list do
    local ch_pos = list[i]
    local e_list = game.entity_grid[1].cells[ch_pos.x][ch_pos.y]
    if #e_list > 1 then
      for i = 1, #e_list do
        local e_1 = game.ecs:get_entity(e_list[i])
        for j = 1, #e_list do
          if j ~= i then
            local e_2 = game.ecs:get_entity(e_list[j])
            engine.system.collide(e_1, e_2)
            collision_checks = collision_checks + 1
          end
        end
      end
    end
  end
end

return collide