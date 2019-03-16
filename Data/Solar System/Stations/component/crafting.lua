--[[Crafting Component:
  The crafting component is passed a product and an amount which are the product to make and the amount to make each cycle
  the time to make each good is determined by the recipe
]]

local craft = {}

function craft.new(product, cargo_amt)
  if engine.recipes[product] == nil then
    engine.log("ERROR: Recipe for "..product.." does not exist.")
    return {}
  end
  local recipe = engine.recipes[product]
  local cr = {}
  cr.product = product
  cr.time = recipe.crafting_time
  cr.elapsed = -1
  cr.max_cargo = cargo_amt
  cr.inventory = {}
  for i = 1, #recipe.ingredients do
    cr.inventory[recipe.ingredients[i].name] = {
      item = recipe.ingredients[i].name,
      amount = cargo_amt / 5,
      max = cargo_amt,
      price = 10,
    }
  end
  cr.output = {}
  for i = 1, #recipe.output do
    cr.output[recipe.output[i].name] = {
      item = recipe.output[i].name,
      amount = cargo_amt,
      max = cargo_amt,
      price = 0,
    }
  end
  return cr
end

return craft