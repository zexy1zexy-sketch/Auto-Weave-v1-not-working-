
-- SHORTNAME HUB KEY SYSTEM
-- EDIT THESE TWO SETTINGS

local HUB_KEY = "CHANGE-ME-123"
local DISCORD_INVITE = "https://discord.gg/YOUR-INVITE"

-- Do not edit below unless you want to customize the UI.

local KeySystem = {}

function KeySystem.Start()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ShortNameKeySystem"
    ScreenGui.ResetOnSpawn = false

    local success = pcall(function()
        ScreenGui.Parent = gethui()
    end)

    if not success then
        ScreenGui.Parent = game:GetService("CoreGui")
    end

    local Purple = Color3.fromRGB(145, 75, 255)
    local Dark = Color3.fromRGB(12, 12, 17)
    local White = Color3.fromRGB(240, 240, 248)

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.fromOffset(310, 215)
    Frame.Position = UDim2.new(0.5, -155, 0.5, -107)
    Frame.BackgroundColor3 = Dark
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Frame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Purple
    Stroke.Thickness = 1.5
    Stroke.Parent = Frame

    local function MakeLabel(text, position, size, textSize)
        local Label = Instance.new("TextLabel")
        Label.Size = size
        Label.Position = position
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = White
        Label.TextSize = textSize
        Label.Font = Enum.Font.GothamBold
        Label.Parent = Frame
        return Label
    end

    MakeLabel(
        "SHORTNAME HUB",
        UDim2.fromOffset(10, 12),
        UDim2.new(1, -20, 0, 30),
        18
    )

    MakeLabel(
        "Enter your access key to continue",
        UDim2.fromOffset(10, 44),
        UDim2.new(1, -20, 0, 22),
        11
    )

    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(1, -30, 0, 36)
    KeyBox.Position = UDim2.fromOffset(15, 78)
    KeyBox.BackgroundColor3 = Color3.fromRGB(31, 31, 42)
    KeyBox.TextColor3 = White
    KeyBox.PlaceholderColor3 = Color3.fromRGB(155, 155, 175)
    KeyBox.PlaceholderText = "Enter key here"
    KeyBox.Text = ""
    KeyBox.TextSize = 13
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.ClearTextOnFocus = false
    KeyBox.Parent = Frame

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 7)
    BoxCorner.Parent = KeyBox

    local Status = MakeLabel(
        "WAITING FOR KEY",
        UDim2.fromOffset(10, 118),
        UDim2.new(1, -20, 0, 20),
        10
    )

    Status.TextColor3 = Color3.fromRGB(180, 180, 200)

    local function MakeButton(text, position, color)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -30, 0, 34)
        Button.Position = position
        Button.BackgroundColor3 = color
        Button.Text = text
        Button.TextColor3 = White
        Button.TextSize = 12
        Button.Font = Enum.Font.GothamBold
        Button.Parent = Frame

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 7)
        ButtonCorner.Parent = Button

        return Button
    end

    local VerifyButton = MakeButton(
        "UNLOCK HUB",
        UDim2.fromOffset(15, 143),
        Purple
    )

    local DiscordButton = MakeButton(
        "JOIN DISCORD",
        UDim2.fromOffset(15, 183),
        Color3.fromRGB(65, 85, 160)
    )

    local Finished = false
    local AccessGranted = false

    VerifyButton.Activated:Connect(function()
        if KeyBox.Text == HUB_KEY then
            Status.Text = "KEY ACCEPTED!"
            Status.TextColor3 = Color3.fromRGB(100, 255, 140)

            AccessGranted = true
            Finished = true
        else
            Status.Text = "INVALID KEY!"
            Status.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)

    DiscordButton.Activated:Connect(function()
        local copied = pcall(function()
            setclipboard(DISCORD_INVITE)
        end)

        if copied then
            Status.Text = "DISCORD INVITE COPIED!"
        else
            Status.Text = "COPY FAILED - CHECK YOUR INVITE"
        end
    end)

    while not Finished and ScreenGui.Parent do
        task.wait()
    end

    ScreenGui:Destroy()

    return AccessGranted
end

return KeySystem
