local stats = {
  {item = "kale_kelp", max = "2000", mine = false},
  {item = "kale_kelp", max = "2000", mine = false},
  {item = "work_rations", max = "2000", mine = false},
  {item = "iron_ore", max = "2000", mine = true},
  {item = "iron_ore", max = "2000", mine = true},
  {item = "carbon_ore", max = "2000", mine = true},
  {item = "carbon_ore", max = "2000", mine = true},
  {item = "silicon_ore", max = "2000", mine = true},
  {item = "silicon_ore", max = "2000", mine = true},
  {item = "graphene", max = "2000", mine = false},
  {item = "silicene", max = "2000", mine = false},
  {item = "steel_plates", max = "2000", mine = false},
  {item = "bio_plastics", max = "2000", mine = false},
  {item = "soc_chips", max = "2000", mine = false},
  {item = "nano_piduino_boards", max = "2000", mine = false},
  {item = "mining_equipment", max = "2000", mine = false},
}

local state = {}

function compile_starmap()
  game.starmap = {}
  for i = 1, #game.ecs.entity_list do
    local ent = game.ecs:get_entity(i)
    if ent.class == "star" then
      table.insert(game.starmap, ent.id)
      ent.starmap_id = #game.starmap
      ent.planets = {}
      ent.moons = {}
      ent.debris = {}
      ent.ships = {}
      ent.stations = {}
    elseif ent.class == "planet" then
      local star = game.ecs:get_entity(ent.orbit.star)
      table.insert(star.planets, ent.id)
      ent.moons = {}
    elseif ent.class == "moon" then
      local star = game.ecs:get_entity(ent.orbit.star)
      table.insert(star.moons, ent.id)
      local planet = game.ecs:get_entity(ent.orbit.parent)
      table.insert(planet.moons, ent.id)
    elseif ent.class == "asteroid" then
      local star = game.ecs:get_entity(ent.orbit.star)
      table.insert(star.debris, ent.id)
    elseif ent.class == "station" then
      if ent.model ~= "mine" then
        local star = game.ecs:get_entity(ent.orbit.star)
        table.insert(star.stations, ent.id)
      else
        local asteroid = game.ecs:get_entity(ent.asteroid_id)
        local star = game.ecs:get_entity(asteroid.orbit.star)
        table.insert(star.stations, ent.id)
      end
    end
  end
end

function state.startup()
  game.ecs = engine.system.ecs:new()
  game.ecs:add_system(engine.behaviour.asteroid)
  game.ecs:add_system(engine.behaviour.orbiter)
  game.ecs:add_system(engine.behaviour.planet)
  game.ecs:add_system(engine.behaviour.collide)
  game.ecs:add_system(engine.behaviour.damage)
  game.ecs:add_system(engine.behaviour.travel)
  game.ecs:add_system(engine.behaviour.trade_ai)
  game.ecs:add_system(engine.behaviour.crafting)
  game.ecs:add_system(engine.behaviour.track)
  engine.commands.spawn_star({"0", "0", "sol"})
  game.players = {
    engine.player.new(1000000),
    engine.player.new(1000000),
  }
  local r_min = 10000
  local r_max = 50000
  for i = 1, #stats do
    if stats[i].mine then
      engine.commands.mine({stats[i].item, stats[i].max})
    else
      engine.commands.station({stats[i].item, "1", "1", stats[i].max})
    end
  end
  engine.commands.ship({"shuttle", "80", "1"})
  compile_starmap()
end

function state.update(dt)
  game.ecs:update(dt)
end

return state