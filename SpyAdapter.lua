
-- SHORTNAME HUB - SIMPLESPY ADAPTER

local SpyAdapter = {}

local Logger
local SimpleSpy

local Connections = {}
local WatchedRemotes = {}
local Enabled = false

local function IsRemote(instance)
    return instance:IsA("RemoteEvent")
        or instance:IsA("RemoteFunction")
end

local function WatchRemote(remote)
    if not Enabled or not IsRemote(remote) then
        return
    end

    if WatchedRemotes[remote] then
        return
    end

    local method = remote:IsA("RemoteEvent")
        and "FireServer"
        or "InvokeServer"

    local success, signal = pcall(function()
        return SimpleSpy:GetRemoteFiredSignal(remote)
    end)

    if not success or not signal then
        return
    end

    local connected, connection = pcall(function()
        return signal:Connect(function(args)
            if not Enabled or not Logger then
                return
            end

            pcall(function()
                Logger:Record(
                    remote,
                    method,
                    args
                )
            end)
        end)
    end)

    if connected and connection then
        WatchedRemotes[remote] = true
        table.insert(Connections, connection)
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

    local Env = getgenv and getgenv() or _G
    SimpleSpy = Env.SimpleSpy

    if not SimpleSpy
    or type(SimpleSpy.GetRemoteFiredSignal) ~= "function" then
        warn("ShortName Hub: SimpleSpy was not found!")
        return false
    end

    Logger = LoggerModule
    Enabled = true

    for _, instance in ipairs(game:GetDescendants()) do
        WatchRemote(instance)
    end

    local addedConnection = game.DescendantAdded:Connect(WatchRemote)
    table.insert(Connections, addedConnection)

    print("ShortName Hub: SpyAdapter started!")

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
    table.clear(WatchedRemotes)

    Logger = nil
    SimpleSpy = nil

    print("ShortName Hub: SpyAdapter stopped!")
end

return SpyAdapter
