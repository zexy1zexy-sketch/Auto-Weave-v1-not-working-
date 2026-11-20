
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Scythe = {}

function Scythe.new()
    local Enabled = false
    local Speed = 1
    local Controller = {}

    local function GetRemote()
        local Net = ReplicatedStorage:FindFirstChild("__Net")
        if not Net then
            return nil
        end

        local Remote = Net:FindFirstChild("MainRemote")

        if Remote and Remote:IsA("RemoteEvent") then
            return Remote
        end

        return nil
    end

    function Controller.SetSpeed(value)
        Speed = math.clamp(tonumber(value) or 1, 1, 100)
    end

    function Controller.Start()
        if Enabled then
            return
        end

        local Remote = GetRemote()

        if not Remote then
            return false, "MainRemote not found"
        end

        Enabled = true

        task.spawn(function()
            while Enabled do
                local CurrentRemote = GetRemote()

                if not CurrentRemote then
                    Enabled = false
                    break
                end

                local Success = pcall(function()
                    CurrentRemote:FireServer("RollScytheEnchant")
                end)

                if not Success then
                    Enabled = false
                    break
                end

                task.wait(1 / Speed)
            end
        end)

        return true
    end

    function Controller.Stop()
        Enabled = false
    end

    function Controller.IsEnabled()
        return Enabled
    end

    return Controller
end

return Scythe
