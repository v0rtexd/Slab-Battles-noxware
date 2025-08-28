-- Anerial UI Library for Roblox
-- Created by Grok
-- Features: Draggable UI, Tabs, Modules with toggles, Sliders, Dropdowns, Keybinds
-- Device detection: Smaller UI on mobile (TouchEnabled)

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local UILibrary = {}

function UILibrary.new(hubName)
    local isMobile = UIS.TouchEnabled
    local scaleFactor = isMobile and 0.7 or 1

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AnerialUI"
    screenGui.Parent = PlayerGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    main.BackgroundTransparency = 0.1
    main.Position = UDim2.new(0.309, 0, 0.324, 0)
    main.BorderSizePixel = 0
    main.Size = UDim2.new(0, 569 * scaleFactor, 0, 288 * scaleFactor)
    main.Parent = screenGui

    local uICorner = Instance.new("UICorner")
    uICorner.CornerRadius = UDim.new(0, 9)
    uICorner.Parent = main

    local randomImage = Instance.new("ImageLabel")
    randomImage.Name = "RandomImage"
    randomImage.ImageColor3 = Color3.fromRGB(143, 143, 143)
    randomImage.ScaleType = Enum.ScaleType.Crop
    randomImage.BackgroundTransparency = 1
    randomImage.Rotation = -17
    randomImage.Image = "rbxassetid://10709818626"
    randomImage.Position = UDim2.new(0.023, 0, 0.02, 0)
    randomImage.Size = UDim2.new(0, 17 * scaleFactor, 0, 17 * scaleFactor)
    randomImage.Parent = main

    local dragFrame = Instance.new("Frame")
    dragFrame.Name = "DragFrame"
    dragFrame.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
    dragFrame.BackgroundTransparency = 0.8
    dragFrame.Position = UDim2.new(0.0133, 0, 0.0339, 0)
    dragFrame.BorderSizePixel = 0
    dragFrame.Size = UDim2.new(0, 561 * scaleFactor, 0, 25 * scaleFactor)
    dragFrame.Parent = main

    local dragButton = Instance.new("TextButton")
    dragButton.Name = "DragButton"
    dragButton.Text = ""
    dragButton.BackgroundTransparency = 1
    dragButton.Size = UDim2.new(1, 0, 1, 0)
    dragButton.Parent = dragFrame

    local uICorner2 = Instance.new("UICorner")
    uICorner2.CornerRadius = UDim.new(0, 4)
    uICorner2.Parent = dragFrame

    local hubNameLabel = Instance.new("TextLabel")
    hubNameLabel.Name = "HubName"
    hubNameLabel.Font = Enum.Font.GothamSemibold
    hubNameLabel.TextColor3 = Color3.fromRGB(167, 167, 167)
    hubNameLabel.Text = hubName or "Anerial.cc"
    hubNameLabel.BackgroundTransparency = 1
    hubNameLabel.Position = UDim2.new(0.0585, 0, 0.176, 0)
    hubNameLabel.TextSize = 14 * scaleFactor
    hubNameLabel.Size = UDim2.new(0, 87 * scaleFactor, 0, 15 * scaleFactor)
    hubNameLabel.Parent = dragFrame

    local tabFrame = Instance.new("Frame")
    tabFrame.Name = "TabFrame"
    tabFrame.BackgroundTransparency = 1
    tabFrame.Position = UDim2.new(0.01, 0, 1.5, 0)
    tabFrame.Size = UDim2.new(0, 128 * scaleFactor, 0, 243 * scaleFactor)
    tabFrame.Parent = dragFrame

    local modulesFrame = Instance.new("ScrollingFrame")
    modulesFrame.Name = "ModulesFrame"
    modulesFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    modulesFrame.Active = true
    modulesFrame.ScrollBarThickness = 3
    modulesFrame.BackgroundTransparency = 1
    modulesFrame.Position = UDim2.new(0.228, 0, 0.119, 0)
    modulesFrame.Size = UDim2.new(0, 435 * scaleFactor, 0, 249 * scaleFactor)
    modulesFrame.BorderSizePixel = 0
    modulesFrame.Parent = main

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5 * scaleFactor)
    UIListLayout.Parent = modulesFrame

    -- Dragging functionality
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    dragButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Library object
    local library = {}
    local tabs = {}
    local currentTab = nil

    function library.addTab(name, iconAsset)
        local tab = Instance.new("Frame")
        tab.BackgroundTransparency = 1
        tab.Size = UDim2.new(0, 117 * scaleFactor, 0, 22 * scaleFactor)
        tab.Parent = tabFrame

        local UIListLayoutTabs = Instance.new("UIListLayout")
        UIListLayoutTabs.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayoutTabs.Padding = UDim.new(0, 5 * scaleFactor)
        UIListLayoutTabs.Parent = tabFrame

        local tabLabel = Instance.new("TextLabel")
        tabLabel.Font = Enum.Font.GothamSemibold
        tabLabel.TextColor3 = Color3.fromRGB(168, 168, 168)
        tabLabel.Text = name
        tabLabel.BackgroundTransparency = 1
        tabLabel.Position = UDim2.new(0.197, 0, 0.182, 0)
        tabLabel.TextSize = 13 * scaleFactor
        tabLabel.Size = UDim2.new(0, 70 * scaleFactor, 0, 13 * scaleFactor)
        tabLabel.Parent = tab

        local tabButton = Instance.new("TextButton")
        tabButton.Text = ""
        tabButton.BackgroundTransparency = 1
        tabButton.Size = UDim2.new(0, 111 * scaleFactor, 0, 20 * scaleFactor)
        tabButton.Parent = tab

        local tabIcon = Instance.new("ImageLabel")
        tabIcon.ImageColor3 = Color3.fromRGB(144, 144, 144)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Image = iconAsset or "rbxassetid://10734951847"
        tabIcon.Position = UDim2.new(0.1, 0, 0.145, 0)
        tabIcon.Size = UDim2.new(0, 15 * scaleFactor, 0, 15 * scaleFactor)
        tabIcon.Parent = tab

        local aspectRatio = Instance.new("UIAspectRatioConstraint")
        aspectRatio.Parent = tabIcon

        local tabModules = Instance.new("Folder")
        tabModules.Name = name .. "Modules"
        tabModules.Parent = modulesFrame

        tabs[name] = tabModules

        tabButton.MouseButton1Click:Connect(function()
            for _, modFolder in pairs(modulesFrame:GetChildren()) do
                if modFolder:IsA("Folder") then
                    modFolder.Visible = (modFolder == tabModules)
                end
            end
            currentTab = name
        end)

        if not currentTab then
            tabButton:Invoke()
        end

        return library
    end

    function library.addModule(tabName, moduleName)
        local tabModules = tabs[tabName]
        if not tabModules then return end

        local moduleFrame = Instance.new("Frame")
        moduleFrame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
        moduleFrame.BackgroundTransparency = 0.6
        moduleFrame.Size = UDim2.new(0, 204 * scaleFactor, 0, 26 * scaleFactor)  -- Initial collapsed size
        moduleFrame.Parent = tabModules

        local uICornerMod = Instance.new("UICorner")
        uICornerMod.CornerRadius = UDim.new(0, 3)
        uICornerMod.Parent = moduleFrame

        local moduleHeader = Instance.new("Frame")
        moduleHeader.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
        moduleHeader.BackgroundTransparency = 0.4
        moduleHeader.Size = UDim2.new(1, 0, 0, 26 * scaleFactor)
        moduleHeader.Parent = moduleFrame

        local uICornerHeader = Instance.new("UICorner")
        uICornerHeader.CornerRadius = UDim.new(0, 4)
        uICornerHeader.Parent = moduleHeader

        local moduleLabel = Instance.new("TextLabel")
        moduleLabel.Font = Enum.Font.GothamSemibold
        moduleLabel.TextColor3 = Color3.fromRGB(193, 193, 193)
        moduleLabel.Text = moduleName
        moduleLabel.BackgroundTransparency = 1
        moduleLabel.Position = UDim2.new(0.106, 0, 0.204, 0)
        moduleLabel.TextSize = 14 * scaleFactor
        moduleLabel.Size = UDim2.new(0, 97 * scaleFactor, 0, 14 * scaleFactor)
        moduleLabel.Parent = moduleHeader

        local moduleButton = Instance.new("TextButton")
        moduleButton.Text = ""
        moduleButton.BackgroundTransparency = 1
        moduleButton.Size = UDim2.new(1, 0, 1, 0)
        moduleButton.Parent = moduleHeader

        local keybindFrame = Instance.new("Frame")
        keybindFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        keybindFrame.Position = UDim2.new(0.041, 0, 0.091, 0)
        keybindFrame.Size = UDim2.new(0, 20 * scaleFactor, 0, 20 * scaleFactor)
        keybindFrame.Parent = moduleHeader

        local uICornerKey = Instance.new("UICorner")
        uICornerKey.CornerRadius = UDim.new(0, 4)
        uICornerKey.Parent = keybindFrame

        local keybindButton = Instance.new("TextButton")
        keybindButton.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
        keybindButton.Position = UDim2.new(0.25, 0, 0.25, 0)
        keybindButton.Size = UDim2.new(0, 10 * scaleFactor, 0, 10 * scaleFactor)
        keybindButton.Text = ""
        keybindButton.Parent = keybindFrame

        local uICornerKeyBtn = Instance.new("UICorner")
        uICornerKeyBtn.CornerRadius = UDim.new(0, 4)
        uICornerKeyBtn.Parent = keybindButton

        local optionsContainer = Instance.new("Frame")
        optionsContainer.BackgroundTransparency = 1
        optionsContainer.Position = UDim2.new(0, 0, 1, 0)
        optionsContainer.Size = UDim2.new(1, 0, 0, 0)
        optionsContainer.Parent = moduleFrame

        local UIListLayoutOptions = Instance.new("UIListLayout")
        UIListLayoutOptions.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayoutOptions.Padding = UDim.new(0, 5 * scaleFactor)
        UIListLayoutOptions.Parent = optionsContainer

        local expanded = false
        moduleButton.MouseButton1Click:Connect(function()
            expanded = not expanded
            if expanded then
                moduleFrame.Size = UDim2.new(0, 204 * scaleFactor, 0, 26 * scaleFactor + optionsContainer.AbsoluteSize.Y + 10 * scaleFactor)
            else
                moduleFrame.Size = UDim2.new(0, 204 * scaleFactor, 0, 26 * scaleFactor)
            end
            optionsContainer.Visible = expanded
        end)

        local module = {
            addSlider = function(sliderName, min, max, default, callback)
                local sliderFrame = Instance.new("Frame")
                sliderFrame.BackgroundColor3 = Color3.fromRGB(77, 77, 77)
                sliderFrame.Size = UDim2.new(1, -10 * scaleFactor, 0, 22 * scaleFactor)
                sliderFrame.Position = UDim2.new(0, 5 * scaleFactor, 0, 0)
                sliderFrame.Parent = optionsContainer

                local uICornerSlider = Instance.new("UICorner")
                uICornerSlider.CornerRadius = UDim.new(1, 0)
                uICornerSlider.Parent = sliderFrame

                local sliderValue = Instance.new("Frame")
                sliderValue.BackgroundColor3 = Color3.fromRGB(143, 143, 143)
                sliderValue.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                sliderValue.Parent = sliderFrame

                local sliderButton = Instance.new("TextButton")
                sliderButton.BackgroundColor3 = Color3.new(1, 1, 1)
                sliderButton.Position = UDim2.new(1, -5 * scaleFactor, -1, 0)
                sliderButton.Size = UDim2.new(0, 10 * scaleFactor, 0, 10 * scaleFactor)
                sliderButton.Text = ""
                sliderButton.Parent = sliderValue

                local uICornerSliderBtn = Instance.new("UICorner")
                uICornerSliderBtn.CornerRadius = UDim.new(1, 0)
                uICornerSliderBtn.Parent = sliderButton

                local sliderText = Instance.new("TextLabel")
                sliderText.Font = Enum.Font.GothamSemibold
                sliderText.TextColor3 = Color3.fromRGB(162, 162, 162)
                sliderText.Text = sliderName
                sliderText.BackgroundTransparency = 1
                sliderText.Position = UDim2.new(0.05, 0, -0.5, 0)
                sliderText.TextSize = 14 * scaleFactor
                sliderText.Size = UDim2.new(0.5, 0, 1, 0)
                sliderText.Parent = sliderFrame

                local valueLabel = Instance.new("TextLabel")
                valueLabel.Font = Enum.Font.GothamSemibold
                valueLabel.TextColor3 = Color3.fromRGB(162, 162, 162)
                valueLabel.Text = tostring(default)
                valueLabel.BackgroundTransparency = 1
                valueLabel.Position = UDim2.new(0.8, 0, -0.5, 0)
                valueLabel.TextSize = 14 * scaleFactor
                valueLabel.Size = UDim2.new(0.2, 0, 1, 0)
                valueLabel.Parent = sliderFrame

                local currentValue = default
                local sliding = false

                sliderButton.MouseButton1Down:Connect(function()
                    sliding = true
                end)

                UIS.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = false
                    end
                end)

                RunService.RenderStepped:Connect(function()
                    if sliding then
                        local mousePos = UIS:GetMouseLocation()
                        local relPos = mousePos - sliderFrame.AbsolutePosition
                        local percent = math.clamp(relPos.X / sliderFrame.AbsoluteSize.X, 0, 1)
                        currentValue = min + (max - min) * percent
                        valueLabel.Text = tostring(math.floor(currentValue))
                        sliderValue.Size = UDim2.new(percent, 0, 1, 0)
                        callback(currentValue)
                    end
                end)

                return module
            end,

            addDropdown = function(dropdownName, options, default, callback)
                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
                dropdownFrame.BackgroundTransparency = 0.4
                dropdownFrame.Size = UDim2.new(1, -10 * scaleFactor, 0, 18 * scaleFactor)
                dropdownFrame.Position = UDim2.new(0, 5 * scaleFactor, 0, 0)
                dropdownFrame.Parent = optionsContainer

                local uICornerDrop = Instance.new("UICorner")
                uICornerDrop.CornerRadius = UDim.new(0, 4)
                uICornerDrop.Parent = dropdownFrame

                local dropLabel = Instance.new("TextLabel")
                dropLabel.Font = Enum.Font.GothamSemibold
                dropLabel.TextColor3 = Color3.fromRGB(162, 162, 162)
                dropLabel.Text = default or dropdownName
                dropLabel.BackgroundTransparency = 1
                dropLabel.Position = UDim2.new(0.05, 0, 0.167, 0)
                dropLabel.TextSize = 14 * scaleFactor
                dropLabel.Size = UDim2.new(0.9, 0, 1, 0)
                dropLabel.Parent = dropdownFrame

                local dropButton = Instance.new("TextButton")
                dropButton.Text = ""
                dropButton.BackgroundTransparency = 1
                dropButton.Size = UDim2.new(1, 0, 1, 0)
                dropButton.Parent = dropdownFrame

                local dropList = Instance.new("Frame")
                dropList.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
                dropList.BackgroundTransparency = 0.4
                dropList.Position = UDim2.new(0, 0, 1, 0)
                dropList.Size = UDim2.new(1, 0, 0, #options * 20 * scaleFactor)
                dropList.Visible = false
                dropList.Parent = dropdownFrame

                local uICornerDropList = Instance.new("UICorner")
                uICornerDropList.CornerRadius = UDim.new(0, 4)
                uICornerDropList.Parent = dropList

                local UIListLayoutDrop = Instance.new("UIListLayout")
                UIListLayoutDrop.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayoutDrop.Padding = UDim.new(0, 2 * scaleFactor)
                UIListLayoutDrop.Parent = dropList

                for _, opt in ipairs(options) do
                    local optButton = Instance.new("TextButton")
                    optButton.Font = Enum.Font.GothamSemibold
                    optButton.TextColor3 = Color3.fromRGB(162, 162, 162)
                    optButton.Text = opt
                    optButton.BackgroundTransparency = 1
                    optButton.TextSize = 14 * scaleFactor
                    optButton.Size = UDim2.new(1, 0, 0, 18 * scaleFactor)
                    optButton.Parent = dropList

                    optButton.MouseButton1Click:Connect(function()
                        dropLabel.Text = opt
                        dropList.Visible = false
                        callback(opt)
                    end)
                end

                dropButton.MouseButton1Click:Connect(function()
                    dropList.Visible = not dropList.Visible
                end)

                return module
            end,

            setKeybind = function(callback)
                local binding = false
                keybindButton.MouseButton1Click:Connect(function()
                    binding = true
                    keybindButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Indicate binding
                end)

                UIS.InputBegan:Connect(function(input)
                    if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                        local key = input.KeyCode
                        keybindButton.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
                        binding = false
                        callback(key)
                    end
                end)

                return module
            end
        }

        return module
    end

    return library
end

return UILibrary
