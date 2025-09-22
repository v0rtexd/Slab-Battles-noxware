-- Flow UI Library v1.0
-- A modular Roblox UI Library with Tabs, Modules, Toggles, Sliders, Dropdowns, Keybinds
-- Supports Device Detection for Scaling (PC: Full, Tablet: Normal, Mobile: 0.7 Scale)
-- Usage:
-- local Flow = loadstring(game:HttpGet("your_script_url"))()
-- Flow:Init()
-- local Tab1 = Flow:AddTab("Blatant", "rbxassetid://icon_id")
-- local Module1 = Tab1:AddModule("Auto Parry")
-- Module1:AddToggle("Enabled", function(state) print("Toggle:", state) end)
-- Module1:AddSlider("Speed", 1, 100, 50, function(value) print("Slider:", value) end)
-- etc.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

local Flow = {}
Flow.Tabs = {}
Flow.Sections = {}
Flow.CurrentTab = nil

-- Device Detection
local isTouchEnabled = UserInputService.TouchEnabled
local isKeyboardEnabled = UserInputService.KeyboardEnabled
local deviceType = "PC"

if isTouchEnabled then
    if isKeyboardEnabled then
        deviceType = "Tablet"
    else
        deviceType = "Mobile"
    end
end

local scaleFactor = (deviceType == "Mobile") and 0.7 or 1

local function scaleUDim2(udim2, factor)
    return UDim2.new(udim2.X.Scale * factor, udim2.X.Offset * factor, udim2.Y.Scale * factor, udim2.Y.Offset * factor)
end

local originalSizes = {
    Container = UDim2.new(0, 640, 0, 355),
    Tabs = UDim2.new(0, 138, 0, 308),
    Section = UDim2.new(0, 237, 0, 306),
    Module = UDim2.new(0, 237, 0, 189),
    Settings = UDim2.new(0, 237, 0, 161),
    Dropdown = UDim2.new(0, 216, 0, 127),
    Box = UDim2.new(0, 218, 0, 18),
    OptionsExpanded = UDim2.new(0, 218, 0, 103),
    Options = UDim2.new(0, 218, 0, 85),
    List = UDim2.new(0, 218, 0, 85),
    Option = UDim2.new(0, 205, 0, 17),
    Slider = UDim2.new(0, 216, 0, 27),
    Drag = UDim2.new(0, 217, 0, 4),
    Fill1 = UDim2.new(0, 217, 0, 4),
    Circle = UDim2.new(0, 6, 0, 6),
    Header2 = UDim2.new(0, 237, 0, 28),
    Keybind = UDim2.new(0, 33, 0, 28),
    Background = UDim2.new(0, 20, 0, 20),
    Mobile = UDim2.new(0.036, 0, 0.044, 0),
    Tab = UDim2.new(0, 138, 0, 27)
}

local function createInstance(class, properties)
    local inst = Instance.new(class)
    for prop, value in pairs(properties) do
        inst[prop] = value
    end
    return inst
end

function Flow:Init()
    -- Core GUI
    self.ScreenGui = createInstance("ScreenGui", {ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Name = "Flow", Parent = CoreGui})

    self.Container = createInstance("Frame", {
        Active = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = scaleUDim2(originalSizes.Container, scaleFactor),
        Name = "Container",
        Parent = self.ScreenGui
    })

    local frame = createInstance("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0.95, 0, 0.95, 0),
        Parent = self.Container
    })

    local corner = createInstance("UICorner", {CornerRadius = UDim.new(0, 10 * scaleFactor), Parent = self.Container})

    -- Header
    local header = createInstance("Frame", {
        BackgroundColor3 = Color3.fromRGB(27, 27, 27),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = UDim2.new(0.0125, 0, 0.0225, 0),
        Size = scaleUDim2(UDim2.new(0, 624, 0, 24), scaleFactor),
        Name = "Header",
        Parent = self.Container
    })

    local headerCorner = createInstance("UICorner", {CornerRadius = UDim.new(0, 5 * scaleFactor), Parent = header})

    local clientLabel = createInstance("TextLabel", {
        Font = Enum.Font.Gotham,
        Text = "Flow",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextScaled = true,
        TextSize = 14 * scaleFactor,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.044, 0, 0.5, 0),
        Size = scaleUDim2(UDim2.new(0, 78, 0, 12), scaleFactor),
        Name = "Client",
        Parent = header
    })

    local clientTSC = createInstance("UITextSizeConstraint", {MaxTextSize = 12 * scaleFactor, Parent = clientLabel})

    -- Search Bar
    local searchBar = createInstance("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Color3.fromRGB(33, 33, 33),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = UDim2.new(0.995, 0, 0.5, 0),
        Size = scaleUDim2(UDim2.new(0, 64, 0, 17), scaleFactor),
        Name = "SearchBar",
        Parent = header
    })

    local searchCorner = createInstance("UICorner", {CornerRadius = UDim.new(0, 4 * scaleFactor), Parent = searchBar})

    local input = createInstance("TextBox", {
        ClearTextOnFocus = false,
        Font = Enum.Font.Gotham,
        PlaceholderColor3 = Color3.fromRGB(255, 255, 255),
        PlaceholderText = "Search",
        Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 10 * scaleFactor,
        TextTransparency = 0.5,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = scaleUDim2(UDim2.new(0, 39, 0, 14), scaleFactor),
        Name = "Input",
        Parent = searchBar
    })

    local inputTSC = createInstance("UITextSizeConstraint", {MaxTextSize = 10 * scaleFactor, Parent = input})

    local searchPadding = createInstance("UIPadding", {PaddingLeft = UDim.new(0, 9 * scaleFactor), Parent = searchBar})

    local iconBG = createInstance("ImageLabel", {
        Image = "rbxassetid://137743164814611",
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = scaleUDim2(UDim2.new(0, 17, 0, 17), scaleFactor),
        Name = "IconBG",
        Parent = searchBar
    })

    local icon = createInstance("ImageLabel", {
        Image = "rbxassetid://86686259429503",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = scaleUDim2(UDim2.new(0, 9, 0, 9), scaleFactor),
        Name = "Icon",
        Parent = iconBG
    })

    -- Tabs ScrollingFrame
    self.TabsFrame = createInstance("ScrollingFrame", {
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        ScrollBarImageTransparency = 1,
        ScrollBarThickness = 0,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.0125, 0, 0.11, 0),
        Size = scaleUDim2(originalSizes.Tabs, scaleFactor),
        Name = "Tabs",
        Parent = self.Container
    })

    local tabsLayout = createInstance("UIListLayout", {Padding = UDim.new(0, 6 * scaleFactor), SortOrder = Enum.SortOrder.LayoutOrder, Parent = self.TabsFrame})

    -- Sections Folder
    self.SectionsFolder = createInstance("Folder", {Name = "Sections", Parent = self.Container})

    -- Mobile Button
    local mobileBtn = createInstance("TextButton", {
        AutoButtonColor = false,
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.9, 0),
        Size = scaleUDim2(originalSizes.Mobile, scaleFactor),
        Name = "Mobile",
        Parent = self.ScreenGui
    })

    local mobileCorner = createInstance("UICorner", {CornerRadius = UDim.new(0, 10 * scaleFactor), Parent = mobileBtn})

    local mobileIcon = createInstance("ImageLabel", {
        Image = "rbxassetid://85235558678018",
        ImageTransparency = 0.4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0.2586, 0, 0.5, 0),
        Name = "Icon",
        Parent = mobileBtn
    })

    local mobileARC = createInstance("UIAspectRatioConstraint", {AspectRatio = 1.6111111640930176, Parent = mobileBtn})

    -- UIScale
    local uiScale = createInstance("UIScale", {Scale = scaleFactor, Parent = self.Container})

    -- Aspect Ratio
    local arc = createInstance("UIAspectRatioConstraint", {AspectRatio = 1.8028168678283691, Parent = self.ScreenGui})

    -- Search Functionality
    input:GetPropertyChangedSignal("Text"):Connect(function()
        local query = input.Text:lower()
        for _, section in ipairs(self.Sections) do
            for _, module in ipairs(section:GetChildren()) do
                if module:IsA("Frame") and module:FindFirstChild("Header") then
                    module.Visible = query == "" or string.find(module:FindFirstChild("Header").Title.Text:lower(), query)
                end
            end
        end
    end)

    -- Mobile Toggle
    mobileBtn.MouseButton1Click:Connect(function()
        self.Container.Visible = not self.Container.Visible
    end)

    -- Templates (Hidden)
    self.ModuleTemplate = self:createModuleTemplate()
    self.SettingsTemplate = self.ModuleTemplate.Settings
    self.DropdownTemplate = self:createDropdownTemplate()
    self.SliderTemplate = self:createSliderTemplate()
    self.KeybindTemplate = self:createKeybindTemplate()
    self.ToggleTemplate = self:createToggleTemplate()
    self.OptionTemplate = self:createOptionTemplate()

    print("Flow UI Library Initialized - Device:", deviceType, "Scale:", scaleFactor)
end

function Flow:createModuleTemplate()
    local module = createInstance("Frame", {
        BackgroundColor3 = Color3.fromRGB(27, 27, 27),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Size = scaleUDim2(originalSizes.Module, scaleFactor),
        Name = "Module"
    })

    local mCorner = createInstance("UICorner", {CornerRadius = UDim.new(0, 5 * scaleFactor), Parent = module})

    local header = createInstance("ImageButton", {
        Image = "rbxassetid://72035547110749",
        ImageTransparency = 0.5,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = scaleUDim2(originalSizes.Header2, scaleFactor),
        Name = "Header",
        Parent = module
    })

    local title = createInstance("TextLabel", {
        Font = Enum.Font.Gotham,
        Text = "Module Title",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextScaled = true,
        TextSize = 14 * scaleFactor,
        TextTransparency = 0.5,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.05, 0, 0.5, 0),
        Size = scaleUDim2(UDim2.new(0, 156, 0, 12), scaleFactor),
        Name = "Title",
        Parent = header
    })

    local titleTSC = createInstance("UITextSizeConstraint", {MaxTextSize = 12 * scaleFactor, Parent = title})

    local arrow = createInstance("ImageLabel", {
        Image = "rbxassetid://136776761805636",
        ImageTransparency = 0.5,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.9, 0, 0.286, 0),
        Rotation = -90,
        Size = scaleUDim2(UDim2.new(0, 11, 0, 11), scaleFactor),
        Name = "Arrow",
        Parent = header
    })

    local settings = createInstance("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.new(0, 0, 1, 0),
        Size = scaleUDim2(originalSizes.Settings, scaleFactor),
        Name = "Settings",
        Parent = module
    })

    local settingsLayout = createInstance("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = settings
    })

    -- Expand/Collapse
    local expanded = false
    header.MouseButton1Click:Connect(function()
        expanded = not expanded
        settings.Visible = expanded
        arrow.Rotation = expanded and 90 or -90
        TweenService:Create(module, TweenInfo.new(0.2), {Size = expanded and scaleUDim2(UDim2.new(0, 237, 0, 250), scaleFactor) or scaleUDim2(originalSizes.Module, scaleFactor)}):Play()
    end)

    module.Header = header
    module.Settings = settings
    return module
end

function Flow:createToggleTemplate()
    local toggle = createInstance("TextButton", {
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 216, 0, 20),
        Name = "Toggle"
    })

    local title = createInstance("TextLabel", {
        Font = Enum.Font.GothamMedium,
        Text = "Toggle",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextScaled = true,
        TextSize = 14 * scaleFactor,
        TextTransparency = 0.5,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 172, 0, 12),
        Name = "Title",
        Parent = toggle
    })

    local titleTSC = createInstance("UITextSizeConstraint", {MaxTextSize = 12 * scaleFactor, Parent = title})

    local indicator = createInstance("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -25, 0.5, 0),
        Size = UDim2.new(0, 16, 0, 16),
        Name = "Indicator",
        Parent = toggle
    })

    local iCorner = createInstance("UICorner", {CornerRadius = UDim.new(0.5, 0), Parent = indicator})

    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        indicator.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        -- Callback will be set externally
    end)

    toggle.SetState = function(bool)
        state = bool
        indicator.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        if toggle.Callback then toggle.Callback(state) end
    end

    toggle.GetState = function() return state end

    return toggle
end

function Flow:createSliderTemplate()
    local slider = createInstance("TextButton", {
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = scaleUDim2(originalSizes.Slider, scaleFactor),
        Name = "Slider"
    })

    local title = createInstance("TextLabel", {
        Font = Enum.Font.GothamMedium,
        Text = "Slider",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextScaled = true,
        TextSize = 14 * scaleFactor,
        TextTransparency = 0.5,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.4, 0),
        Size = scaleUDim2(UDim2.new(0, 172, 0, 12), scaleFactor),
        Name = "Title",
        Parent = slider
    })

    local titleTSC = createInstance("UITextSizeConstraint", {MaxTextSize = 12 * scaleFactor, Parent = title})

    local valueLabel = createInstance("TextLabel", {
        Font = Enum.Font.GothamMedium,
        Text = "50",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextScaled = true,
        TextSize = 14 * scaleFactor,
        TextTransparency = 0.5,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Right,
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(1, 0, 0.4, 0),
        Size = scaleUDim2(UDim2.new(0, 42, 0, 12), scaleFactor),
        Name = "Value",
        Parent = slider
    })

    local valueTSC = createInstance("UITextSizeConstraint", {MaxTextSize = 12 * scaleFactor, Parent = valueLabel})

    local drag = createInstance("Frame", {
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(48, 48, 48),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.8, 0),
        Size = scaleUDim2(originalSizes.Drag, scaleFactor),
        Name = "Drag",
        Parent = slider
    })

    local dCorner = createInstance("UICorner", {CornerRadius = UDim.new(0, 2 * scaleFactor), Parent = drag})

    local fill = createInstance("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = scaleUDim2(originalSizes.Fill1, scaleFactor),
        Name = "Fill",
        Parent = drag
    })

    local fCorner = createInstance("UICorner", {CornerRadius = UDim.new(0, 2 * scaleFactor), Parent = fill})

    local circle = createInstance("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = scaleUDim2(originalSizes.Circle, scaleFactor),
        Name = "Circle",
        Parent = fill
    })

    local cCorner = createInstance("UICorner", {CornerRadius = UDim.new(0.5, 0), Parent = circle})

    local minVal, maxVal, currentVal = 0, 100, 50
    local dragging = false

    local function updateSlider(percent)
        currentVal = math.floor(minVal + (maxVal - minVal) * percent)
        fill.Size = UDim2.new(percent, 0, 0, fill.Size.Y.Offset)
        circle.Position = UDim2.new(percent, 0, 0.5, 0)
        valueLabel.Text = tostring(currentVal)
        if slider.Callback then slider.Callback(currentVal) end
    end

    drag.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position.X - drag.AbsolutePosition.X
            local percent = math.clamp(delta / drag.AbsoluteSize.X, 0, 1)
            updateSlider(percent)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    updateSlider((currentVal - minVal) / (maxVal - minVal))

    slider.SetRange = function(min, max)
        minVal, maxVal = min, max
        updateSlider((currentVal - minVal) / (maxVal - minVal))
    end

    slider.SetValue = function(val)
        currentVal = math.clamp(val, minVal, maxVal)
        updateSlider((currentVal - minVal) / (maxVal - minVal))
    end

    slider.GetValue = function() return currentVal end

    return slider
end

function Flow:createDropdownTemplate()
    local dropdown = createInstance("TextButton", {
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = scaleUDim2(originalSizes.Dropdown, scaleFactor),
        Name = "Dropdown"
    })

    local padding = createInstance("UIPadding", {PaddingTop = UDim.new(0, 3 * scaleFactor), Parent = dropdown})

    local title = createInstance("TextLabel", {
        Font = Enum.Font.GothamMedium,
        Text = "Dropdown",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextScaled = true,
        TextSize = 14 * scaleFactor,
        TextTransparency = 0.5,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = scaleUDim2(UDim2.new(0, 215, 0, 12), scaleFactor),
        Name = "Title",
        Parent = dropdown
    })

    local titleTSC = createInstance("UITextSizeConstraint", {MaxTextSize = 12 * scaleFactor, Parent = title})

    local box = createInstance("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(48, 48, 48),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 1.3, 0),
        Size = scaleUDim2(originalSizes.Box, scaleFactor),
        Name = "Box",
        Parent = title
    })

    local boxCorner = createInstance("UICorner", {CornerRadius = UDim.new(0, 5 * scaleFactor), Parent = box})

    local headerImg = createInstance("ImageLabel", {
        Image = "rbxassetid://70783523951929",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, -0.5, 0),
        Size = scaleUDim2(UDim2.new(0, 218, 0, 18), scaleFactor),
        Name = "Header",
        Parent = box
    })

    local dArrow = createInstance("ImageLabel", {
        Image = "rbxassetid://136776761805636",
        ImageTransparency = 0.5,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.93, 0, 0.25, 0),
        Rotation = -90,
        Size = scaleUDim2(UDim2.new(0, 10, 0, 10), scaleFactor),
        Name = "Arrow",
        Parent = headerImg
    })

    local optTitle = createInstance("TextLabel", {
        Font = Enum.Font.GothamMedium,
        Text = "Option",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12 * scaleFactor,
        TextTransparency = 0.5,
        TextXAlignment = Enum.TextXAlignment.Left,
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.1, 0),
        Size = scaleUDim2(UDim2.new(0, 194, 0, 12), scaleFactor),
        Name = "Option",
        Parent = headerImg
    })

    local optTSC = createInstance("UITextSizeConstraint", {MaxTextSize = 12 * scaleFactor, Parent = optTitle})

    local gradient = createInstance("UIGradient", {
        Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.758, 0),
            NumberSequenceKeypoint.new(0.93, 0.269),
            NumberSequenceKeypoint.new(1, 1)
        },
        Parent = optTitle
    })

    local optionsFrame = createInstance("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.new(0.5, 0, 1.1, 0),
        Size = scaleUDim2(originalSizes.Options, scaleFactor),
        Name = "Options",
        Parent = box
    })

    local list = createInstance("ScrollingFrame", {
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarImageTransparency = 1,
        ScrollBarThickness = 0,
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = scaleUDim2(originalSizes.List, scaleFactor),
        Name = "List",
        Parent = optionsFrame
    })

    local listLayout = createInstance("UIListLayout", {HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = list})

    local fill = createInstance("Frame", {
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, -0.05, 0),
        Size = scaleUDim2(UDim2.new(0, 218, 0, 89), scaleFactor),
        Name = "Fill",
        Parent = optionsFrame
    })

    local cornerImg = createInstance("ImageLabel", {
        Image = "rbxassetid://130629302605775",
        ImageTransparency = 0.5,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, 0),
        Size = scaleUDim2(UDim2.new(0, 218, 0, 10), scaleFactor),
        Name = "Corner",
        Parent = fill
    })

    local open = false
    headerImg.MouseButton1Click:Connect(function()
        open = not open
        list.Visible = open
        dArrow.Rotation = open and 90 or -90
        TweenService:Create(box, TweenInfo.new(0.2), {Size = open and scaleUDim2(originalSizes.OptionsExpanded, scaleFactor) or scaleUDim2(originalSizes.Box, scaleFactor)}):Play()
    end)

    local selected = ""
    dropdown.AddOption = function(optText)
        local opt = self.OptionTemplate:Clone()
        opt.Text = optText
        opt.TextTransparency = (optText == selected) and 0.5 or 0.8
        opt.Parent = list
        opt.MouseButton1Click:Connect(function()
            selected = optText
            title.Text = selected
            for _, o in ipairs(list:GetChildren()) do
                if o:IsA("TextButton") then
                    o.TextTransparency = (o.Text == selected) and 0.5 or 0.8
                end
            end
            open = false
            list.Visible = false
            dArrow.Rotation = -90
            TweenService:Create(box, TweenInfo.new(0.2), {Size = scaleUDim2(originalSizes.Box, scaleFactor)}):Play()
            if dropdown.Callback then dropdown.Callback(selected) end
        end)
    end

    dropdown.SetSelected = function(val)
        selected = val
        title.Text = selected
        for _, o in ipairs(list:GetChildren()) do
            if o:IsA("TextButton") then
                o.TextTransparency = (o.Text == selected) and 0.5 or 0.8
            end
        end
        if dropdown.Callback then dropdown.Callback(selected) end
    end

    dropdown.GetSelected = function() return selected end

    return dropdown
end

function Flow:createKeybindTemplate()
    local keybind = createInstance("TextButton", {
        AutoButtonColor = false,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = scaleUDim2(originalSizes.Keybind, scaleFactor),
        Name = "Keybind"
    })

    local bg = createInstance("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(62, 62, 62),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = scaleUDim2(originalSizes.Background, scaleFactor),
        Name = "Background",
        Parent = keybind
    })

    local bgCorner = createInstance("UICorner", {CornerRadius = UDim.new(0, 4 * scaleFactor), Parent = bg})

    local str = createInstance("TextLabel", {
        Font = Enum.Font.Gotham,
        Text = "R",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 10 * scaleFactor,
        TextTransparency = 0.5,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = scaleUDim2(UDim2.new(0, 12, 0, 12), scaleFactor),
        Visible = true,
        Name = "String",
        Parent = bg
    })

    local strTSC = createInstance("UITextSizeConstraint", {MaxTextSize = 11 * scaleFactor, Parent = str})

    local delete = createInstance("ImageLabel", {
        Image = "rbxassetid://79831062733212",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = scaleUDim2(UDim2.new(0, 10, 0, 10), scaleFactor),
        Visible = false,
        Name = "Delete",
        Parent = bg
    })

    local edit = createInstance("ImageLabel", {
        Image = "rbxassetid://10734887784",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = scaleUDim2(UDim2.new(0, 10, 0, 10), scaleFactor),
        Name = "Edit",
        Parent = bg
    })

    local currentKey = "R"
    local binding = false

    keybind.MouseButton1Click:Connect(function()
        binding = true
        str.Visible = false
        edit.Visible = false
        delete.Visible = false
        bg.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if binding and not processed and input.KeyCode ~= Enum.KeyCode.Unknown then
            currentKey = input.KeyCode.Name
            str.Text = currentKey
            str.Visible = true
            edit.Visible = true
            delete.Visible = true
            bg.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
            binding = false
            if keybind.Callback then keybind.Callback(currentKey) end
        end
    end)

    delete.MouseButton1Click:Connect(function()
        currentKey = "None"
        str.Text = "None"
        if keybind.Callback then keybind.Callback(currentKey) end
    end)

    keybind.SetKey = function(key)
        currentKey = key or "None"
        str.Text = currentKey
        if keybind.Callback then keybind.Callback(currentKey) end
    end

    keybind.GetKey = function() return currentKey end

    return keybind
end

function Flow:createOptionTemplate()
    local opt = createInstance("TextButton", {
        Font = Enum.Font.GothamMedium,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12 * scaleFactor,
        TextTransparency = 0.5,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = scaleUDim2(originalSizes.Option, scaleFactor),
        ZIndex = 2,
        Name = "Option"
    })

    local optTSC = createInstance("UITextSizeConstraint", {MaxTextSize = 12 * scaleFactor, Parent = opt})

    local g = createInstance("UIGradient", {
        Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.758, 0),
            NumberSequenceKeypoint.new(0.93, 0.269),
            NumberSequenceKeypoint.new(1, 1)
        },
        Parent = opt
    })

    return opt
end

function Flow:AddTab(name, iconId)
    local tabIndex = #self.Tabs + 1
    local section = createInstance("ScrollingFrame", {
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarImageTransparency = 1,
        ScrollBarThickness = 0,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = (tabIndex == 1) and UDim2.new(0.24, 0, 0.11, 0) or UDim2.new(0.62, 0, 0.11, 0),
        Size = scaleUDim2(originalSizes.Section, scaleFactor),
        Name = name,
        Parent = self.SectionsFolder,
        Visible = (tabIndex == 1)
    })

    local sLayout = createInstance("UIListLayout", {Padding = UDim.new(0, 6 * scaleFactor), SortOrder = Enum.SortOrder.LayoutOrder, Parent = section})

    -- Tab Button
    local tab = createInstance("TextButton", {
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(27, 27, 27),
        BackgroundTransparency = (tabIndex == 1) and 0 or 0.5,
        BorderSizePixel = 0,
        Size = scaleUDim2(originalSizes.Tab, scaleFactor),
        Font = Enum.Font.SourceSans,
        Text = "",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 14 * scaleFactor,
        Name = name,
        Parent = self.TabsFrame
    })

    local tabCorner = createInstance("UICorner", {CornerRadius = UDim.new(0, 5 * scaleFactor), Parent = tab})

    local tabIcon = createInstance("ImageLabel", {
        Image = iconId or "",
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.1, 0, 0.5, 0),
        Size = scaleUDim2(UDim2.new(0, 12, 0, 12), scaleFactor),
        Name = "Icon",
        Parent = tab
    })

    local tabTitle = createInstance("TextLabel", {
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextScaled = true,
        TextSize = 14 * scaleFactor,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.225, 0, 0.5, 0),
        Size = scaleUDim2(UDim2.new(0, 75, 0, 12), scaleFactor),
        Name = "Title",
        Parent = tab
    })

    local tabTitleTSC = createInstance("UITextSizeConstraint", {MaxTextSize = 12 * scaleFactor, Parent = tabTitle})

    tab.MouseButton1Click:Connect(function()
        for i, s in ipairs(self.Sections) do
            s.Visible = (i == tabIndex)
        end
        for i, t in ipairs(self.Tabs) do
            t.BackgroundTransparency = (i == tabIndex) and 0 or 0.5
        end
        self.CurrentTab = tabIndex
    end)

    table.insert(self.Tabs, tab)
    table.insert(self.Sections, section)

    local tabObj = {}
    function tabObj:AddModule(mName)
        local mod = self.ModuleTemplate:Clone()
        -- Fix for cloned template: Reassign custom properties
        mod.Header = mod:FindFirstChild("Header")
        mod.Settings = mod:FindFirstChild("Settings")
        mod.Name = mName
        mod.Header.Title.Text = mName
        mod.Parent = section

        local modObj = {}
        function modObj:AddToggle(tName, callback)
            local toggle = Flow.ToggleTemplate:Clone()
            toggle.Title.Text = tName
            toggle.Callback = callback
            toggle.Parent = mod.Settings
            toggle:SetState(false)
            return toggle
        end

        function modObj:AddSlider(sName, min, max, default, callback)
            local slider = Flow.SliderTemplate:Clone()
            slider.Title.Text = sName
            slider.Callback = callback
            slider:SetRange(min or 0, max or 100)
            slider:SetValue(default or 50)
            slider.Parent = mod.Settings
            return slider
        end

        function modObj:AddDropdown(dName, options, default, callback)
            local dropdown = Flow.DropdownTemplate:Clone()
            dropdown.Title.Text = dName
            dropdown.Callback = callback
            for _, opt in ipairs(options or {}) do
                dropdown:AddOption(opt)
            end
            if default and #options > 0 then
                dropdown:SetSelected(default)
            elseif #options > 0 then
                dropdown:SetSelected(options[1])
            end
            dropdown.Parent = mod.Settings
            return dropdown
        end

        function modObj:AddKeybind(kName, default, callback)
            local keybind = Flow.KeybindTemplate:Clone()
            keybind.Parent = mod.Header
            -- Position adjustment if needed
            keybind.Position = UDim2.new(1, -40 * scaleFactor, 0.5, 0)
            keybind:SetKey(default or "R")
            keybind.Callback = callback
            return keybind
        end

        return modObj
    end

    return tabObj
end

return Flow
