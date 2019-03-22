--[[Basic class library:
  This simple class lib is added to engine.class, you can create a new class by calling:-
  
  local new_class = engine.class:extend()
  
  Extend does support multiclassing so you can pass another class as an argument to extend.
]]
local class = {}

function log(text)
  print(text)
end

function class:extend(subClass)
  return setmetatable(subClass or {}, {__index = self})
end

function class:new(...)
  local inst = setmetatable({}, {__index = self})
  return inst, inst:init(...)
end

function class:init(...) end

--[[math.round:
  Pass a number [n] and an amount of decimal places to round to [deci].
]]
function math.round(n, deci)
  deci = 10^(deci or 0)
  return math.floor(n*deci+.5)/deci
end

--[[Recursive Load:
  Recursively load files and store them in a table.
]]
local function scandir(directory)
  local i, t, popen = 0, {}, io.popen
  local pfile = popen('ls -a "'..directory..'"')
  for filename in pfile:lines() do
    i = i + 1
    t[i] = filename
  end
  pfile:close()
  return t
end

local function getFile(tab, path, folder, file)
  if tab[folder] == nil then
    tab[folder] = {}
  end
  local ext = string.sub(file, #file - 3, #file)
  file = string.sub(file, 1, #file - 4)
  local filePath = path.."/"..folder.."/"..file
  if ext == ".lua" then
    tab[folder][file] = require(path.."."..folder.."."..file)
  end
  if tab[folder][file] ~= nil then
    print("Loaded : engine."..folder.."."..file)
  end
end

local function getFiles(tab, path, folder)
  local filePath = path
  if folder == nil then
    folder = ""
  else
    filePath = path.."/"..folder
  end
  local data = scandir(filePath)
  for i = 1, #data do
    local file = data[i]
    if file ~= "." and file ~= ".." then
      local f = io.open(filePath.."/"..file, "r")
      local x,err=f:read(1)
      if err == "Is a directory" then
        if folder ~= "" then
          getFiles(tab, filePath, file)
        else
          getFiles(tab, path, file)
        end
      else
        getFile(tab, path, folder, file)
      end
    end
  end
end

--[[Main Functions:
  load_game is called once at program start.

  Update is then looped until the exit condition is met.
]]
local enet = require("enet")
local socket = require("socket")
local dt = 0
local time = socket.gettime()

hosts = {}
clients = {}
names = {}
game = {}
engine = {
  class = class,
  log = log,
  texture_variation = 5,
  game_speed = 1,
  hash_grid_size = 512,
  server_col = {0,1,0,1},
  host = enet.host_create("*:6701"),
  hosts = require("Saved_Data.host_data"),
  players = {},
  clients = {},
  debug_log = {},
  debug_draw = {},
  debug_mode = true,
  debug_count = 0,
  debug_line = 0,
}

local function format_time(s)
  local secs = engine.string.r_pad(tostring(s % 60), 2, "0")
  local mins = engine.string.r_pad(tostring(math.floor(s / 60) % 60), 2, "0")
  local hours = engine.string.r_pad(tostring(math.floor(s / (60 * 60 * 24)) % 24), 2, "0")
  return hours..":"..mins..":"..secs
end

function engine.debug_text(key, value)
  local index = #engine.debug_log + 1
  if engine.debug_mode then
    if engine.debug_log[key] then
      index = engine.debug_log[key].index
      if engine.debug_log[key].value == value then
        return
      end
    else
      engine.debug_log[key] = {
        value = value,
        index = index,
        last = "",
      }
      engine.debug_count = engine.debug_count + 1
      engine.debug_draw[engine.debug_count] = key
      return
    end
    engine.debug_log[key].last = engine.debug_log[key].value
    engine.debug_log[key].value = value
  end
end

function print_debug()
  if engine.debug_mode then
    local l = #engine.debug_draw
    engine.debug_line = engine.debug_line + 1
    if engine.debug_line > l then
      engine.debug_line = 1
    end
    for i = 1, #engine.debug_draw do
      local key = engine.debug_draw[i]
      if engine.debug_log[key].value ~= engine.debug_log[key].last then
        os.execute("ansi --position="..i..",1 --hide-cursor '"..engine.string.l_pad(key, 20)..engine.string.r_pad(tostring(engine.debug_log[key].value), 15).."'")
      end
    end
  end
end

function load_game()
  os.execute("ansi --erase-display=2")
  engine.debug_text("Uptime", "00:00:00")
  engine.debug_text("Tracked values", 0)
  engine.debug_text("Delta Time", math.round(1, 2))
  engine.debug_text("RAM Start", math.round(1, 2))
  engine.debug_text("RAM Usage", math.round(1, 2))
  engine.debug_text("RAM Reclaimed", math.round(1, 2))
  engine.debug_text("Connections", "None")
  engine.debug_text("Last IP", "None")
  engine.debug_text("Last Port", "None")
  engine.debug_text("Last Packet", "None")
  engine.debug_text("Last Message", "None")
  engine.debug_text("Last Disconnect", "None")
  engine.state.solar.startup()
  local time = os.time()
  engine.start_time = time
  engine.uptime = time
  engine.check_time = 0
  engine.connected = 0
end

function update()
  local event = engine.host:service(50)
  while event do
    local pkt = engine.string.unpack(event.data)
    if pkt then
      local p_str = tostring(event.peer)
      local IP_data = engine.string.split(p_str, ":")
      local e_ip = IP_data[1]
      local e_port = IP_data[2]
      engine.debug_text("Last IP", e_ip)
      engine.debug_text("Last Port", e_port)
      if event.type == "receive" then
        engine.debug_text("Last Packet", "Receive")
        engine.debug_text("Last Message", pkt.command)
        if engine.message[pkt.command] then
          engine.message[pkt.command](event, pkt)
        end
      elseif event.type == "connect" then
        engine.debug_text("Last Packet", "Connect")
        engine.connected = engine.connected + 1
        engine.message.auth(event)
      elseif event.type == "disconnect" then
        engine.debug_text("Last Packet", "Disconnect")
        engine.debug_text("Last Disconnect", e_ip)
        engine.connected = engine.connected - 1
        for k, v in pairs(engine.clients) do
          if v.peer == event.peer then
            engine.hosts[k].online = false
            engine.clients[k].peer = nil
          end
        end
      end
    end
    event = engine.host:service()
  end
  local pkt = {
    command = "map_update",
    data = game.ecs.entity_list,
  }
  engine.message.broadcast(pkt)
  engine.pre_ram_count = collectgarbage("count")
  collectgarbage("collect")
  engine.post_ram_count = collectgarbage("count")
  local dt = socket.gettime() - time
  time = socket.gettime()
  engine.uptime = os.time()
  engine.debug_text("Uptime", format_time(engine.uptime - engine.start_time))
  engine.debug_text("Tracked values", engine.debug_count)
  engine.debug_text("Delta Time", math.round(dt, 2))
  engine.debug_text("RAM Start", math.round(engine.pre_ram_count))
  engine.debug_text("RAM Usage", math.round(engine.post_ram_count))
  engine.debug_text("RAM Reclaimed", math.round(engine.post_ram_count - engine.pre_ram_count, 2))
  engine.debug_text("Connections", engine.connected.."/"..engine.host:peer_count())
  engine.state.solar.update(dt)
end

--PROGRAM START:
getFiles(engine, "Lib")
getFiles(engine, "Data")

load_game()
engine.exit_bool = false
engine.state.solar.update(dt)
engine.last_ram_count = math.floor(collectgarbage("count"))
while not engine.exit_bool do
  update()
  print_debug()
end