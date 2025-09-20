-- Flow UI Library v1.0
-- A modern, responsive UI library for Roblox

local FlowUI = {}
FlowUI.__index = FlowUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Device Detection
local function detectDevice()
    local camera = workspace.CurrentCamera
    local viewportSize = camera.ViewportSize
    
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        if viewportSize.X > 1000 or viewportSize.Y > 700 then
            return "Tablet"
        else
            return "Mobile"
        end
    else
        return "Desktop"
    end
end

-- Utility Functions
local function createTween(instance, properties, duration, easingStyle, easingDirection)
    duration = duration or 0.3
    easingStyle = easingStyle or Enum.EasingStyle.Quint
    easingDirection = easingDirection or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    return tween
end

-- Main Library Constructor
function FlowUI.new(config)
    local self = setmetatable({}, FlowUI)
    
    -- Configuration
    config = config or {}
    self.title = config.title or "Flow"
    self.device = detectDevice()
    
    -- Scale factors based on device
    local scaleFactors = {
        Desktop = 1.0,
        Tablet = 0.8,
        Mobile = 0.6
    }
    self.scale = scaleFactors[self.device]
    
    -- Create main GUI
    self:_createMainGUI()
    
    -- State management
    self.currentTab = nil
    self.tabs = {}
    self.modules = {}
    self.isVisible = true
    self.isMobileMode = self.device == "Mobile"
    
    -- Mobile toggle setup
    if self.isMobileMode then
        self:_setupMobileToggle()
    end
    
    return self
end

-- Create the main GUI structure
function FlowUI:_createMainGUI()
    -- Main ScreenGui
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "FlowUI"
    self.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.gui.Parent = CoreGui
    
    -- Main Container
    self.container = Instance.new("Frame")
    self.container.Name = "Container"
    self.container.AnchorPoint = Vector2.new(0.5, 0.5)
    self.container.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.container.Size = UDim2.new(0, 640 * self.scale, 0, 355 * self.scale)
    self.container.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
    self.container.BackgroundTransparency = 0.1
    self.container.BorderSizePixel = 0
    self.container.Active = true
    self.container.Parent = self.gui
    
    -- Corner rounding
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 10)
    containerCorner.Parent = self.container
    
    -- Scale constraint
    local uiScale = Instance.new("UIScale")
    uiScale.Scale = self.scale
    uiScale.Parent = self.container
    
    -- Create sections
    self:_createHeader()
    self:_createTabSection()
    self:_createContentSections()
    
    -- Mobile button (if mobile device)
    if self.isMobileMode then
        self:_createMobileButton()
    end
    
    -- Make draggable
    self:_makeDraggable()
end

-- Create header section
function FlowUI:_createHeader()
    self.header = Instance.new("Frame")
    self.header.Name = "Header"
    self.header.Position = UDim2.new(0.0125, 0, 0.0225, 0)
    self.header.Size = UDim2.new(0, 624, 0, 24)
    self.header.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
    self.header.BackgroundTransparency = 0.5
    self.header.BorderSizePixel = 0
    self.header.Parent = self.container
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 5)
    headerCorner.Parent = self.header
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = self.title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.AnchorPoint = Vector2.new(0, 0.5)
    titleLabel.Position = UDim2.new(0.044, 0, 0.5, 0)
    titleLabel.Size = UDim2.new(0, 78, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = self.header
    
    local titleConstraint = Instance.new("UITextSizeConstraint")
    titleConstraint.MaxTextSize = 12
    titleConstraint.MinTextSize = 12
    titleConstraint.Parent = titleLabel
    
    -- Search bar (placeholder for now)
    self:_createSearchBar()
end

-- Create search bar
function FlowUI:_createSearchBar()
    local searchBar = Instance.new("Frame")
    searchBar.Name = "SearchBar"
    searchBar.AnchorPoint = Vector2.new(1, 0.5)
    searchBar.Position = UDim2.new(0.995, 0, 0.5, 0)
    searchBar.Size = UDim2.new(0, 64, 0, 17)
    searchBar.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    searchBar.BackgroundTransparency = 0.5
    searchBar.BorderSizePixel = 0
    searchBar.Parent = self.header
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 4)
    searchCorner.Parent = searchBar
    
    local searchInput = Instance.new("TextBox")
    searchInput.Name = "Input"
    searchInput.PlaceholderText = "Search"
    searchInput.Text = ""
    searchInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchInput.TextTransparency = 0.5
    searchInput.TextSize = 10
    searchInput.TextXAlignment = Enum.TextXAlignment.Left
    searchInput.Font = Enum.Font.Gotham
    searchInput.Position = UDim2.new(0, 9, 0, 0)
    searchInput.Size = UDim2.new(0, 39, 1, 0)
    searchInput.BackgroundTransparency = 1
    searchInput.BorderSizePixel = 0
    searchInput.ClearTextOnFocus = false
    searchInput.Parent = searchBar
end

-- Create tab section
function FlowUI:_createTabSection()
    self.tabContainer = Instance.new("ScrollingFrame")
    self.tabContainer.Name = "Tabs"
    self.tabContainer.Position = UDim2.new(0.0125, 0, 0.11, 0)
    self.tabContainer.Size = UDim2.new(0, 138, 0, 308)
    self.tabContainer.BackgroundTransparency = 1
    self.tabContainer.BorderSizePixel = 0
    self.tabContainer.ScrollBarThickness = 0
    self.tabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.tabContainer.Parent = self.container
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = self.tabContainer
end

-- Create content sections
function FlowUI:_createContentSections()
    self.sectionsFolder = Instance.new("Folder")
    self.sectionsFolder.Name = "Sections"
    self.sectionsFolder.Parent = self.container
    
    -- Left section
    self.leftSection = Instance.new("ScrollingFrame")
    self.leftSection.Name = "LeftSection"
    self.leftSection.Position = UDim2.new(0.24, 0, 0.11, 0)
    self.leftSection.Size = UDim2.new(0, 237, 0, 306)
    self.leftSection.BackgroundTransparency = 1
    self.leftSection.BorderSizePixel = 0
    self.leftSection.ScrollBarThickness = 0
    self.leftSection.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.leftSection.Parent = self.sectionsFolder
    
    local leftLayout = Instance.new("UIListLayout")
    leftLayout.Padding = UDim.new(0, 6)
    leftLayout.Parent = self.leftSection
    
    -- Right section
    self.rightSection = Instance.new("ScrollingFrame")
    self.rightSection.Name = "RightSection"
    self.rightSection.Position = UDim2.new(0.62, 0, 0.11, 0)
    self.rightSection.Size = UDim2.new(0, 237, 0, 306)
    self.rightSection.BackgroundTransparency = 1
    self.rightSection.BorderSizePixel = 0
    self.rightSection.ScrollBarThickness = 0
    self.rightSection.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.rightSection.Parent = self.sectionsFolder
    
    local rightLayout = Instance.new("UIListLayout")
    rightLayout.Padding = UDim.new(0, 6)
    rightLayout.Parent = self.rightSection
end

-- Create mobile toggle button
function FlowUI:_createMobileButton()
    self.mobileButton = Instance.new("TextButton")
    self.mobileButton.Name = "MobileToggle"
    self.mobileButton.Text = ""
    self.mobileButton.AnchorPoint = Vector2.new(0.5, 0)
    self.mobileButton.Position = UDim2.new(0.5, 0, 0.9, 0)
    self.mobileButton.Size = UDim2.new(0.036, 0, 0.044, 0)
    self.mobileButton.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
    self.mobileButton.BackgroundTransparency = 0.1
    self.mobileButton.BorderSizePixel = 0
    self.mobileButton.AutoButtonColor = false
    self.mobileButton.Parent = self.gui
    
    local mobileCorner = Instance.new("UICorner")
    mobileCorner.CornerRadius = UDim.new(0, 10)
    mobileCorner.Parent = self.mobileButton
    
    -- Mobile icon (placeholder)
    local mobileIcon = Instance.new("ImageLabel")
    mobileIcon.Name = "Icon"
    mobileIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    mobileIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    mobileIcon.Size = UDim2.new(0.26, 0, 0.5, 0)
    mobileIcon.BackgroundTransparency = 1
    mobileIcon.Image = "rbxassetid://6031094678" -- Menu icon
    mobileIcon.ImageTransparency = 0.4
    mobileIcon.Parent = self.mobileButton
end

-- Setup mobile toggle functionality
function FlowUI:_setupMobileToggle()
    if not self.mobileButton then return end
    
    self.mobileButton.Activated:Connect(function()
        self:toggleVisibility()
    end)
end

-- Make GUI draggable
function FlowUI:_makeDraggable()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.container.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self.container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Public API Methods

-- Create a new tab
function FlowUI:CreateTab(config)
    config = config or {}
    local tabName = config.Name or "Tab"
    local tabIcon = config.Icon or "rbxassetid://6031094678"
    
    local tab = {
        name = tabName,
        icon = tabIcon,
        modules = {},
        button = nil,
        leftContent = {},
        rightContent = {}
    }
    
    -- Create tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName
    tabButton.Text = ""
    tabButton.Size = UDim2.new(0, 138, 0, 27)
    tabButton.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
    tabButton.BackgroundTransparency = 0.5
    tabButton.BorderSizePixel = 0
    tabButton.AutoButtonColor = false
    tabButton.LayoutOrder = #self.tabs + 1
    tabButton.Parent = self.tabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 5)
    tabCorner.Parent = tabButton
    
    -- Tab icon
    local iconLabel = Instance.new("ImageLabel")
    iconLabel.Name = "Icon"
    iconLabel.Image = tabIcon
    iconLabel.AnchorPoint = Vector2.new(0, 0.5)
    iconLabel.Position = UDim2.new(0.1, 0, 0.5, 0)
    iconLabel.Size = UDim2.new(0, 12, 0, 12)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Parent = tabButton
    
    -- Tab title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = tabName
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.Gotham
    titleLabel.AnchorPoint = Vector2.new(0, 0.5)
    titleLabel.Position = UDim2.new(0.225, 0, 0.5, 0)
    titleLabel.Size = UDim2.new(0, 75, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = tabButton
    
    local titleConstraint = Instance.new("UITextSizeConstraint")
    titleConstraint.MaxTextSize = 12
    titleConstraint.MinTextSize = 12
    titleConstraint.Parent = titleLabel
    
    tab.button = tabButton
    
    -- Tab click functionality
    tabButton.Activated:Connect(function()
        self:switchToTab(tab)
    end)
    
    -- Add to tabs list
    table.insert(self.tabs, tab)
    
    -- If this is the first tab, make it active
    if #self.tabs == 1 then
        self:switchToTab(tab)
    end
    
    return self:createTabInterface(tab)
end

-- Create tab interface
function FlowUI:createTabInterface(tab)
    local interface = {}
    
    function interface:CreateModule(config)
        return FlowUI:CreateModule(tab, config)
    end
    
    return interface
end

-- Create a module within a tab
function FlowUI:CreateModule(tab, config)
    config = config or {}
    local moduleName = config.Name or "Module"
    local section = config.Section or "left" -- "left" or "right"
    
    local targetSection = section == "left" and self.leftSection or self.rightSection
    
    -- Create module container
    local moduleFrame = Instance.new("Frame")
    moduleFrame.Name = moduleName
    moduleFrame.Size = UDim2.new(0, 237, 0, 28) -- Initial height, will expand with settings
    moduleFrame.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
    moduleFrame.BackgroundTransparency = 0.5
    moduleFrame.BorderSizePixel = 0
    moduleFrame.ClipsDescendants = true
    moduleFrame.Parent = targetSection
    
    local moduleCorner = Instance.new("UICorner")
    moduleCorner.CornerRadius = UDim.new(0, 5)
    moduleCorner.Parent = moduleFrame
    
    -- Module header
    local headerButton = Instance.new("ImageButton")
    headerButton.Name = "Header"
    headerButton.Size = UDim2.new(1, 0, 0, 28)
    headerButton.BackgroundTransparency = 1
    headerButton.Image = "rbxassetid://6031094678" -- Placeholder
    headerButton.ImageTransparency = 0.5
    headerButton.Parent = moduleFrame
    
    -- Module title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = moduleName
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTransparency = 0.5
    titleLabel.Font = Enum.Font.Gotham
    titleLabel.AnchorPoint = Vector2.new(0, 0.5)
    titleLabel.Position = UDim2.new(0.15, 0, 0.5, 0)
    titleLabel.Size = UDim2.new(0, 156, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = headerButton
    
    local titleConstraint = Instance.new("UITextSizeConstraint")
    titleConstraint.MaxTextSize = 12
    titleConstraint.MinTextSize = 12
    titleConstraint.Parent = titleLabel
    
    -- Expand arrow
    local arrow = Instance.new("ImageLabel")
    arrow.Name = "Arrow"
    arrow.Image = "rbxassetid://6031094678" -- Arrow icon
    arrow.ImageTransparency = 0.5
    arrow.Position = UDim2.new(0.9, 0, 0.29, 0)
    arrow.Size = UDim2.new(0, 11, 0, 11)
    arrow.BackgroundTransparency = 1
    arrow.Rotation = -90
    arrow.Parent = headerButton
    
    -- Settings container
    local settingsFrame = Instance.new("Frame")
    settingsFrame.Name = "Settings"
    settingsFrame.AnchorPoint = Vector2.new(0, 1)
    settingsFrame.Position = UDim2.new(0, 0, 1, 0)
    settingsFrame.Size = UDim2.new(1, 0, 0, 0) -- Will expand as settings are added
    settingsFrame.BackgroundTransparency = 1
    settingsFrame.Parent = moduleFrame
    
    local settingsLayout = Instance.new("UIListLayout")
    settingsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    settingsLayout.Parent = settingsFrame
    
    -- Module state
    local module = {
        name = moduleName,
        frame = moduleFrame,
        settingsFrame = settingsFrame,
        settingsLayout = settingsLayout,
        expanded = false,
        settings = {},
        keybind = config.Keybind,
        enabled = false
    }
    
    -- Toggle functionality
    headerButton.Activated:Connect(function()
        module.expanded = not module.expanded
        self:updateModuleSize(module)
        
        local arrowRotation = module.expanded and 0 or -90
        createTween(arrow, {Rotation = arrowRotation}):Play()
    end)
    
    -- Add keybind if specified
    if config.Keybind then
        self:addKeybind(module, config.Keybind)
    end
    
    -- Store module
    table.insert(tab.modules, module)
    
    return self:createModuleInterface(module)
end

-- Create module interface
function FlowUI:createModuleInterface(module)
    local interface = {}
    
    function interface:CreateSlider(config)
        return FlowUI:CreateSlider(module, config)
    end
    
    function interface:CreateDropdown(config)
        return FlowUI:CreateDropdown(module, config)
    end
    
    function interface:CreateToggle(config)
        return FlowUI:CreateToggle(module, config)
    end
    
    function interface:SetKeybind(key)
        FlowUI:addKeybind(module, key)
    end
    
    return interface
end

-- Create slider
function FlowUI:CreateSlider(module, config)
    config = config or {}
    local name = config.Name or "Slider"
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or min
    local callback = config.Callback or function() end
    
    -- Create slider container
    local sliderContainer = Instance.new("TextButton")
    sliderContainer.Name = name
    sliderContainer.Size = UDim2.new(0, 216, 0, 27)
    sliderContainer.BackgroundTransparency = 1
    sliderContainer.Text = ""
    sliderContainer.AutoButtonColor = false
    sliderContainer.LayoutOrder = #module.settings + 1
    sliderContainer.Parent = module.settingsFrame
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = name
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTransparency = 0.5
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.AnchorPoint = Vector2.new(0, 0.5)
    titleLabel.Position = UDim2.new(0, 0, 0.4, 0)
    titleLabel.Size = UDim2.new(0, 172, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = sliderContainer
    
    -- Value label
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.TextScaled = true
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.TextTransparency = 0.5
    valueLabel.Font = Enum.Font.GothamMedium
    valueLabel.AnchorPoint = Vector2.new(1, 0.5)
    valueLabel.Position = UDim2.new(1, 0, 0.4, 0)
    valueLabel.Size = UDim2.new(0, 42, 0, 12)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Parent = sliderContainer
    
    -- Slider track
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.AnchorPoint = Vector2.new(0.5, 1)
    track.Position = UDim2.new(0.5, 0, 0.8, 0)
    track.Size = UDim2.new(0, 217, 0, 4)
    track.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
    track.BackgroundTransparency = 0.5
    track.BorderSizePixel = 0
    track.Parent = sliderContainer
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.Parent = track
    
    -- Slider fill
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.AnchorPoint = Vector2.new(0, 0.5)
    fill.Position = UDim2.new(0, 0, 0.5, 0)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fill.BackgroundTransparency = 0.5
    fill.BorderSizePixel = 0
    fill.Parent = track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.Parent = fill
    
    -- Slider handle
    local handle = Instance.new("Frame")
    handle.Name = "Handle"
    handle.AnchorPoint = Vector2.new(1, 0.5)
    handle.Position = UDim2.new(1, 0, 0.5, 0)
    handle.Size = UDim2.new(0, 6, 0, 6)
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.BorderSizePixel = 0
    handle.Parent = fill
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(1, 0)
    handleCorner.Parent = handle
    
    -- Slider functionality
    local dragging = false
    local currentValue = default
    
    local function updateSlider(input)
        local trackPos = track.AbsolutePosition.X
        local trackSize = track.AbsoluteSize.X
        local mousePos = input.Position.X
        
        local relative = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
        currentValue = math.floor(min + (max - min) * relative)
        
        valueLabel.Text = tostring(currentValue)
        fill.Size = UDim2.new(relative, 0, 1, 0)
        
        callback(currentValue)
    end
    
    sliderContainer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    -- Store setting
    local setting = {
        name = name,
        type = "slider",
        element = sliderContainer,
        getValue = function() return currentValue end,
        setValue = function(value)
            currentValue = math.clamp(value, min, max)
            valueLabel.Text = tostring(currentValue)
            fill.Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)
            callback(currentValue)
        end
    }
    
    table.insert(module.settings, setting)
    self:updateModuleSize(module)
    
    return setting
end

-- Create dropdown
function FlowUI:CreateDropdown(module, config)
    config = config or {}
    local name = config.Name or "Dropdown"
    local options = config.Options or {"Option 1", "Option 2"}
    local default = config.Default or options[1]
    local callback = config.Callback or function() end
    
    -- Create dropdown container
    local dropdownContainer = Instance.new("TextButton")
    dropdownContainer.Name = name
    dropdownContainer.Size = UDim2.new(0, 216, 0, 42) -- Base height
    dropdownContainer.BackgroundTransparency = 1
    dropdownContainer.Text = ""
    dropdownContainer.AutoButtonColor = false
    dropdownContainer.LayoutOrder = #module.settings + 1
    dropdownContainer.Parent = module.settingsFrame
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = name
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTransparency = 0.5
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.Size = UDim2.new(1, -5, 0, 12)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = dropdownContainer
    
    local titleConstraint = Instance.new("UITextSizeConstraint")
    titleConstraint.MaxTextSize = 12
    titleConstraint.MinTextSize = 12
    titleConstraint.Parent = titleLabel
    
    -- Dropdown box
    local dropdownBox = Instance.new("Frame")
    dropdownBox.Name = "Box"
    dropdownBox.AnchorPoint = Vector2.new(0.5, 0)
    dropdownBox.Position = UDim2.new(0.5, 0, 0, 15)
    dropdownBox.Size = UDim2.new(0, 218, 0, 18)
    dropdownBox.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
    dropdownBox.BackgroundTransparency = 0.5
    dropdownBox.BorderSizePixel = 0
    dropdownBox.Parent = dropdownContainer
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 5)
    boxCorner.Parent = dropdownBox
    
    -- Dropdown header (clickable area)
    local dropdownHeader = Instance.new("ImageButton")
    dropdownHeader.Name = "Header"
    dropdownHeader.Size = UDim2.new(1, 0, 1, 0)
    dropdownHeader.BackgroundTransparency = 1
    dropdownHeader.Image = ""
    dropdownHeader.Parent = dropdownBox
    
    -- Current selection display
    local selectionLabel = Instance.new("TextLabel")
    selectionLabel.Name = "Selection"
    selectionLabel.Text = default
    selectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    selectionLabel.TextSize = 12
    selectionLabel.TextTransparency = 0.5
    selectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectionLabel.Font = Enum.Font.GothamMedium
    selectionLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    selectionLabel.Position = UDim2.new(0.5, -5, 0.5, 0)
    selectionLabel.Size = UDim2.new(1, -30, 1, 0)
    selectionLabel.BackgroundTransparency = 1
    selectionLabel.Parent = dropdownHeader
    
    -- Dropdown arrow
    local arrow = Instance.new("ImageLabel")
    arrow.Name = "Arrow"
    arrow.Image = "rbxassetid://6031094678" -- Arrow icon
    arrow.ImageTransparency = 0.5
    arrow.Position = UDim2.new(0.93, 0, 0.25, 0)
    arrow.Size = UDim2.new(0, 10, 0, 10)
    arrow.BackgroundTransparency = 1
    arrow.Rotation = -90
    arrow.Parent = dropdownHeader
    
    -- Options container
    local optionsContainer = Instance.new("Frame")
    optionsContainer.Name = "Options"
    optionsContainer.AnchorPoint = Vector2.new(0.5, 0)
    optionsContainer.Position = UDim2.new(0.5, 0, 1, 2)
    optionsContainer.Size = UDim2.new(1, 0, 0, 0) -- Will expand when opened
    optionsContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    optionsContainer.BackgroundTransparency = 1
    optionsContainer.BorderSizePixel = 0
    optionsContainer.ClipsDescendants = true
    optionsContainer.Parent = dropdownBox
    
    -- Options list
    local optionsList = Instance.new("ScrollingFrame")
    optionsList.Name = "List"
    optionsList.Size = UDim2.new(1, 0, 1, 0)
    optionsList.BackgroundTransparency = 1
    optionsList.BorderSizePixel = 0
    optionsList.ScrollBarThickness = 0
    optionsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    optionsList.Parent = optionsContainer
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    optionsLayout.Parent = optionsList
    
    -- Create option buttons
    local optionButtons = {}
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option" .. i
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionButton.TextSize = 12
        optionButton.TextTransparency = option == default and 0.5 or 0.8
        optionButton.TextXAlignment = Enum.TextXAlignment.Left
        optionButton.Font = Enum.Font.GothamMedium
        optionButton.Size = UDim2.new(0, 205, 0, 17)
        optionButton.BackgroundTransparency = 1
        optionButton.BorderSizePixel = 0
        optionButton.Parent = optionsList
        
        -- Gradient for fade effect
        local gradient = Instance.new("UIGradient")
        gradient.Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.758, 0),
            NumberSequenceKeypoint.new(0.93, 0.269),
            NumberSequenceKeypoint.new(1, 1)
        }
        gradient.Parent = optionButton
        
        optionButtons[option] = optionButton
        
        -- Option click handler
        optionButton.Activated:Connect(function()
            -- Update selection
            selectionLabel.Text = option
            
            -- Update visual states
            for opt, btn in pairs(optionButtons) do
                btn.TextTransparency = opt == option and 0.5 or 0.8
            end
            
            -- Close dropdown
            self:toggleDropdown(dropdownContainer, false)
            
            -- Fire callback
            callback(option)
        end)
    end
    
    -- Dropdown state
    local isOpen = false
    local currentValue = default
    
    -- Toggle dropdown function
    function self:toggleDropdown(container, forceState)
        if forceState ~= nil then
            isOpen = forceState
        else
            isOpen = not isOpen
        end
        
        local targetHeight = isOpen and math.min(#options * 17, 85) or 0
        local targetRotation = isOpen and 0 or -90
        local targetTransparency = isOpen and 0.5 or 1
        
        -- Animate dropdown
        createTween(optionsContainer, {
            Size = UDim2.new(1, 0, 0, targetHeight),
            BackgroundTransparency = targetTransparency
        }):Play()
        
        createTween(arrow, {Rotation = targetRotation}):Play()
        
        -- Update container height
        local newHeight = isOpen and 42 + targetHeight or 42
        createTween(container, {Size = UDim2.new(0, 216, 0, newHeight)}):Play()
        
        -- Update module size
        wait(0.1)
        self:updateModuleSize(module)
    end
    
    -- Header click handler
    dropdownHeader.Activated:Connect(function()
        self:toggleDropdown(dropdownContainer)
    end)
    
    -- Store setting
    local setting = {
        name = name,
        type = "dropdown",
        element = dropdownContainer,
        getValue = function() return currentValue end,
        setValue = function(value)
            if table.find(options, value) then
                currentValue = value
                selectionLabel.Text = value
                for opt, btn in pairs(optionButtons) do
                    btn.TextTransparency = opt == value and 0.5 or 0.8
                end
                callback(value)
            end
        end
    }
    
    table.insert(module.settings, setting)
    self:updateModuleSize(module)
    
    return setting
end

-- Create toggle/checkbox
function FlowUI:CreateToggle(module, config)
    config = config or {}
    local name = config.Name or "Toggle"
    local default = config.Default or false
    local callback = config.Callback or function() end
    
    -- Create toggle container
    local toggleContainer = Instance.new("TextButton")
    toggleContainer.Name = name
    toggleContainer.Size = UDim2.new(0, 216, 0, 20)
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Text = ""
    toggleContainer.AutoButtonColor = false
    toggleContainer.LayoutOrder = #module.settings + 1
    toggleContainer.Parent = module.settingsFrame
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = name
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTransparency = 0.5
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.AnchorPoint = Vector2.new(0, 0.5)
    titleLabel.Position = UDim2.new(0.1, 0, 0.5, 0)
    titleLabel.Size = UDim2.new(0, 150, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = toggleContainer
    
    local titleConstraint = Instance.new("UITextSizeConstraint")
    titleConstraint.MaxTextSize = 12
    titleConstraint.MinTextSize = 12
    titleConstraint.Parent = titleLabel
    
    -- Toggle switch background
    local switchBG = Instance.new("Frame")
    switchBG.Name = "Switch"
    switchBG.AnchorPoint = Vector2.new(1, 0.5)
    switchBG.Position = UDim2.new(0.95, 0, 0.5, 0)
    switchBG.Size = UDim2.new(0, 24, 0, 12)
    switchBG.BackgroundColor3 = default and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(60, 60, 60)
    switchBG.BackgroundTransparency = 0.3
    switchBG.BorderSizePixel = 0
    switchBG.Parent = toggleContainer
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switchBG
    
    -- Toggle switch handle
    local switchHandle = Instance.new("Frame")
    switchHandle.Name = "Handle"
    switchHandle.AnchorPoint = Vector2.new(0.5, 0.5)
    switchHandle.Position = default and UDim2.new(0.75, 0, 0.5, 0) or UDim2.new(0.25, 0, 0.5, 0)
    switchHandle.Size = UDim2.new(0, 8, 0, 8)
    switchHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchHandle.BorderSizePixel = 0
    switchHandle.Parent = switchBG
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(1, 0)
    handleCorner.Parent = switchHandle
    
    -- Toggle state
    local currentValue = default
    
    -- Toggle functionality
    toggleContainer.Activated:Connect(function()
        currentValue = not currentValue
        
        -- Animate switch
        local targetPos = currentValue and UDim2.new(0.75, 0, 0.5, 0) or UDim2.new(0.25, 0, 0.5, 0)
        local targetColor = currentValue and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(60, 60, 60)
        
        createTween(switchHandle, {Position = targetPos}):Play()
        createTween(switchBG, {BackgroundColor3 = targetColor}):Play()
        
        callback(currentValue)
    end)
    
    -- Store setting
    local setting = {
        name = name,
        type = "toggle",
        element = toggleContainer,
        getValue = function() return currentValue end,
        setValue = function(value)
            currentValue = value
            local targetPos = currentValue and UDim2.new(0.75, 0, 0.5, 0) or UDim2.new(0.25, 0, 0.5, 0)
            local targetColor = currentValue and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(60, 60, 60)
            switchHandle.Position = targetPos
            switchBG.BackgroundColor3 = targetColor
            callback(currentValue)
        end
    }
    
    table.insert(module.settings, setting)
    self:updateModuleSize(module)
    
    return setting
end

-- Add keybind to module
function FlowUI:addKeybind(module, key)
    -- Create keybind display
    local keybindContainer = Instance.new("TextButton")
    keybindContainer.Name = "Keybind"
    keybindContainer.Text = ""
    keybindContainer.AnchorPoint = Vector2.new(0, 0.5)
    keybindContainer.Position = UDim2.new(0, 0, 0.5, 0)
    keybindContainer.Size = UDim2.new(0, 33, 0, 28)
    keybindContainer.BackgroundTransparency = 1
    keybindContainer.AutoButtonColor = false
    keybindContainer.Parent = module.frame:FindFirstChild("Header")
    
    local keybindBG = Instance.new("Frame")
    keybindBG.Name = "Background"
    keybindBG.AnchorPoint = Vector2.new(0.5, 0.5)
    keybindBG.Position = UDim2.new(0.5, 0, 0.5, 0)
    keybindBG.Size = UDim2.new(0, 20, 0, 20)
    keybindBG.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
    keybindBG.BackgroundTransparency = 0.5
    keybindBG.BorderSizePixel = 0
    keybindBG.Parent = keybindContainer
    
    local keybindCorner = Instance.new("UICorner")
    keybindCorner.CornerRadius = UDim.new(0, 4)
    keybindCorner.Parent = keybindBG
    
    local keybindLabel = Instance.new("TextLabel")
    keybindLabel.Name = "KeyLabel"
    keybindLabel.Text = key:upper()
    keybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    keybindLabel.TextSize = 10
    keybindLabel.TextTransparency = 0.5
    keybindLabel.Font = Enum.Font.Gotham
    keybindLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    keybindLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    keybindLabel.Size = UDim2.new(1, -2, 1, -2)
    keybindLabel.BackgroundTransparency = 1
    keybindLabel.Parent = keybindBG
    
    -- Keybind functionality
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode.Name:upper() == key:upper() then
            module.enabled = not module.enabled
            -- You can add visual feedback here for module enabled/disabled state
            
            -- Animate keybind press
            createTween(keybindBG, {BackgroundTransparency = 0.2}, 0.1):Play()
            wait(0.1)
            createTween(keybindBG, {BackgroundTransparency = 0.5}, 0.1):Play()
        end
    end)
    
    module.keybind = key
end

-- Update module size based on settings
function FlowUI:updateModuleSize(module)
    local settingsHeight = 0
    
    if module.expanded then
        for _, setting in pairs(module.settings) do
            settingsHeight = settingsHeight + setting.element.Size.Y.Offset + 3 -- Small padding
        end
    end
    
    local totalHeight = 28 + settingsHeight -- Header height + settings height
    
    createTween(module.frame, {
        Size = UDim2.new(0, 237, 0, totalHeight)
    }):Play()
    
    createTween(module.settingsFrame, {
        Size = UDim2.new(1, 0, 0, settingsHeight)
    }):Play()
end

-- Switch to tab
function FlowUI:switchToTab(tab)
    if self.currentTab == tab then return end
    
    -- Update tab buttons
    for _, existingTab in pairs(self.tabs) do
        if existingTab.button then
            createTween(existingTab.button, {BackgroundTransparency = 0.5}):Play()
        end
    end
    
    -- Highlight current tab
    createTween(tab.button, {BackgroundTransparency = 0.3}):Play()
    
    -- Clear current content
    for _, child in pairs(self.leftSection:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    for _, child in pairs(self.rightSection:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Show tab modules
    for _, module in pairs(tab.modules) do
        module.frame.Parent = self.leftSection -- Default to left, can be improved
    end
    
    self.currentTab = tab
end

-- Toggle GUI visibility
function FlowUI:toggleVisibility()
    self.isVisible = not self.isVisible
    
    local targetTransparency = self.isVisible and 0 or 1
    local targetPosition = self.isVisible and 
        UDim2.new(0.5, 0, 0.5, 0) or 
        UDim2.new(0.5, 0, -1, 0)
    
    createTween(self.container, {
        Position = targetPosition,
        BackgroundTransparency = targetTransparency
    }, 0.4, Enum.EasingStyle.Back):Play()
    
    -- Fade all children
    for _, child in pairs(self.container:GetDescendants()) do
        if child:IsA("GuiObject") and child ~= self.container then
            local currentTrans = child.BackgroundTransparency
            local targetTrans = self.isVisible and currentTrans or 1
            
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                createTween(child, {TextTransparency = targetTrans}):Play()
            end
            
            if child:IsA("ImageLabel") or child:IsA("ImageButton") then
                createTween(child, {ImageTransparency = targetTrans}):Play()
            end
            
            createTween(child, {BackgroundTransparency = targetTrans}):Play()
        end
    end
end

-- Destroy the GUI
function FlowUI:Destroy()
    if self.gui then
        self.gui:Destroy()
    end
end

-- Get setting value by name
function FlowUI:GetSetting(tabName, moduleName, settingName)
    for _, tab in pairs(self.tabs) do
        if tab.name == tabName then
            for _, module in pairs(tab.modules) do
                if module.name == moduleName then
                    for _, setting in pairs(module.settings) do
                        if setting.name == settingName then
                            return setting.getValue()
                        end
                    end
                end
            end
        end
    end
    return nil
end

-- Set setting value by name
function FlowUI:SetSetting(tabName, moduleName, settingName, value)
    for _, tab in pairs(self.tabs) do
        if tab.name == tabName then
            for _, module in pairs(tab.modules) do
                if module.name == moduleName then
                    for _, setting in pairs(module.settings) do
                        if setting.name == settingName then
                            setting.setValue(value)
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

return FlowUI