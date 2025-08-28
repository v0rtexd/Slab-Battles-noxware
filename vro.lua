-- UI Library ModuleScript

local UI = {}

function UI:CreateLibrary(hubName)
    local Library = {}
    Library.tabs = {}
    Library.currentTab = nil

    local UserInputService = game:GetService("UserInputService")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ScreenGui"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.BackgroundColor3 = Color3.new(0.0471, 0.0471, 0.0471)
    main.BackgroundTransparency = 0.1
    main.Position = UDim2.new(0.309, 0, 0.324, 0)
    main.BorderColor3 = Color3.new(0, 0, 0)
    main.BorderSizePixel = 0
    main.Size = UDim2.new(0, 569, 0, 288)
    main.Parent = screenGui

    local uICorner = Instance.new("UICorner")
    uICorner.Name = "UICorner"
    uICorner.CornerRadius = UDim.new(0, 9)
    uICorner.Parent = main

    local random_shit_no_worry = Instance.new("ImageLabel")
    random_shit_no_worry.Name = "Random shit no worry"
    random_shit_no_worry.ImageColor3 = Color3.new(0.561, 0.561, 0.561)
    random_shit_no_worry.ScaleType = Enum.ScaleType.Crop
    random_shit_no_worry.BorderColor3 = Color3.new(0, 0, 0)
    random_shit_no_worry.BackgroundColor3 = Color3.new(1, 1, 1)
    random_shit_no_worry.Rotation = -17
    random_shit_no_worry.Image = "rbxassetid://10709818626"
    random_shit_no_worry.BackgroundTransparency = 1
    random_shit_no_worry.Position = UDim2.new(0.023, 0, 0.02, 0)
    random_shit_no_worry.BorderSizePixel = 0
    random_shit_no_worry.Size = UDim2.new(0, 17, 0, 17)
    random_shit_no_worry.Parent = main

    local dragging_system_frame_seacrh = Instance.new("Frame")
    dragging_system_frame_seacrh.Name = "Dragging system frame + seacrh"
    dragging_system_frame_seacrh.BackgroundColor3 = Color3.new(0.204, 0.204, 0.204)
    dragging_system_frame_seacrh.BackgroundTransparency = 0.8
    dragging_system_frame_seacrh.Position = UDim2.new(0.0133, 0, 0.0339, 0)
    dragging_system_frame_seacrh.BorderColor3 = Color3.new(0, 0, 0)
    dragging_system_frame_seacrh.BorderSizePixel = 0
    dragging_system_frame_seacrh.Size = UDim2.new(0, 561, 0, 25)
    dragging_system_frame_seacrh.Parent = main

    local to_make_the_ui_dragg = Instance.new("TextButton")
    to_make_the_ui_dragg.Name = "to make the ui dragg"
    to_make_the_ui_dragg.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
    to_make_the_ui_dragg.TextColor3 = Color3.new(0, 0, 0)
    to_make_the_ui_dragg.BorderColor3 = Color3.new(0, 0, 0)
    to_make_the_ui_dragg.Text = ""
    to_make_the_ui_dragg.BackgroundTransparency = 1
    to_make_the_ui_dragg.BackgroundColor3 = Color3.new(1, 1, 1)
    to_make_the_ui_dragg.BorderSizePixel = 0
    to_make_the_ui_dragg.TextSize = 14
    to_make_the_ui_dragg.Size = UDim2.new(0, 561, 0, 23)
    to_make_the_ui_dragg.Parent = dragging_system_frame_seacrh

    local uICorner_2 = Instance.new("UICorner")
    uICorner_2.Name = "UICorner"
    uICorner_2.CornerRadius = UDim.new(0, 4)
    uICorner_2.Parent = dragging_system_frame_seacrh

    local tab_frame_system = Instance.new("Frame")
    tab_frame_system.Name = "Tab frame system"
    tab_frame_system.BackgroundColor3 = Color3.new(1, 1, 1)
    tab_frame_system.BackgroundTransparency = 1
    tab_frame_system.Position = UDim2.new(-0.0148, 0, 1.24, 0)
    tab_frame_system.BorderColor3 = Color3.new(0, 0, 0)
    tab_frame_system.BorderSizePixel = 0
    tab_frame_system.Size = UDim2.new(0, 128, 0, 243)
    tab_frame_system.Parent = dragging_system_frame_seacrh

    local hub_name_example_ = Instance.new("TextLabel")
    hub_name_example_.Name = "Hub name (example)"
    hub_name_example_.FontFace = Font.new(
        "rbxasset://fonts/families/GothamSSm.json",
        Enum.FontStyle.Normal,
        Enum.FontWeight.SemiBold
    )
    hub_name_example_.TextColor3 = Color3.new(0.655, 0.655, 0.655)
    hub_name_example_.Text = hubName or "Anerial.cc - original"
    hub_name_example_.BackgroundColor3 = Color3.new(1, 1, 1)
    hub_name_example_.BackgroundTransparency = 1
    hub_name_example_.Position = UDim2.new(0.0585, 0, 0.176, 0)
    hub_name_example_.BorderSizePixel = 0
    hub_name_example_.BorderColor3 = Color3.new(0, 0, 0)
    hub_name_example_.TextSize = 14
    hub_name_example_.Size = UDim2.new(0, 87, 0, 15)
    hub_name_example_.Parent = dragging_system_frame_seacrh

    local modules_frame = Instance.new("ScrollingFrame")
    modules_frame.Name = "Modules frame"
    modules_frame.ScrollBarImageColor3 = Color3.new(0.392, 0.392, 0.392)
    modules_frame.Active = true
    modules_frame.ScrollBarThickness = 3
    modules_frame.BackgroundTransparency = 1
    modules_frame.Position = UDim2.new(0.228, 0, 0.119, 0)
    modules_frame.Size = UDim2.new(0, 435, 0, 249)
    modules_frame.BorderColor3 = Color3.new(0, 0, 0)
    modules_frame.BorderSizePixel = 0
    modules_frame.BackgroundColor3 = Color3.new(1, 1, 1)
    modules_frame.Parent = main

    local uIListLayout = Instance.new("UIListLayout")
    uIListLayout.FillDirection = Enum.FillDirection.Horizontal
    uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uIListLayout.Padding = UDim.new(0, 10)
    uIListLayout.Parent = modules_frame

    -- Device detection
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        local scale = Instance.new("UIScale")
        scale.Scale = 0.7
        scale.Parent = main
    end

    -- Dragging
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function updateInput(input)
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    to_make_the_ui_dragg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            local conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    conn:Disconnect()
                end
            end)
        end
    end)

    to_make_the_ui_dragg.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            updateInput(input)
        end
    end)

    function Library:AddTab(tabName, imageId)
        local tab = {}
        tab.modules = {}
        tab.container = Instance.new("ScrollingFrame")
        tab.container.Name = tabName .. "Container"
        tab.container.ScrollBarImageColor3 = Color3.new(0.392, 0.392, 0.392)
        tab.container.Active = true
        tab.container.ScrollBarThickness = 3
        tab.container.BackgroundTransparency = 1
        tab.container.Size = UDim2.new(1, 0, 1, 0)
        tab.container.BorderColor3 = Color3.new(0, 0, 0)
        tab.container.BorderSizePixel = 0
        tab.container.BackgroundColor3 = Color3.new(1, 1, 1)
        tab.container.Visible = false
        tab.container.Parent = modules_frame

        local uIListLayoutTab = Instance.new("UIListLayout")
        uIListLayoutTab.FillDirection = Enum.FillDirection.Horizontal
        uIListLayoutTab.SortOrder = Enum.SortOrder.LayoutOrder
        uIListLayoutTab.Padding = UDim.new(0, 10)
        uIListLayoutTab.Parent = tab.container

        local tabFrame = Instance.new("Frame")
        tabFrame.Name = "Tab " .. tabName
        tabFrame.BackgroundColor3 = Color3.new(0, 0, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Position = UDim2.new(0.047, 0, #Library.tabs * 0.14, 0)
        tabFrame.BorderColor3 = Color3.new(0, 0, 0)
        tabFrame.BorderSizePixel = 0
        tabFrame.Size = UDim2.new(0, 117, 0, 22)
        tabFrame.Parent = tab_frame_system

        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "Text tab"
        textLabel.FontFace = Font.new(
            "rbxasset://fonts/families/GothamSSm.json",
            Enum.FontStyle.Normal,
            Enum.FontWeight.SemiBold
        )
        textLabel.TextColor3 = Color3.new(0.659, 0.659, 0.659)
        textLabel.Text = tabName
        textLabel.BackgroundColor3 = Color3.new(1, 1, 1)
        textLabel.BackgroundTransparency = 1
        textLabel.Position = UDim2.new(0.197, 0, 0.182, 0)
        textLabel.BorderSizePixel = 0
        textLabel.BorderColor3 = Color3.new(0, 0, 0)
        textLabel.TextSize = 13
        textLabel.Size = UDim2.new(0, 70, 0, 13)
        textLabel.Parent = tabFrame

        local button = Instance.new("TextButton")
        button.Name = "Button to select the tab"
        button.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
        button.TextColor3 = Color3.new(0, 0, 0)
        button.Text = ""
        button.BackgroundTransparency = 1
        button.BackgroundColor3 = Color3.new(1, 1, 1)
        button.BorderSizePixel = 0
        button.BorderColor3 = Color3.new(0, 0, 0)
        button.TextSize = 14
        button.Size = UDim2.new(0, 111, 0, 20)
        button.Parent = tabFrame

        local imageLabel = Instance.new("ImageLabel")
        imageLabel.Name = "ImageLabel"
        imageLabel.ImageColor3 = Color3.new(0.565, 0.565, 0.565)
        imageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
        imageLabel.Image = imageId or "rbxassetid://10734951847"
        imageLabel.BackgroundTransparency = 1
        imageLabel.Position = UDim2.new(0.1, 0, 0.145, 0)
        imageLabel.BorderColor3 = Color3.new(0, 0, 0)
        imageLabel.BorderSizePixel = 0
        imageLabel.Size = UDim2.new(0, 15, 0, 15)
        imageLabel.Parent = tabFrame

        local uIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
        uIAspectRatioConstraint.Name = "UIAspectRatioConstraint"
        uIAspectRatioConstraint.Parent = imageLabel

        button.MouseButton1Click:Connect(function()
            for _, t in pairs(Library.tabs) do
                t.container.Visible = false
                t.textLabel.TextColor3 = Color3.new(0.659, 0.659, 0.659)
                t.imageLabel.ImageColor3 = Color3.new(0.565, 0.565, 0.565)
            end
            tab.container.Visible = true
            textLabel.TextColor3 = Color3.new(1, 1, 1)
            imageLabel.ImageColor3 = Color3.new(1, 1, 1)
            Library.currentTab = tab
        end)

        tab.textLabel = textLabel
        tab.imageLabel = imageLabel

        table.insert(Library.tabs, tab)

        if #Library.tabs == 1 then
            button:SimulateInput(Enum.UserInputType.MouseButton1)  -- Select first tab by default
        end

        function tab:AddModule(moduleName, callback)
            callback = callback or function(state) end
            local module = {}
            module.enabled = false
            module.keybind = Enum.KeyCode.Unknown
            module.expanded = false

            local moduleFrame = Instance.new("Frame")
            moduleFrame.Name = "Module " .. moduleName
            moduleFrame.BackgroundColor3 = Color3.new(0.188, 0.188, 0.188)
            moduleFrame.BackgroundTransparency = 0.4
            moduleFrame.Position = UDim2.new(0, 0, 0, 0)
            moduleFrame.BorderColor3 = Color3.new(0, 0, 0)
            moduleFrame.BorderSizePixel = 0
            moduleFrame.Size = UDim2.new(0.5, -5, 0, 26)
            moduleFrame.Parent = tab.container

            local uICornerMod = Instance.new("UICorner")
            uICornerMod.CornerRadius = UDim.new(0, 4)
            uICornerMod.Parent = moduleFrame

            local keyBindFrame = Instance.new("Frame")
            keyBindFrame.Name = "key bind changer to enable module"
            keyBindFrame.BackgroundColor3 = Color3.new(0.275, 0.275, 0.275)
            keyBindFrame.Position = UDim2.new(0.041, 0, 0.091, 0)
            keyBindFrame.BorderColor3 = Color3.new(0, 0, 0)
            keyBindFrame.BorderSizePixel = 0
            keyBindFrame.Size = UDim2.new(0, 20, 0, 20)
            keyBindFrame.Parent = moduleFrame

            local uICornerKey = Instance.new("UICorner")
            uICornerKey.CornerRadius = UDim.new(0, 4)
            uICornerKey.Parent = keyBindFrame

            local keyButton = Instance.new("TextButton")
            keyButton.Name = "The button to change the keybind"
            keyButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
            keyButton.TextColor3 = Color3.new(0, 0, 0)
            keyButton.Text = ""
            keyButton.BackgroundColor3 = Color3.new(0.675, 0.675, 0.675)
            keyButton.Position = UDim2.new(0.25, 0, 0.25, 0)
            keyButton.BorderSizePixel = 0
            keyButton.BorderColor3 = Color3.new(0, 0, 0)
            keyButton.TextSize = 14
            keyButton.Size = UDim2.new(0, 10, 0, 10)
            keyButton.Parent = keyBindFrame

            local uICornerKeyBut = Instance.new("UICorner")
            uICornerKeyBut.CornerRadius = UDim.new(0, 4)
            uICornerKeyBut.Parent = keyButton

            local moduleLabel = Instance.new("TextLabel")
            moduleLabel.Name = "Module name"
            moduleLabel.FontFace = Font.new(
                "rbxasset://fonts/families/GothamSSm.json",
                Enum.FontStyle.Normal,
                Enum.FontWeight.SemiBold
            )
            moduleLabel.TextColor3 = Color3.new(0.757, 0.757, 0.757)
            moduleLabel.BorderColor3 = Color3.new(0, 0, 0)
            moduleLabel.Text = moduleName
            moduleLabel.BackgroundColor3 = Color3.new(1, 1, 1)
            moduleLabel.BorderSizePixel = 0
            moduleLabel.BackgroundTransparency = 1
            moduleLabel.Position = UDim2.new(0.106, 0, 0.204, 0)
            moduleLabel.TextStrokeColor3 = Color3.new(0.757, 0.757, 0.757)
            moduleLabel.TextSize = 14
            moduleLabel.Size = UDim2.new(0, 97, 0, 14)
            moduleLabel.Parent = moduleFrame

            local expandButton = Instance.new("TextButton")
            expandButton.Name = "Expand button"
            expandButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
            expandButton.TextColor3 = Color3.new(0, 0, 0)
            expandButton.Text = ""
            expandButton.BackgroundTransparency = 1
            expandButton.BackgroundColor3 = Color3.new(1, 1, 1)
            expandButton.BorderSizePixel = 0
            expandButton.BorderColor3 = Color3.new(0, 0, 0)
            expandButton.TextSize = 14
            expandButton.Size = UDim2.new(1, 0, 1, 0)
            expandButton.Parent = moduleFrame

            local optionsContainer = Instance.new("Frame")
            optionsContainer.Name = "OptionsContainer"
            optionsContainer.BackgroundColor3 = Color3.new(0.122, 0.122, 0.122)
            optionsContainer.BackgroundTransparency = 0.6
            optionsContainer.Position = UDim2.new(0, 0, 1, 0)
            optionsContainer.BorderColor3 = Color3.new(0, 0, 0)
            optionsContainer.BorderSizePixel = 0
            optionsContainer.Size = UDim2.new(1, 0, 0, 137)
            optionsContainer.Visible = false
            optionsContainer.Parent = moduleFrame

            local uICornerOpt = Instance.new("UICorner")
            uICornerOpt.CornerRadius = UDim.new(0, 3)
            uICornerOpt.Parent = optionsContainer

            local uIListLayoutOpt = Instance.new("UIListLayout")
            uIListLayoutOpt.SortOrder = Enum.SortOrder.LayoutOrder
            uIListLayoutOpt.Padding = UDim.new(0, 5)
            uIListLayoutOpt.Parent = optionsContainer

            keyButton.MouseButton1Click:Connect(function()
                keyButton.BackgroundColor3 = Color3.new(1, 0, 0)
                local conn
                conn = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        module.keybind = input.KeyCode
                        keyButton.BackgroundColor3 = Color3.new(0.675, 0.675, 0.675)
                        conn:Disconnect()
                    end
                end)
            end)

            UserInputService.InputBegan:Connect(function(input)
                if input.KeyCode == module.keybind then
                    module.enabled = not module.enabled
                    moduleLabel.TextColor3 = module.enabled and Color3.new(1, 0, 0) or Color3.new(0.757, 0.757, 0.757)
                    callback(module.enabled)
                end
            end)

            expandButton.MouseButton1Click:Connect(function()
                module.expanded = not module.expanded
                if module.expanded then
                    moduleFrame.Size = UDim2.new(0.5, -5, 0, 26 + 137)
                    optionsContainer.Visible = true
                    keyBindFrame.Position = UDim2.new(0.041, 0, 0.02, 0)
                else
                    moduleFrame.Size = UDim2.new(0.5, -5, 0, 26)
                    optionsContainer.Visible = false
                    keyBindFrame.Position = UDim2.new(0.041, 0, 0.091, 0)
                end
            end)

            function module:AddDropdown(title, options, default, dropCallback)
                dropCallback = dropCallback or function(value) end
                local selected = default or options[1]

                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Name = "Dropdown"
                dropdownFrame.BackgroundColor3 = Color3.new(0.188, 0.188, 0.188)
                dropdownFrame.BackgroundTransparency = 0.4
                dropdownFrame.BorderColor3 = Color3.new(0, 0, 0)
                dropdownFrame.BorderSizePixel = 0
                dropdownFrame.Size = UDim2.new(1, -10, 0, 18)
                dropdownFrame.Parent = optionsContainer

                local uICornerDrop = Instance.new("UICorner")
                uICornerDrop.CornerRadius = UDim.new(0, 4)
                uICornerDrop.Parent = dropdownFrame

                local dropButton = Instance.new("TextButton")
                dropButton.Name = "DropButton"
                dropButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
                dropButton.TextColor3 = Color3.new(0, 0, 0)
                dropButton.Text = ""
                dropButton.BackgroundTransparency = 1
                dropButton.BackgroundColor3 = Color3.new(1, 1, 1)
                dropButton.BorderSizePixel = 0
                dropButton.BorderColor3 = Color3.new(0, 0, 0)
                dropButton.TextSize = 14
                dropButton.Size = UDim2.new(1, 0, 1, 0)
                dropButton.Parent = dropdownFrame

                local dropLabel = Instance.new("TextLabel")
                dropLabel.Name = "DropLabel"
                dropLabel.FontFace = Font.new(
                    "rbxasset://fonts/families/GothamSSm.json",
                    Enum.FontStyle.Normal,
                    Enum.FontWeight.SemiBold
                )
                dropLabel.TextColor3 = Color3.new(0.635, 0.635, 0.635)
                dropLabel.Text = selected
                dropLabel.BackgroundColor3 = Color3.new(1, 1, 1)
                dropLabel.BackgroundTransparency = 1
                dropLabel.Position = UDim2.new(0.05, 0, 0.167, 0)
                dropLabel.BorderSizePixel = 0
                dropLabel.BorderColor3 = Color3.new(0, 0, 0)
                dropLabel.TextSize = 14
                dropLabel.Size = UDim2.new(0.9, 0, 1, 0)
                dropLabel.Parent = dropdownFrame

                local dropList = Instance.new("Frame")
                dropList.Name = "DropList"
                dropList.BackgroundColor3 = Color3.new(0.188, 0.188, 0.188)
                dropList.BackgroundTransparency = 0.4
                dropList.Position = UDim2.new(0, 0, 1, 0)
                dropList.BorderColor3 = Color3.new(0, 0, 0)
                dropList.BorderSizePixel = 0
                dropList.Size = UDim2.new(1, 0, 0, #options * 18)
                dropList.Visible = false
                dropList.Parent = dropdownFrame

                local uICornerList = Instance.new("UICorner")
                uICornerList.CornerRadius = UDim.new(0, 4)
                uICornerList.Parent = dropList

                local uIListLayoutDrop = Instance.new("UIListLayout")
                uIListLayoutDrop.SortOrder = Enum.SortOrder.LayoutOrder
                uIListLayoutDrop.Parent = dropList

                for _, opt in ipairs(options) do
                    local optButton = Instance.new("TextButton")
                    optButton.FontFace = Font.new(
                        "rbxasset://fonts/families/GothamSSm.json",
                        Enum.FontStyle.Normal,
                        Enum.FontWeight.SemiBold
                    )
                    optButton.TextColor3 = Color3.new(0.635, 0.635, 0.635)
                    optButton.BorderColor3 = Color3.new(0, 0, 0)
                    optButton.Text = opt
                    optButton.BackgroundColor3 = Color3.new(1, 1, 1)
                    optButton.BackgroundTransparency = 1
                    optButton.BorderSizePixel = 0
                    optButton.TextSize = 14
                    optButton.Size = UDim2.new(1, 0, 0, 18)
                    optButton.Parent = dropList

                    optButton.MouseButton1Click:Connect(function()
                        selected = opt
                        dropLabel.Text = selected
                        dropList.Visible = false
                        dropCallback(selected)
                    end)
                end

                dropButton.MouseButton1Click:Connect(function()
                    dropList.Visible = not dropList.Visible
                end)

                return dropdownFrame
            end

            function module:AddSlider(title, min, max, default, sliderCallback)
                sliderCallback = sliderCallback or function(value) end
                local value = default or min

                local sliderFrame = Instance.new("Frame")
                sliderFrame.Name = "slider frame"
                sliderFrame.BackgroundColor3 = Color3.new(0.302, 0.302, 0.302)
                sliderFrame.BorderColor3 = Color3.new(0, 0, 0)
                sliderFrame.BorderSizePixel = 0
                sliderFrame.Size = UDim2.new(1, -10, 0, 20)
                sliderFrame.Parent = optionsContainer

                local uICornerSlider = Instance.new("UICorner")
                uICornerSlider.CornerRadius = UDim.new(1, 0)
                uICornerSlider.Parent = sliderFrame

                local sliderValue = Instance.new("Frame")
                sliderValue.Name = "Slider value changer"
                sliderValue.BackgroundColor3 = Color3.new(0.561, 0.561, 0.561)
                sliderValue.Position = UDim2.new(0, 0, 0.25, 0)
                sliderValue.BorderColor3 = Color3.new(0, 0, 0)
                sliderValue.BorderSizePixel = 0
                sliderValue.Size = UDim2.new((value - min) / (max - min), 0, 0.5, 0)
                sliderValue.Parent = sliderFrame

                local dragButton = Instance.new("TextButton")
                dragButton.Name = "Hold it to change the value"
                dragButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
                dragButton.TextColor3 = Color3.new(0, 0, 0)
                dragButton.Text = ""
                dragButton.BackgroundColor3 = Color3.new(1, 1, 1)
                dragButton.Position = UDim2.new(1, -5, 0, -5)
                dragButton.BorderSizePixel = 0
                dragButton.BorderColor3 = Color3.new(1, 1, 1)
                dragButton.TextSize = 14
                dragButton.Size = UDim2.new(0, 10, 0, 10)
                dragButton.Parent = sliderValue

                local uICornerDrag = Instance.new("UICorner")
                uICornerDrag.CornerRadius = UDim.new(1, 0)
                uICornerDrag.Parent = dragButton

                local sliderText = Instance.new("TextLabel")
                sliderText.Name = "Slider text"
                sliderText.FontFace = Font.new(
                    "rbxasset://fonts/families/GothamSSm.json",
                    Enum.FontStyle.Normal,
                    Enum.FontWeight.SemiBold
                )
                sliderText.TextColor3 = Color3.new(0.635, 0.635, 0.635)
                sliderText.Text = title
                sliderText.BackgroundColor3 = Color3.new(1, 1, 1)
                sliderText.BackgroundTransparency = 1
                sliderText.Position = UDim2.new(0, 0, -1, 0)
                sliderText.BorderSizePixel = 0
                sliderText.BorderColor3 = Color3.new(0, 0, 0)
                sliderText.TextSize = 14
                sliderText.Size = UDim2.new(1, 0, 0, 12)
                sliderText.Parent = sliderFrame

                local valueText = Instance.new("TextLabel")
                valueText.Name = "Value show text from slider"
                valueText.FontFace = Font.new(
                    "rbxasset://fonts/families/GothamSSm.json",
                    Enum.FontStyle.Normal,
                    Enum.FontWeight.SemiBold
                )
                valueText.TextColor3 = Color3.new(0.635, 0.635, 0.635)
                valueText.Text = tostring(value)
                valueText.BackgroundColor3 = Color3.new(1, 1, 1)
                valueText.BackgroundTransparency = 1
                valueText.Position = UDim2.new(1, -50, -1, 0)
                valueText.BorderSizePixel = 0
                valueText.BorderColor3 = Color3.new(0, 0, 0)
                valueText.TextSize = 14
                valueText.Size = UDim2.new(0, 41, 0, 13)
                valueText.Parent = sliderFrame

                local sliderDragging = false

                dragButton.MouseButton1Down:Connect(function()
                    sliderDragging = true
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if sliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local relativeX = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
                        sliderValue.Size = UDim2.new(relativeX, 0, 0.5, 0)
                        value = math.round(min + relativeX * (max - min))
                        valueText.Text = tostring(value)
                        sliderCallback(value)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliderDragging = false
                    end
                end)

                return sliderFrame
            end

            return module
        end

        return tab
    end

    return Library
end

return UI
