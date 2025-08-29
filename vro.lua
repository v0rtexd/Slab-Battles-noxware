local Library = {}

function Library:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AnerialUI"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    main.BackgroundTransparency = 0.1
    main.Position = UDim2.new(0.3, 0, 0.3, 0)
    main.Size = UDim2.new(0, 569, 0, 288)
    main.Parent = screenGui

    local uICorner = Instance.new("UICorner")
    uICorner.CornerRadius = UDim.new(0, 9)
    uICorner.Parent = main

    -- Topbar for dragging and title
    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
    topbar.BackgroundTransparency = 0.8
    topbar.Size = UDim2.new(1, 0, 0, 25)
    topbar.Position = UDim2.new(0, 0, 0, 0)
    topbar.Parent = main

    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 4)
    topCorner.Parent = topbar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title or "Anerial.cc - original"
    titleLabel.Position = UDim2.new(0.05, 0, 0, 0)
    titleLabel.Size = UDim2.new(0.4, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(167, 167, 167)
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topbar

    -- Dragging functionality
    local dragToggle = nil
    local dragStart = nil
    local startPos = nil

    local function updateInput(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        game:GetService("TweenService"):Create(main, TweenInfo.new(0.1), {Position = position}):Play()
    end

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragToggle then
                updateInput(input)
            end
        end
    end)

    -- Tabs frame
    local tabsFrame = Instance.new("Frame")
    tabsFrame.BackgroundTransparency = 1
    tabsFrame.Position = UDim2.new(0, 10, 0.12, 0)
    tabsFrame.Size = UDim2.new(0.2, 0, 0.85, 0)
    tabsFrame.Parent = main

    local tabsList = Instance.new("UIListLayout")
    tabsList.FillDirection = Enum.FillDirection.Vertical
    tabsList.Padding = UDim.new(0, 5)
    tabsList.Parent = tabsFrame

    -- Modules scrolling frame
    local modulesFrame = Instance.new("ScrollingFrame")
    modulesFrame.Name = "ModulesFrame"
    modulesFrame.BackgroundTransparency = 1
    modulesFrame.Position = UDim2.new(0.23, 0, 0.12, 0)
    modulesFrame.Size = UDim2.new(0.75, 0, 0.85, 0)
    modulesFrame.ScrollBarThickness = 3
    modulesFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    modulesFrame.Parent = main

    local modulesGrid = Instance.new("UIGridLayout")
    modulesGrid.CellSize = UDim2.new(0.48, 0, 0, 30)
    modulesGrid.CellPadding = UDim2.new(0, 10, 0, 10)
    modulesGrid.SortOrder = Enum.SortOrder.LayoutOrder
    modulesGrid.Parent = modulesFrame

    modulesFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

    local function updateCanvas()
        modulesFrame.CanvasSize = UDim2.new(0, 0, 0, modulesGrid.AbsoluteContentSize.Y + 20)
    end

    modulesGrid.Changed:Connect(updateCanvas)

    local Window = {}
    local tabs = {}
    local currentTab = nil

    function Window:CreateTab(name, icon)
        local tab = {}
        tab.modules = {}
        tab.container = Instance.new("Frame")
        tab.container.BackgroundTransparency = 1
        tab.container.Size = UDim2.new(1, 0, 1, 0)
        tab.container.Visible = false
        tab.container.Parent = modulesFrame -- But we'll manage visibility

        local tabButton = Instance.new("TextButton")
        tabButton.BackgroundTransparency = 1
        tabButton.Size = UDim2.new(1, 0, 0, 22)
        tabButton.Text = ""
        tabButton.Parent = tabsFrame

        local tabIcon = Instance.new("ImageLabel")
        tabIcon.BackgroundTransparency = 1
        tabIcon.Position = UDim2.new(0, 0, 0, 3)
        tabIcon.Size = UDim2.new(0, 15, 0, 15)
        tabIcon.Image = icon or "rbxassetid://10734951847"
        tabIcon.ImageColor3 = Color3.fromRGB(144, 144, 144)
        tabIcon.Parent = tabButton

        local tabText = Instance.new("TextLabel")
        tabText.BackgroundTransparency = 1
        tabText.Position = UDim2.new(0.2, 0, 0, 0)
        tabText.Size = UDim2.new(0.8, 0, 1, 0)
        tabText.Text = name
        tabText.TextColor3 = Color3.fromRGB(168, 168, 168)
        tabText.Font = Enum.Font.GothamSemibold
        tabText.TextSize = 13
        tabText.TextXAlignment = Enum.TextXAlignment.Left
        tabText.Parent = tabButton

        local function switchTab()
            if currentTab then
                currentTab.container.Visible = false
            end
            currentTab = tab
            tab.container.Visible = true
        end

        tabButton.MouseButton1Click:Connect(switchTab)

        table.insert(tabs, tab)

        if #tabs == 1 then
            switchTab()
        end

        function tab:CreateModule(name)
            local module = {}
            module.Name = name
            module.Enabled = false
            module.Keybind = nil
            module.OptionsHeight = 0
            module.Callback = function() end -- For toggle

            module.Frame = Instance.new("Frame")
            module.Frame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
            module.Frame.BackgroundTransparency = 0.4
            module.Frame.Size = UDim2.new(1, 0, 0, 26)
            module.Frame.Parent = tab.container

            local modCorner = Instance.new("UICorner")
            modCorner.CornerRadius = UDim.new(0, 4)
            modCorner.Parent = module.Frame

            local modTitle = Instance.new("TextLabel")
            modTitle.Text = name
            modTitle.Position = UDim2.new(0.1, 0, 0, 4)
            modTitle.Size = UDim2.new(0.6, 0, 1, -8)
            modTitle.BackgroundTransparency = 1
            modTitle.TextColor3 = Color3.fromRGB(193, 193, 193)
            modTitle.Font = Enum.Font.GothamSemibold
            modTitle.TextSize = 14
            modTitle.TextXAlignment = Enum.TextXAlignment.Left
            modTitle.Parent = module.Frame

            local keyFrame = Instance.new("Frame")
            keyFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            keyFrame.Position = UDim2.new(0.8, 0, 0, 3)
            keyFrame.Size = UDim2.new(0, 30, 0, 20)
            keyFrame.Parent = module.Frame

            local keyCorner = Instance.new("UICorner")
            keyCorner.CornerRadius = UDim.new(0, 4)
            keyCorner.Parent = keyFrame

            local keyButton = Instance.new("TextButton")
            keyButton.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
            keyButton.Position = UDim2.new(0.15, 0, 0.15, 0)
            keyButton.Size = UDim2.new(0, 20, 0, 12)
            keyButton.Text = ""
            keyButton.Parent = keyFrame

            local keyBCorner = Instance.new("UICorner")
            keyBCorner.CornerRadius = UDim.new(0, 4)
            keyBCorner.Parent = keyButton

            local optionsFrame = Instance.new("Frame")
            optionsFrame.Name = "Options"
            optionsFrame.BackgroundTransparency = 1
            optionsFrame.Position = UDim2.new(0, 0, 0, 26)
            optionsFrame.Size = UDim2.new(1, 0, 0, 0)
            optionsFrame.Visible = false
            optionsFrame.Parent = module.Frame

            local optionsList = Instance.new("UIListLayout")
            optionsList.Padding = UDim.new(0, 5)
            optionsList.Parent = optionsFrame

            local expanded = false

            local expandButton = Instance.new("TextButton")
            expandButton.BackgroundTransparency = 1
            expandButton.Size = UDim2.new(1, 0, 0, 26)
            expandButton.Text = ""
            expandButton.Parent = module.Frame

            expandButton.MouseButton1Click:Connect(function()
                expanded = not expanded
                optionsFrame.Visible = expanded
                module.Frame.Size = UDim2.new(1, 0, 0, expanded and (26 + optionsList.AbsoluteContentSize.Y) or 26)
                updateCanvas()
            end)

            optionsList.Changed:Connect(function()
                optionsFrame.Size = UDim2.new(1, 0, 0, optionsList.AbsoluteContentSize.Y)
                if expanded then
                    module.Frame.Size = UDim2.new(1, 0, 0, 26 + optionsList.AbsoluteContentSize.Y)
                    updateCanvas()
                end
            end)

            -- Keybind logic
            local binding = false
            keyButton.MouseButton1Click:Connect(function()
                binding = true
                keyButton.Text = "..." -- Indicate binding
            end)

            game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
                if binding and not processed and input.UserInputType == Enum.UserInputType.Keyboard then
                    module.Keybind = input.KeyCode
                    binding = false
                    keyButton.Text = ""
                    -- You can add text for the key if you want keyButton.Text = module.Keybind.Name:sub(5) or something
                end
            end)

            -- Toggle module with keybind
            game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
                if not processed and module.Keybind and input.KeyCode == module.Keybind then
                    module.Enabled = not module.Enabled
                    module.Callback(module.Enabled)
                end
            end)

            function module:AddDropdown(name, opts, default, callback)
                callback = callback or function() end
                local selected = default or opts[1]

                local dropFrame = Instance.new("Frame")
                dropFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
                dropFrame.BackgroundTransparency = 0.4
                dropFrame.Size = UDim2.new(1, -10, 0, 18)
                dropFrame.Parent = optionsFrame

                local dropCorner = Instance.new("UICorner")
                dropCorner.CornerRadius = UDim.new(0, 4)
                dropCorner.Parent = dropFrame

                local selectText = Instance.new("TextLabel")
                selectText.Text = selected
                selectText.Position = UDim2.new(0.05, 0, 0, 0)
                selectText.Size = UDim2.new(0.9, 0, 1, 0)
                selectText.BackgroundTransparency = 1
                selectText.TextColor3 = Color3.fromRGB(162, 162, 162)
                selectText.Font = Enum.Font.GothamSemibold
                selectText.TextSize = 14
                selectText.TextXAlignment = Enum.TextXAlignment.Left
                selectText.Parent = dropFrame

                local listFrame = Instance.new("ScrollingFrame")
                listFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
                listFrame.BackgroundTransparency = 0.4
                listFrame.Position = UDim2.new(0, 0, 1, 0)
                listFrame.Size = UDim2.new(1, 0, 0, math.min(#opts * 20, 100))
                listFrame.Visible = false
                listFrame.ScrollBarThickness = 3
                listFrame.Parent = dropFrame

                local listCorner = Instance.new("UICorner")
                listCorner.CornerRadius = UDim.new(0, 4)
                listCorner.Parent = listFrame

                local listLay = Instance.new("UIListLayout")
                listLay.Parent = listFrame

                for _, opt in ipairs(opts) do
                    local optBut = Instance.new("TextButton")
                    optBut.BackgroundTransparency = 1
                    optBut.Size = UDim2.new(1, 0, 0, 20)
                    optBut.Text = opt
                    optBut.TextColor3 = Color3.fromRGB(162, 162, 162)
                    optBut.Font = Enum.Font.GothamSemibold
                    optBut.TextSize = 14
                    optBut.Parent = listFrame

                    optBut.MouseButton1Click:Connect(function()
                        selected = opt
                        selectText.Text = opt
                        listFrame.Visible = false
                        callback(opt)
                    end)
                end

                local dropBut = Instance.new("TextButton")
                dropBut.BackgroundTransparency = 1
                dropBut.Size = UDim2.new(1, 0, 1, 0)
                dropBut.Text = ""
                dropBut.Parent = dropFrame

                dropBut.MouseButton1Click:Connect(function()
                    listFrame.Visible = not listFrame.Visible
                end)
            end

            function module:AddSlider(name, min, max, default, callback)
                callback = callback or function() end
                local value = default or min

                local sliderFrame = Instance.new("Frame")
                sliderFrame.BackgroundColor3 = Color3.fromRGB(77, 77, 77)
                sliderFrame.Size = UDim2.new(1, -10, 0, 3)
                sliderFrame.Parent = optionsFrame

                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(1, 0)
                sliderCorner.Parent = sliderFrame

                local fillFrame = Instance.new("Frame")
                fillFrame.BackgroundColor3 = Color3.fromRGB(143, 143, 143)
                fillFrame.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                fillFrame.Parent = sliderFrame

                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(1, 0)
                fillCorner.Parent = fillFrame

                local knob = Instance.new("TextButton")
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                knob.Position = UDim2.new(1, -5, -1, -3.5)
                knob.Size = UDim2.new(0, 10, 0, 10)
                knob.Text = ""
                knob.Parent = fillFrame

                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(1, 0)
                knobCorner.Parent = knob

                local sliderText = Instance.new("TextLabel")
                sliderText.Text = name
                sliderText.Position = UDim2.new(0, 0, 0, -15)
                sliderText.Size = UDim2.new(0.5, 0, 0, 12)
                sliderText.BackgroundTransparency = 1
                sliderText.TextColor3 = Color3.fromRGB(162, 162, 162)
                sliderText.Font = Enum.Font.GothamSemibold
                sliderText.TextSize = 14
                sliderText.Parent = sliderFrame

                local valueText = Instance.new("TextLabel")
                valueText.Text = tostring(value)
                valueText.Position = UDim2.new(0.8, 0, 0, -15)
                valueText.Size = UDim2.new(0.2, 0, 0, 12)
                valueText.BackgroundTransparency = 1
                valueText.TextColor3 = Color3.fromRGB(162, 162, 162)
                valueText.Font = Enum.Font.GothamSemibold
                valueText.TextSize = 14
                valueText.Parent = sliderFrame

                local dragging = false

                knob.MouseButton1Down:Connect(function()
                    dragging = true
                end)

                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local rel = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
                        value = min + (max - min) * rel
                        value = math.floor(value)
                        fillFrame.Size = UDim2.new(rel, 0, 1, 0)
                        valueText.Text = tostring(value)
                        callback(value)
                    end
                end)
            end

            function module:SetCallback(cb)
                module.Callback = cb
            end

            return module
        end

        return tab
    end

    return Window
end

return Library
