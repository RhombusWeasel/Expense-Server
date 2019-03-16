local health = {}

function health.new(hp, ap, sp, dmg)
  return {
    hp_max = hp,
    hp = hp,
    ap_max = ap,
    ap = ap,
    sp_max = sp,
    sp = sp,
    dmg = dmg or 0
  }
end

return health