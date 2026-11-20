
local BaseURL =
    "https://raw.githubusercontent.com/zexy1zexy-sketch/ShortName-Hub/refs/heads/main/"

local function LoadModule(name)
    local url = BaseURL .. name

    local success, result = pcall(function()
        local source = game:HttpGet(url)
        local chunk = loadstring(source)

        assert(chunk, "Could not compile " .. name)

        return chunk()
    end)

    if not success then
        error("ShortName Hub failed loading " .. name .. ": " .. tostring(result))
    end

    return result
end

-- Disable Roblox paused notification
pcall(function()
    game:GetService("GuiService"):SetGameplayPausedNotificationEnabled(false)
end)

-- Key system
local KeySystem = LoadModule("KeySystem.lua")

if not KeySystem.Start() then
    return
end

-- Load modules
local Config = LoadModule("Config.lua")
local NPC = LoadModule("NPC.lua")
local Teleport = LoadModule("Teleport.lua")
local GUI = LoadModule("GUI.lua")
local ScytheModule = LoadModule("Scythe.lua")
local Logger = LoadModule("Logger.lua")
local SpyAdapter = LoadModule("SpyAdapter.lua")

-- Create controllers
local Controller
local Scythe
local Interface

Controller = Teleport.new(Config, NPC, function(status)
    if Interface then
        Interface.SetStatus(status)
    end
end)

Scythe = ScytheModule.new()

-- Connect SimpleSpy to Remote Logger
local SpyStarted = SpyAdapter.Start(Logger)

if SpyStarted then
    print("ShortName Hub: Remote Logger connected to SimpleSpy!")
else
    warn("ShortName Hub: SimpleSpy not detected. Start SimpleSpy first.")
end

-- Create interface
Interface = GUI.Create(
    Config,
    Controller,
    Scythe,
    Logger
)
