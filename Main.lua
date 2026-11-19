
local BaseURL =
    "https://raw.githubusercontent.com/zexy1zexy-sketch/ShortName-Hub/refs/heads/main/"

-- Disable Roblox gameplay paused notification
pcall(function()
    game:GetService("GuiService"):SetGameplayPausedNotificationEnabled(false)
end)

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

local Config = LoadModule("Config.lua")
local NPC = LoadModule("NPC.lua")
local Teleport = LoadModule("Teleport.lua")
local GUI = LoadModule("GUI.lua")

local Controller
local Interface

Controller = Teleport.new(Config, NPC, function(status)
    if Interface then
        Interface.SetStatus(status)
    end
end)

Interface = GUI.Create(Config, Controller)
