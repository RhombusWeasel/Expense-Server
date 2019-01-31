--[[Basic class library:
  This simple class lib is added to engine.class, you can create a new class by calling:-
  
  local new_class = engine.class:extend()
  
  Extend does support multiclassing so you can pass another class as an argument to extend.
]]
local class = {}

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

function scandir(directory)
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
    print("Loading: Creating table engine."..folder)
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
  print("Loading: Checking "..filePath)
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

game = {}
engine = {
  class = class,
  host = enet.host_create("*:6790"),
}

function load_game()
  
end

os.execute("clear")

getFiles(engine, "Lib")