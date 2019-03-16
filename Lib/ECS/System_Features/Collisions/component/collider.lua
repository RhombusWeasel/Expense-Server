local collider = {}

function collider.new(coll_type, r, dmg)
  return {
    coll_type = coll_type,
    w = r,
    dmg = dmg
  }
end

return collider