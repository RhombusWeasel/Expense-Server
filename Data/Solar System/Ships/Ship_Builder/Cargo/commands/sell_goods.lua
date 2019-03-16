return function(item, amt, ship, stat)
  for i = 1, #ship.cargo.goods do
    local t_data = ship.cargo.goods[i]
    if t_data.item == item then
      if t_data.amount < amt then
        amt = t_data.amount
      end
      if stat.crafting.inventory[item].max - stat.crafting.inventory[item].amount < amt then
        amt = stat.crafting.inventory[item].max - stat.crafting.inventory[item].amount
      end
      if amt <= 0 then
        return
      end
      local price = stat.crafting.inventory[item].price
      local tot_cost = amt * price
      game.players[ship.owner].cash = game.players[ship.owner].cash + tot_cost
      game.players[stat.owner].cash = game.players[stat.owner].cash - tot_cost
      t_data.amount = t_data.amount - amt
      ship.cargo.total = ship.cargo.total - amt
      stat.crafting.inventory[item].amount = stat.crafting.inventory[item].amount + amt
      return
    end
  end
end