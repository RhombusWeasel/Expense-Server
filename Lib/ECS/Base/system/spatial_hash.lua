local fl = math.floor

local spHash = engine.class:extend()

function spHash:init(cellSize)
  self.cell_size = cellSize
  self.cells = {}
  self.warnings = {}
end

function spHash:get_cell_position(x, y)
  return fl(x / self.cell_size), fl(y / self.cell_size)
end

function spHash:get_chunk_list(x, y, w, h)
  local rTab = {}
  local minx, miny = self:get_cell_position(x - (w * .5), y - (h * .5))
  local maxx, maxy = self:get_cell_position(x + (w * .5), y + (h * .5))
  for cx = minx, maxx do
    for cy = miny, maxy do
      if self.cells[cx] ~= nil and self.cells[cx][cy] ~= nil then
        table.insert(rTab, {x = cx, y = cy})
      end
    end
  end
  return rTab
end

function spHash:add(x, y, w, h, id)
  local minx, miny = self:get_cell_position(x - (w * .5), y - (h * .5))
  local maxx, maxy = self:get_cell_position(x + (w * .5), y + (h * .5))
  for cx = minx, maxx do
    if self.cells[cx] == nil then
      self.cells[cx] = {}
    end
    for cy = miny, maxy do
      if self.cells[cx][cy] == nil then
        self.cells[cx][cy] = {count = 1}
      end
      local chunkPos = {x = cx, y = cy}
      self.cells[cx][cy][self.cells[cx][cy].count] = id
      self.cells[cx][cy].count = self.cells[cx][cy].count + 1
      if self.cells[cx][cy].count > 1 then
        local found = false
        for i = 1, #self.warnings do
          if self.warnings[i].x == chunkPos.x then
            if self.warnings[i].y == chunkPos.y then
              found = true
            end
          end
        end
        if not found then
          table.insert(self.warnings, chunkPos)
        end
      end
    end
  end
end

function spHash:get_entity_list(x, y, w, h)
  local e_list = {}
  local minx, miny = self:get_cell_position(x - (w * .5), y - (h * .5))
  local maxx, maxy = self:get_cell_position(x + (w * .5), y + (h * .5))
--  self.operations = 0
  for cx = minx, maxx do
--    self.operations = self.operations + 1
    if self.cells[cx] ~= nil then
      for cy = miny, maxy do
--        self.operations = self.operations + 1
        if self.cells[cx][cy] ~= nil then
          for i = 1, #self.cells[cx][cy] do
--            self.operations = self.operations + 1
            local val = self.cells[cx][cy][i]
            if e_list[1] == nil then
              table.insert(e_list, val)
            else
              local found = false
              for j = 1, #e_list do
--                self.operations = self.operations + 1
                if val == e_list[j] then
                  found = true
                end
              end
              if not found then
                table.insert(e_list, val)
              end
            end
          end
        end
      end
    end
  end
--  engine.log(self.operations)
  return e_list[1] ~= nil and e_list or false
end

function spHash:check_collide(x, y, w, h)
  local hw, hh = w * .5, h * .5
  local minx, miny = self:get_cell_position(x - hw, y - hh)
  local maxx, maxy = self:get_cell_position(x + hw, y + hh)
  local r_tab = {}
  for cx = minx, maxx do
    if self.cells[cx] ~= nil then
      for cy = miny, maxy do
        if self.cells[cx][cy] ~= nil then
          for i = 1, #self.cells[cx][cy] do
            local tid = self.cells[cx][cy][i]
            local e = game.ecs:get_entity(tid)
            local hw = e.body.w * .5
            local hh = e.body.h * .5
            local x1, y1, w1, h1 = x - (w * .5), y - (h * .5), w, h
            local x2, y2, w2, h2 = e.body.x - hw, e.body.y - hh, e.body.w, e.body.h
            if (x1 < x2 + w2) and (x2 < x1 + w1) and (y1 < y2 + h2) and (y2 < y1 + h1) then
              table.insert(r_tab, tid)
            end
          end
        end
      end
    end
  end
  return #r_tab >= 1 and r_tab or false
end

return spHash