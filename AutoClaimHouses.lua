
local AutoClaimHouses = {}

function AutoClaimHouses.new()
    local Enabled = {
        [1] = false,
        [2] = false,
        [3] = false
    }

    local Speed = 50
    local Controller = {}

    function Controller.SetSpeed(value)
        Speed = math.clamp(tonumber(value) or 50, 1, 100)
    end

    function Controller.GetSpeed()
        return Speed
    end

    function Controller.SetHouseEnabled(HouseNumber, State)
        if Enabled[HouseNumber] == nil then
            return false
        end

        Enabled[HouseNumber] = State == true
        return true
    end

    function Controller.IsHouseEnabled(HouseNumber)
        return Enabled[HouseNumber] == true
    end

    function Controller.StopHouse(HouseNumber)
        if Enabled[HouseNumber] ~= nil then
            Enabled[HouseNumber] = false
        end
    end

    function Controller.Stop()
        for HouseNumber = 1, 3 do
            Enabled[HouseNumber] = false
        end
    end

    function Controller.IsEnabled()
        return Enabled[1] or Enabled[2] or Enabled[3]
    end

    return Controller
end

return AutoClaimHouses
