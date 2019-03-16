--[[ECS Unit Test - By Pete Hunter.
  A test of the ECS system, it imports a test system and 1000 entities
]]
local state = {}

local function randomVector(mult)
  return math.random() * mult, math.random() * mult
end

function state.enter()
  game.ecs = engine.system.ecs:new()
  game.ecs:add_system(engine.behaviour.move)
  for i = 1, 10000 do
    local x, y = randomVector(1)
    local vx, vy = randomVector(1000)
    game.ecs:add_entity(engine.entity.test_entity, x * engine.screen_width, y * engine.screen_height, vx, vy)
  end
end

function state.update(dt)
  game.ecs:update(dt)
end

function state.draw()
  love.graphics.setColor(100,255,200,2)
  for i = 1, #game.ecs.entity_list do
    local pos = game.ecs.entity_list[i].body
    love.graphics.circle("fill", pos.x, pos.y, 3)
  end
end

return state