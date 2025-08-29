-- Responsive UI Library with Device Detection
-- Based on Allusive-UI style with mobile optimization

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local UILibrary = {}
UILibrary.__index = UILibrary

-- Device detection
local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function getDeviceScale()
    if isMobile() then
        return 0.7 -- Smaller scale for mobile
    else
        return 1.0 -- Normal scale for desktop
    end
end

-- Create the main UI
function UILibrary.new(config)
    local self = setmetatable({}, UILibrary)
    
    config = config or {}
    self.hubName = config.hubName or "UI Library"
    self.scale = getDeviceScale()
    self.modules = {}
    self.currentTab = nil
    self.tabs = {}
    
    -- Create ScreenGui
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "ResponsiveUILibrary"
    self.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main frame with responsive sizing
    local baseWidth, baseHeight = 569, 288
    self.main = Instance.new("Frame")
    self.main.Name = "Main"
    self.main.BackgroundColor3 = Color3.new(0.0471, 0.0471, 0.0471)
    self.main.BackgroundTransparency = 0.1
    self.main.Position = UDim2.new(0.5, -(baseWidth * self.scale)/2, 0.5, -(baseHeight * self.scale)/2)
    self.main.BorderSizePixel = 0
    self.main.Size = UDim2.new(0, baseWidth * self.scale, 0, baseHeight * self.scale)
    self.main.Parent = self.screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 9 * self.scale)
    mainCorner.Parent = self.main
    
    -- Create dragging system
    self:createDragSystem()
    
    -- Create tab system
    self:createTabSystem()
    
    -- Create modules frame
    self:createModulesFrame()
    
    return self
end

-- Create dragging system with hub name
function UILibrary:createDragSystem()
    self.dragFrame = Instance.new("Frame")
    self.dragFrame.Name = "DragFrame"
    self.dragFrame.BackgroundColor3 = Color3.new(0.204, 0.204, 0.204)
    self.dragFrame.BackgroundTransparency = 0.8
    self.dragFrame.Position = UDim2.new(0.0133, 0, 0.0339, 0)
    self.dragFrame.BorderSizePixel = 0
    self.dragFrame.Size = UDim2.new(0.987, 0, 0, 25 * self.scale)
    self.dragFrame.Parent = self.main
    
    local dragCorner = Instance.new("UICorner")
    dragCorner.CornerRadius = UDim.new(0, 4 * self.scale)
    dragCorner.Parent = self.dragFrame
    
    -- Hub name label
    local hubLabel = Instance.new("TextLabel")
    hubLabel.Name = "HubLabel"
    hubLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontStyle.Normal, Enum.FontWeight.SemiBold)
    hubLabel.TextColor3 = Color3.new(0.655, 0.655, 0.655)
    hubLabel.Text = self.hubName
    hubLabel.BackgroundTransparency = 1
    hubLabel.Position = UDim2.new(0.0585, 0, 0.176, 0)
    hubLabel.Size = UDim2.new(0, 200 * self.scale, 0, 15 * self.scale)
    hubLabel.TextSize = 14 * self.scale
    hubLabel.Parent = self.dragFrame
    
    -- Drag button
    local dragButton = Instance.new("TextButton")
    dragButton.Name = "DragButton"
    dragButton.Text = ""
    dragButton.BackgroundTransparency = 1
    dragButton.Size = UDim2.new(1, 0, 1, 0)
    dragButton.Parent = self.dragFrame
    
    -- Implement dragging
    local dragging = false
    local dragStart, startPos
    
    dragButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.main.Position
        end
    end)
    
    dragButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self.main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Create tab system
function UILibrary:createTabSystem()
    self.tabFrame = Instance.new("Frame")
    self.tabFrame.Name = "TabFrame"
    self.tabFrame.BackgroundTransparency = 1
    self.tabFrame.Position = UDim2.new(0, 0, 0.2, 0)
    self.tabFrame.Size = UDim2.new(0, 128 * self.scale, 0, 200 * self.scale)
    self.tabFrame.Parent = self.main
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 5 * self.scale)
    tabLayout.Parent = self.tabFrame
end

-- Create modules frame (right side)
function UILibrary:createModulesFrame()
    self.modulesFrame = Instance.new("ScrollingFrame")
    self.modulesFrame.Name = "ModulesFrame"
    self.modulesFrame.ScrollBarImageColor3 = Color3.new(0.392, 0.392, 0.392)
    self.modulesFrame.Active = true
    self.modulesFrame.ScrollBarThickness = 3 * self.scale
    self.modulesFrame.BackgroundTransparency = 1
    self.modulesFrame.Position = UDim2.new(0.228, 0, 0.119, 0)
    self.modulesFrame.Size = UDim2.new(0, 435 * self.scale, 0, 220 * self.scale)
    self.modulesFrame.BorderSizePixel = 0
    self.modulesFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.modulesFrame.Parent = self.main
    
    local moduleLayout = Instance.new("UIListLayout")
    moduleLayout.SortOrder = Enum.SortOrder.LayoutOrder
    moduleLayout.Padding = UDim.new(0, 10 * self.scale)
    moduleLayout.Parent = self.modulesFrame
    
    -- Auto-resize canvas
    moduleLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.modulesFrame.CanvasSize = UDim2.new(0, 0, 0, moduleLayout.AbsoluteContentSize.Y + 20)
    end)
end

-- Create a new tab
function UILibrary:createTab(config)
    config = config or {}
    local tabName = config.name or "Tab"
    local tabIcon = config.icon or "rbxassetid://10734951847"
    
    -- Tab button frame
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = tabName .. "Tab"
    tabFrame.BackgroundTransparency = 1
    tabFrame.Size = UDim2.new(0, 117 * self.scale, 0, 22 * self.scale)
    tabFrame.Parent = self.tabFrame
    
    -- Tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = "TabButton"
    tabButton.Text = ""
    tabButton.BackgroundTransparency = 1
    tabButton.Size = UDim2.new(1, 0, 1, 0)
    tabButton.Parent = tabFrame
    
    -- Tab icon
    local tabIcon = Instance.new("ImageLabel")
    tabIcon.Name = "TabIcon"
    tabIcon.ImageColor3 = Color3.new(0.565, 0.565, 0.565)
    tabIcon.BackgroundTransparency = 1
    tabIcon.Image = tabIcon
    tabIcon.Position = UDim2.new(0.1, 0, 0.145, 0)
    tabIcon.Size = UDim2.new(0, 15 * self.scale, 0, 15 * self.scale)
    tabIcon.Parent = tabFrame
    
    -- Tab label
    local tabLabel = Instance.new("TextLabel")
    tabLabel.Name = "TabLabel"
    tabLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontStyle.Normal, Enum.FontWeight.SemiBold)
    tabLabel.TextColor3 = Color3.new(0.659, 0.659, 0.659)
    tabLabel.Text = tabName
    tabLabel.BackgroundTransparency = 1
    tabLabel.Position = UDim2.new(0.197, 0, 0.182, 0)
    tabLabel.Size = UDim2.new(0, 70 * self.scale, 0, 13 * self.scale)
    tabLabel.TextSize = 13 * self.scale
    tabLabel.Parent = tabFrame
    
    -- Tab data
    local tabData = {
        name = tabName,
        frame = tabFrame,
        button = tabButton,
        modules = {},
        isSelected = false
    }
    
    table.insert(self.tabs, tabData)
    
    -- Tab selection
    tabButton.MouseButton1Click:Connect(function()
        self:selectTab(tabData)
    end)
    
    -- Select first tab by default
    if #self.tabs == 1 then
        self:selectTab(tabData)
    end
    
    return {
        addModule = function(moduleConfig)
            return self:addModule(tabData, moduleConfig)
        end
    }
end

-- Select a tab
function UILibrary:selectTab(tabData)
    -- Deselect all tabs
    for _, tab in pairs(self.tabs) do
        tab.isSelected = false
        tab.frame.BackgroundTransparency = 1
    end
    
    -- Select current tab
    tabData.isSelected = true
    tabData.frame.BackgroundColor3 = Color3.new(0.122, 0.122, 0.122)
    tabData.frame.BackgroundTransparency = 0.6
    
    -- Add corner to selected tab
    if not tabData.frame:FindFirstChild("UICorner") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4 * self.scale)
        corner.Parent = tabData.frame
    end
    
    self.currentTab = tabData
    self:updateModulesView()
end

-- Update modules view based on selected tab
function UILibrary:updateModulesView()
    -- Clear current modules
    for _, child in pairs(self.modulesFrame:GetChildren()) do
        if child:IsA("Frame") and child.Name:find("Module") then
            child:Destroy()
        end
    end
    
    if not self.currentTab then return end
    
    -- Display modules for current tab
    for i, moduleData in pairs(self.currentTab.modules) do
        self:createModuleFrame(moduleData, i)
    end
end

-- Add a module to a tab
function UILibrary:addModule(tabData, config)
    config = config or {}
    local moduleName = config.name or "Module"
    
    local moduleData = {
        name = moduleName,
        enabled = config.enabled or false,
        keybind = config.keybind or "F",
        elements = {}
    }
    
    table.insert(tabData.modules, moduleData)
    
    if tabData.isSelected then
        self:updateModulesView()
    end
    
    return {
        addSlider = function(sliderConfig)
            return self:addSlider(moduleData, sliderConfig)
        end,
        addDropdown = function(dropdownConfig)
            return self:addDropdown(moduleData, dropdownConfig)
        end,
        addToggle = function(toggleConfig)
            return self:addToggle(moduleData, toggleConfig)
        end
    }
end

-- Create module frame
function UILibrary:createModuleFrame(moduleData, index)
    local moduleFrame = Instance.new("Frame")
    moduleFrame.Name = "Module" .. index
    moduleFrame.BackgroundColor3 = Color3.new(0.122, 0.122, 0.122)
    moduleFrame.BackgroundTransparency = 0.6
    moduleFrame.Size = UDim2.new(0, 204 * self.scale, 0, math.max(100, #moduleData.elements * 30 + 60) * self.scale)
    moduleFrame.BorderSizePixel = 0
    moduleFrame.Parent = self.modulesFrame
    
    local moduleCorner = Instance.new("UICorner")
    moduleCorner.CornerRadius = UDim.new(0, 3 * self.scale)
    moduleCorner.Parent = moduleFrame
    
    -- Module header
    local headerFrame = Instance.new("Frame")
    headerFrame.Name = "Header"
    headerFrame.BackgroundColor3 = Color3.new(0.188, 0.188, 0.188)
    headerFrame.BackgroundTransparency = 0.4
    headerFrame.Size = UDim2.new(1, 0, 0, 26 * self.scale)
    headerFrame.BorderSizePixel = 0
    headerFrame.Parent = moduleFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 4 * self.scale)
    headerCorner.Parent = headerFrame
    
    -- Module name
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "ModuleName"
    nameLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontStyle.Normal, Enum.FontWeight.SemiBold)
    nameLabel.TextColor3 = Color3.new(0.757, 0.757, 0.757)
    nameLabel.Text = moduleData.name
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0.106, 0, 0.204, 0)
    nameLabel.Size = UDim2.new(0, 97 * self.scale, 0, 14 * self.scale)
    nameLabel.TextSize = 14 * self.scale
    nameLabel.Parent = headerFrame
    
    -- Keybind display
    local keybindFrame = Instance.new("Frame")
    keybindFrame.Name = "KeybindFrame"
    keybindFrame.BackgroundColor3 = Color3.new(0.275, 0.275, 0.275)
    keybindFrame.Position = UDim2.new(0.041, 0, 0.091, 0)
    keybindFrame.Size = UDim2.new(0, 20 * self.scale, 0, 20 * self.scale)
    keybindFrame.BorderSizePixel = 0
    keybindFrame.Parent = headerFrame
    
    local keybindCorner = Instance.new("UICorner")
    keybindCorner.CornerRadius = UDim.new(0, 4 * self.scale)
    keybindCorner.Parent = keybindFrame
    
    local keybindButton = Instance.new("TextButton")
    keybindButton.Name = "KeybindButton"
    keybindButton.Text = ""
    keybindButton.BackgroundColor3 = Color3.new(0.675, 0.675, 0.675)
    keybindButton.Position = UDim2.new(0.25, 0, 0.25, 0)
    keybindButton.Size = UDim2.new(0, 10 * self.scale, 0, 10 * self.scale)
    keybindButton.BorderSizePixel = 0
    keybindButton.Parent = keybindFrame
    
    local keybindButtonCorner = Instance.new("UICorner")
    keybindButtonCorner.CornerRadius = UDim.new(1, 0)
    keybindButtonCorner.Parent = keybindButton
    
    -- Elements container
    local elementsFrame = Instance.new("Frame")
    elementsFrame.Name = "Elements"
    elementsFrame.BackgroundTransparency = 1
    elementsFrame.Position = UDim2.new(0, 0, 0, 30 * self.scale)
    elementsFrame.Size = UDim2.new(1, 0, 1, -30 * self.scale)
    elementsFrame.Parent = moduleFrame
    
    local elementLayout = Instance.new("UIListLayout")
    elementLayout.SortOrder = Enum.SortOrder.LayoutOrder
    elementLayout.Padding = UDim.new(0, 10 * self.scale)
    elementLayout.Parent = elementsFrame
    
    -- Create elements
    for _, element in pairs(moduleData.elements) do
        if element.type == "slider" then
            self:createSliderElement(elementsFrame, element)
        elseif element.type == "dropdown" then
            self:createDropdownElement(elementsFrame, element)
        elseif element.type == "toggle" then
            self:createToggleElement(elementsFrame, element)
        end
    end
end

-- Add slider to module
function UILibrary:addSlider(moduleData, config)
    config = config or {}
    local sliderData = {
        type = "slider",
        name = config.name or "Slider",
        min = config.min or 0,
        max = config.max or 100,
        value = config.value or 50,
        callback = config.callback or function() end
    }
    
    table.insert(moduleData.elements, sliderData)
    
    if self.currentTab and table.find(self.currentTab.modules, moduleData) then
        self:updateModulesView()
    end
    
    return sliderData
end

-- Add dropdown to module
function UILibrary:addDropdown(moduleData, config)
    config = config or {}
    local dropdownData = {
        type = "dropdown",
        name = config.name or "Dropdown",
        options = config.options or {"Option 1", "Option 2", "Option 3"},
        selected = config.selected or config.options and config.options[1] or "Option 1",
        callback = config.callback or function() end,
        isOpen = false
    }
    
    table.insert(moduleData.elements, dropdownData)
    
    if self.currentTab and table.find(self.currentTab.modules, moduleData) then
        self:updateModulesView()
    end
    
    return dropdownData
end

-- Add toggle to module
function UILibrary:addToggle(moduleData, config)
    config = config or {}
    local toggleData = {
        type = "toggle",
        name = config.name or "Toggle",
        enabled = config.enabled or false,
        callback = config.callback or function() end
    }
    
    table.insert(moduleData.elements, toggleData)
    
    if self.currentTab and table.find(self.currentTab.modules, moduleData) then
        self:updateModulesView()
    end
    
    return toggleData
end

-- Create slider element
function UILibrary:createSliderElement(parent, sliderData)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "SliderFrame"
    sliderFrame.BackgroundColor3 = Color3.new(0.302, 0.302, 0.302)
    sliderFrame.Size = UDim2.new(0, 190 * self.scale, 0, 3 * self.scale)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = parent
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderFrame
    
    -- Slider fill
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.BackgroundColor3 = Color3.new(0.561, 0.561, 0.561)
    sliderFill.Size = UDim2.new((sliderData.value - sliderData.min) / (sliderData.max - sliderData.min), 0, 1, 0)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderFrame
    
    -- Slider handle
    local sliderHandle = Instance.new("TextButton")
    sliderHandle.Name = "SliderHandle"
    sliderHandle.Text = ""
    sliderHandle.BackgroundColor3 = Color3.new(1, 1, 1)
    sliderHandle.Position = UDim2.new((sliderData.value - sliderData.min) / (sliderData.max - sliderData.min), -5 * self.scale, -1.33, 0)
    sliderHandle.Size = UDim2.new(0, 10 * self.scale, 0, 10 * self.scale)
    sliderHandle.BorderSizePixel = 0
    sliderHandle.Parent = sliderFrame
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(1, 0)
    handleCorner.Parent = sliderHandle
    
    -- Slider label
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Name = "SliderLabel"
    sliderLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontStyle.Normal, Enum.FontWeight.SemiBold)
    sliderLabel.TextColor3 = Color3.new(0.635, 0.635, 0.635)
    sliderLabel.Text = sliderData.name
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Position = UDim2.new(0, 0, -7.33, 0)
    sliderLabel.Size = UDim2.new(0, 100 * self.scale, 0, 12 * self.scale)
    sliderLabel.TextSize = 14 * self.scale
    sliderLabel.Parent = sliderFill
    
    -- Value display
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontStyle.Normal, Enum.FontWeight.SemiBold)
    valueLabel.TextColor3 = Color3.new(0.635, 0.635, 0.635)
    valueLabel.Text = tostring(sliderData.value)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(0.784, 0, -7.33, 0)
    valueLabel.Size = UDim2.new(0, 41 * self.scale, 0, 13 * self.scale)
    valueLabel.TextSize = 14 * self.scale
    valueLabel.Parent = sliderFrame
    
    -- Slider functionality
    local dragging = false
    
    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    sliderHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local framePos = sliderFrame.AbsolutePosition.X
            local frameSize = sliderFrame.AbsoluteSize.X
            local mousePos = input.Position.X
            
            local percent = math.clamp((mousePos - framePos) / frameSize, 0, 1)
            local value = math.floor(sliderData.min + (sliderData.max - sliderData.min) * percent)
            
            sliderData.value = value
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderHandle.Position = UDim2.new(percent, -5 * self.scale, -1.33, 0)
            valueLabel.Text = tostring(value)
            
            if sliderData.callback then
                sliderData.callback(value)
            end
        end
    end)
end

-- Create dropdown element
function UILibrary:createDropdownElement(parent, dropdownData)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "DropdownFrame"
    dropdownFrame.BackgroundColor3 = Color3.new(0.188, 0.188, 0.188)
    dropdownFrame.BackgroundTransparency = 0.4
    dropdownFrame.Size = UDim2.new(0, 187 * self.scale, 0, 18 * self.scale)
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Parent = parent
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 4 * self.scale)
    dropdownCorner.Parent = dropdownFrame
    
    -- Selected option label
    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Name = "SelectedLabel"
    selectedLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontStyle.Normal, Enum.FontWeight.SemiBold)
    selectedLabel.TextColor3 = Color3.new(0.635, 0.635, 0.635)
    selectedLabel.Text = dropdownData.selected
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Position = UDim2.new(0.05, 0, 0.167, 0)
    selectedLabel.Size = UDim2.new(0.8, 0, 0, 12 * self.scale)
    selectedLabel.TextSize = 14 * self.scale
    selectedLabel.Parent = dropdownFrame
    
    -- Dropdown button
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Text = ""
    dropdownButton.BackgroundTransparency = 1
    dropdownButton.Size = UDim2.new(1, 0, 1, 0)
    dropdownButton.Parent = dropdownFrame
    
    -- Options list
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Name = "OptionsFrame"
    optionsFrame.BackgroundColor3 = Color3.new(0.188, 0.188, 0.188)
    optionsFrame.BackgroundTransparency = 0.4
    optionsFrame.Position = UDim2.new(0, 0, 1.5, 0)
    optionsFrame.Size = UDim2.new(1, 0, 0, #dropdownData.options * 20 * self.scale)
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Visible = false
    optionsFrame.Parent = dropdownFrame
    
    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, 4 * self.scale)
    optionsCorner.Parent = optionsFrame
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Padding = UDim.new(0, 2 * self.scale)
    optionsLayout.Parent = optionsFrame
    
    -- Create option buttons
    for i, option in pairs(dropdownData.options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option" .. i
        optionButton.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontStyle.Normal, Enum.FontWeight.SemiBold)
        optionButton.TextColor3 = Color3.new(0.635, 0.635, 0.635)
        optionButton.Text = option
        optionButton.BackgroundTransparency = 1
        optionButton.Size = UDim2.new(1, 0, 0, 16 * self.scale)
        optionButton.TextSize = 14 * self.scale
        optionButton.Parent = optionsFrame
        
        optionButton.MouseButton1Click:Connect(function()
            dropdownData.selected = option
            selectedLabel.Text = option
            optionsFrame.Visible = false
            dropdownData.isOpen = false
            
            if dropdownData.callback then
                dropdownData.callback(option)
            end
        end)
    end
    
    -- Toggle dropdown
    dropdownButton.MouseButton1Click:Connect(function()
        dropdownData.isOpen = not dropdownData.isOpen
        optionsFrame.Visible = dropdownData.isOpen
    end)
end

-- Create toggle element
function UILibrary:createToggleElement(parent, toggleData)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "ToggleFrame"
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Size = UDim2.new(0, 190 * self.scale, 0, 20 * self.scale)
    toggleFrame.Parent = parent
    
    -- Toggle label
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "ToggleLabel"
    toggleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontStyle.Normal, Enum.FontWeight.SemiBold)
    toggleLabel.TextColor3 = Color3.new(0.635, 0.635, 0.635)
    toggleLabel.Text = toggleData.name
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Position = UDim2.new(0, 0, 0, 0)
    toggleLabel.Size = UDim2.new(0, 120 * self.scale, 0, 20 * self.scale)
    toggleLabel.TextSize = 14 * self.scale
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    -- Toggle switch background
    local switchBackground = Instance.new("Frame")
    switchBackground.Name = "SwitchBackground"
    switchBackground.BackgroundColor3 = toggleData.enabled and Color3.new(0.2, 0.6, 1) or Color3.new(0.3, 0.3, 0.3)
    switchBackground.Position = UDim2.new(1, -40 * self.scale, 0.1, 0)
    switchBackground.Size = UDim2.new(0, 35 * self.scale, 0, 16 * self.scale)
    switchBackground.BorderSizePixel = 0
    switchBackground.Parent = toggleFrame
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switchBackground
    
    -- Toggle switch handle
    local switchHandle = Instance.new("Frame")
    switchHandle.Name = "SwitchHandle"
    switchHandle.BackgroundColor3 = Color3.new(1, 1, 1)
    switchHandle.Position = toggleData.enabled and UDim2.new(1, -14 * self.scale, 0.125, 0) or UDim2.new(0, 2 * self.scale, 0.125, 0)
    switchHandle.Size = UDim2.new(0, 12 * self.scale, 0, 12 * self.scale)
    switchHandle.BorderSizePixel = 0
    switchHandle.Parent = switchBackground
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(1, 0)
    handleCorner.Parent = switchHandle
    
    -- Toggle button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Text = ""
    toggleButton.BackgroundTransparency = 1
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.Parent = toggleFrame
    
    toggleButton.MouseButton1Click:Connect(function()
        toggleData.enabled = not toggleData.enabled
        
        -- Animate toggle
        local targetColor = toggleData.enabled and Color3.new(0.2, 0.6, 1) or Color3.new(0.3, 0.3, 0.3)
        local targetPosition = toggleData.enabled and UDim2.new(1, -14 * self.scale, 0.125, 0) or UDim2.new(0, 2 * self.scale, 0.125, 0)
        
        local colorTween = TweenService:Create(switchBackground, TweenInfo.new(0.2), {BackgroundColor3 = targetColor})
        local positionTween = TweenService:Create(switchHandle, TweenInfo.new(0.2), {Position = targetPosition})
        
        colorTween:Play()
        positionTween:Play()
        
        if toggleData.callback then
            toggleData.callback(toggleData.enabled)
        end
    end)
end

-- Destroy the UI
function UILibrary:Destroy()
    if self.screenGui then
        self.screenGui:Destroy()
    end
end

-- Example usage function
function UILibrary:createExample()
    -- Create main UI
    local ui = UILibrary.new({
        hubName = "Anerial.cc - Responsive"
    })
    
    -- Create Blatant tab
    local blatantTab = ui:createTab({
        name = "Blatant",
        icon = "rbxassetid://10734951847"
    })
    
    -- Add Auto Parry module
    local autoParryModule = blatantTab.addModule({
        name = "Auto Parry",
        enabled = false,
        keybind = "F"
    })
    
    -- Add slider to Auto Parry
    autoParryModule.addSlider({
        name = "Parry Accuracy",
        min = 0,
        max = 100,
        value = 50,
        callback = function(value)
            print("Parry Accuracy set to:", value)
        end
    })
    
    -- Add dropdown to Auto Parry
    autoParryModule.addDropdown({
        name = "Mode",
        options = {"Custom", "Aggressive", "Defensive", "Balanced"},
        selected = "Custom",
        callback = function(option)
            print("Mode set to:", option)
        end
    })
    
    -- Add toggle
    autoParryModule.addToggle({
        name = "Enable Auto Parry",
        enabled = false,
        callback = function(enabled)
            print("Auto Parry enabled:", enabled)
        end
    })
    
    -- Add Auto Spam module
    local autoSpamModule = blatantTab.addModule({
        name = "Auto Spam",
        enabled = false,
        keybind = "G"
    })
    
    autoSpamModule.addSlider({
        name = "Spam Rate",
        min = 1,
        max = 20,
        value = 10,
        callback = function(value)
            print("Spam Rate set to:", value)
        end
    })
    
    autoSpamModule.addToggle({
        name = "Enable Auto Spam",
        enabled = false,
        callback = function(enabled)
            print("Auto Spam enabled:", enabled)
        end
    })
    
    -- Create Legit tab
    local legitTab = ui:createTab({
        name = "Legit",
        icon = "rbxassetid://10734951847"
    })
    
    local aimAssistModule = legitTab.addModule({
        name = "Aim Assist",
        enabled = false,
        keybind = "H"
    })
    
    aimAssistModule.addSlider({
        name = "Smoothness",
        min = 1,
        max = 10,
        value = 5,
        callback = function(value)
            print("Smoothness set to:", value)
        end
    })
    
    aimAssistModule.addDropdown({
        name = "Target Part",
        options = {"Head", "Torso", "Random"},
        selected = "Head",
        callback = function(option)
            print("Target Part set to:", option)
        end
    })
    
    return ui
end

-- Auto-detect device and adjust UI on startup
local function initializeResponsiveUI()
    print("Device detected:", isMobile() and "Mobile" or "Desktop")
    print("UI Scale:", getDeviceScale())
    
    -- Create example UI
    local ui = UILibrary:createExample()
    
    -- Handle device orientation changes for mobile
    if isMobile() then
        local function onOrientationChanged()
            -- Adjust UI position based on screen size
            local screenSize = workspace.CurrentCamera.ViewportSize
            ui.main.Position = UDim2.new(0.5, -(ui.main.Size.X.Offset)/2, 0.5, -(ui.main.Size.Y.Offset)/2)
        end
        
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(onOrientationChanged)
    end
    
    return ui
end

-- Initialize the UI
-- Uncomment the line below to auto-create the example UI:
-- initializeResponsiveUI()

return UILibrary
