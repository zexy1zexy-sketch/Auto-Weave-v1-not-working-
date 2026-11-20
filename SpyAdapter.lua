
-- SHORTNAME HUB - REMOTE SPY ADAPTER

local SpyAdapter = {}

local Logger
local Enabled = false

local Hooked = {}
local Connections = {}

local function IsRemote(instance)
    return instance:IsA("RemoteEvent")
        or instance:IsA("RemoteFunction")
end

local function Record(remote, method, args)
    if not Enabled or not Logger then
        return
    end

    pcall(function()
        Logger:Record(remote, method, args)
    end)
end

local function HookRemote(remote)
    if not Enabled or Hooked[remote] then
        return
    end

    if not IsRemote(remote) then
        return
    end

    Hooked[remote] = true

    if remote:IsA("RemoteEvent") then
        local success, original = pcall(function()
            return hookfunction(remote.FireServer, function(self, ...)
                if self == remote then
                    Record(remote, "FireServer", {...})
                end

                return original(self, ...)
            end)
        end)

        if not success then
            warn("ShortName Hub: FireServer hook failed:", original)
            Hooked[remote] = nil
            return
        end

        local connected, connection = pcall(function()
            return remote.OnClientEvent:Connect(function(...)
                Record(remote, "OnClientEvent", {...})
            end)
        end)

        if connected and connection then
            table.insert(Connections, connection)
        end

    elseif remote:IsA("RemoteFunction") then
        local success, original = pcall(function()
            return hookfunction(remote.InvokeServer, function(self, ...)
                if self == remote then
                    Record(remote, "InvokeServer", {...})
                end

                return original(self, ...)
            end)
        end)

        if not success then
            warn("ShortName Hub: InvokeServer hook failed:", original)
            Hooked[remote] = nil
            return
        end
    end
end

function SpyAdapter.Start(LoggerModule)
    if Enabled then
        return true
    end

    if type(LoggerModule) ~= "table"
        or type(LoggerModule.Record) ~= "function" then
        warn("ShortName Hub: Invalid Logger module")
        return false
    end

    if type(hookfunction) ~= "function" then
        warn("ShortName Hub: hookfunction is unavailable")
        return false
    end

    Logger = LoggerModule
    Enabled = true

    for _, instance in ipairs(game:GetDescendants()) do
        HookRemote(instance)
    end

    local connection = game.DescendantAdded:Connect(HookRemote)
    table.insert(Connections, connection)

    print("ShortName Hub: Remote Logger started!")
    return true
end

function SpyAdapter.Stop()
    Enabled = false

    for _, connection in ipairs(Connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end

    table.clear(Connections)
    table.clear(Hooked)

    Logger = nil

    print("ShortName Hub: Remote Logger stopped!")
    return true
end

return SpyAdapter
