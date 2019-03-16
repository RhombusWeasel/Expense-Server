local thruster = {}

function thruster.new(dock, thrust, max, particles)
  return {
    target_id = -1,
    docked = dock,
    acc = thrust < max and thrust or max,
    speed = 0,
    max = max,
    particles = particles ~= nil and particles or {},
  }
end

return thruster