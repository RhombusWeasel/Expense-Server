local function check_recipe(ingredients, inv)
  for i = 1, #ingredients do
    local item = ingredients[i].name
    if inv[item].amount < ingredients[i].amount then
      return false
    end
  end
  return true
end

local function has_space(ent)
  local recipe = engine.recipes[ent.crafting.product]
  for i = 1, #recipe.output do
    local item = recipe.output[i].name
    if ent.crafting.output[item].amount + recipe.output[i].amount > ent.crafting.max_cargo then
      return false
    end
  end
  return true
end

local function use_ingredients(ingredients, inv)
  for i = 1, #ingredients do
    local item = ingredients[i].name
    if inv[item].amount >= ingredients[i].amount then
      inv[item].amount = inv[item].amount - ingredients[i].amount
    end
  end
end

local crafter = engine.class:extend()
      crafter.requirements = {"crafting"}

function crafter:update(dt, ent)
  local recipe = engine.recipes[ent.crafting.product]
  --Check Timer:
  if ent.crafting.elapsed >= ent.crafting.time then
    for i = 1, #recipe.output do
      local name = recipe.output[i].name
      local amount = recipe.output[i].amount
      ent.crafting.output[name].amount = ent.crafting.output[name].amount + amount
    end
    ent.crafting.elapsed = -1
  end
  --Check Ingredients:
  if ent.crafting.elapsed == -1 then
    if check_recipe(recipe.ingredients, ent.crafting.inventory) then
      if has_space(ent) then
        use_ingredients(recipe.ingredients, ent.crafting.inventory)
        ent.crafting.elapsed = 0
      end
    end
  end
  --Increment Timer:
  if ent.crafting.elapsed >= 0 then
    ent.crafting.elapsed = ent.crafting.elapsed + dt
  end
end

return crafter