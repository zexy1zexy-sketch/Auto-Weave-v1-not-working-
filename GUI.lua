
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local GUI = {}

function GUI.Create(Config, Controller)
    local Player = Players.LocalPlayer

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ShortNameHub"
    ScreenGui.ResetOnSpawn = false

    local success = pcall(function()
        ScreenGui.Parent = gethui()
    end)

    if not success then
        ScreenGui.Parent = game:GetService("CoreGui")
    end

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.fromOffset(280, 320)
    Frame.Position = UDim2.new(0.5, -140, 0.5, -160)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Frame

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -75, 1, 0)
    Title.Position = UDim2.fromOffset(10, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "SHORTNAME HUB"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local MinButton = Instance.new("TextButton")
    MinButton.Size = UDim2.fromOffset(30, 27)
    MinButton.Position = UDim2.new(1, -65, 0, 4)
    MinButton.Text = "-"
    MinButton.TextSize = 20
    MinButton.BackgroundColor3 = Color3.fromRGB(65, 65, 80)
    MinButton.TextColor3 = Color3.new(1, 1, 1)
    MinButton.Parent = TitleBar

    local ExitButton = Instance.new("TextButton")
    ExitButton.Size = UDim2.fromOffset(30, 27)
    ExitButton.Position = UDim2.new(1, -32, 0, 4)
    ExitButton.Text = "X"
    ExitButton.TextSize = 14
    ExitButton.BackgroundColor3 = Color3.fromRGB(160, 45, 45)
    ExitButton.TextColor3 = Color3.new(1, 1, 1)
    ExitButton.Parent = TitleBar

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Position = UDim2.fromOffset(8, 43)
    Scroll.Size = UDim2.new(1, -16, 1, -88)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 4
    Scroll.CanvasSize = UDim2.fromOffset(0, 410)
    Scroll.Parent = Frame

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 7)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Scroll

    local Padding = Instance.new("UIPadding")
    Padding.PaddingBottom = UDim.new(0, 8)
    Padding.Parent = Scroll

    local function MakeLabel(text)
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -5, 0, 20)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(220, 220, 230)
        Label.TextSize = 12
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Scroll
        return Label
    end

    local function MakeBox(label, value, callback)
        MakeLabel(label)

        local Box = Instance.new("TextBox")
        Box.Size = UDim2.new(1, -5, 0, 30)
        Box.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
        Box.TextColor3 = Color3.new(1, 1, 1)
        Box.PlaceholderColor3 = Color3.fromRGB(160, 160, 170)
        Box.Text = tostring(value)
        Box.TextSize = 13
        Box.Font = Enum.Font.Gotham
        Box.ClearTextOnFocus = false
        Box.Parent = Scroll

        Box.FocusLost:Connect(function()
            callback(Box.Text)
        end)

        return Box
    end

    local function MakeButton(text, callback, color)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -5, 0, 32)
        Button.BackgroundColor3 = color or Color3.fromRGB(65, 85, 130)
        Button.TextColor3 = Color3.new(1, 1, 1)
        Button.Text = text
        Button.TextSize = 13
        Button.Font = Enum.Font.GothamBold
        Button.Parent = Scroll

        Button.MouseButton1Click:Connect(callback)

        return Button
    end

    local Status = MakeLabel("STATUS: READY")

    local function SetStatus(text)
        Status.Text = "STATUS: " .. text
    end

    local SearchBox = MakeBox(
        "NPC NAME",
        Config.TargetName,
        function(value)
            Config.TargetName = value
            Controller.SetTargetName(value)
        end
    )

    MakeBox("AIR INTERVAL (SECONDS)", Config.AirInterval, function(value)
        Config.AirInterval = math.clamp(
            tonumber(value) or 5, 1, 30
        )
    end)

    MakeBox("AIR TIME (SECONDS)", Config.AirTime, function(value)
        Config.AirTime = math.clamp(
            tonumber(value) or 3, 1, 30
        )
    end)

    MakeBox("TP HEIGHT (STUDS)", Config.AirHeight, function(value)
        Config.AirHeight = math.clamp(
            tonumber(value) or 100, 1, 1000
        )
    end)

    MakeBox("TP SPEED", Config.TeleportsPerSecond, function(value)
        Config.TeleportsPerSecond = math.clamp(
            tonumber(value) or 1, 0.1, 100
        )
    end)

    MakeButton("TELEPORT NOW", function()
        Controller.TeleportNow()
    end)

    local AutoButton

    AutoButton = MakeButton("AUTO TP: OFF", function()
        if Controller.IsEnabled() then
            Controller.Stop()
            AutoButton.Text = "AUTO TP: OFF"
        else
            Controller.Start()
            AutoButton.Text = "AUTO TP: ON"
        end
    end, Color3.fromRGB(45, 125, 75))

    local BottomBar = Instance.new("Frame")
    BottomBar.Size = UDim2.new(1, -16, 0, 32)
    BottomBar.Position = UDim2.new(0, 8, 1, -38)
    BottomBar.BackgroundTransparency = 1
    BottomBar.Parent = Frame

    local Minimized = false

    MinButton.MouseButton1Click:Connect(function()
        Minimized = not Minimized

        if Minimized then
            TitleBar.Visible = false
            Scroll.Visible = false
            BottomBar.Visible = false
            Frame.Size = UDim2.fromOffset(54, 54)
            Frame.BackgroundColor3 = Color3.fromRGB(65, 85, 130)
            MinButton.Size = UDim2.fromOffset(54, 54)
            MinButton.Position = UDim2.fromOffset(0, 0)
            MinButton.Text = "SN"
            MinButton.TextSize = 15
        else
            Frame.Size = UDim2.fromOffset(280, 320)
            Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
            TitleBar.Visible = true
            Scroll.Visible = true
            BottomBar.Visible = true
            MinButton.Size = UDim2.fromOffset(30, 27)
            MinButton.Position = UDim2.new(1, -65, 0, 4)
            MinButton.Text = "-"
            MinButton.TextSize = 20
        end
    end)

    ExitButton.MouseButton1Click:Connect(function()
        Controller.Stop()
        ScreenGui:Destroy()
    end)

    local Dragging = false
    local DragStart
    local StartPosition

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = Frame.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if Dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local Delta = input.Position - DragStart

            Frame.Position = UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Scroll.CanvasSize = UDim2.fromOffset(
            0,
            Layout.AbsoluteContentSize.Y + 15
        )
    end)

    return {
        SetStatus = SetStatus,
        Destroy = function()
            ScreenGui:Destroy()
        end
    }
end

return GUI
