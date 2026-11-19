
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

    local function TeleportToNPC(Target)
        if not NPC.IsAlive(Target) then
            return false
        end

        local Character = GetCharacter()
        local Root = NPC.GetRoot(Target)

        if not Character or not Root then
            return false
        end

        Character:PivotTo(
            Root.CFrame * CFrame.new(0, 0, 4)
        )

        return true
    end

    local function GoUpAndReturn(isAuto)
        local Character = GetCharacter()

        if not Character then
            return
        end

        local OriginalPosition = Character:GetPivot()
        local Height = math.clamp(
            tonumber(Config.AirHeight) or 100,
            1,
            1000
        )

        local AirTime = math.clamp(
            tonumber(Config.AirTime) or 3,
            1,
            30
        )

        Character:PivotTo(
            OriginalPosition + Vector3.new(0, Height, 0)
        )

        local StartTime = os.clock()

        while os.clock() - StartTime < AirTime do
            if isAuto and not Enabled then
                break
            end

            local Remaining = math.ceil(
                AirTime - (os.clock() - StartTime)
            )

            if isAuto then
                SetStatus("AUTO TPING")
            else
                SetStatus("AIR TIME: " .. Remaining)
            end

            task.wait(0.1)
        end

        Character = GetCharacter()

        if Character then
            Character:PivotTo(OriginalPosition)
        end
    end

    function Controller.SetTargetName(name)
        Config.TargetName = name
        LockedNPC = nil
    end

    function Controller.TeleportNow()
        if CycleBusy then
            return
        end

        task.spawn(function()
            CycleBusy = true

            local Target = NPC.FindTarget(
                Config.TargetName,
                nil
            )

            if Target and TeleportToNPC(Target) then
                SetStatus("TELEPORTED")

                task.wait(
                    math.clamp(
                        tonumber(Config.AirInterval) or 5,
                        1,
                        30
                    )
                )

                GoUpAndReturn(false)
                SetStatus("READY")
            else
                SetStatus("NPC NOT FOUND")
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
            (tonumber(Config.AirInterval) or 5)

        task.spawn(function()
            while Enabled do
                if not CycleBusy then
                    local Target = NPC.FindTarget(
                        Config.TargetName,
                        LockedNPC
                    )

                    if Target then
                        LockedNPC = Target

                        if TeleportToNPC(Target) then
                            if os.clock() >= NextAirTime then
    CycleBusy = true

    GoUpAndReturn(true)

    NextAirTime = os.clock() +
        (tonumber(Config.AirInterval) or 5)

    CycleBusy = false
                                end

                            if Enabled then
                                SetStatus("AUTO TPING")
                            end
                        end
                    else
                        LockedNPC = nil
                        SetStatus("WAITING FOR NPC")
                    end
                end

                local Speed = math.clamp(
                    tonumber(Config.TeleportsPerSecond) or 1,
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
