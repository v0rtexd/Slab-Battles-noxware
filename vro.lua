-- Astral UI Library
-- A modern, dark-themed UI library for Roblox

local AstralUI = {}
AstralUI.__index = AstralUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Constants
local TWEEN_INFO = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Utility Functions
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 5)
    corner.Parent = parent
    return corner
end

local function createTextSizeConstraint(parent, maxSize, minSize)
    local constraint = Instance.new("UITextSizeConstraint")
    constraint.MaxTextSize = maxSize or 12
    constraint.MinTextSize = minSize or maxSize or 12
    constraint.Parent = parent
    return constraint
end

local function createPadding(parent, padding)
    local uiPadding = Instance.new("UIPadding")
    if typeof(padding) == "number" then
        uiPadding.PaddingTop = UDim.new(0, padding)
        uiPadding.PaddingBottom = UDim.new(0, padding)
        uiPadding.PaddingLeft = UDim.new(0, padding)
        uiPadding.PaddingRight = UDim.new(0, padding)
    elseif typeof(padding) == "table" then
        uiPadding.PaddingTop = UDim.new(0, padding.Top or 0)
        uiPadding.PaddingBottom = UDim.new(0, padding.Bottom or 0)
        uiPadding.PaddingLeft = UDim.new(0, padding.Left or 0)
        uiPadding.PaddingRight = UDim.new(0, padding.Right or 0)
    end
    uiPadding.Parent = parent
    return uiPadding
end

-- Main Library Constructor
function AstralUI.new(title)
    local self = setmetatable({}, AstralUI)
    
    self.title = title or "Astral"
    self.tabs = {}
    self.currentTab = nil
    self.callbacks = {}
    
    self:_createMainFrame()
    
    return self
end

function AstralUI:_createMainFrame()
    -- Main ScreenGui
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "AstralUI"
    self.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.screenGui.Parent = game:GetService("CoreGui")
    
    -- Container Frame
    self.container = Instance.new("Frame")
    self.container.Name = "Container"
    self.container.AnchorPoint = Vector2.new(0.5, 0.5)
    self.container.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
    self.container.BackgroundTransparency = 0.1
    self.container.BorderSizePixel = 0
    self.container.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.container.Size = UDim2.new(0, 640, 0, 355)
    self.container.Active = true
    self.container.Parent = self.screenGui
    
    createCorner(self.container, 10)
    
    -- Make draggable
    self:_makeDraggable()
    
    -- Header
    self:_createHeader()
    
    -- Tabs Section
    self:_createTabsSection()
    
    -- Content Sections
    self:_createContentSections()
    
    -- Mobile Toggle Button
    self:_createMobileToggle()
end

function AstralUI:_makeDraggable()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.container.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.container.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function AstralUI:_createHeader()
    self.header = Instance.new("Frame")
    self.header.Name = "Header"
    self.header.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
    self.header.BackgroundTransparency = 0.5
    self.header.BorderSizePixel = 0
    self.header.Position = UDim2.new(0.0125, 0, 0.0225, 0)
    self.header.Size = UDim2.new(0, 624, 0, 24)
    self.header.Parent = self.container
    
    createCorner(self.header, 5)
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = self.title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.AnchorPoint = Vector2.new(0, 0.5)
    titleLabel.Position = UDim2.new(0.044, 0, 0.5, 0)
    titleLabel.Size = UDim2.new(0, 78, 0, 12)
    titleLabel.Parent = self.header
    
    createTextSizeConstraint(titleLabel, 12)
    
    -- Search Bar
    self:_createSearchBar()
end

function AstralUI:_createSearchBar()
    local searchBar = Instance.new("Frame")
    searchBar.Name = "SearchBar"
    searchBar.AnchorPoint = Vector2.new(1, 0.5)
    searchBar.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    searchBar.BackgroundTransparency = 0.5
    searchBar.BorderSizePixel = 0
    searchBar.Position = UDim2.new(0.995, 0, 0.5, 0)
    searchBar.Size = UDim2.new(0, 64, 0, 17)
    searchBar.Parent = self.header
    
    createCorner(searchBar, 4)
    createPadding(searchBar, {Left = 9})
    
    local input = Instance.new("TextBox")
    input.Name = "Input"
    input.ClearTextOnFocus = false
    input.Font = Enum.Font.Gotham
    input.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
    input.PlaceholderText = "Search"
    input.Text = ""
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.TextSize = 10
    input.TextTransparency = 0.5
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.BackgroundTransparency = 1
    input.AnchorPoint = Vector2.new(0, 0.5)
    input.Position = UDim2.new(0, 0, 0.5, 0)
    input.Size = UDim2.new(0, 39, 0, 14)
    input.Parent = searchBar
    
    createTextSizeConstraint(input, 10)
end

function AstralUI:_createTabsSection()
    self.tabsFrame = Instance.new("ScrollingFrame")
    self.tabsFrame.Name = "Tabs"
    self.tabsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.tabsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.tabsFrame.ScrollBarImageTransparency = 1
    self.tabsFrame.ScrollBarThickness = 0
    self.tabsFrame.BackgroundTransparency = 1
    self.tabsFrame.BorderSizePixel = 0
    self.tabsFrame.Position = UDim2.new(0.0125, 0, 0.11, 0)
    self.tabsFrame.Size = UDim2.new(0, 138, 0, 308)
    self.tabsFrame.Parent = self.container
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 6)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = self.tabsFrame
end

function AstralUI:_createContentSections()
    self.sectionsFolder = Instance.new("Folder")
    self.sectionsFolder.Name = "Sections"
    self.sectionsFolder.Parent = self.container
    
    -- Left Section
    self.leftSection = Instance.new("ScrollingFrame")
    self.leftSection.Name = "LeftSection"
    self.leftSection.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.leftSection.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.leftSection.ScrollBarImageTransparency = 1
    self.leftSection.ScrollBarThickness = 0
    self.leftSection.BackgroundTransparency = 1
    self.leftSection.BorderSizePixel = 0
    self.leftSection.Position = UDim2.new(0.24, 0, 0.11, 0)
    self.leftSection.Size = UDim2.new(0, 237, 0, 306)
    self.leftSection.Parent = self.sectionsFolder
    
    local leftLayout = Instance.new("UIListLayout")
    leftLayout.Padding = UDim.new(0, 6)
    leftLayout.Parent = self.leftSection
    
    -- Right Section
    self.rightSection = Instance.new("ScrollingFrame")
    self.rightSection.Name = "RightSection"
    self.rightSection.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.rightSection.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.rightSection.ScrollBarImageTransparency = 1
    self.rightSection.ScrollBarThickness = 0
    self.rightSection.BackgroundTransparency = 1
    self.rightSection.BorderSizePixel = 0
    self.rightSection.Position = UDim2.new(0.62, 0, 0.11, 0)
    self.rightSection.Size = UDim2.new(0, 237, 0, 306)
    self.rightSection.Parent = self.sectionsFolder
    
    local rightLayout = Instance.new("UIListLayout")
    rightLayout.Padding = UDim.new(0, 6)
    rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rightLayout.Parent = self.rightSection
end

function AstralUI:_createMobileToggle()
    self.mobileButton = Instance.new("TextButton")
    self.mobileButton.Name = "MobileToggle"
    self.mobileButton.Font = Enum.Font.SourceSans
    self.mobileButton.Text = ""
    self.mobileButton.AutoButtonColor = false
    self.mobileButton.AnchorPoint = Vector2.new(0.5, 0)
    self.mobileButton.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
    self.mobileButton.BackgroundTransparency = 0.1
    self.mobileButton.BorderSizePixel = 0
    self.mobileButton.Position = UDim2.new(0.5, 0, 0.903, 0)
    self.mobileButton.Size = UDim2.new(0.036, 0, 0.044, 0)
    self.mobileButton.Parent = self.screenGui
    
    createCorner(self.mobileButton, 10)
    
    self.mobileButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
end

-- Tab Management
function AstralUI:CreateTab(name, icon)
    local tab = {
        name = name,
        icon = icon,
        elements = {},
        frame = nil,
        button = nil,
        visible = false
    }
    
    -- Create tab button
    tab.button = Instance.new("TextButton")
    tab.button.Name = name .. "Tab"
    tab.button.Font = Enum.Font.SourceSans
    tab.button.Text = ""
    tab.button.AutoButtonColor = false
    tab.button.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
    tab.button.BackgroundTransparency = 0.5
    tab.button.BorderSizePixel = 0
    tab.button.Size = UDim2.new(0, 138, 0, 27)
    tab.button.Parent = self.tabsFrame
    
    createCorner(tab.button, 5)
    
    -- Tab title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Font = Enum.Font.Gotham
    title.Text = name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.AnchorPoint = Vector2.new(0, 0.5)
    title.Position = UDim2.new(0.225, 0, 0.5, 0)
    title.Size = UDim2.new(0, 75, 0, 12)
    title.Parent = tab.button
    
    createTextSizeConstraint(title, 12)
    
    -- Tab click handler
    tab.button.MouseButton1Click:Connect(function()
        self:_selectTab(tab)
    end)
    
    -- Create tab content frame
    tab.frame = Instance.new("Frame")
    tab.frame.Name = name .. "Content"
    tab.frame.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
    tab.frame.BackgroundTransparency = 0.5
    tab.frame.BorderSizePixel = 0
    tab.frame.ClipsDescendants = true
    tab.frame.Size = UDim2.new(0, 237, 0, 0)
    tab.frame.Visible = false
    tab.frame.Parent = self.leftSection
    
    createCorner(tab.frame, 5)
    
    -- Content layout
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 3)
    contentLayout.Parent = tab.frame
    
    createPadding(tab.frame, 10)
    
    table.insert(self.tabs, tab)
    
    -- Select first tab automatically
    if #self.tabs == 1 then
        self:_selectTab(tab)
    end
    
    return self:_createTabAPI(tab)
end

function AstralUI:_selectTab(selectedTab)
    -- Hide all tabs
    for _, tab in pairs(self.tabs) do
        tab.frame.Visible = false
        tab.button.BackgroundTransparency = 0.5
        tab.visible = false
    end
    
    -- Show selected tab
    selectedTab.frame.Visible = true
    selectedTab.button.BackgroundTransparency = 0.2
    selectedTab.visible = true
    self.currentTab = selectedTab
    
    self:_updateTabSize(selectedTab)
end

function AstralUI:_updateTabSize(tab)
    local contentSize = 0
    for _, element in pairs(tab.elements) do
        if element.frame and element.frame.Visible then
            contentSize = contentSize + element.frame.AbsoluteSize.Y + 6
        end
    end
    
    tab.frame.Size = UDim2.new(0, 237, 0, math.max(contentSize + 20, 50))
end

function AstralUI:_createTabAPI(tab)
    local tabAPI = {}
    
    function tabAPI:CreateDropdown(name, options, callback)
        local dropdown = self:_createDropdown(tab, name, options, callback)
        table.insert(tab.elements, dropdown)
        self:_updateTabSize(tab)
        return dropdown
    end
    
    function tabAPI:CreateSlider(name, min, max, default, callback)
        local slider = self:_createSlider(tab, name, min, max, default, callback)
        table.insert(tab.elements, slider)
        self:_updateTabSize(tab)
        return slider
    end
    
    function tabAPI:CreateKeybind(name, default, callback)
        local keybind = self:_createKeybind(tab, name, default, callback)
        table.insert(tab.elements, keybind)
        self:_updateTabSize(tab)
        return keybind
    end
    
    function tabAPI:CreateToggle(name, default, callback)
        local toggle = self:_createToggle(tab, name, default, callback)
        table.insert(tab.elements, toggle)
        self:_updateTabSize(tab)
        return toggle
    end
    
    return tabAPI
end

-- UI Elements
function AstralUI:_createDropdown(tab, name, options, callback)
    local dropdown = {
        name = name,
        options = options or {},
        selected = options and options[1] or "None",
        callback = callback,
        open = false
    }
    
    -- Main dropdown frame
    dropdown.frame = Instance.new("Frame")
    dropdown.frame.Name = name .. "Dropdown"
    dropdown.frame.BackgroundTransparency = 1
    dropdown.frame.BorderSizePixel = 0
    dropdown.frame.Size = UDim2.new(0, 216, 0, 45)
    dropdown.frame.Parent = tab.frame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Font = Enum.Font.GothamMedium
    title.Text = name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.TextTransparency = 0.5
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(0, 215, 0, 12)
    title.Parent = dropdown.frame
    
    createTextSizeConstraint(title, 12)
    
    -- Dropdown box
    local box = Instance.new("TextButton")
    box.Name = "Box"
    box.Font = Enum.Font.GothamMedium
    box.Text = dropdown.selected
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 12
    box.TextTransparency = 0.5
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.AutoButtonColor = false
    box.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
    box.BackgroundTransparency = 0.5
    box.BorderSizePixel = 0
    box.AnchorPoint = Vector2.new(0.5, 0)
    box.Position = UDim2.new(0.5, 0, 0.4, 0)
    box.Size = UDim2.new(0, 218, 0, 18)
    box.Parent = dropdown.frame
    
    createCorner(box, 5)
    createPadding(box, {Left = 10})
    
    -- Options container
    local optionsContainer = Instance.new("Frame")
    optionsContainer.Name = "Options"
    optionsContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    optionsContainer.BackgroundTransparency = 0.2
    optionsContainer.BorderSizePixel = 0
    optionsContainer.ClipsDescendants = true
    optionsContainer.AnchorPoint = Vector2.new(0.5, 0)
    optionsContainer.Position = UDim2.new(0.5, 0, 1.1, 0)
    optionsContainer.Size = UDim2.new(0, 218, 0, 0)
    optionsContainer.Visible = false
    optionsContainer.Parent = box
    
    createCorner(optionsContainer, 5)
    
    local optionsList = Instance.new("UIListLayout")
    optionsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    optionsList.Parent = optionsContainer
    
    -- Create option buttons
    for _, option in pairs(dropdown.options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = option
        optionButton.Font = Enum.Font.GothamMedium
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionButton.TextSize = 12
        optionButton.TextTransparency = 0.5
        optionButton.TextXAlignment = Enum.TextXAlignment.Left
        optionButton.BackgroundTransparency = 1
        optionButton.BorderSizePixel = 0
        optionButton.Size = UDim2.new(0, 205, 0, 17)
        optionButton.Parent = optionsContainer
        
        createPadding(optionButton, {Left = 10})
        createTextSizeConstraint(optionButton, 12)
        
        optionButton.MouseButton1Click:Connect(function()
            dropdown.selected = option
            box.Text = option
            dropdown.open = false
            optionsContainer.Visible = false
            
            if callback then
                callback(option)
            end
        end)
    end
    
    -- Toggle dropdown
    box.MouseButton1Click:Connect(function()
        dropdown.open = not dropdown.open
        optionsContainer.Visible = dropdown.open
        
        if dropdown.open then
            optionsContainer.Size = UDim2.new(0, 218, 0, #dropdown.options * 17)
        else
            optionsContainer.Size = UDim2.new(0, 218, 0, 0)
        end
    end)
    
    return dropdown
end

function AstralUI:_createSlider(tab, name, min, max, default, callback)
    local slider = {
        name = name,
        min = min or 0,
        max = max or 100,
        value = default or min or 0,
        callback = callback,
        dragging = false
    }
    
    -- Main slider frame
    slider.frame = Instance.new("Frame")
    slider.frame.Name = name .. "Slider"
    slider.frame.BackgroundTransparency = 1
    slider.frame.BorderSizePixel = 0
    slider.frame.Size = UDim2.new(0, 216, 0, 35)
    slider.frame.Parent = tab.frame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Font = Enum.Font.GothamMedium
    title.Text = name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.TextTransparency = 0.5
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.AnchorPoint = Vector2.new(0, 0.5)
    title.Position = UDim2.new(0, 0, 0.4, 0)
    title.Size = UDim2.new(0, 172, 0, 12)
    title.Parent = slider.frame
    
    createTextSizeConstraint(title, 12)
    
    -- Value label
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Font = Enum.Font.GothamMedium
    valueLabel.Text = tostring(slider.value)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.TextScaled = true
    valueLabel.TextTransparency = 0.5
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.BackgroundTransparency = 1
    valueLabel.AnchorPoint = Vector2.new(1, 0.5)
    valueLabel.Position = UDim2.new(1, 0, 0.4, 0)
    valueLabel.Size = UDim2.new(0, 42, 0, 12)
    valueLabel.Parent = slider.frame
    
    createTextSizeConstraint(valueLabel, 12)
    
    -- Slider track
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
    track.BackgroundTransparency = 0.5
    track.BorderSizePixel = 0
    track.AnchorPoint = Vector2.new(0.5, 1)
    track.Position = UDim2.new(0.5, 0, 0.8, 0)
    track.Size = UDim2.new(0, 217, 0, 4)
    track.Parent = slider.frame
    
    createCorner(track, 2)
    
    -- Slider fill
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fill.BackgroundTransparency = 0.5
    fill.BorderSizePixel = 0
    fill.AnchorPoint = Vector2.new(0, 0.5)
    fill.Position = UDim2.new(0, 0, 0.5, 0)
    fill.Size = UDim2.new((slider.value - slider.min) / (slider.max - slider.min), 0, 0, 4)
    fill.Parent = track
    
    createCorner(fill, 2)
    
    -- Slider handle
    local handle = Instance.new("Frame")
    handle.Name = "Handle"
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.BorderSizePixel = 0
    handle.AnchorPoint = Vector2.new(0.5, 0.5)
    handle.Position = UDim2.new((slider.value - slider.min) / (slider.max - slider.min), 0, 0.5, 0)
    handle.Size = UDim2.new(0, 6, 0, 6)
    handle.Parent = fill
    
    createCorner(handle, 3)
    
    -- Slider functionality
    local function updateSlider(input)
        local trackPosition = track.AbsolutePosition.X
        local trackSize = track.AbsoluteSize.X
        local mouseX = input.Position.X
        
        local percentage = math.clamp((mouseX - trackPosition) / trackSize, 0, 1)
        slider.value = math.floor(slider.min + (slider.max - slider.min) * percentage)
        
        valueLabel.Text = tostring(slider.value)
        fill.Size = UDim2.new(percentage, 0, 0, 4)
        handle.Position = UDim2.new(percentage, 0, 0.5, 0)
        
        if callback then
            callback(slider.value)
        end
    end
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            slider.dragging = true
            updateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if slider.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            slider.dragging = false
        end
    end)
    
    return slider
end

function AstralUI:_createToggle(tab, name, default, callback)
    local toggle = {
        name = name,
        enabled = default or false,
        callback = callback
    }
    
    -- Main toggle frame
    toggle.frame = Instance.new("TextButton")
    toggle.frame.Name = name .. "Toggle"
    toggle.frame.Font = Enum.Font.SourceSans
    toggle.frame.Text = ""
    toggle.frame.AutoButtonColor = false
    toggle.frame.BackgroundTransparency = 1
    toggle.frame.BorderSizePixel = 0
    toggle.frame.Size = UDim2.new(0, 216, 0, 25)
    toggle.frame.Parent = tab.frame
    
    -- Toggle switch
    local switch = Instance.new("Frame")
    switch.Name = "Switch"
    switch.BackgroundColor3 = toggle.enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(48, 48, 48)
    switch.BackgroundTransparency = 0.3
    switch.BorderSizePixel = 0
    switch.AnchorPoint = Vector2.new(1, 0.5)
    switch.Position = UDim2.new(1, 0, 0.5, 0)
    switch.Size = UDim2.new(0, 40, 0, 20)
    switch.Parent = toggle.frame
    
    createCorner(switch, 10)
    
    -- Toggle circle
    local circle = Instance.new("Frame")
    circle.Name = "Circle"
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BorderSizePixel = 0
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.Position = toggle.enabled and UDim2.new(0.75, 0, 0.5, 0) or UDim2.new(0.25, 0, 0.5, 0)
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Parent = switch
    
    createCorner(circle, 8)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Font = Enum.Font.GothamMedium
    title.Text = name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.TextTransparency = 0.5
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.AnchorPoint = Vector2.new(0, 0.5)
    title.Position = UDim2.new(0, 0, 0.5, 0)
    title.Size = UDim2.new(0, 150, 0, 12)
    title.Parent = toggle.frame
    
    createTextSizeConstraint(title, 12)
    
    -- Toggle functionality
    toggle.frame.MouseButton1Click:Connect(function()
        toggle.enabled = not toggle.enabled
        
        local newColor = toggle.enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(48, 48, 48)
        local newPosition = toggle.enabled and UDim2.new(0.75, 0, 0.5, 0) or UDim2.new(0.25, 0, 0.5, 0)
        
        TweenService:Create(switch, TWEEN_INFO, {BackgroundColor3 = newColor}):Play()
        TweenService:Create(circle, TWEEN_INFO, {Position = newPosition}):Play()
        
        if callback then
            callback(toggle.enabled)
        end
    end)
    
    return toggle
end

function AstralUI:_createKeybind(tab, name, default, callback)
    local keybind = {
        name = name,
        key = default or Enum.KeyCode.Unknown,
        callback = callback,
        listening = false
    }
    
    -- Main keybind frame
    keybind.frame = Instance.new("Frame")
    keybind.frame.Name = name .. "Keybind"
    keybind.frame.BackgroundTransparency = 1
    keybind.frame.BorderSizePixel = 0
    keybind.frame.Size = UDim2.new(0, 216, 0, 35)
    keybind.frame.Parent = tab.frame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Font = Enum.Font.GothamMedium
    title.Text = name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.TextTransparency = 0.5
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.AnchorPoint = Vector2.new(0, 0.5)
    title.Position = UDim2.new(0, 0, 0.4, 0)
    title.Size = UDim2.new(0, 150, 0, 12)
    title.Parent = keybind.frame
    
    createTextSizeConstraint(title, 12)
    
    -- Keybind button
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Font = Enum.Font.GothamMedium
    button.Text = keybind.key.Name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.TextTransparency = 0.5
    button.AutoButtonColor = false
    button.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
    button.BackgroundTransparency = 0.5
    button.BorderSizePixel = 0
    button.AnchorPoint = Vector2.new(1, 0.5)
    button.Position = UDim2.new(1, 0, 0.4, 0)
    button.Size = UDim2.new(0, 60, 0, 18)
    button.Parent = keybind.frame
    
    createCorner(button, 5)
    
    -- Keybind functionality
    button.MouseButton1Click:Connect(function()
        if keybind.listening then return end
        
        keybind.listening = true
        button.Text = "..."
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.UserInputType == Enum.UserInputType.Keyboard then
                keybind.key = input.KeyCode
                button.Text = input.KeyCode.Name
                keybind.listening = false
                connection:Disconnect()
                
                if callback then
                    callback(input.KeyCode)
                end
            end
        end)
    end)
    
    return keybind
end

-- Utility Methods
function AstralUI:Toggle()
    self.container.Visible = not self.container.Visible
end

function AstralUI:Destroy()
    if self.screenGui then
        self.screenGui:Destroy()
    end
end

return AstralUI
