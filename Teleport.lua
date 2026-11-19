
local Players = game:GetService("Players")

local Teleport = {}

function Teleport.new(Config, NPC, onStatus)
    local Player = Players.LocalPlayer
    local Controller = {}

    local Enabled = false
    local CycleBusy = false
    local LockedNPC = nil
    local NextAirTime = 0

    local function SetStatus(message)
        if onStatus then
            pcall(onStatus, message)
        end
    end

    local function GetCharacter()
        local Character = Player.Character

        if not Character or not Character.Parent then
            return nil
        end

        return Character
    end

    local function GetNumber(value, fallback, minimum, maximum)
        return math.clamp(
            tonumber(value) or fallback,
            minimum,
            maximum
        )
    end

    local function TeleportToNPC(Target)
        if not NPC.IsAlive(Target) then
            return false
        end

        local Character = GetCharacter()
        local Root = NPC.GetRoot(Target)

        if not Character or not Root then
            return false
        end

        local Success, Error = pcall(function()
            Character:PivotTo(
                Root.CFrame * CFrame.new(0, 0, 4)
            )
        end)

        if not Success then
            SetStatus("TP ERROR: " .. tostring(Error))
            return false
        end

        return true
    end

    local function GoUpAndReturn(isAuto)
        local Character = GetCharacter()

        if not Character then
            SetStatus("CHARACTER NOT FOUND")
            return false
        end

        local OriginalPosition = Character:GetPivot()

        local Height = GetNumber(
            Config.AirHeight, 100, 1, 1000
        )

        local AirTime = GetNumber(
            Config.AirTime, 3, 1, 30
        )

        local Success, Error = pcall(function()
            Character:PivotTo(
                OriginalPosition + Vector3.new(0, Height, 0)
            )
        end)

        if not Success then
            SetStatus("AIR TP ERROR: " .. tostring(Error))
            return false
        end

        local StartTime = os.clock()

        while os.clock() - StartTime < AirTime do
            if isAuto and not Enabled then
                break
            end

            local Remaining = math.ceil(
                AirTime - (os.clock() - StartTime)
            )

            if isAuto then
                SetStatus("AIR TIME: " .. Remaining)
            else
                SetStatus("AIR TIME: " .. Remaining)
            end

            task.wait(0.1)

            Character = GetCharacter()

            if not Character then
                SetStatus("CHARACTER LOST")
                return false
            end
        end

        Character = GetCharacter()

        if Character then
            local ReturnSuccess, ReturnError = pcall(function()
                Character:PivotTo(OriginalPosition)
            end)

            if not ReturnSuccess then
                SetStatus("RETURN ERROR: " .. tostring(ReturnError))
                return false
            end
        end

        return true
    end

    function Controller.SetTargetName(name)
        Config.TargetName = name
        LockedNPC = nil
        SetStatus("TARGET UPDATED")
    end

    function Controller.TeleportNow()
        if CycleBusy then
            return
        end

        task.spawn(function()
            CycleBusy = true

            local Success, Error = pcall(function()
                local Target = NPC.FindTarget(
                    Config.TargetName,
                    nil
                )

                if not Target then
                    SetStatus("NPC NOT FOUND")
                    return
                end

                if not TeleportToNPC(Target) then
                    SetStatus("TELEPORT FAILED")
                    return
                end

                SetStatus("TELEPORTED")
            end)

            if not Success then
                SetStatus("ERROR: " .. tostring(Error))
            end

            CycleBusy = false
        end)
    end

    function Controller.Start()
        if Enabled then
            return
        end

        Enabled = true

        NextAirTime = os.clock() +
            GetNumber(Config.AirInterval, 5, 1, 30)

        task.spawn(function()
            while Enabled do
                if not CycleBusy then
                    CycleBusy = true

                    local Success, Error = pcall(function()
                        local Target = NPC.FindTarget(
                            Config.TargetName,
                            LockedNPC
                        )

                        if not Target then
                            LockedNPC = nil
                            SetStatus("WAITING FOR NPC")
                            return
                        end

                        LockedNPC = Target

                        if not TeleportToNPC(Target) then
                            SetStatus("TELEPORT FAILED")
                            return
                        end

                        if os.clock() >= NextAirTime then
                            SetStatus("GOING UP")

                            GoUpAndReturn(true)

                            NextAirTime = os.clock() +
                                GetNumber(
                                    Config.AirInterval,
                                    5,
                                    1,
                                    30
                                )
                        else
                            SetStatus("AUTO TPING")
                        end
                    end)

                    if not Success then
                        SetStatus("AUTO ERROR: " .. tostring(Error))
                    end

                    CycleBusy = false
                end

                local Speed = GetNumber(
                    Config.TeleportsPerSecond,
                    1,
                    0.1,
                    100
                )

                task.wait(1 / Speed)
            end

            SetStatus("AUTO TP OFF")
        end)
    end

    function Controller.Stop()
        Enabled = false
        SetStatus("AUTO TP OFF")
    end

    function Controller.IsEnabled()
        return Enabled
    end

    return Controller
end

return Teleport
