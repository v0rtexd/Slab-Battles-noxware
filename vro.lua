local library = {}
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

function library.CreateLibrary(name)
    local self = {}
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ScreenGui"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    main.BackgroundTransparency = 0.1
    main.Position = UDim2.new(0.309, 0, 0.324, 0)
    main.BorderSizePixel = 0
    local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
    main.Size = isMobile and UDim2.new(0, 285, 0, 144) or UDim2.new(0, 569, 0, 288)
    main.Parent = screenGui

    local uICorner = Instance.new("UICorner")
    uICorner.CornerRadius = UDim.new(0, 9)
    uICorner.Parent = main

    local decoration = Instance.new("ImageLabel")
    decoration.Name = "Decoration"
    decoration.ImageColor3 = Color3.fromRGB(143, 143, 143)
    decoration.ScaleType = Enum.ScaleType.Crop
    decoration.BackgroundTransparency = 1
    decoration.Rotation = -17
    decoration.Image = "rbxassetid://10709818626"
    decoration.Position = UDim2.new(0.023, 0, 0.02, 0)
    decoration.Size = UDim2.new(0, 17, 0, 17)
    decoration.Parent = main

    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
    topBar.BackgroundTransparency = 0.8
    topBar.Position = UDim2.new(0.0133, 0, 0.0339, 0)
    topBar.Size = UDim2.new(1, 0, 0, 25)
    topBar.BorderSizePixel = 0
    topBar.Parent = main

    local uICorner2 = Instance.new("UICorner")
    uICorner2.CornerRadius = UDim.new(0, 4)
    uICorner2.Parent = topBar

    local dragButton = Instance.new("TextButton")
    dragButton.Name = "DragButton"
    dragButton.BackgroundTransparency = 1
    dragButton.Size = UDim2.new(1, 0, 1, 0)
    dragButton.Text = ""
    dragButton.Parent = topBar

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Font = Font.fromName("GothamSSm", Enum.FontWeight.SemiBold)
    title.TextColor3 = Color3.fromRGB(167, 167, 167)
    title.BackgroundTransparency = 1
    title.TextSize = 14
    title.Text = name
    title.Size = UDim2.new(0, 87, 0, 15)
    title.Position = UDim2.new(0.0585, 0, 0.176, 0)
    title.Parent = topBar

    local tabsFrame = Instance.new("Frame")
    tabsFrame.Name = "TabsFrame"
    tabsFrame.BackgroundTransparency = 1
    tabsFrame.Position = UDim2.new(0, 0, 1, 0)
    tabsFrame.Size = UDim2.new(0, 128, 1, -25)
    tabsFrame.Parent = topBar

    local tabsLayout = Instance.new("UIListLayout")
    tabsLayout.FillDirection = Enum.FillDirection.Vertical
    tabsLayout.Padding = UDim.new(0, 5)
    tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabsLayout.Parent = tabsFrame

    local modulesFrame = Instance.new("ScrollingFrame")
    modulesFrame.Name = "ModulesFrame"
    modulesFrame.BackgroundTransparency = 1
    modulesFrame.ScrollBarThickness = 3
    modulesFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    modulesFrame.Position = UDim2.new(0.228, 0, 0.119, 0)
    modulesFrame.Size = UDim2.new(0.772, 0, 0.861, 0)
    modulesFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    modulesFrame.Parent = main

    local modulesLayout = Instance.new("UIListLayout")
    modulesLayout.FillDirection = Enum.FillDirection.Vertical
    modulesLayout.Padding = UDim.new(0, 5)
    modulesLayout.SortOrder = Enum.SortOrder.LayoutOrder
    modulesLayout.Parent = modulesFrame

    modulesLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        modulesFrame.CanvasSize = UDim2.new(0, 0, 0, modulesLayout.AbsoluteContentSize.Y)
    end)

    local dragging = false
    local dragStartPos
    local startPos

    dragButton.MouseButton1Down:Connect(function()
        dragging = true
        dragStartPos = UIS:GetMouseLocation()
        startPos = main.Position
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = UIS:GetMouseLocation() - dragStartPos
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    self.tabs = {}
    local selectedTab

    function self:AddTab(tabName)
        local tab = {}
        tab.moduleFrames = {}
        tab.frame = Instance.new("Frame")
        tab.frame.BackgroundTransparency = 1
        tab.frame.Size = UDim2.new(1, 0, 0, 22)
        tab.frame.Parent = tabsFrame

        local tabButton = Instance.new("TextButton")
        tabButton.BackgroundTransparency = 1
        tabButton.Size = UDim2.new(1, 0, 1, 0)
        tabButton.Text = ""
        tabButton.Parent = tab.frame

        local tabIcon = Instance.new("ImageLabel")
        tabIcon.BackgroundTransparency = 1
        tabIcon.ImageColor3 = Color3.fromRGB(144, 144, 144)
        tabIcon.Image = "rbxassetid://10734951847"
        tabIcon.Position = UDim2.new(0.1, 0, 0.145, 0)
        tabIcon.Size = UDim2.new(0, 15, 0, 15)
        tabIcon.Parent = tab.frame
        Instance.new("UIAspectRatioConstraint").Parent = tabIcon

        local tabText = Instance.new("TextLabel")
        tabText.BackgroundTransparency = 1
        tabText.Font = Font.fromName("GothamSSm", Enum.FontWeight.SemiBold)
        tabText.TextSize = 13
        tabText.TextColor3 = Color3.fromRGB(168, 168, 168)
        tabText.Text = tabName
        tabText.Position = UDim2.new(0.197, 0, 0.182, 0)
        tabText.Size = UDim2.new(0, 70, 0, 13)
        tabText.Parent = tab.frame

        tabButton.MouseButton1Click:Connect(function()
            if selectedTab then
                selectedTab.text.TextColor3 = Color3.fromRGB(168, 168, 168)
                for _, modFrame in ipairs(selectedTab.moduleFrames) do
                    modFrame.Visible = false
                end
            end
            selectedTab = tab
            tabText.TextColor3 = Color3.new(1, 1, 1)
            for _, modFrame in ipairs(tab.moduleFrames) do
                modFrame.Visible = true
            end
        end)

        tab.text = tabText

        if not selectedTab then
            tabButton.MouseButton1Click:Fire()
        end

        function tab:AddModule(modName, callback)
            callback = callback or function() end
            local module = {}
            module.enabled = false
            module.keybind = Enum.KeyCode.Unknown
            module.callback = callback

            local modFrame = Instance.new("Frame")
            modFrame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
            modFrame.BackgroundTransparency = 0.6
            modFrame.Size = UDim2.new(1, 0, 0, 26)
            modFrame.Visible = (selectedTab == tab)
            modFrame.Parent = modulesFrame
            table.insert(tab.moduleFrames, modFrame)

            local uICornerMod = Instance.new("UICorner")
            uICornerMod.CornerRadius = UDim.new(0, 3)
            uICornerMod.Parent = modFrame

            local header = Instance.new("Frame")
            header.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
            header.BackgroundTransparency = 0.4
            header.Size = UDim2.new(1, 0, 0, 26)
            header.Parent = modFrame

            local headerCorner = Instance.new("UICorner")
            headerCorner.CornerRadius = UDim.new(0, 4)
            headerCorner.Parent = header

            local headerButton = Instance.new("TextButton")
            headerButton.BackgroundTransparency = 1
            headerButton.Size = UDim2.new(1, 0, 1, 0)
            headerButton.Text = ""
            headerButton.Parent = header

            local modText = Instance.new("TextLabel")
            modText.BackgroundTransparency = 1
            modText.TextColor3 = Color3.fromRGB(193, 193, 193)
            modText.Font = Font.fromName("GothamSSm", Enum.FontWeight.SemiBold)
            modText.TextSize = 14
            modText.Text = modName
            modText.Position = UDim2.new(0.106, 0, 0.204, 0)
            modText.Size = UDim2.new(0, 97, 0, 14)
            modText.Parent = header

            local keyFrame = Instance.new("Frame")
            keyFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            keyFrame.Position = UDim2.new(0.041, 0, 0.038, 0)
            keyFrame.Size = UDim2.new(0, 20, 0, 20)
            keyFrame.Parent = header

            local keyCorner = Instance.new("UICorner")
            keyCorner.CornerRadius = UDim.new(0, 4)
            keyCorner.Parent = keyFrame

            local keyButton = Instance.new("TextButton")
            keyButton.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
            keyButton.Position = UDim2.new(0.25, 0, 0.25, 0)
            keyButton.Size = UDim2.new(0, 10, 0, 10)
            keyButton.Text = ""
            keyButton.Parent = keyFrame

            local keyCorner2 = Instance.new("UICorner")
            keyCorner2.CornerRadius = UDim.new(0, 4)
            keyCorner2.Parent = keyButton

            local content = Instance.new("Frame")
            content.BackgroundTransparency = 1
            content.Position = UDim2.new(0, 0, 1, 0)
            content.Size = UDim2.new(1, 0, 0, 0)
            content.Parent = modFrame

            local contentLayout = Instance.new("UIListLayout")
            contentLayout.Padding = UDim.new(0, 5)
            contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            contentLayout.Parent = content

            contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                content.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y)
                if expanded then
                    modFrame.Size = UDim2.new(1, 0, 0, 26 + content.Size.Y.Offset + 5)
                end
            end)

            local expanded = false
            headerButton.MouseButton1Click:Connect(function()
                expanded = not expanded
                if expanded then
                    modFrame.Size = UDim2.new(1, 0, 0, 26 + content.Size.Y.Offset + 5)
                else
                    modFrame.Size = UDim2.new(1, 0, 0, 26)
                end
            end)

            local function toggleModule()
                module.enabled = not module.enabled
                module.callback(module.enabled)
                if module.enabled then
                    keyButton.BackgroundColor3 = Color3.new(1, 1, 1)
                else
                    keyButton.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
                end
            end

            local waitingKey = false
            keyButton.MouseButton1Click:Connect(function()
                waitingKey = true
                keyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            end)

            local keyConn = UIS.InputBegan:Connect(function(input, gpe)
                if waitingKey and not gpe and input.UserInputType == Enum.UserInputType.Keyboard then
                    module.keybind = input.KeyCode
                    waitingKey = false
                    keyButton.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
                end
            end)

            local toggleConn = UIS.InputBegan:Connect(function(input, gpe)
                if not gpe and input.KeyCode == module.keybind and not waitingKey then
                    toggleModule()
                end
            end)

            function module:AddDropdown(options, default, dropCallback)
                dropCallback = dropCallback or function() end
                local selected = default or options[1]

                local dropFrame = Instance.new("Frame")
                dropFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
                dropFrame.BackgroundTransparency = 0.4
                dropFrame.Size = UDim2.new(1, 0, 0, 18)
                dropFrame.Parent = content

                local dropCorner = Instance.new("UICorner")
                dropCorner.CornerRadius = UDim.new(0, 4)
                dropCorner.Parent = dropFrame

                local dropButton = Instance.new("TextButton")
                dropButton.BackgroundTransparency = 1
                dropButton.Size = UDim2.new(1, 0, 1, 0)
                dropButton.Text = ""
                dropButton.Parent = dropFrame

                local dropText = Instance.new("TextLabel")
                dropText.BackgroundTransparency = 1
                dropText.Font = Font.fromName("GothamSSm", Enum.FontWeight.SemiBold)
                dropText.TextColor3 = Color3.fromRGB(162, 162, 162)
                dropText.TextSize = 14
                dropText.Text = selected
                dropText.Position = UDim2.new(-0.0481, 0, 0.167, 0)
                dropText.Size = UDim2.new(0, 86, 0, 12)
                dropText.Parent = dropFrame

                local listFrame = Instance.new("Frame")
                listFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
                listFrame.BackgroundTransparency = 0.4
                listFrame.Position = UDim2.new(0, 0, 1, 0)
                listFrame.Size = UDim2.new(1, 0, 0, 0)
                listFrame.Visible = false
                listFrame.Parent = dropFrame

                local listCorner = Instance.new("UICorner")
                listCorner.CornerRadius = UDim.new(0, 4)
                listCorner.Parent = listFrame

                local listLayout = Instance.new("UIListLayout")
                listLayout.FillDirection = Enum.FillDirection.Vertical
                listLayout.Padding = UDim.new(0, 0)
                listLayout.SortOrder = Enum.SortOrder.LayoutOrder
                listLayout.Parent = listFrame

                listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    listFrame.Size = UDim2.new(1, 0, 0, listLayout.AbsoluteContentSize.Y)
                end)

                for _, opt in ipairs(options) do
                    local optButton = Instance.new("TextButton")
                    optButton.BackgroundTransparency = 1
                    optButton.Size = UDim2.new(1, 0, 0, 18)
                    optButton.TextColor3 = Color3.fromRGB(162, 162, 162)
                    optButton.Font = Font.fromName("GothamSSm", Enum.FontWeight.SemiBold)
                    optButton.TextSize = 14
                    optButton.Text = opt
                    optButton.Parent = listFrame

                    optButton.MouseButton1Click:Connect(function()
                        selected = opt
                        dropText.Text = opt
                        dropCallback(opt)
                        listFrame.Visible = false
                    end)
                end

                dropButton.MouseButton1Click:Connect(function()
                    listFrame.Visible = not listFrame.Visible
                end)
            end

            function module:AddSlider(sliderName, min, max, default, sliderCallback)
                sliderCallback = sliderCallback or function() end
                local value = default or min

                local sliderFrame = Instance.new("Frame")
                sliderFrame.BackgroundColor3 = Color3.fromRGB(77, 77, 77)
                sliderFrame.Position = UDim2.new(0, 0, 0, 0)
                sliderFrame.Size = UDim2.new(1, 0, 0, 3)
                sliderFrame.Parent = content

                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(1, 0)
                sliderCorner.Parent = sliderFrame

                local fill = Instance.new("Frame")
                fill.BackgroundColor3 = Color3.fromRGB(143, 143, 143)
                fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                fill.Parent = sliderFrame

                local dragButton = Instance.new("TextButton")
                dragButton.BackgroundColor3 = Color3.new(1, 1, 1)
                dragButton.Size = UDim2.new(0, 10, 0, 10)
                dragButton.Position = UDim2.new(fill.Size.X.Scale, -5, -3.33, 0)
                dragButton.Text = ""
                dragButton.Parent = sliderFrame

                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(1, 0)
                buttonCorner.Parent = dragButton

                local sliderText = Instance.new("TextLabel")
                sliderText.BackgroundTransparency = 1
                sliderText.Font = Font.fromName("GothamSSm", Enum.FontWeight.SemiBold)
                sliderText.TextColor3 = Color3.fromRGB(162, 162, 162)
                sliderText.TextSize = 14
                sliderText.Text = sliderName
                sliderText.Position = UDim2.new(0.296, 0, -7.33, 0)
                sliderText.Size = UDim2.new(0, 39, 0, 12)
                sliderText.Parent = sliderFrame

                local valueText = Instance.new("TextLabel")
                valueText.BackgroundTransparency = 1
                valueText.Font = Font.fromName("GothamSSm", Enum.FontWeight.SemiBold)
                valueText.TextColor3 = Color3.fromRGB(162, 162, 162)
                valueText.TextSize = 14
                valueText.Text = tostring(value)
                valueText.Position = UDim2.new(0.784, 0, -7.33, 0)
                valueText.Size = UDim2.new(0, 41, 0, 13)
                valueText.Parent = sliderFrame

                local sliding = false
                dragButton.MouseButton1Down:Connect(function()
                    sliding = true
                end)

                UIS.InputChanged:Connect(function(input)
                    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local pos = UIS:GetMouseLocation().X
                        local framePos = sliderFrame.AbsolutePosition.X
                        local frameSize = sliderFrame.AbsoluteSize.X
                        local relative = math.clamp((pos - framePos) / frameSize, 0, 1)
                        value = math.round(min + relative * (max - min))
                        fill.Size = UDim2.new(relative, 0, 1, 0)
                        dragButton.Position = UDim2.new(relative, -5, -3.33, 0)
                        valueText.Text = tostring(value)
                        sliderCallback(value)
                    end
                end)

                UIS.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = false
                    end
                end)
            end

            return module
        end

        return tab
    end

    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    return self
end

return library
