-- Anerial.cc UI Library
-- Created by Grok based on user's preview
-- Usage example at the bottom

local Library = {}

function Library.new(title)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")

    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    -- Detect device
    local isMobile = UserInputService.TouchEnabled
    local scaleFactor = isMobile and 0.7 or 1
    local baseSizeX = 569
    local baseSizeY = 288
    local sizeX = math.floor(baseSizeX * scaleFactor)
    local sizeY = math.floor(baseSizeY * scaleFactor)

    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AnerialUI"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui  -- Change to game.CoreGui if needed for exploits

    -- Main Frame
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)  -- 0.0471 * 255 ≈ 12
    main.BackgroundTransparency = 0.1
    main.Position = UDim2.new(0.309, 0, 0.324, 0)
    main.BorderSizePixel = 0
    main.Size = UDim2.new(0, sizeX, 0, sizeY)
    main.Parent = screenGui

    local uICorner = Instance.new("UICorner")
    uICorner.CornerRadius = UDim.new(0, 9)
    uICorner.Parent = main

    -- Random image label
    local randomImage = Instance.new("ImageLabel")
    randomImage.Name = "RandomImage"
    randomImage.ImageColor3 = Color3.fromRGB(143, 143, 143)
    randomImage.ScaleType = Enum.ScaleType.Crop
    randomImage.BackgroundTransparency = 1
    randomImage.Rotation = -17
    randomImage.Image = "rbxassetid://10709818626"
    randomImage.Position = UDim2.new(0.023, 0, 0.02, 0)
    randomImage.Size = UDim2.new(0, 17, 0, 17)
    randomImage.Parent = main

    -- Dragging frame
    local dragFrame = Instance.new("Frame")
    dragFrame.Name = "DragFrame"
    dragFrame.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
    dragFrame.BackgroundTransparency = 0.8
    dragFrame.Position = UDim2.new(0.0133, 0, 0.0339, 0)
    dragFrame.BorderSizePixel = 0
    dragFrame.Size = UDim2.new(0, sizeX - 8, 0, 25)
    dragFrame.Parent = main

    local uICornerDrag = Instance.new("UICorner")
    uICornerDrag.CornerRadius = UDim.new(0, 4)
    uICornerDrag.Parent = dragFrame

    local dragButton = Instance.new("TextButton")
    dragButton.Name = "DragButton"
    dragButton.Text = ""
    dragButton.BackgroundTransparency = 1
    dragButton.Size = UDim2.new(1, 0, 1, 0)
    dragButton.Parent = dragFrame

    -- Hub name
    local hubName = Instance.new("TextLabel")
    hubName.Name = "HubName"
    hubName.Font = Enum.Font.GothamSemibold
    hubName.TextColor3 = Color3.fromRGB(167, 167, 167)
    hubName.Text = title or "Anerial.cc - original"
    hubName.BackgroundTransparency = 1
    hubName.Position = UDim2.new(0.0585, 0, 0.176, 0)
    hubName.TextSize = 14
    hubName.Size = UDim2.new(0, 87, 0, 15)
    hubName.Parent = dragFrame

    -- Tab frame
    local tabFrameSystem = Instance.new("Frame")
    tabFrameSystem.Name = "TabFrameSystem"
    tabFrameSystem.BackgroundTransparency = 1
    tabFrameSystem.Position = UDim2.new(0.01, 0, 1.2, 0)
    tabFrameSystem.Size = UDim2.new(0, 128, 0, sizeY - 70)
    tabFrameSystem.Parent = dragFrame

    -- Modules scrolling frame
    local modulesFrame = Instance.new("ScrollingFrame")
    modulesFrame.Name = "ModulesFrame"
    modulesFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    modulesFrame.Active = true
    modulesFrame.ScrollBarThickness = 3
    modulesFrame.BackgroundTransparency = 1
    modulesFrame.Position = UDim2.new(0.228, 0, 0.119, 0)
    modulesFrame.Size = UDim2.new(0, sizeX * 0.765, 0, sizeY * 0.865)
    modulesFrame.Parent = main

    local uIListLayout = Instance.new("UIListLayout")
    uIListLayout.FillDirection = Enum.FillDirection.Horizontal
    uIListLayout.Wraps = true
    uIListLayout.Padding = UDim.new(0, 10)
    uIListLayout.Parent = modulesFrame

    local uIPadding = Instance.new("UIPadding")
    uIPadding.PaddingLeft = UDim.new(0, 10)
    uIPadding.PaddingTop = UDim.new(0, 5)
    uIPadding.Parent = modulesFrame

    -- Dragging functionality
    local dragSpeed = 0.25
    local dragToggle, dragInput, dragStart, startPos
    dragButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = main.Position
            local conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                    conn:Disconnect()
                end
            end)
        end
    end)
    dragButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragToggle and input == dragInput then
            local delta = input.Position - dragStart
            local pos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(main, TweenInfo.new(dragSpeed), {Position = pos}):Play()
        end
    end)

    -- Library object
    local lib = {}
    local currentTab
    local tabs = {}

    function lib:AddTab(name, icon)
        local tabButtonFrame = Instance.new("Frame")
        tabButtonFrame.BackgroundTransparency = 1
        tabButtonFrame.Size = UDim2.new(0, 117, 0, 22)
        tabButtonFrame.Parent = tabFrameSystem

        local tabButton = Instance.new("TextButton")
        tabButton.Text = ""
        tabButton.BackgroundTransparency = 1
        tabButton.Size = UDim2.new(1, 0, 1, 0)
        tabButton.Parent = tabButtonFrame

        local tabIcon = Instance.new("ImageLabel")
        tabIcon.ImageColor3 = Color3.fromRGB(144, 144, 144)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Image = icon or "rbxassetid://10734951847"
        tabIcon.Position = UDim2.new(0.1, 0, 0.145, 0)
        tabIcon.Size = UDim2.new(0, 15, 0, 15)
        tabIcon.Parent = tabButtonFrame

        Instance.new("UIAspectRatioConstraint").Parent = tabIcon

        local tabLabel = Instance.new("TextLabel")
        tabLabel.Font = Enum.Font.GothamSemibold
        tabLabel.TextColor3 = Color3.fromRGB(168, 168, 168)
        tabLabel.Text = name
        tabLabel.BackgroundTransparency = 1
        tabLabel.Position = UDim2.new(0.197, 0, 0.182, 0)
        tabLabel.TextSize = 13
        tabLabel.Size = UDim2.new(0, 70, 0, 13)
        tabLabel.Parent = tabButtonFrame

        -- Tab modules container
        local tabModules = modulesFrame:Clone()
        tabModules.Name = name .. "Modules"
        tabModules.Parent = main
        tabModules.Visible = false

        tabButton.MouseButton1Click:Connect(function()
            for _, tmod in ipairs(main:GetChildren()) do
                if tmod.Name:match("Modules$") then
                    tmod.Visible = false
                end
            end
            tabModules.Visible = true
            currentTab = tabModules
            -- Highlight (change color)
            for _, tb in ipairs(tabFrameSystem:GetChildren()) do
                if tb:IsA("Frame") then
                    tb:FindFirstChildWhichIsA("TextLabel").TextColor3 = Color3.fromRGB(168, 168, 168)
                end
            end
            tabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        local uIListLayoutTab = Instance.new("UIListLayout")
        uIListLayoutTab.SortOrder = Enum.SortOrder.LayoutOrder
        uIListLayoutTab.Padding = UDim.new(0, 5)
        uIListLayoutTab.Parent = tabFrameSystem

        table.insert(tabs, tabButtonFrame)

        local tab = {}
        local moduleCount = 0

        function tab:AddModule(name)
            local moduleCollapsed = Instance.new("Frame")
            moduleCollapsed.Name = "ModuleCollapsed"
            moduleCollapsed.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
            moduleCollapsed.BackgroundTransparency = 0.4
            moduleCollapsed.Size = UDim2.new(0, 204, 0, 26)
            moduleCollapsed.Parent = tabModules

            local uICornerMod = Instance.new("UICorner")
            uICornerMod.CornerRadius = UDim.new(0, 4)
            uICornerMod.Parent = moduleCollapsed

            local moduleButton = Instance.new("TextButton")
            moduleButton.Text = ""
            moduleButton.BackgroundTransparency = 1
            moduleButton.Size = UDim2.new(1, 0, 1, 0)
            moduleButton.Parent = moduleCollapsed

            local moduleNameLabel = Instance.new("TextLabel")
            moduleNameLabel.Font = Enum.Font.GothamSemibold
            moduleNameLabel.TextColor3 = Color3.fromRGB(193, 193, 193)
            moduleNameLabel.Text = name
            moduleNameLabel.BackgroundTransparency = 1
            moduleNameLabel.Position = UDim2.new(0.106, 0, 0.204, 0)
            moduleNameLabel.TextSize = 14
            moduleNameLabel.Size = UDim2.new(0, 97, 0, 14)
            moduleNameLabel.Parent = moduleCollapsed

            local keybindFrame = Instance.new("Frame")
            keybindFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            keybindFrame.Position = UDim2.new(0.041, 0, 0.091, 0)
            keybindFrame.Size = UDim2.new(0, 20, 0, 20)
            keybindFrame.Parent = moduleCollapsed

            local uICornerKey = Instance.new("UICorner")
            uICornerKey.CornerRadius = UDim.new(0, 4)
            uICornerKey.Parent = keybindFrame

            local keybindButton = Instance.new("TextButton")
            keybindButton.Text = ""
            keybindButton.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
            keybindButton.Position = UDim2.new(0.25, 0, 0.25, 0)
            keybindButton.Size = UDim2.new(0, 10, 0, 10)
            keybindButton.Parent = keybindFrame

            local uICornerKeyBtn = Instance.new("UICorner")
            uICornerKeyBtn.CornerRadius = UDim.new(0, 4)
            uICornerKeyBtn.Parent = keybindButton

            -- Expanded frame
            local moduleExpanded = Instance.new("Frame")
            moduleExpanded.Name = "ModuleExpanded"
            moduleExpanded.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
            moduleExpanded.BackgroundTransparency = 0.6
            moduleExpanded.Position = UDim2.new(0, 0, 1, 0)
            moduleExpanded.Size = UDim2.new(1, 0, 0, 0)  -- Start with 0 height, will adjust dynamically
            moduleExpanded.Visible = false
            moduleExpanded.Parent = moduleCollapsed

            local uICornerExp = Instance.new("UICorner")
            uICornerExp.CornerRadius = UDim.new(0, 3)
            uICornerExp.Parent = moduleExpanded

            local expandedLayout = Instance.new("UIListLayout")
            expandedLayout.SortOrder = Enum.SortOrder.LayoutOrder
            expandedLayout.Padding = UDim.new(0, 5)
            expandedLayout.Parent = moduleExpanded

            expandedLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                moduleExpanded.Size = UDim2.new(1, 0, 0, expandedLayout.AbsoluteContentSize.Y + 10)
            end)

            -- Toggle expand
            moduleButton.MouseButton1Click:Connect(function()
                moduleExpanded.Visible = not moduleExpanded.Visible
            end)

            -- Keybind functionality (example, bind to toggle module)
            local boundKey = Enum.KeyCode.Unknown
            keybindButton.MouseButton1Click:Connect(function()
                keybindButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  -- Waiting
                local input = UserInputService.InputBegan:Wait()
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    boundKey = input.KeyCode
                    keybindButton.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
                end
            end)

            local mod = {}
            local elementCount = 0

            function mod:AddDropdown(options, default, callback)
                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
                dropdownFrame.BackgroundTransparency = 0.4
                dropdownFrame.Size = UDim2.new(1, -10, 0, 18)
                dropdownFrame.Parent = moduleExpanded

                local uICornerDrop = Instance.new("UICorner")
                uICornerDrop.CornerRadius = UDim.new(0, 4)
                uICornerDrop.Parent = dropdownFrame

                local dropButton = Instance.new("TextButton")
                dropButton.Text = ""
                dropButton.BackgroundTransparency = 1
                dropButton.Size = UDim2.new(1, 0, 1, 0)
                dropButton.Parent = dropdownFrame

                local dropLabel = Instance.new("TextLabel")
                dropLabel.Font = Enum.Font.GothamSemibold
                dropLabel.TextColor3 = Color3.fromRGB(162, 162, 162)
                dropLabel.Text = default or options[1]
                dropLabel.BackgroundTransparency = 1
                dropLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
                dropLabel.TextSize = 14
                dropLabel.Size = UDim2.new(0.9, 0, 0.8, 0)
                dropLabel.Parent = dropdownFrame

                local dropList = Instance.new("Frame")
                dropList.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
                dropList.BackgroundTransparency = 0.4
                dropList.Position = UDim2.new(0, 0, 1, 0)
                dropList.Size = UDim2.new(1, 0, 0, #options * 20)
                dropList.Visible = false
                dropList.Parent = dropdownFrame

                local uICornerList = Instance.new("UICorner")
                uICornerList.CornerRadius = UDim.new(0, 4)
                uICornerList.Parent = dropList

                local listLayout = Instance.new("UIListLayout")
                listLayout.Parent = dropList

                for _, opt in ipairs(options) do
                    local optButton = Instance.new("TextButton")
                    optButton.Font = Enum.Font.GothamSemibold
                    optButton.TextColor3 = Color3.fromRGB(162, 162, 162)
                    optButton.Text = opt
                    optButton.BackgroundTransparency = 1
                    optButton.Size = UDim2.new(1, 0, 0, 20)
                    optButton.Parent = dropList

                    optButton.MouseButton1Click:Connect(function()
                        dropLabel.Text = opt
                        dropList.Visible = false
                        if callback then callback(opt) end
                    end)
                end

                dropButton.MouseButton1Click:Connect(function()
                    dropList.Visible = not dropList.Visible
                end)

                elementCount = elementCount + 1
            end

            function mod:AddSlider(name, min, max, default, callback)
                local sliderFrame = Instance.new("Frame")
                sliderFrame.BackgroundColor3 = Color3.fromRGB(77, 77, 77)
                sliderFrame.Size = UDim2.new(1, -10, 0, 20)
                sliderFrame.Parent = moduleExpanded

                local uICornerSlider = Instance.new("UICorner")
                uICornerSlider.CornerRadius = UDim.new(1, 0)
                uICornerSlider.Parent = sliderFrame

                local sliderName = Instance.new("TextLabel")
                sliderName.Font = Enum.Font.GothamSemibold
                sliderName.TextColor3 = Color3.fromRGB(162, 162, 162)
                sliderName.Text = name
                sliderName.BackgroundTransparency = 1
                sliderName.Position = UDim2.new(0.05, 0, 0, 0)
                sliderName.TextSize = 14
                sliderName.Size = UDim2.new(0.4, 0, 1, 0)
                sliderName.Parent = sliderFrame

                local sliderValue = Instance.new("TextLabel")
                sliderValue.Font = Enum.Font.GothamSemibold
                sliderValue.TextColor3 = Color3.fromRGB(162, 162, 162)
                sliderValue.Text = tostring(default)
                sliderValue.BackgroundTransparency = 1
                sliderValue.Position = UDim2.new(0.8, 0, 0, 0)
                sliderValue.TextSize = 14
                sliderValue.Size = UDim2.new(0.2, 0, 1, 0)
                sliderValue.Parent = sliderFrame

                local sliderBar = Instance.new("Frame")
                sliderBar.BackgroundColor3 = Color3.fromRGB(143, 143, 143)
                sliderBar.Position = UDim2.new(0, 0, 0.7, 0)
                sliderBar.Size = UDim2.new((default - min) / (max - min), 0, 0, 3)
                sliderBar.Parent = sliderFrame

                local sliderKnob = Instance.new("TextButton")
                sliderKnob.Text = ""
                sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                sliderKnob.Position = UDim2.new(1, -5, -0.5, 0)
                sliderKnob.Size = UDim2.new(0, 10, 0, 10)
                sliderKnob.Parent = sliderBar

                local uICornerKnob = Instance.new("UICorner")
                uICornerKnob.CornerRadius = UDim.new(1, 0)
                uICornerKnob.Parent = sliderKnob

                local value = default
                sliderKnob.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        local conn = RunService.RenderStepped:Connect(function()
                            local mousePos = UserInputService:GetMouseLocation()
                            local rel = math.clamp((mousePos.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
                            value = min + (max - min) * rel
                            value = math.floor(value)
                            sliderValue.Text = tostring(value)
                            sliderBar.Size = UDim2.new(rel, 0, 0, 3)
                            if callback then callback(value) end
                        end)
                        local endConn = input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                conn:Disconnect()
                                endConn:Disconnect()
                            end
                        end)
                    end
                end)

                elementCount = elementCount + 1
            end

            -- Add more elements like toggles, buttons, etc., similarly

            moduleCount = moduleCount + 1
            return mod
        end

        if #tabs == 1 then
            tabButton:SimulateClick()  -- Select first tab by default
        end

        return tab
    end

    return lib
end

return Library

-- Usage example:
--[[
local uiLib = require(script.Parent.UILibrary)  -- Assuming this is a ModuleScript
local ui = uiLib.new("My Hub")

local tab1 = ui:AddTab("Blatant", "rbxassetid://10734951847")
local mod1 = tab1:AddModule("Auto Parry")
mod1:AddSlider("Parry Accuracy", 0, 100, 50, function(val)
    print("Parry Accuracy set to", val)
end)
mod1:AddDropdown({"Custom", "Preset1", "Preset2"}, "Custom", function(opt)
    print("Selected", opt)
end)

local tab2 = ui:AddTab("Utility")
local mod2 = tab2:AddModule("Auto Spam")
mod2:AddSlider("Spam Rate", 1, 10, 5, function(val)
    print("Spam Rate set to", val)
end)
--]]
