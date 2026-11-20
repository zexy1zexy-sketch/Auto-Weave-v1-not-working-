
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

local GUI = {}

function GUI.Create(Config, Controller, Scythe, Logger)
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
    local LoggerNav = MakeNav("◉  Remote Logger", 3)
    local SoonNav = MakeNav("＋  Coming Soon", 4)

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
    local LoggerPage = MakePage("RemoteLogger")
    local SoonPage = MakePage("ComingSoon")

    local function SelectPage(page)
        SettingsPage.Visible = page == "Settings"
        GamePage.Visible = page == "Game"
        LoggerPage.Visible = page == "Logger"
        SoonPage.Visible = page == "Soon"

        SettingsNav.BackgroundColor3 = page == "Settings" and Color3.fromRGB(48, 37, 67) or ButtonDark
        GameNav.BackgroundColor3 = page == "Game" and Color3.fromRGB(48, 37, 67) or ButtonDark
        LoggerNav.BackgroundColor3 = page == "Logger" and Color3.fromRGB(48, 37, 67) or ButtonDark
        SoonNav.BackgroundColor3 = page == "Soon" and Color3.fromRGB(48, 37, 67) or ButtonDark
    end

    SettingsNav.Activated:Connect(function()
        SelectPage("Settings")
    end)

    GameNav.Activated:Connect(function()
        SelectPage("Game")
    end)

    LoggerNav.Activated:Connect(function()
        SelectPage("Logger")
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

    Config.ScytheSpeed = math.clamp(
        tonumber(Config.ScytheSpeed) or 1,
        1,
        100
    )

    MakeBox("SCYTHE ROLL SPEED (1-100 CPS)", Config.ScytheSpeed, function(value)
        Config.ScytheSpeed = math.clamp(
            tonumber(value) or 1,
            1,
            100
        )

        Scythe.SetSpeed(Config.ScytheSpeed)
    end)

    Scythe.SetSpeed(Config.ScytheSpeed)

    local ScytheButton

    ScytheButton = MakeButton("SYTHE ENCHANT AUTO ROLL: OFF", function()
        if Scythe.IsEnabled() then
            Scythe.Stop()
            ScytheButton.Text = "SYTHE ENCHANT AUTO ROLL: OFF"
            SetStatus("SCYTHE ROLL STOPPED")
        else
            local success, message = Scythe.Start()

            if success then
                ScytheButton.Text = "SYTHE ENCHANT AUTO ROLL: ON"
                SetStatus("SCYTHE ROLL RUNNING")
            else
                ScytheButton.Text = "SYTHE ENCHANT AUTO ROLL: OFF"
                SetStatus(message or "SCYTHE ERROR")
            end
        end
    end, Color3.fromRGB(100, 65, 160))

    -- Remote Logger page
    Label(LoggerPage, "REMOTE LOGGER", 17, 30).Font = Enum.Font.GothamBold
    Label(LoggerPage, "Monitor instrumented remote activity", 11, 22, Grey)

    local StatsLabel = Label(LoggerPage, "TOTAL: 0  |  FIRE: 0  |  INVOKE: 0", 10, 25, Grey)

    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(1, 0, 0, 36)
    SearchBox.BackgroundColor3 = ButtonDark
    SearchBox.TextColor3 = White
    SearchBox.PlaceholderColor3 = Grey
    SearchBox.PlaceholderText = "Search remote name or path..."
    SearchBox.Text = ""
    SearchBox.TextSize = 11
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.ClearTextOnFocus = false
    SearchBox.Parent = LoggerPage
    Corner(SearchBox, 7)
    Stroke(SearchBox, Purple, 1)

    local SelectedCategory = "All"

    local CategoryFrame = Instance.new("Frame")
    CategoryFrame.Size = UDim2.new(1, 0, 0, 32)
    CategoryFrame.BackgroundTransparency = 1
    CategoryFrame.Parent = LoggerPage

    local CategoryLayout = Instance.new("UIListLayout")
    CategoryLayout.FillDirection = Enum.FillDirection.Horizontal
    CategoryLayout.Padding = UDim.new(0, 4)
    CategoryLayout.Parent = CategoryFrame

    local Categories = {"All", "FireServer", "InvokeServer", "Other"}
    local CategoryButtons = {}

    local LogContainer = Instance.new("ScrollingFrame")
    LogContainer.Name = "LogContainer"
    LogContainer.Size = UDim2.new(1, 0, 0, 170)
    LogContainer.BackgroundColor3 = Dark
    LogContainer.BorderSizePixel = 0
    LogContainer.ScrollBarThickness = 4
    LogContainer.ScrollBarImageColor3 = Purple
    LogContainer.CanvasSize = UDim2.fromOffset(0, 0)
    LogContainer.Parent = LoggerPage
    Corner(LogContainer, 7)

    local LogLayout = Instance.new("UIListLayout")
    LogLayout.Padding = UDim.new(0, 5)
    LogLayout.Parent = LogContainer

    local LogPadding = Instance.new("UIPadding")
    LogPadding.PaddingTop = UDim.new(0, 6)
    LogPadding.PaddingLeft = UDim.new(0, 6)
    LogPadding.PaddingRight = UDim.new(0, 6)
    LogPadding.Parent = LogContainer

    LogLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        LogContainer.CanvasSize = UDim2.fromOffset(
            0,
            LogLayout.AbsoluteContentSize.Y + 15
        )
    end)

    local function RefreshLogs()
        for _, child in ipairs(LogContainer:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end

        if not Logger then
            StatsLabel.Text = "LOGGER MODULE NOT LOADED"
            return
        end

        local stats = Logger:GetStats()

        StatsLabel.Text = string.format(
            "TOTAL: %d  |  FIRE: %d  |  INVOKE: %d",
            stats.Total,
            stats.FireServer,
            stats.InvokeServer
        )

        local entries = Logger:GetLogs(
            SelectedCategory,
            SearchBox.Text
        )

        if #entries == 0 then
            local Empty = Label(
                LogContainer,
                "No matching logs found.",
                11,
                35,
                Grey
            )
            Empty.TextXAlignment = Enum.TextXAlignment.Center
            return
        end

        for _, entry in ipairs(entries) do
            local Card = Instance.new("Frame")
            Card.Size = UDim2.new(1, -4, 0, 68)
            Card.BackgroundColor3 = Panel
            Card.BorderSizePixel = 0
            Card.Parent = LogContainer
            Corner(Card, 6)
            Stroke(Card, Color3.fromRGB(60, 50, 80), 1)

            local Name = Label(
                Card,
                entry.Name .. "  [" .. entry.Method .. "]",
                10,
                24,
                White
            )
            Name.Position = UDim2.fromOffset(7, 2)
            Name.Size = UDim2.new(1, -14, 0, 22)
            Name.Font = Enum.Font.GothamBold

            local Path = Label(
                Card,
                entry.Path,
                9,
                18,
                Grey
            )
            Path.Position = UDim2.fromOffset(7, 25)
            Path.Size = UDim2.new(1, -14, 0, 18)
            Path.TextTruncate = Enum.TextTruncate.AtEnd

            local Time = Label(
                Card,
                entry.Timestamp,
                9,
                17,
                Purple
            )
            Time.Position = UDim2.fromOffset(7, 45)
        end
    end

    for index, category in ipairs(Categories) do
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0.25, -4, 1, 0)
        Button.BackgroundColor3 = category == "All" and Purple or ButtonDark
        Button.Text = category
        Button.TextColor3 = White
        Button.TextSize = 8
        Button.Font = Enum.Font.GothamBold
        Button.Parent = CategoryFrame
        Corner(Button, 5)

        CategoryButtons[category] = Button

        Button.Activated:Connect(function()
            SelectedCategory = category

            for _, name in ipairs(Categories) do
                CategoryButtons[name].BackgroundColor3 =
                    name == category and Purple or ButtonDark
            end

            RefreshLogs()
        end)
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(RefreshLogs)

    local function MakeLoggerButton(text, callback, color)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 36)
        Button.BackgroundColor3 = color or ButtonDark
        Button.Text = text
        Button.TextColor3 = White
        Button.TextSize = 11
        Button.Font = Enum.Font.GothamBold
        Button.Parent = LoggerPage
        Corner(Button, 6)
        Stroke(Button, Purple, 1)
        Button.Activated:Connect(callback)
        return Button
    end

    MakeLoggerButton("COPY ALL LOGS", function()
        if not Logger then return end

        local output = Logger:Export()

        if setclipboard then
            local success = pcall(function()
                setclipboard(output)
            end)

            if success then
                StatsLabel.Text = "ALL LOGS COPIED!"
            else
                StatsLabel.Text = "COPY FAILED"
            end
        else
            StatsLabel.Text = "CLIPBOARD NOT SUPPORTED"
        end
    end, Color3.fromRGB(75, 55, 115))

    MakeLoggerButton("CLEAR ALL LOGS", function()
        if Logger then
            Logger:Clear()
            RefreshLogs()
        end
    end, Color3.fromRGB(125, 45, 55))

    local LoggingButton

    LoggingButton = MakeLoggerButton("PAUSE LOGGING", function()
        if not Logger then return end

        local enabled = not Logger.Enabled
        Logger:SetEnabled(enabled)

        LoggingButton.Text = enabled and "PAUSE LOGGING" or "RESUME LOGGING"
        RefreshLogs()
    end, Color3.fromRGB(45, 100, 75))

    RefreshLogs()

    -- Coming Soon
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
        if Minimized then return end

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
        if not Minimized then return end

        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            BubbleDragging = true
            BubbleInput = input
            BubbleStart = input.Position
            BubblePosition = Frame.Position
            BubbleMoved = false
        end
    end)
