return function(item, amt, ship, stat)
  local t_data = stat.crafting.output[item]
  if t_data.amount < amt then
    amt = t_data.amount
  end
  if amt + ship.cargo.total > ship.cargo.max then
    amt = ship.cargo.max - ship.cargo.total
  end
  if amt <= 0 then
    return
  end
  local tot_cost = amt * t_data.price
  if game.players[ship.owner].cash < tot_cost then
    engine.log("Insufficient funds.")
    return
  end
  engine.log("Ship "..ship.id.." buying "..amt.." "..engine.recipes[item].label..".", "trade")
  game.players[ship.owner].cash = game.players[ship.owner].cash - tot_cost
  game.players[stat.owner].cash = game.players[stat.owner].cash + tot_cost
  t_data.amount = t_data.amount - amt
  engine.commands.add_item(ship, item, amt, t_data.price)
end