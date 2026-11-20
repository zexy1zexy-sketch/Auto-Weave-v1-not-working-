                {Color3.fromRGB(19,18,27),new.Dark},{Color3.fromRGB(55,48,69),new.ButtonAccentHover},
                {Color3.fromRGB(48,40,63),new.ButtonAccentHover},{Color3.fromRGB(43,33,61),new.BubbleHover}
            }
            for _,pair in ipairs(pairsToMap) do
                if c == pair[1] then return pair[2] end
            end
            return c
        end
        for _,o in ipairs(ScreenGui:GetDescendants()) do
            if o:IsA("UIGradient") then
                local points = {}
                for _,point in ipairs(o.Color.Keypoints) do
                    table.insert(points,ColorSequenceKeypoint.new(point.Time,MapColor(point.Value)))
                end
                o.Color = ColorSequence.new(points)
            elseif o:IsA("UIStroke") then
                o.Color = MapColor(o.Color)
            elseif o:IsA("GuiObject") then
                o.BackgroundColor3 = MapColor(o.BackgroundColor3)
                if o:IsA("ScrollingFrame") then o.ScrollBarImageColor3 = MapColor(o.ScrollBarImageColor3) end
            end
            if o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") then
                o.TextColor3 = MapColor(o.TextColor3)
                if o:IsA("TextBox") then o.PlaceholderColor3 = MapColor(o.PlaceholderColor3) end
            end
            if o:IsA("TextButton") then
                local normal = o:GetAttribute("ThemeNormalColor")
                local hover = o:GetAttribute("ThemeHoverColor")
                if typeof(normal)=="Color3" then o:SetAttribute("ThemeNormalColor",MapColor(normal)) end
                if typeof(hover)=="Color3" then o:SetAttribute("ThemeHoverColor",MapColor(hover)) end
            end
        end
        Dark,Panel,ButtonDark,Border = new.Dark,new.Panel,new.Button,new.Border
        Purple,PurpleLight = new.Color,new.Light
        ThemePalette = new
        CurrentAccent = preset
        AccentLine.BackgroundColor3 = new.Color
        for name,b in pairs(CategoryButtons) do
            local active = name == SelectedCategory
            b.BackgroundColor3 = active and new.Active or ButtonDark
            local st = b:FindFirstChildOfClass("UIStroke")
            if st then st.Color = active and new.Light or new.Border end
        end
        for _,nav in ipairs({SettingsNav,GameNav,LoggerNav,SoonNav}) do
            local active = (CurrentPage=="Settings" and nav==SettingsNav) or
                (CurrentPage=="Game" and nav==GameNav) or
                (CurrentPage=="Logger" and nav==LoggerNav) or
                (CurrentPage=="Soon" and nav==SoonNav)
            nav.BackgroundColor3 = active and new.Active or new.Button
            local st = nav:FindFirstChildOfClass("UIStroke")
            if st then st.Color = active and new.Light or new.Border end
        end
    end
    local ColorRow=Instance.new("Frame") ColorRow.Size=UDim2.new(1,0,0,34) ColorRow.BackgroundTransparency=1 ColorRow.Parent=SettingsPage
    local ColorLayout=Instance.new("UIListLayout") ColorLayout.FillDirection=Enum.FillDirection.Horizontal ColorLayout.Padding=UDim.new(0,5) ColorLayout.Parent=ColorRow
    for _,preset in ipairs(AccentPresets) do
        local b=Instance.new("TextButton") b.Size=UDim2.new(0.2,-4,1,0) b.BackgroundColor3=preset.Color b.Text=preset.Name b.TextColor3=Color3.new(1,1,1) b.TextSize=9 b.Font=Enum.Font.GothamBold b.Parent=ColorRow Corner(b,7) Stroke(b,preset.Light,1) AddHover(b,preset.Color,preset.Light) b.Activated:Connect(function() ApplyAccent(preset) end)
    end
    Label(SettingsPage,"Window size",11,19,Grey)
    local SizeRow=Instance.new("Frame") SizeRow.Size=UDim2.new(1,0,0,34) SizeRow.BackgroundTransparency=1 SizeRow.Parent=SettingsPage
    local SizeLayout=Instance.new("UIListLayout") SizeLayout.FillDirection=Enum.FillDirection.Horizontal SizeLayout.Padding=UDim.new(0,6) SizeLayout.Parent=SizeRow
    for _,preset in ipairs({{Name="SMALL",Scale=0.82},{Name="MEDIUM",Scale=1},{Name="LARGE",Scale=1.15}}) do
        local b=Instance.new("TextButton") b.Size=UDim2.new(1/3,-5,1,0) b.BackgroundColor3=ButtonDark b.Text=preset.Name b.TextColor3=White b.TextSize=10 b.Font=Enum.Font.GothamBold b.Parent=SizeRow Corner(b,7) Stroke(b,Border,1) AddHover(b,ButtonDark,Color3.fromRGB(55,48,69))
        b.Activated:Connect(function() Tween(WindowScale,{Scale=preset.Scale},TweenInfo.new(0.28,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)) for _,sib in ipairs(SizeRow:GetChildren()) do if sib:IsA("TextButton") then local st=sib:FindFirstChildOfClass("UIStroke") if st then Tween(st,{Color=sib==b and CurrentAccent.Light or Border,Thickness=sib==b and 1.5 or 1}) end end end end)
    end
    Label(SettingsPage,"Changes apply instantly and reset when the hub is reloaded.",10,30,Grey)
    Label(SettingsPage,"GENERAL",13,25,PurpleLight).Font=Enum.Font.GothamBold
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
    Corner(PauseButton, 9)
    Stroke(PauseButton, Border, 1)
    AddHover(PauseButton, ButtonDark, Color3.fromRGB(48, 40, 63))
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
    local function LogAction(name, details)
        if Logger and type(Logger.RecordAction) == "function" then
            pcall(function()
                Logger:RecordAction(name, details or {})
            end)
        end
    end
    -- FOLDER SYSTEM
    local function MakeFolder(name)
        local Folder = Instance.new("Frame")
        Folder.Name = name:gsub("%W", "") .. "Folder"
        Folder.Size = UDim2.new(1, 0, 0, 38)
        Folder.BackgroundColor3 = ButtonDark
        Folder.BorderSizePixel = 0
        Folder.ClipsDescendants = true
        Folder.Parent = GamePage
        Corner(Folder, 10)
        Stroke(Folder, Border, 1)
        AddGradient(Folder, Color3.fromRGB(34, 32, 46), ButtonDark, 90)
        local HeaderButton = Instance.new("TextButton")
        HeaderButton.Size = UDim2.new(1, 0, 0, 38)
        HeaderButton.BackgroundTransparency = 1
        HeaderButton.Text = "📁  " .. name .. "     +"
        HeaderButton.TextColor3 = White
        HeaderButton.TextSize = 12
        HeaderButton.Font = Enum.Font.GothamBold
        HeaderButton.TextXAlignment = Enum.TextXAlignment.Left
        HeaderButton.AutoButtonColor = false
        HeaderButton.TextColor3 = Color3.fromRGB(235, 228, 250)
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
            Tween(FolderContent,{Size=UDim2.new(1,-16,0,Open and contentHeight or 0)},TweenInfo.new(0.2,Enum.EasingStyle.Quint,Enum.EasingDirection.Out))
            Tween(Folder,{Size=UDim2.new(1,0,0,Open and (43+contentHeight) or 38)},TweenInfo.new(0.2,Enum.EasingStyle.Quint,Enum.EasingDirection.Out))
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
    -- INPUT BOXES
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
        Corner(box, 8)
        Stroke(box, Border, 1)
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.FocusLost:Connect(function()
            callback(box.Text)
        end)
        return box
    end
    -- BUTTONS
    local function MakeButton(parent, text, callback, color)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 38)
        b.BackgroundColor3 = color or Color3.fromRGB(75, 55, 115)
        b.TextColor3 = White
        b.Text = text
        b.TextSize = 12
        b.Font = Enum.Font.GothamBold
        b.Parent = parent
        Corner(b, 8)
        Stroke(b, Border, 1)
        AddHover(
            b,
            color or Color3.fromRGB(75, 55, 115),
            Color3.fromRGB(94, 68, 137)
        )
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
        LogAction("Manual Teleport", {
            Target = Config.TargetName
        })
        Controller.TeleportNow()
    end)
    local AutoButton
    AutoButton = MakeButton(TeleportFolder, "AUTO TP: OFF", function()
        if Controller.IsEnabled() then
            Controller.Stop()
            AutoButton.Text = "AUTO TP: OFF"
            LogAction("Auto TP Stopped")
        else
            Controller.Start()
            AutoButton.Text = "AUTO TP: ON"
            LogAction("Auto TP Started", {
                Target = Config.TargetName,
                Speed = Config.TeleportsPerSecond
            })
        end
    end, Color3.fromRGB(45, 115, 75))
    -- REMOTES FOLDER
    local ScytheFolder = MakeFolder("REMOTES")
    Config.ScytheSpeed = math.clamp(tonumber(Config.ScytheSpeed) or 1, 1, 100)
    MakeBox(ScytheFolder, "SCYTHE ROLL SPEED (1-100 CPS)", Config.ScytheSpeed, function(value)
        Config.ScytheSpeed = math.clamp(tonumber(value) or 1, 1, 100)
        Scythe.SetSpeed(Config.ScytheSpeed)
        LogAction("Scythe Speed Changed", {
            Speed = Config.ScytheSpeed
        })
    end)
    Scythe.SetSpeed(Config.ScytheSpeed)
    local ScytheButton
    ScytheButton = MakeButton(ScytheFolder, "SCYTHE ENCHANT AUTO ROLL: OFF", function()
        if Scythe.IsEnabled() then
            Scythe.Stop()
            ScytheButton.Text = "SCYTHE ENCHANT AUTO ROLL: OFF"
            SetStatus("SCYTHE ROLL STOPPED")
            LogAction("Scythe Auto Roll Stopped")
        else
            local ok, message = Scythe.Start()
            if ok then
                ScytheButton.Text = "SCYTHE ENCHANT AUTO ROLL: ON"
                SetStatus("SCYTHE ROLL RUNNING")
                LogAction("Scythe Auto Roll Started", {
                    Speed = Config.ScytheSpeed
                })
            else
                ScytheButton.Text = "SCYTHE ENCHANT AUTO ROLL: OFF"
                SetStatus(message or "SCYTHE ERROR")
                LogAction("Scythe Auto Roll Failed", {
                    Reason = tostring(message)
                })
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
    local CategoryFrame = Instance.new("Frame")
    CategoryFrame.Size = UDim2.new(1, 0, 0, 32)
    CategoryFrame.BackgroundTransparency = 1
    CategoryFrame.Parent = LoggerPage
    local CategoryLayout = Instance.new("UIListLayout")
    CategoryLayout.FillDirection = Enum.FillDirection.Horizontal
    CategoryLayout.Padding = UDim.new(0, 4)
    CategoryLayout.Parent = CategoryFrame
    local Categories = {"All", "FireServer", "InvokeServer", "Other"}
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
I caught a formatting problem while sending the long replacement: the code was duplicated across the streamed sections. **Please don't paste that code.**

Would you like me to update `GUI.lua` directly in your GitHub repository instead? That avoids risking a broken copy-and-paste.
