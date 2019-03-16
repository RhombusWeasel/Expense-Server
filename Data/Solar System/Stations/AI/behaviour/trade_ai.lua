local ai = engine.class:extend()
      ai.requirements = {"body", "crafting", "hangar", "ai"}
      engine.ai_station_list = {}

function ai:init_lists()
  engine.ai_station_list = {}
  local star_count = 0
  for i = 1, #game.ecs.entity_list do
    local ent = game.ecs:get_entity(i)
    local class = ent.class
    if ent ~= "none" then
      if class == "star" then
        star_count = ent.id
        engine.ai_station_list[star_count] = {}
      elseif class == "station" then
        for k, v in pairs(ent.crafting.output) do
          local goods = v.item
          if engine.ai_station_list[star_count] ~= nil then
            if engine.ai_station_list[star_count][goods] == nil then
              engine.ai_station_list[star_count][goods] = {}
            end
            table.insert(engine.ai_station_list[star_count][goods], ent.id)
          end
        end
      end
    end
  end
end

function ai:buy_ships(ent)
  if #ent.hangar.ships < ent.hangar.max then
    for k, v in pairs(ent.crafting.inventory) do
      local id = game.ecs:add_entity(engine.entity.shuttle, ent.id, ent.id)
      local ship = game.ecs:get_entity(id)
      ship.goods = k
      ship.colour = engine.recipes[ent.crafting.product].colour
      table.insert(ent.hangar.ships, id)
      ent.cash = ent.cash - 50000
    end
  end
end

function ai:find_goods(stat, goods)
  local id = -1
  local lowest_price = math.huge
  local found = false
  if engine.ai_station_list[stat.home_star] ~= nil and engine.ai_station_list[stat.home_star][goods] ~= nil then
    if stat.crafting.inventory[goods].amount < stat.crafting.max_cargo / 2 and stat.cash > 0 then
      for i = 1, #engine.ai_station_list[stat.home_star][goods] do
        local target = game.ecs:get_entity(engine.ai_station_list[stat.home_star][goods][i])
        for k, v in pairs(target.crafting.output) do
          if v.item == goods then
            found = true
            local price = v.price
            if price < lowest_price then
              lowest_price = price
              id = target.id
            elseif price == v.price then
              local r = math.random()
              if r > .5 then
                id = target.id
              end
            end
          end
        end
      end
    end
  end
  if not found then
    self:init_lists()
  end
  return id
end

function ai:buy_goods(stat, supplier, ship)
  local amount = ship.cargo.max - ship.cargo.total
  local available = supplier.crafting.output[ship.goods].amount
  local price = supplier.crafting.output[ship.goods].price
  if available < amount then
    amount = math.floor(available)
  end
  local total = amount * price
  if total > stat.cash then
    amount = stat.cash / price
    total = amount * price
  end
  stat.cash = stat.cash - total
  supplier.cash = supplier.cash + total
  supplier.crafting.output[ship.goods].amount = supplier.crafting.output[ship.goods].amount - amount
  table.insert(ship.cargo.goods, {item = ship.goods, amount = amount, price = price})
  ship.cargo.total = ship.cargo.total + amount
  engine.commands.set_target(ship, stat.id)
end

function ai:unload_goods(stat, ship)
  for i = #ship.cargo.goods, 1, -1 do
    local goods = ship.cargo.goods[i].item
    local prev_amount = stat.crafting.inventory[goods].amount
    local prev_price = prev_amount * stat.crafting.inventory[goods].price
    local new_amount = ship.cargo.goods[i].amount
    local new_price = new_amount * ship.cargo.goods[i].price
    local new_total = prev_amount + new_amount
    local tot_cost = prev_price + new_price
    local tot_price = math.ceil(tot_cost / new_total)
    stat.crafting.inventory[goods].amount = stat.crafting.inventory[goods].amount + new_amount
    stat.crafting.inventory[goods].price = tot_price
    ship.cargo.total = ship.cargo.total - new_amount
    table.remove(ship.cargo.goods, i)
  end
end

function ai:update_ship(stat, ent)
  if ent.engine.docked == stat.id then
    if ent.cargo.total > 0 then
      self:unload_goods(stat, ent)
    end
    local target = self:find_goods(stat, ent.goods)
    if target ~= stat.id and target > 0 then
      engine.commands.set_target(ent, target)
    end
  elseif ent.engine.docked ~= -1 then
    local supplier = game.ecs:get_entity(ent.engine.docked)
    self:buy_goods(stat, supplier, ent)
  end
end

function ai:update(dt, ent)
  self:buy_ships(ent)
  for i = 1, #ent.hangar.ships do
    self:update_ship(ent, game.ecs:get_entity(ent.hangar.ships[i]))
  end
  local recipe = engine.recipes[ent.product]
  local total = 0
  for i = 1, #recipe.ingredients do
    local goods = recipe.ingredients[i].name
    ent.crafting.inventory[goods].amount = ent.crafting.inventory[goods].amount
    local paid = ent.crafting.inventory[goods].price
    local cost = recipe.ingredients[i].amount * paid
    total = total + cost
  end
  for i = 1, #recipe.output do
    local goods = recipe.output[i].name
    local total_cost = total / recipe.output[i].amount
    local total_amount = ent.crafting.output[goods].amount
    ent.crafting.output[goods].amount = ent.crafting.output[goods].amount
    ent.crafting.output[goods].price = math.ceil(engine.math.map(total_amount, 0, ent.crafting.max_cargo, total_cost * 3, total_cost * 1.1))
  end
end

return ai