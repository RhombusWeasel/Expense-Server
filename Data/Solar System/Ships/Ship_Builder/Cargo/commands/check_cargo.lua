return function(ship, item)
  for i = 1, #ship.cargo.goods do
    if ship.cargo.goods[i].item == item then
      return ship.cargo.goods[i].amount
    end
  end
  return 0
end