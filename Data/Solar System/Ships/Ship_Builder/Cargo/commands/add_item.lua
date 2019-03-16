return function (ship, item, amt, price)
  ship.cargo.total = ship.cargo.total + amt
  for i = 1, #ship.cargo.goods do
    if ship.cargo.goods[i].item == item then
      local goods = ship.cargo.goods[i]
      local tot_price = (goods.amount * goods.price) + (amt * price)
      local tot_per_unit = tot_price / (goods.amount + amt)
      goods.amount = goods.amount + amt
      goods.price = tot_per_unit
      return
    end
  end
  table.insert(ship.cargo.goods, {item = item, label = engine.recipes[item].label, amount = amt, price = price})
end