
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local GUI = {}

function GUI.Create(Config, Controller)
    local Player = Players.LocalPlayer

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ShortNameHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local success = pcall(function()
        ScreenGui.Parent = gethui()
    end)

    if not success then
        ScreenGui.Parent = game:GetService("CoreGui")
    end

    local Camera = workspace.CurrentCamera
    local Viewport = Camera and Camera.ViewportSize or Vector2.new(800, 600)

    local WindowWidth = math.max(300, math.min(620, Viewport.X - 20))
    local WindowHeight = math.max(300, math.min(430, Viewport.Y - 40))

    local Purple = Color3.fromRGB(145, 75, 255)
    local Dark = Color3.fromRGB(12, 12, 17)
    local Panel = Color3.fromRGB(23, 23, 31)
    local ButtonDark = Color3.fromRGB(31, 31, 42)
    local White = Color3.fromRGB(240, 240, 248)
    local Grey = Color3.fromRGB(155, 155, 175)

    local function Corner(object, radius)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius or 8)
        c.Parent = object
        return c
    end

    local function Stroke(object, color, thickness)
        local s = Instance.new("UIStroke")
        s.Color = color or Purple
        s.Thickness = thickness or 1
        s.Parent = object
        return s
    end

    local function Label(parent, text, size, height, color)
        local item = Instance.new("TextLabel")
        item.Size = UDim2.new(1, 0, 0, height or 25)
        item.BackgroundTransparency = 1
        item.Text = text
        item.TextColor3 = color or White
        item.TextSize = size or 13
        item.Font = Enum.Font.Gotham
        item.TextXAlignment = Enum.TextXAlignment.Left
        item.Parent = parent
        return item
    end

    -- Main window
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.fromOffset(WindowWidth, WindowHeight)
    Frame.Position = UDim2.new(0.5, -WindowWidth / 2, 0.5, -WindowHeight / 2)
    Frame.BackgroundColor3 = Dark
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    Corner(Frame, 12)
    Stroke(Frame, Purple, 1.3)

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 48)
    Header.BackgroundColor3 = Dark
    Header.BorderSizePixel = 0
    Header.Parent = Frame
    Corner(Header, 10)

    local HeaderTitle = Label(Header, "  SHORTNAME HUB", 15, 48, White)
    HeaderTitle.Font = Enum.Font.GothamBold
    HeaderTitle.Size = UDim2.new(1, -110, 1, 0)

    local MinButton = Instance.new("TextButton")
    MinButton.Size = UDim2.fromOffset(38, 34)
    MinButton.Position = UDim2.new(1, -88, 0, 7)
    MinButton.BackgroundColor3 = ButtonDark
    MinButton.Text = "—"
    MinButton.TextColor3 = White
    MinButton.TextSize = 19
    MinButton.Font = Enum.Font.GothamBold
    MinButton.Parent = Frame
    MinButton.ZIndex = 5
    Corner(MinButton, 8)
    Stroke(MinButton, Purple, 1)

    local ExitButton = Instance.new("TextButton")
    ExitButton.Size = UDim2.fromOffset(38, 34)
    ExitButton.Position = UDim2.new(1, -44, 0, 7)
    ExitButton.BackgroundColor3 = ButtonDark
    ExitButton.Text = "×"
    ExitButton.TextColor3 = Color3.fromRGB(255, 170, 180)
    ExitButton.TextSize = 23
    ExitButton.Font = Enum.Font.Gotham
    ExitButton.Parent = Header
    Corner(ExitButton, 8)
    Stroke(ExitButton, Purple, 1)

    -- Sidebar
    local SidebarWidth = math.min(155, WindowWidth * 0.34)

    local Sidebar = Instance.new("Frame")
    Sidebar.Position = UDim2.fromOffset(10, 58)
    Sidebar.Size = UDim2.new(0, SidebarWidth, 1, -68)
    Sidebar.BackgroundColor3 = Panel
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Frame
    Corner(Sidebar, 9)

    local SideLayout = Instance.new("UIListLayout")
    SideLayout.Padding = UDim.new(0, 7)
    SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SideLayout.Parent = Sidebar

    local SidePadding = Instance.new("UIPadding")
    SidePadding.PaddingTop = UDim.new(0, 9)
    SidePadding.PaddingLeft = UDim.new(0, 8)
    SidePadding.PaddingRight = UDim.new(0, 8)
    SidePadding.Parent = Sidebar

    local function MakeNav(text, order)
        local Button = Instance.new("TextButton")
        Button.Name = text
        Button.LayoutOrder = order
        Button.Size = UDim2.new(1, 0, 0, 43)
        Button.BackgroundColor3 = ButtonDark
        Button.TextColor3 = White
        Button.Text = text
        Button.TextSize = WindowWidth < 380 and 11 or 13
        Button.Font = Enum.Font.GothamBold
        Button.Parent = Sidebar
        Corner(Button, 7)
        Stroke(Button, Purple, 1)
        return Button
    end

    local SettingsNav = MakeNav("⚙  Settings", 1)
    local GameNav = MakeNav("◆  Noob Incremental", 2)
    local SoonNav = MakeNav("＋  Coming Soon", 3)

    -- Content area
    local Content = Instance.new("Frame")
    Content.Position = UDim2.new(0, SidebarWidth + 20, 0, 58)
    Content.Size = UDim2.new(1, -SidebarWidth - 30, 1, -68)
    Content.BackgroundColor3 = Panel
    Content.BorderSizePixel = 0
    Content.Parent = Frame
    Corner(Content, 9)

    local function MakePage(name)
        local Page = Instance.new("ScrollingFrame")
        Page.Name = name
        Page.Size = UDim2.new(1, -16, 1, -16)
        Page.Position = UDim2.fromOffset(8, 8)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 4
        Page.ScrollBarImageColor3 = Purple
        Page.CanvasSize = UDim2.fromOffset(0, 0)
        Page.Visible = false
        Page.Parent = Content

        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 8)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Parent = Page

        local Padding = Instance.new("UIPadding")
        Padding.PaddingBottom = UDim.new(0, 10)
        Padding.Parent = Page

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.fromOffset(
                0,
                Layout.AbsoluteContentSize.Y + 15
            )
        end)

        return Page
    end

    local SettingsPage = MakePage("Settings")
    local GamePage = MakePage("NoobIncremental")
    local SoonPage = MakePage("ComingSoon")

    local CurrentPage

    local function SelectPage(page)
        CurrentPage = page

        SettingsPage.Visible = page == "Settings"
        GamePage.Visible = page == "Game"
        SoonPage.Visible = page == "Soon"

        SettingsNav.BackgroundColor3 = page == "Settings" and Color3.fromRGB(48, 37, 67) or ButtonDark
        GameNav.BackgroundColor3 = page == "Game" and Color3.fromRGB(48, 37, 67) or ButtonDark
        SoonNav.BackgroundColor3 = page == "Soon" and Color3.fromRGB(48, 37, 67) or ButtonDark
    end

    SettingsNav.Activated:Connect(function()
        SelectPage("Settings")
    end)

    GameNav.Activated:Connect(function()
        SelectPage("Game")
    end)

    SoonNav.Activated:Connect(function()
        SelectPage("Soon")
    end)

    -- Settings page
    Label(SettingsPage, "SETTINGS", 17, 30).Font = Enum.Font.GothamBold
    Label(SettingsPage, "General hub settings", 12, 23, Grey)

    local PausedDisabled = true

    pcall(function()
        GuiService:SetGameplayPausedNotificationEnabled(false)
    end)

    local PauseButton = Instance.new("TextButton")
    PauseButton.Size = UDim2.new(1, 0, 0, 48)
    PauseButton.BackgroundColor3 = ButtonDark
    PauseButton.TextColor3 = White
    PauseButton.TextSize = 12
    PauseButton.Font = Enum.Font.GothamBold
    PauseButton.Parent = SettingsPage
    Corner(PauseButton, 7)
    Stroke(PauseButton, Purple, 1)

    local function UpdatePauseButton()
        PauseButton.Text = "Gameplay Paused Notification: " ..
            (PausedDisabled and "OFF" or "ON")
    end

    UpdatePauseButton()

    PauseButton.Activated:Connect(function()
        PausedDisabled = not PausedDisabled

        local success, err = pcall(function()
            GuiService:SetGameplayPausedNotificationEnabled(not PausedDisabled)
        end)

        UpdatePauseButton()

        if not success then
            Label(SettingsPage, "Could not change setting: " .. tostring(err), 10, 35, Color3.fromRGB(255, 130, 130))
        end
    end)

    Label(
        SettingsPage,
        "When OFF, Roblox's gameplay-paused notification is disabled.",
        11,
        42,
        Grey
    )

    -- Noob Incremental page
    Label(GamePage, "NOOB INCREMENTAL", 17, 30).Font = Enum.Font.GothamBold
    Label(GamePage, "NPC and teleport controls", 12, 22, Grey)

    local Status = Label(GamePage, "STATUS: READY", 12, 28, Color3.fromRGB(170, 210, 255))
    Status.Font = Enum.Font.GothamBold

    local function SetStatus(text)
        Status.Text = "STATUS: " .. tostring(text)
    end

    local function MakeBox(label, value, callback)
        Label(GamePage, label, 11, 20, Grey)

        local Box = Instance.new("TextBox")
        Box.Size = UDim2.new(1, 0, 0, 34)
        Box.BackgroundColor3 = ButtonDark
        Box.TextColor3 = White
        Box.PlaceholderColor3 = Grey
        Box.Text = tostring(value)
        Box.TextSize = 13
        Box.Font = Enum.Font.Gotham
        Box.ClearTextOnFocus = false
        Box.Parent = GamePage
        Corner(Box, 6)
        Stroke(Box, Color3.fromRGB(65, 65, 85), 1)

        Box.FocusLost:Connect(function()
            callback(Box.Text)
        end)

        return Box
    end

    local function MakeButton(text, callback, color)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 38)
        Button.BackgroundColor3 = color or Color3.fromRGB(75, 55, 115)
        Button.TextColor3 = White
        Button.Text = text
        Button.TextSize = 12
        Button.Font = Enum.Font.GothamBold
        Button.Parent = GamePage
        Corner(Button, 7)
        Stroke(Button, Purple, 1)

        Button.Activated:Connect(callback)

        return Button
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
    end, Color3.fromRGB(45, 115, 75))

    -- Coming Soon page
    Label(SoonPage, "COMING SOON", 18, 35).Font = Enum.Font.GothamBold

    local SoonMessage = Label(
        SoonPage,
        "New features will appear here in future updates.",
        12,
        55,
        Grey
    )
    SoonMessage.TextWrapped = true

    -- Initial page
    SelectPage("Settings")

    -- Minimize / draggable bubble
    local Minimized = false
    local BubbleDragging = false
    local BubbleInput
    local BubbleStart
    local BubblePosition
    local BubbleMoved = false

    MinButton.Activated:Connect(function()
        if Minimized then
            return
        end

        Minimized = true

        Header.Visible = false
        Sidebar.Visible = false
        Content.Visible = false

        Frame.Size = UDim2.fromOffset(54, 54)
        Frame.BackgroundColor3 = Purple

        MinButton.Size = UDim2.fromOffset(54, 54)
        MinButton.Position = UDim2.fromOffset(0, 0)
        MinButton.Text = "SN"
        MinButton.TextSize = 15
        MinButton.BackgroundColor3 = Purple
        MinButton.BorderSizePixel = 0
        MinButton.ZIndex = 10
    end)

    MinButton.InputBegan:Connect(function(input)
        if not Minimized then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            BubbleDragging = true
            BubbleInput = input
            BubbleStart = input.Position
            BubblePosition = Frame.Position
            BubbleMoved = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not BubbleDragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input == BubbleInput then
            local Delta = input.Position - BubbleStart

            if Delta.Magnitude > 6 then
                BubbleMoved = true
            end

            Frame.Position = UDim2.new(
                BubblePosition.X.Scale,
                BubblePosition.X.Offset + Delta.X,
                BubblePosition.Y.Scale,
                BubblePosition.Y.Offset + Delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if not BubbleDragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input == BubbleInput then
            BubbleDragging = false

            if not BubbleMoved and Minimized then
                Minimized = false

                Frame.Size = UDim2.fromOffset(WindowWidth, WindowHeight)
                Frame.BackgroundColor3 = Dark

                Header.Visible = true
                Sidebar.Visible = true
                Content.Visible = true

                MinButton.Size = UDim2.fromOffset(38, 34)
                MinButton.Position = UDim2.new(1, -88, 0, 7)
                MinButton.Text = "—"
                MinButton.TextSize = 19
                MinButton.BackgroundColor3 = ButtonDark
                MinButton.ZIndex = 5
            end

            BubbleInput = nil
        end
    end)

    -- Drag main window using header
    local Dragging = false
    local DragInput
    local DragStart
    local StartPosition

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragInput = input
            DragStart = input.Position
            StartPosition = Frame.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if Dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input == DragInput
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
        or input == DragInput then
            Dragging = false
            DragInput = nil
        end
    end)

    ExitButton.Activated:Connect(function()
        Controller.Stop()
        ScreenGui:Destroy()
    end)

    return {
        SetStatus = SetStatus,
        Destroy = function()
            ScreenGui:Destroy()
        end
    }
end

return GUI
