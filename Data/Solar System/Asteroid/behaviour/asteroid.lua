local asteroid = engine.class:extend()
      asteroid.requirements = {
        "body",
        "orbit",
        "resource"
      }

function asteroid:update(dt, ent)
  
end

return asteroid