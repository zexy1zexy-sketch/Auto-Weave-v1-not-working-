
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AutoClaimHouses = {}

function AutoClaimHouses.new()
    local Enabled = false
    local Speed = 50
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
        Speed = math.clamp(tonumber(value) or 50, 1, 100)
    end

    function Controller.GetSpeed()
        return Speed
    end

    function Controller.Start()
        if Enabled then
            return true
        end

        Enabled = true

        task.spawn(function()
            while Enabled do
                local Remote = GetRemote()

                if Remote then
                    -- Claim houses 1, 2, and 3 independently.
                    for HouseNumber = 1, 3 do
                        if not Enabled then
                            break
                        end

                        local Success = pcall(function()
                            Remote:FireServer(
                                "TouchTrickOrTreatHouse",
                                HouseNumber
                            )
                        end)

                        if not Success then
                            task.wait(0.1)
                        end
                    end

                    -- Keep the total claim rate near the selected CPS.
                    task.wait(3 / Speed)
                else
                    -- Retry if MainRemote is temporarily unavailable.
                    task.wait(1)
                end
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

return AutoClaimHouses
    