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
  debug_change = true,
  debug_mode = true,
}

function engine.debug_text(key, value)
  if engine.debug_mode then
    if engine.debug_log[key] then
      if engine.debug_log[key] == value then
        return
      end
    end
    engine.debug_log[key] = value
    engine.debug_change = true
  end
end

function print_debug()
  if engine.debug_change then
    os.execute("ansi --erase-display=2")
    os.execute("ansi --position=1,1")
    for k, v in pairs(engine.debug_log) do
      print(k, v)
    end
    engine.debug_change = false
  end
end

function load_game()
  engine.state.solar.startup()
end

function update()
  local event = engine.host:service(50)
  while event do
    local pkt = engine.string.unpack(event.data)
    if pkt then
      if event.type == "receive" then
        --print(event.peer, pkt.command)
        if engine.message[pkt.command] then
          engine.message[pkt.command](event, pkt)
        end
      elseif event.type == "connect" then
        print(event.peer, "Connected.")
        engine.message.auth(event)
      elseif event.type == "disconnect" then
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
  collectgarbage("collect")
  engine.debug_text("Post-broadcast ram", math.floor(collectgarbage("count")))
  local dt = socket.gettime() - time
  time = socket.gettime()
  engine.state.solar.update(dt)
  engine.debug_text("Post-update ram", math.floor(collectgarbage("count")))
end

--PROGRAM START:
os.execute("clear")

getFiles(engine, "Lib")
getFiles(engine, "Data")

load_game()
engine.exit_bool = false
engine.state.solar.update(dt)
while not engine.exit_bool do
  update()
  print_debug()
end