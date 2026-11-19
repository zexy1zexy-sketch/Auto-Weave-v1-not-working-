
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local GUI = {}

function GUI.Create(Config, Controller)
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
    Frame.Size = UDim2.fromOffset(280, 350)
    Frame.Position = UDim2.new(0.5, -140, 0.5, -175)
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
    MinButton.ZIndex = 3

    local ExitButton = Instance.new("TextButton")
    ExitButton.Size = UDim2.fromOffset(30, 27)
    ExitButton.Position = UDim2.new(1, -32, 0, 4)
    ExitButton.Text = "X"
    ExitButton.TextSize = 14
    ExitButton.BackgroundColor3 = Color3.fromRGB(160, 45, 45)
    ExitButton.TextColor3 = Color3.new(1, 1, 1)
    ExitButton.Parent = TitleBar

    -- Tab buttons
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, -16, 0, 34)
    TabBar.Position = UDim2.fromOffset(8, 40)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = Frame

    local function MakeTab(text, position)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0.5, -3, 1, 0)
        Button.Position = position
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
        Button.TextColor3 = Color3.new(1, 1, 1)
        Button.Text = text
        Button.TextSize = 11
        Button.Font = Enum.Font.GothamBold
        Button.Parent = TabBar

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = Button

        return Button
    end

    local GameTab = MakeTab(
        "NOOB INCREMENTAL",
        UDim2.fromOffset(0, 0)
    )

    local ComingTab = MakeTab(
        "COMING SOON",
        UDim2.new(0.5, 3, 0, 0)
    )

    local Pages = Instance.new("Frame")
    Pages.Position = UDim2.fromOffset(8, 82)
    Pages.Size = UDim2.new(1, -16, 1, -126)
    Pages.BackgroundTransparency = 1
    Pages.Parent = Frame

    local GamePage = Instance.new("ScrollingFrame")
    GamePage.Size = UDim2.new(1, 0, 1, 0)
    GamePage.BackgroundTransparency = 1
    GamePage.BorderSizePixel = 0
    GamePage.ScrollBarThickness = 4
    GamePage.CanvasSize = UDim2.fromOffset(0, 0)
    GamePage.Parent = Pages

    local GameLayout = Instance.new("UIListLayout")
    GameLayout.Padding = UDim.new(0, 7)
    GameLayout.SortOrder = Enum.SortOrder.LayoutOrder
    GameLayout.Parent = GamePage

    local GamePadding = Instance.new("UIPadding")
    GamePadding.PaddingBottom = UDim.new(0, 8)
    GamePadding.Parent = GamePage

    local ComingPage = Instance.new("Frame")
    ComingPage.Size = UDim2.new(1, 0, 1, 0)
    ComingPage.BackgroundTransparency = 1
    ComingPage.Visible = false
    ComingPage.Parent = Pages

    local ComingText = Instance.new("TextLabel")
    ComingText.Size = UDim2.new(1, 0, 0, 50)
    ComingText.Position = UDim2.new(0, 0, 0.35, 0)
    ComingText.BackgroundTransparency = 1
    ComingText.Text = "MORE FEATURES COMING SOON"
    ComingText.TextColor3 = Color3.fromRGB(170, 170, 185)
    ComingText.TextSize = 13
    ComingText.Font = Enum.Font.GothamBold
    ComingText.Parent = ComingPage

    local function SelectTab(tab)
        local IsGame = tab == "Game"

        GamePage.Visible = IsGame
        ComingPage.Visible = not IsGame

        GameTab.BackgroundColor3 = IsGame
            and Color3.fromRGB(65, 85, 130)
            or Color3.fromRGB(45, 45, 58)

        ComingTab.BackgroundColor3 = not IsGame
            and Color3.fromRGB(65, 85, 130)
            or Color3.fromRGB(45, 45, 58)
    end

    GameTab.Activated:Connect(function()
        SelectTab("Game")
    end)

    ComingTab.Activated:Connect(function()
        SelectTab("Coming")
    end)

    local function MakeLabel(text)
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -5, 0, 20)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(220, 220, 230)
        Label.TextSize = 12
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = GamePage
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
        Box.Parent = GamePage

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
        Button.Parent = GamePage

        Button.Activated:Connect(callback)

        return Button
    end

    local Status = MakeLabel("STATUS: READY")

    local function SetStatus(text)
        Status.Text = "STATUS: " .. text
    end

    MakeBox("NPC NAME", Config.TargetName, function(value)
        Config.TargetName = value
        Controller.SetTargetName(value)
    end)

    MakeBox("AIR INTERVAL (SECONDS)", Config.AirInterval, function(value)
        Config.AirInterval = math.clamp(tonumber(value) or 5, 1, 30)
    end)

    MakeBox("AIR TIME (SECONDS)", Config.AirTime, function(value)
        Config.AirTime = math.clamp(tonumber(value) or 3, 1, 30)
    end)

    MakeBox("TP HEIGHT (STUDS)", Config.AirHeight, function(value)
        Config.AirHeight = math.clamp(tonumber(value) or 100, 1, 1000)
    end)

    MakeBox("TP SPEED", Config.TeleportsPerSecond, function(value)
        Config.TeleportsPerSecond = math.clamp(tonumber(value) or 1, 0.1, 100)
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

    local Minimized = false
    local BubbleDragging = false
    local BubbleDragStart
    local BubbleStartPosition

    MinButton.Activated:Connect(function()
        Minimized = not Minimized

        if Minimized then
            TitleBar.Visible = false
            TabBar.Visible = false
            Pages.Visible = false

            Frame.Size = UDim2.fromOffset(54, 54)
            Frame.BackgroundColor3 = Color3.fromRGB(65, 85, 130)

            MinButton.Size = UDim2.fromOffset(54, 54)
            MinButton.Position = UDim2.fromOffset(0, 0)
            MinButton.Text = "SN"
            MinButton.TextSize = 15
        else
            Frame.Size = UDim2.fromOffset(280, 350)
            Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)

            TitleBar.Visible = true
            TabBar.Visible = true
            Pages.Visible = true

            MinButton.Size = UDim2.fromOffset(30, 27)
            MinButton.Position = UDim2.new(1, -65, 0, 4)
            MinButton.Text = "-"
            MinButton.TextSize = 20
        end
    end)

    -- Drag the minimized bubble
    MinButton.InputBegan:Connect(function(input)
        if not Minimized then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            BubbleDragging = true
            BubbleDragStart = input.Position
            BubbleStartPosition = Frame.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if BubbleDragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local Delta = input.Position - BubbleDragStart

            Frame.Position = UDim2.new(
                BubbleStartPosition.X.Scale,
                BubbleStartPosition.X.Offset + Delta.X,
                BubbleStartPosition.Y.Scale,
                BubbleStartPosition.Y.Offset + Delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            BubbleDragging = false
        end
    end)

    ExitButton.Activated:Connect(function()
        Controller.Stop()
        ScreenGui:Destroy()
    end)

    -- Drag the full window using the title bar
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

    GameLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        GamePage.CanvasSize = UDim2.fromOffset(
            0,
            GameLayout.AbsoluteContentSize.Y + 15
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
