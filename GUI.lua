
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local GUI = {}

function GUI.Create(Config, Controller, Scythe, Logger)
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

    local function Corner(obj, radius)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius or 8)
        c.Parent = obj
    end

    local function Stroke(obj, color, thickness)
        local s = Instance.new("UIStroke")
        s.Color = color or Purple
        s.Thickness = thickness or 1
        s.Parent = obj
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

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.fromOffset(WindowWidth, WindowHeight)
    Frame.Position = UDim2.new(0.5, -WindowWidth / 2, 0.5, -WindowHeight / 2)
    Frame.BackgroundColor3 = Dark
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    Corner(Frame, 12)
    Stroke(Frame, Purple, 1.3)

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 48)
    Header.BackgroundColor3 = Dark
    Header.BorderSizePixel = 0
    Header.Parent = Frame
    Corner(Header, 10)

    local HeaderTitle = Label(Header, "  SHORTNAME HUB", 15, 48)
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
        local b = Instance.new("TextButton")
        b.Name = text
        b.LayoutOrder = order
        b.Size = UDim2.new(1, 0, 0, 43)
        b.BackgroundColor3 = ButtonDark
        b.TextColor3 = White
        b.Text = text
        b.TextSize = WindowWidth < 380 and 11 or 13
        b.Font = Enum.Font.GothamBold
        b.Parent = Sidebar
        Corner(b, 7)
        Stroke(b, Purple, 1)
        return b
    end

    local SettingsNav = MakeNav("⚙  Settings", 1)
    local GameNav = MakeNav("◆  Noob Incremental", 2)
    local LoggerNav = MakeNav("◉  Remote Logger", 3)
    local SoonNav = MakeNav("＋  Coming Soon", 4)

    local Content = Instance.new("Frame")
    Content.Position = UDim2.new(0, SidebarWidth + 20, 0, 58)
    Content.Size = UDim2.new(1, -SidebarWidth - 30, 1, -68)
    Content.BackgroundColor3 = Panel
    Content.BorderSizePixel = 0
    Content.Parent = Frame
    Corner(Content, 9)

    local function MakePage(name)
        local page = Instance.new("ScrollingFrame")
        page.Name = name
        page.Size = UDim2.new(1, -16, 1, -16)
        page.Position = UDim2.fromOffset(8, 8)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 4
        page.ScrollBarImageColor3 = Purple
        page.CanvasSize = UDim2.fromOffset(0, 0)
        page.Visible = false
        page.Parent = Content

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page

        local padding = Instance.new("UIPadding")
        padding.PaddingBottom = UDim.new(0, 10)
        padding.Parent = page

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 15)
        end)

        return page
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

    SettingsNav.Activated:Connect(function() SelectPage("Settings") end)
    GameNav.Activated:Connect(function() SelectPage("Game") end)
    LoggerNav.Activated:Connect(function() SelectPage("Logger") end)
    SoonNav.Activated:Connect(function() SelectPage("Soon") end)

    -- SETTINGS
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
        local ok, err = pcall(function()
            GuiService:SetGameplayPausedNotificationEnabled(not PausedDisabled)
        end)
        UpdatePauseButton()
        if not ok then
            Label(SettingsPage, "Could not change setting: " .. tostring(err), 10, 35, Color3.fromRGB(255, 130, 130))
        end
    end)

    Label(SettingsPage, "When OFF, Roblox's gameplay-paused notification is disabled.", 11, 42, Grey)

    -- NOOB INCREMENTAL
    Label(GamePage, "NOOB INCREMENTAL", 17, 30).Font = Enum.Font.GothamBold
    Label(GamePage, "Tap a folder to show or hide its features.", 12, 22, Grey)

    local Status = Label(GamePage, "STATUS: READY", 12, 28, Color3.fromRGB(170, 210, 255))
    Status.Font = Enum.Font.GothamBold

    local function SetStatus(text)
        Status.Text = "STATUS: " .. tostring(text)
    end

    local function MakeFolder(name)
        local Folder = Instance.new("Frame")
        Folder.Name = name:gsub("%W", "") .. "Folder"
        Folder.Size = UDim2.new(1, 0, 0, 38)
        Folder.BackgroundColor3 = ButtonDark
        Folder.BorderSizePixel = 0
        Folder.ClipsDescendants = true
        Folder.Parent = GamePage
        Corner(Folder, 8)
        Stroke(Folder, Purple, 1)

        local HeaderButton = Instance.new("TextButton")
        HeaderButton.Size = UDim2.new(1, 0, 0, 38)
        HeaderButton.BackgroundTransparency = 1
        HeaderButton.Text = "📁  " .. name .. "     +"
        HeaderButton.TextColor3 = White
        HeaderButton.TextSize = 12
        HeaderButton.Font = Enum.Font.GothamBold
        HeaderButton.TextXAlignment = Enum.TextXAlignment.Left
        HeaderButton.Parent = Folder

        local FolderContent = Instance.new("Frame")
        FolderContent.Position = UDim2.fromOffset(8, 43)
        FolderContent.Size = UDim2.new(1, -16, 0, 0)
        FolderContent.BackgroundTransparency = 1
        FolderContent.Visible = false
        FolderContent.Parent = Folder

        local FolderLayout = Instance.new("UIListLayout")
        FolderLayout.Padding = UDim.new(0, 7)
        FolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
        FolderLayout.Parent = FolderContent

        local FolderPadding = Instance.new("UIPadding")
        FolderPadding.PaddingBottom = UDim.new(0, 8)
        FolderPadding.Parent = FolderContent

        local Open = false

        local function UpdateSize()
            local contentHeight = FolderLayout.AbsoluteContentSize.Y + 8
            FolderContent.Size = UDim2.new(1, -16, 0, contentHeight)
            Folder.Size = UDim2.new(
                1, 0, 0,
                Open and (43 + contentHeight) or 38
            )
        end

        HeaderButton.Activated:Connect(function()
            Open = not Open
            FolderContent.Visible = Open
            HeaderButton.Text = (Open and "📂  " or "📁  ")
                .. name .. (Open and "     -" or "     +")
            UpdateSize()
        end)

        FolderLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if Open then
                UpdateSize()
            end
        end)

        return FolderContent
    end

    local function MakeBox(parent, label, value, callback)
        Label(parent, label, 11, 20, Grey)

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, 0, 0, 34)
        box.BackgroundColor3 = ButtonDark
        box.TextColor3 = White
        box.PlaceholderColor3 = Grey
        box.Text = tostring(value)
        box.TextSize = 13
        box.Font = Enum.Font.Gotham
        box.ClearTextOnFocus = false
        box.Parent = parent
        Corner(box, 6)
        Stroke(box, Color3.fromRGB(65, 65, 85), 1)

        box.FocusLost:Connect(function()
            callback(box.Text)
        end)

        return box
    end

    local function MakeButton(parent, text, callback, color)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 38)
        b.BackgroundColor3 = color or Color3.fromRGB(75, 55, 115)
        b.TextColor3 = White
        b.Text = text
        b.TextSize = 12
        b.Font = Enum.Font.GothamBold
        b.Parent = parent
        Corner(b, 7)
        Stroke(b, Purple, 1)
        b.Activated:Connect(callback)
        return b
    end

    -- NPC & TELEPORT FOLDER
    local TeleportFolder = MakeFolder("NPC & TELEPORT")

    MakeBox(TeleportFolder, "NPC NAME", Config.TargetName, function(value)
        Config.TargetName = value
        Controller.SetTargetName(value)
    end)

    MakeBox(TeleportFolder, "AIR INTERVAL (SECONDS)", Config.AirInterval, function(value)
        Config.AirInterval = math.clamp(tonumber(value) or 5, 1, 30)
    end)

    MakeBox(TeleportFolder, "AIR TIME (SECONDS)", Config.AirTime, function(value)
        Config.AirTime = math.clamp(tonumber(value) or 3, 1, 30)
    end)

    MakeBox(TeleportFolder, "TP HEIGHT (STUDS)", Config.AirHeight, function(value)
        Config.AirHeight = math.clamp(tonumber(value) or 100, 1, 1000)
    end)

    MakeBox(TeleportFolder, "TP SPEED", Config.TeleportsPerSecond, function(value)
        Config.TeleportsPerSecond = math.clamp(tonumber(value) or 1, 0.1, 100)
    end)

    MakeButton(TeleportFolder, "TELEPORT NOW", function()
        Controller.TeleportNow()
    end)

    local AutoButton
    AutoButton = MakeButton(TeleportFolder, "AUTO TP: OFF", function()
        if Controller.IsEnabled() then
            Controller.Stop()
            AutoButton.Text = "AUTO TP: OFF"
        else
            Controller.Start()
            AutoButton.Text = "AUTO TP: ON"
        end
    end, Color3.fromRGB(45, 115, 75))

    -- SCYTHE FOLDER
    local ScytheFolder = MakeFolder("SCYTHE")

    Config.ScytheSpeed = math.clamp(tonumber(Config.ScytheSpeed) or 1, 1, 100)

    MakeBox(ScytheFolder, "SCYTHE ROLL SPEED (1-100 CPS)", Config.ScytheSpeed, function(value)
        Config.ScytheSpeed = math.clamp(tonumber(value) or 1, 1, 100)
        Scythe.SetSpeed(Config.ScytheSpeed)
    end)

    Scythe.SetSpeed(Config.ScytheSpeed)

    local ScytheButton
    ScytheButton = MakeButton(ScytheFolder, "SCYTHE ENCHANT AUTO ROLL: OFF", function()
        if Scythe.IsEnabled() then
            Scythe.Stop()
            ScytheButton.Text = "SCYTHE ENCHANT AUTO ROLL: OFF"
            SetStatus("SCYTHE ROLL STOPPED")
        else
            local ok, message = Scythe.Start()
            if ok then
                ScytheButton.Text = "SCYTHE ENCHANT AUTO ROLL: ON"
                SetStatus("SCYTHE ROLL RUNNING")
            else
                ScytheButton.Text = "SCYTHE ENCHANT AUTO ROLL: OFF"
                SetStatus(message or "SCYTHE ERROR")
            end
        end
    end, Color3.fromRGB(100, 65, 160))

    
    -- REMOTE LOGGER PAGE
    Label(LoggerPage, "REMOTE LOGGER", 17, 30).Font = Enum.Font.GothamBold
    Label(LoggerPage, "LOCAL TEST MODE - no game remotes captured", 10, 22, Grey)

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
        LogContainer.CanvasSize = UDim2.fromOffset(0, LogLayout.AbsoluteContentSize.Y + 15)
    end)


    local LastRenderKey = nil
    local DisplayLimit = 30

    local function RefreshLogs(force)
        if not Logger then
            StatsLabel.Text = "LOGGER MODULE NOT LOADED"
            return
        end

        local version = Logger:GetVersion()
        local renderKey = tostring(version) .. "|"
            .. SelectedCategory .. "|" .. SearchBox.Text

        if not force and renderKey == LastRenderKey then
            return
        end

        LastRenderKey = renderKey

        for _, child in ipairs(LogContainer:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then
                child:Destroy()
            end
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

        local shown = math.min(#entries, DisplayLimit)

        for i = 1, shown do
            local entry = entries[i]

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

            local Path = Label(Card, entry.Path, 9, 18, Grey)
            Path.Position = UDim2.fromOffset(7, 25)
            Path.Size = UDim2.new(1, -14, 0, 18)
            Path.TextTruncate = Enum.TextTruncate.AtEnd

            local Time = Label(Card, entry.Timestamp, 9, 17, Purple)
            Time.Position = UDim2.fromOffset(7, 45)
        end
    end

    -- LOGGER CATEGORY BUTTONS
    for _, category in ipairs(Categories) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.25, -4, 1, 0)
        button.BackgroundColor3 = ButtonDark
        button.TextColor3 = White
        button.Text = category == "FireServer" and "Fire"
            or category == "InvokeServer" and "Invoke"
            or category
        button.TextSize = 9
        button.Font = Enum.Font.GothamBold
        button.Parent = CategoryFrame
        Corner(button, 5)

        CategoryButtons[category] = button

        button.Activated:Connect(function()
            SelectedCategory = category

            for name, categoryButton in pairs(CategoryButtons) do
                categoryButton.BackgroundColor3 =
                    name == SelectedCategory
                    and Color3.fromRGB(75, 50, 115)
                    or ButtonDark
            end

            RefreshLogs()
        end)

    end

    CategoryButtons.All.BackgroundColor3 = Color3.fromRGB(75, 50, 115)

    SearchBox:GetPropertyChangedSignal("Text"):Connect(RefreshLogs)

    -- AUTOMATIC LOGGER REFRESH
    task.spawn(function()
        while ScreenGui.Parent do
            task.wait(1)

            if LoggerPage.Visible then
                RefreshLogs()
            end
        end
    end)

    -- LOGGER CONTROLS
    local LoggerControls = Instance.new("Frame")
    LoggerControls.Size = UDim2.new(1, 0, 0, 38)
    LoggerControls.BackgroundTransparency = 1
    LoggerControls.Parent = LoggerPage

    local ControlsLayout = Instance.new("UIListLayout")
    ControlsLayout.FillDirection = Enum.FillDirection.Horizontal
    ControlsLayout.Padding = UDim.new(0, 5)
    ControlsLayout.Parent = LoggerControls

    local function MakeLoggerButton(text, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.2, -4, 1, 0)
        button.BackgroundColor3 = ButtonDark
        button.TextColor3 = White
        button.Text = text
        button.TextSize = 10
        button.Font = Enum.Font.GothamBold
        button.Parent = LoggerControls
        Corner(button, 6)
        Stroke(button, Purple, 1)
        button.Activated:Connect(callback)
        return button
    end

    MakeLoggerButton("REFRESH", RefreshLogs)
    MakeLoggerButton("TEST", function()
        if not Logger then
            return
        end

        local testRemote = Instance.new("Folder")
        testRemote.Name = "ShortNameLoggerTest"

        Logger:Record(testRemote, "Test", {
            Source = "Local test",
            Value = 123
        })

        testRemote:Destroy()
        RefreshLogs(true)
    end)

    MakeLoggerButton("CLEAR", function()
        if Logger then
            Logger:Clear()
        end
        RefreshLogs()
    end)

    local PauseButtonLogger
    PauseButtonLogger = MakeLoggerButton("PAUSE: OFF", function()
        if not Logger then
            return
        end

        Logger:SetEnabled(not Logger.Enabled)
        PauseButtonLogger.Text = Logger.Enabled
            and "PAUSE: OFF"
            or "PAUSE: ON"
    end)

    local CopyLogsButton
    CopyLogsButton = MakeLoggerButton("COPY LOGS", function()
        if not Logger then
            return
        end

        local exported = Logger:Export()
        local copied = false

        if type(setclipboard) == "function" then
            copied = pcall(function()
                setclipboard(exported)
            end)
        end

        if not copied and type(toclipboard) == "function" then
            copied = pcall(function()
                toclipboard(exported)
            end)
        end

        CopyLogsButton.Text = copied and "COPIED!" or "COPY FAILED"

        task.delay(1.5, function()
            if CopyLogsButton and CopyLogsButton.Parent then
                CopyLogsButton.Text = "COPY LOGS"
            end
        end)
    end)

    RefreshLogs()

    -- COMING SOON PAGE
    Label(SoonPage, "COMING SOON", 17, 30).Font = Enum.Font.GothamBold
    Label(SoonPage, "More features are being worked on.", 12, 25, Grey)

    local SoonCard = Instance.new("Frame")
    SoonCard.Size = UDim2.new(1, 0, 0, 75)
    SoonCard.BackgroundColor3 = ButtonDark
    SoonCard.BorderSizePixel = 0
    SoonCard.Parent = SoonPage
    Corner(SoonCard, 8)
    Stroke(SoonCard, Purple, 1)

    local SoonText = Label(SoonCard, "Stay tuned for future updates!", 12, 75, White)
    SoonText.TextXAlignment = Enum.TextXAlignment.Center

    -- MINIMIZE BUBBLE
    local Bubble = Instance.new("TextButton")
    Bubble.Name = "ShortNameBubble"
    Bubble.Size = UDim2.fromOffset(55, 55)
    Bubble.Position = UDim2.new(0, 15, 0.5, -27)
    Bubble.BackgroundColor3 = Dark
    Bubble.Text = "SN"
    Bubble.TextColor3 = White
    Bubble.TextSize = 17
    Bubble.Font = Enum.Font.GothamBold
    Bubble.Visible = false
    Bubble.Parent = ScreenGui
    Corner(Bubble, 50)
    Stroke(Bubble, Purple, 2)

    local Minimized = false

    MinButton.Activated:Connect(function()
        Minimized = true
        Frame.Visible = false
        Bubble.Visible = true
    end)

    Bubble.Activated:Connect(function()
        Minimized = false
        Frame.Visible = true
        Bubble.Visible = false
    end)

    -- WINDOW DRAGGING
    local Dragging = false
    local DragInput
    local DragStart
    local StartPosition

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = Frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local delta = input.Position - DragStart
            Frame.Position = UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + delta.Y
            )
        end
    end)

    -- BUBBLE DRAGGING
    local BubbleDragging = false
    local BubbleInput
    local BubbleStart
    local BubblePosition

    Bubble.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            BubbleDragging = true
            BubbleInput = input
            BubbleStart = input.Position
            BubblePosition = Bubble.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    BubbleDragging = false
                end
            end)
        end
    end)

    Bubble.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            BubbleInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == BubbleInput and BubbleDragging then
            local delta = input.Position - BubbleStart
            Bubble.Position = UDim2.new(
                BubblePosition.X.Scale,
                BubblePosition.X.Offset + delta.X,
                BubblePosition.Y.Scale,
                BubblePosition.Y.Offset + delta.Y
            )
        end
    end)

    -- EXIT
    ExitButton.Activated:Connect(function()
        pcall(function()
            Controller.Stop()
        end)

        pcall(function()
            Scythe.Stop()
        end)

        ScreenGui:Destroy()
    end)

    SelectPage("Settings")

    return {
        SetStatus = SetStatus,
        RefreshLogs = RefreshLogs,
        ScreenGui = ScreenGui
    }
end

return GUI
