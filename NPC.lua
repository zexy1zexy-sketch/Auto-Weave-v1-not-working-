
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local NPC = {}

local function IsPlayerCharacter(model)
    return Players:GetPlayerFromCharacter(model) ~= nil
end

function NPC.GetRoot(model)
    if not model then
        return nil
    end

    return model:FindFirstChild("HumanoidRootPart")
        or model.PrimaryPart
end

function NPC.IsAlive(model)
    if not model or not model.Parent then
        return false
    end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local root = NPC.GetRoot(model)

    return humanoid ~= nil
        and humanoid.Health > 0
        and root ~= nil
end

local function NormalizeName(name)
    name = string.lower(name or "")
    name = string.gsub(name, "%(%d+%)$", "")
    name = string.gsub(name, "[%s_%-]", "")

    return name
end

function NPC.FindTarget(targetName, lockedTarget)
    if NPC.IsAlive(lockedTarget) then
        return lockedTarget
    end

    local searchName = NormalizeName(targetName)

    if searchName == "" then
        return nil
    end

    for _, object in ipairs(Workspace:GetDescendants()) do
        if object:IsA("Model") and not IsPlayerCharacter(object) then
            local name = NormalizeName(object.Name)

            if string.find(name, searchName, 1, true)
                and NPC.IsAlive(object) then
                return object
            end
        end
    end

    return nil
end

return NPC
