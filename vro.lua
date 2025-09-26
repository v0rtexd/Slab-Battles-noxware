local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")

local mouse = Players.LocalPlayer:GetMouse()

-- Configuration and utility functions
local Config = {
    save = function(file_name, config)
        local success, result = pcall(function()
            local flags = HttpService:JSONEncode(config)
            writefile('Flow/' .. file_name .. '.json', flags)
        end)
        if not success then
            warn('Failed to save config:', result)
        end
    end,
    load = function(file_name, config)
        local success, result = pcall(function()
            if not isfile('Flow/' .. file_name .. '.json') then
                Config:save(file_name, config)
                return config
            end
            local flags = readfile('Flow/' .. file_name .. '.json')
            return HttpService:JSONDecode(flags) or config
        end)
        if not success then
            warn('Failed to load config:', result)
            return config
        end
        return result
    end
}

local Util = {
    map = function(value, in_min, in_max, out_min, out_max)
        return (value - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
    end,
    get_offset = function()
        local viewport_size_Y = workspace.CurrentCamera.ViewportSize.Y
        return Util:map(viewport_size_Y, 0, 2560, 8, 56)
    end
}

-- Library setup
local Library = {
    _config = Config:load(game.GameId, {_flags = {}, _keybinds = {}, _library = {}}),
    _device = nil,
    _ui_open = true,
    _ui_scale = 1,
    _ui_loaded = false,
    _ui = nil,
    _dragging = false,
    _drag_start = nil,
    _container_position = nil,
    _modules = {}, -- Store modules for search functionality
    _tabs = {}, -- Store tabs for reference
}
Library.__index = Library

function Library.new()
    local self = setmetatable({
        _loaded = false,
        _tab = 0,
    }, Library)
    self:create_ui()
    return self
end

function Library:get_screen_scale()
    local viewport_size_x = workspace.CurrentCamera.ViewportSize.X
    self._ui_scale = math.clamp(Util:map(viewport_size_x, 800, 2560, 0.7, 1.2), 0.7, 1.2)
end

function Library:get_device()
    local device = 'Unknown'
    if UserInputService.KeyboardEnabled and UserInputService.MouseEnabled and not UserInputService.TouchEnabled then
        device = 'PC'
    elseif UserInputService.TouchEnabled then
        device = 'Mobile'
    elseif UserInputService.GamepadEnabled then
        device = 'Console'
    end
    self._device = device
end

function Library:remove_table_value(__table, table_value)
    for index, value in ipairs(__table) do
        if value == table_value then
            table.remove(__table, index)
            break
        end
    end
end

function Library:create_ui()
    local old_Flow = CoreGui:FindFirstChild('Flow')
    if old_Flow then
        Debris:AddItem(old_Flow, 0)
    end

    local Converted = {
        ["_Flow"] = Instance.new("ScreenGui"),
        ["_Container"] = Instance.new("Frame"),
        ["_Frame"] = Instance.new("Frame"),
        ["_UICorner"] = Instance.new("UICorner"),
        ["_Header"] = Instance.new("Frame"),
        ["_UICorner1"] = Instance.new("UICorner"),
        ["_Client"] = Instance.new("TextLabel"),
        ["_UITextSizeConstraint"] = Instance.new("UITextSizeConstraint"),
        ["_SearchBar"] = Instance.new("Frame"),
        ["_UICorner2"] = Instance.new("UICorner"),
        ["_Input"] = Instance.new("TextBox"),
        ["_UITextSizeConstraint1"] = Instance.new("UITextSizeConstraint"),
        ["_UIPadding"] = Instance.new("UIPadding"),
        ["_IconBG"] = Instance.new("ImageLabel"),
        ["_Icon"] = Instance.new("ImageLabel"),
        ["_Tabs"] = Instance.new("ScrollingFrame"),
        ["_UIListLayout"] = Instance.new("UIListLayout"),
        ["_Sections"] = Instance.new("Folder"),
        ["_LeftSection"] = Instance.new("ScrollingFrame"),
        ["_UIListLayout1"] = Instance.new("UIListLayout"),
        ["_RightSection"] = Instance.new("ScrollingFrame"),
        ["_UIListLayout4"] = Instance.new("UIListLayout"),
        ["_UIScale"] = Instance.new("UIScale"),
        ["_UIAspectRatioConstraint"] = Instance.new("UIAspectRatioConstraint"),
        ["_Mobile"] = Instance.new("TextButton"),
        ["_UICorner10"] = Instance.new("UICorner"),
        ["_Icon2"] = Instance.new("ImageLabel"),
        ["_UIAspectRatioConstraint1"] = Instance.new("UIAspectRatioConstraint"),
    }

    -- Apply properties from provided Converted table
    Converted["_Flow"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Converted["_Flow"].Name = "Flow"
    Converted["_Flow"].Parent = CoreGui

    Converted["_Container"].Active = true
    Converted["_Container"].AnchorPoint = Vector2.new(0.5, 0.5)
    Converted["_Container"].BackgroundColor3 = Color3.fromRGB(13, 13, 13)
    Converted["_Container"].BackgroundTransparency = 0.1
    Converted["_Container"].BorderSizePixel = 0
    Converted["_Container"].Position = UDim2.new(0.5, 0, 0.5, 0)
    Converted["_Container"].Size = UDim2.new(0, 640, 0, 355)
    Converted["_Container"].Parent = Converted["_Flow"]

    Converted["_Frame"].AnchorPoint = Vector2.new(0.5, 0.5)
    Converted["_Frame"].BackgroundTransparency = 1
    Converted["_Frame"].Position = UDim2.new(0.5, 0, 0.5, 0)
    Converted["_Frame"].Size = UDim2.new(0.95, 0, 0.95, 0)
    Converted["_Frame"].Parent = Converted["_Container"]

    Converted["_UICorner"].CornerRadius = UDim.new(0, 10)
    Converted["_UICorner"].Parent = Converted["_Container"]

    Converted["_Header"].BackgroundColor3 = Color3.fromRGB(27, 27, 27)
    Converted["_Header"].BackgroundTransparency = 0.5
    Converted["_Header"].BorderSizePixel = 0
    Converted["_Header"].Position = UDim2.new(0.0125, 0, 0.0225, 0)
    Converted["_Header"].Size = UDim2.new(0, 624, 0, 24)
    Converted["_Header"].Parent = Converted["_Container"]

    Converted["_UICorner1"].CornerRadius = UDim.new(0, 5)
    Converted["_UICorner1"].Parent = Converted["_Header"]

    Converted["_Client"].Font = Enum.Font.Gotham
    Converted["_Client"].Text = "Flow"
    Converted["_Client"].TextColor3 = Color3.fromRGB(255, 255, 255)
    Converted["_Client"].TextScaled = true
    Converted["_Client"].TextSize = 14
    Converted["_Client"].TextXAlignment = Enum.TextXAlignment.Left
    Converted["_Client"].AnchorPoint = Vector2.new(0, 0.5)
    Converted["_Client"].BackgroundTransparency = 1
    Converted["_Client"].BorderSizePixel = 0
    Converted["_Client"].Position = UDim2.new(0.044, 0, 0.5, 0)
    Converted["_Client"].Size = UDim2.new(0, 78, 0, 12)
    Converted["_Client"].Parent = Converted["_Header"]

    Converted["_UITextSizeConstraint"].MaxTextSize = 12
    Converted["_UITextSizeConstraint"].MinTextSize = 12
    Converted["_UITextSizeConstraint"].Parent = Converted["_Client"]

    Converted["_SearchBar"].AnchorPoint = Vector2.new(1, 0.5)
    Converted["_SearchBar"].BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    Converted["_SearchBar"].BackgroundTransparency = 0.5
    Converted["_SearchBar"].BorderSizePixel = 0
    Converted["_SearchBar"].Position = UDim2.new(0.995, 0, 0.5, 0)
    Converted["_SearchBar"].Size = UDim2.new(0, 64, 0, 17)
    Converted["_SearchBar"].Parent = Converted["_Header"]

    Converted["_UICorner2"].CornerRadius = UDim.new(0, 4)
    Converted["_UICorner2"].Parent = Converted["_SearchBar"]

    Converted["_Input"].ClearTextOnFocus = false
    Converted["_Input"].Font = Enum.Font.Gotham
    Converted["_Input"].PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
    Converted["_Input"].PlaceholderText = "Search"
    Converted["_Input"].Text = ""
    Converted["_Input"].TextColor3 = Color3.fromRGB(255, 255, 255)
    Converted["_Input"].TextSize = 10
    Converted["_Input"].TextTransparency = 0.5
    Converted["_Input"].TextXAlignment = Enum.TextXAlignment.Left
    Converted["_Input"].AnchorPoint = Vector2.new(0, 0.5)
    Converted["_Input"].BackgroundTransparency = 1
    Converted["_Input"].BorderSizePixel = 0
    Converted["_Input"].Position = UDim2.new(0, 0, 0.5, 0)
    Converted["_Input"].Size = UDim2.new(0, 39, 0, 14)
    Converted["_Input"].Parent = Converted["_SearchBar"]

    Converted["_UITextSizeConstraint1"].MaxTextSize = 10
    Converted["_UITextSizeConstraint1"].MinTextSize = 10
    Converted["_UITextSizeConstraint1"].Parent = Converted["_Input"]

    Converted["_UIPadding"].PaddingLeft = UDim.new(0, 9)
    Converted["_UIPadding"].Parent = Converted["_SearchBar"]

    Converted["_IconBG"].Image = "rbxassetid://137743164814611"
    Converted["_IconBG"].AnchorPoint = Vector2.new(1, 0.5)
    Converted["_IconBG"].BackgroundTransparency = 1
    Converted["_IconBG"].BorderSizePixel = 0
    Converted["_IconBG"].Position = UDim2.new(1, 0, 0.5, 0)
    Converted["_IconBG"].Size = UDim2.new(0, 17, 0, 17)
    Converted["_IconBG"].Parent = Converted["_SearchBar"]

    Converted["_Icon"].Image = "rbxassetid://86686259429503"
    Converted["_Icon"].AnchorPoint = Vector2.new(0.5, 0.5)
    Converted["_Icon"].BackgroundTransparency = 1
    Converted["_Icon"].BorderSizePixel = 0
    Converted["_Icon"].Position = UDim2.new(0.5, 0, 0.5, 0)
    Converted["_Icon"].Size = UDim2.new(0, 9, 0, 9)
    Converted["_Icon"].Parent = Converted["_IconBG"]

    Converted["_Tabs"].AutomaticCanvasSize = Enum.AutomaticSize.X
    Converted["_Tabs"].CanvasSize = UDim2.new(0, 0, 0.5, 0)
    Converted["_Tabs"].ScrollBarImageTransparency = 1
    Converted["_Tabs"].ScrollBarThickness = 0
    Converted["_Tabs"].Active = true
    Converted["_Tabs"].BackgroundTransparency = 1
    Converted["_Tabs"].BorderSizePixel = 0
    Converted["_Tabs"].Position = UDim2.new(0.0125, 0, 0.11, 0)
    Converted["_Tabs"].Size = UDim2.new(0, 138, 0, 308)
    Converted["_Tabs"].Parent = Converted["_Container"]

    Converted["_UIListLayout"].Padding = UDim.new(0, 6)
    Converted["_UIListLayout"].SortOrder = Enum.SortOrder.LayoutOrder
    Converted["_UIListLayout"].Parent = Converted["_Tabs"]

    Converted["_Sections"].Parent = Converted["_Container"]

    Converted["_LeftSection"].AutomaticCanvasSize = Enum.AutomaticSize.XY
    Converted["_LeftSection"].CanvasSize = UDim2.new(0, 0, 0.5, 0)
    Converted["_LeftSection"].ScrollBarImageTransparency = 1
    Converted["_LeftSection"].ScrollBarThickness = 0
    Converted["_LeftSection"].Active = true
    Converted["_LeftSection"].BackgroundTransparency = 1
    Converted["_LeftSection"].BorderSizePixel = 0
    Converted["_LeftSection"].Position = UDim2.new(0.24, 0, 0.11, 0)
    Converted["_LeftSection"].Size = UDim2.new(0, 237, 0, 306)
    Converted["_LeftSection"].Parent = Converted["_Sections"]

    Converted["_UIListLayout1"].Padding = UDim.new(0, 6)
    Converted["_UIListLayout1"].Parent = Converted["_LeftSection"]

    Converted["_RightSection"].AutomaticCanvasSize = Enum.AutomaticSize.XY
    Converted["_RightSection"].CanvasSize = UDim2.new(0, 0, 0.5, 0)
    Converted["_RightSection"].ScrollBarImageTransparency = 1
    Converted["_RightSection"].ScrollBarThickness = 0
    Converted["_RightSection"].Active = true
    Converted["_RightSection"].BackgroundTransparency = 1
    Converted["_RightSection"].BorderSizePixel = 0
    Converted["_RightSection"].Position = UDim2.new(0.62, 0, 0.11, 0)
    Converted["_RightSection"].Size = UDim2.new(0, 237, 0, 306)
    Converted["_RightSection"].Parent = Converted["_Sections"]

    Converted["_UIListLayout4"].Padding = UDim.new(0, 6)
    Converted["_UIListLayout4"].SortOrder = Enum.SortOrder.LayoutOrder
    Converted["_UIListLayout4"].Parent = Converted["_RightSection"]

    Converted["_UIScale"].Parent = Converted["_Container"]

    Converted["_UIAspectRatioConstraint"].AspectRatio = 1.8028168678283691
    Converted["_UIAspectRatioConstraint"].Parent = Converted["_Flow"]

    Converted["_Mobile"].Font = Enum.Font.SourceSans
    Converted["_Mobile"].Text = ""
    Converted["_Mobile"].TextColor3 = Color3.fromRGB(0, 0, 0)
    Converted["_Mobile"].TextSize = 14
    Converted["_Mobile"].AutoButtonColor = false
    Converted["_Mobile"].AnchorPoint = Vector2.new(0.5, 0)
    Converted["_Mobile"].BackgroundColor3 = Color3.fromRGB(13, 13, 13)
    Converted["_Mobile"].BackgroundTransparency = 0.1
    Converted["_Mobile"].BorderSizePixel = 0
    Converted["_Mobile"].Position = UDim2.new(0.5, 0, 0.902557433, 0)
    Converted["_Mobile"].Size = UDim2.new(0.0360920988, 0, 0.0440097786, 0)
    Converted["_Mobile"].Parent = Converted["_Flow"]

    Converted["_UICorner10"].CornerRadius = UDim.new(0, 10)
    Converted["_UICorner10"].Parent = Converted["_Mobile"]

    Converted["_Icon2"].Image = "rbxassetid://85235558678018"
    Converted["_Icon2"].ImageTransparency = 0.4
    Converted["_Icon2"].AnchorPoint = Vector2.new(0.5, 0.5)
    Converted["_Icon2"].BackgroundTransparency = 1
    Converted["_Icon2"].BorderSizePixel = 0
    Converted["_Icon2"].Position = UDim2.new(0.5, 0, 0.5, 0)
    Converted["_Icon2"].Size = UDim2.new(0.258620679, 0, 0.5, 0)
    Converted["_Icon2"].Parent = Converted["_Mobile"]

    Converted["_UIAspectRatioConstraint1"].AspectRatio = 1.6111111640930176
    Converted["_UIAspectRatioConstraint1"].Parent = Converted["_Mobile"]

    self._ui = Converted["_Flow"]

    -- Dragging functionality
    local function on_drag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self._dragging = true
            self._drag_start = input.Position
            self._container_position = Converted["_Container"].Position
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    self._dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end

    local function update_drag(input)
        if not self._dragging then return end
        local delta = input.Position - self._drag_start
        local position = UDim2.new(self._container_position.X.Scale, self._container_position.X.Offset + delta.X, self._container_position.Y.Scale, self._container_position.Y.Offset + delta.Y)
        TweenService:Create(Converted["_Container"], TweenInfo.new(0.2), {Position = position}):Play()
    end

    Converted["_Container"].InputBegan:Connect(on_drag)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            update_drag(input)
        end
    end)

    -- Search functionality
    Converted["_Input"].FocusLost:Connect(function()
        local query = Converted["_Input"].Text:lower()
        for _, module in pairs(self._modules) do
            local moduleName = module.Title.Text:lower()
            module.Frame.Visible = query == "" or moduleName:find(query) ~= nil
        end
    end)

    -- Mobile toggle
    Converted["_Mobile"].MouseButton1Click:Connect(function()
        self._ui_open = not self._ui_open
        self:change_visiblity(self._ui_open)
    end)

    self:load()
end

function Library:change_visiblity(state)
    local targetSize = state and UDim2.fromOffset(640, 355) or UDim2.fromOffset(104, 52)
    TweenService:Create(Converted["_Container"], TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = targetSize}):Play()
end

function Library:load()
    self:get_device()
    if self._device == 'Mobile' or self._device == 'Unknown' then
        self:get_screen_scale()
        Converted["_UIScale"].Scale = self._ui_scale
        workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(function()
            self:get_screen_scale()
            Converted["_UIScale"].Scale = self._ui_scale
        end)
    end
    TweenService:Create(Converted["_Container"], TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(640, 355)}):Play()
    self._ui_loaded = true
end

function Library:create_tab(title, icon)
    local TabManager = {}
    self._tab = self._tab + 1
    local tab_id = self._tab

    local Tab = Instance.new("TextButton")
    Tab.Font = Enum.Font.SourceSans
    Tab.Text = ""
    Tab.TextColor3 = Color3.fromRGB(0, 0, 0)
    Tab.TextSize = 14
    Tab.AutoButtonColor = false
    Tab.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
    Tab.BackgroundTransparency = 0.5
    Tab.BorderSizePixel = 0
    Tab.Size = UDim2.new(0, 138, 0, 27)
    Tab.Parent = Converted["_Tabs"]
    Tab.LayoutOrder = tab_id

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = Tab

    local Icon = Instance.new("ImageLabel")
    Icon.Image = icon or "rbxassetid://10709810463"
    Icon.AnchorPoint = Vector2.new(0, 0.5)
    Icon.BackgroundTransparency = 1
    Icon.BorderSizePixel = 0
    Icon.Position = UDim2.new(0.1, 0, 0.5, 0)
    Icon.Size = UDim2.new(0, 12, 0, 12)
    Icon.Parent = Tab

    local Title = Instance.new("TextLabel")
    Title.Font = Enum.Font.Gotham
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.AnchorPoint = Vector2.new(0, 0.5)
    Title.BackgroundTransparency = 1
    Title.BorderSizePixel = 0
    Title.Position = UDim2.new(0.225, 0, 0.5, 0)
    Title.Size = UDim2.new(0, 75, 0, 12)
    Title.Parent = Tab

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
    UITextSizeConstraint.MaxTextSize = 12
    UITextSizeConstraint.MinTextSize = 12
    UITextSizeConstraint.Parent = Title

    local LeftSection = Instance.new("ScrollingFrame")
    LeftSection.AutomaticCanvasSize = Enum.AutomaticSize.XY
    LeftSection.CanvasSize = UDim2.new(0, 0, 0.5, 0)
    LeftSection.ScrollBarImageTransparency = 1
    LeftSection.ScrollBarThickness = 0
    LeftSection.Active = true
    LeftSection.BackgroundTransparency = 1
    LeftSection.BorderSizePixel = 0
    LeftSection.Position = UDim2.new(0.24, 0, 0.11, 0)
    LeftSection.Size = UDim2.new(0, 237, 0, 306)
    LeftSection.Parent = Converted["_Sections"]

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 6)
    UIListLayout.Parent = LeftSection

    local RightSection = Instance.new("ScrollingFrame")
    RightSection.AutomaticCanvasSize = Enum.AutomaticSize.XY
    RightSection.CanvasSize = UDim2.new(0, 0, 0.5, 0)
    RightSection.ScrollBarImageTransparency = 1
    RightSection.ScrollBarThickness = 0
    RightSection.Active = true
    RightSection.BackgroundTransparency = 1
    RightSection.BorderSizePixel = 0
    RightSection.Position = UDim2.new(0.62, 0, 0.11, 0)
    RightSection.Size = UDim2.new(0, 237, 0, 306)
    RightSection.Parent = Converted["_Sections"]

    local UIListLayout4 = Instance.new("UIListLayout")
    UIListLayout4.Padding = UDim.new(0, 6)
    UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout4.Parent = RightSection

    self._tabs[tab_id] = {Tab = Tab, LeftSection = LeftSection, RightSection = RightSection}

    Tab.MouseButton1Click:Connect(function()
        self:update_sections(LeftSection, RightSection)
        for _, tab in pairs(self._tabs) do
            local isSelected = tab.Tab == Tab
            TweenService:Create(tab.Tab, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {BackgroundTransparency = isSelected and 0.5 or 1}):Play()
            TweenService:Create(tab.Tab:FindFirstChild("TextLabel"), TweenInfo.new(0.5, Enum.EasingStyle.Quint), {TextTransparency = isSelected and 0 or 0.7, TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)}):Play()
            TweenService:Create(tab.Tab:FindFirstChild("ImageLabel"), TweenInfo.new(0.5, Enum.EasingStyle.Quint), {ImageTransparency = isSelected and 0 or 0.8, ImageColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)}):Play()
        end
    end)

    function TabManager:CreateModule(name)
        local Module = {
            Frame = Instance.new("Frame"),
            Title = Instance.new("TextLabel"),
            Header = Instance.new("ImageButton"),
            Arrow = Instance.new("ImageLabel"),
            Settings = Instance.new("Frame"),
            UIListLayout = Instance.new("UIListLayout"),
            UICorner = Instance.new("UICorner"),
            Enabled = false
        }

        Module.Frame.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
        Module.Frame.BackgroundTransparency = 0.5
        Module.Frame.BorderSizePixel = 0
        Module.Frame.ClipsDescendants = true
        Module.Frame.Size = UDim2.new(0, 237, 0, 28)
        Module.Frame.Parent = LeftSection

        Module.UICorner.CornerRadius = UDim.new(0, 5)
        Module.UICorner.Parent = Module.Frame

        Module.Header.Image = "rbxassetid://72035547110749"
        Module.Header.BackgroundTransparency = 1
        Module.Header.BorderSizePixel = 0
        Module.Header.Size = UDim2.new(0, 237, 0, 28)
        Module.Header.Parent = Module.Frame

        Module.Arrow.Image = "rbxassetid://136776761805636"
        Module.Arrow.ImageTransparency = 0.5
        Module.Arrow.BackgroundTransparency = 1
        Module.Arrow.BorderSizePixel = 0
        Module.Arrow.Position = UDim2.new(0.9, 0, 0.286, 0)
        Module.Arrow.Rotation = -90
        Module.Arrow.Size = UDim2.new(0, 11, 0, 11)
        Module.Arrow.Parent = Module.Header

        Module.Title.Font = Enum.Font.Gotham
        Module.Title.Text = name
        Module.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Module.Title.TextScaled = true
        Module.Title.TextSize = 14
        Module.Title.TextTransparency = 0.5
        Module.Title.TextXAlignment = Enum.TextXAlignment.Left
        Module.Title.AnchorPoint = Vector2.new(0, 0.5)
        Module.Title.BackgroundTransparency = 1
        Module.Title.BorderSizePixel = 0
        Module.Title.Position = UDim2.new(0.05, 0, 0.5, 0)
        Module.Title.Size = UDim2.new(0, 156, 0, 12)
        Module.Title.Parent = Module.Header

        Module.Settings.BackgroundTransparency = 1
        Module.Settings.BorderSizePixel = 0
        Module.Settings.ClipsDescendants = true
        Module.Settings.Position = UDim2.new(0, 0, 1, 0)
        Module.Settings.Size = UDim2.new(0, 237, 0, 0)
        Module.Settings.Parent = Module.Frame

        Module.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        Module.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        Module.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        Module.UIListLayout.Parent = Module.Settings

        table.insert(self._modules, {Frame = Module.Frame, Title = Module.Title})

        local function toggle_settings()
            Module.Enabled = not Module.Enabled
            local targetSize = Module.Enabled and UDim2.new(0, 237, 0, 189) or UDim2.new(0, 237, 0, 28)
            local targetSettingsSize = Module.Enabled and UDim2.new(0, 237, 0, 161) or UDim2.new(0, 237, 0, 0)
            TweenService:Create(Module.Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Size = targetSize}):Play()
            TweenService:Create(Module.Settings, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Size = targetSettingsSize}):Play()
            TweenService:Create(Module.Arrow, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Rotation = Module.Enabled and 90 or -90}):Play()
        end

        Module.Header.MouseButton1Click:Connect(toggle_settings)

        function Module:CreateSlider(title, min, max, default, callback)
            local Slider = {
                Frame = Instance.new("TextButton"),
                Drag = Instance.new("Frame"),
                UICorner6 = Instance.new("UICorner"),
                Fill = Instance.new("Frame"),
                UICorner7 = Instance.new("UICorner"),
                Circle = Instance.new("Frame"),
                UICorner8 = Instance.new("UICorner"),
                Title = Instance.new("TextLabel"),
                Value = Instance.new("TextLabel"),
                ValueTextConstraint = Instance.new("UITextSizeConstraint"),
                CurrentValue = default or min
            }

            Slider.Frame.Font = Enum.Font.SourceSans
            Slider.Frame.Text = ""
            Slider.Frame.TextColor3 = Color3.fromRGB(0, 0, 0)
            Slider.Frame.TextSize = 14
            Slider.Frame.AutoButtonColor = false
            Slider.Frame.BackgroundTransparency = 1
            Slider.Frame.BorderSizePixel = 0
            Slider.Frame.Size = UDim2.new(0, 216, 0, 27)
            Slider.Frame.Parent = Module.Settings

            Slider.Drag.AnchorPoint = Vector2.new(0.5, 1)
            Slider.Drag.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
            Slider.Drag.BackgroundTransparency = 0.5
            Slider.Drag.BorderSizePixel = 0
            Slider.Drag.Position = UDim2.new(0.5, 0, 0.8, 0)
            Slider.Drag.Size = UDim2.new(0, 217, 0, 4)
            Slider.Drag.Parent = Slider.Frame

            Slider.UICorner6.Parent = Slider.Drag

            Slider.Fill.AnchorPoint = Vector2.new(0, 0.5)
            Slider.Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Slider.Fill.BackgroundTransparency = 0.5
            Slider.Fill.BorderSizePixel = 0
            Slider.Fill.Position = UDim2.new(0, 0, 0.5, 0)
            Slider.Fill.Size = UDim2.new(0, Util:map(default, min, max, 0, 217), 0, 4)
            Slider.Fill.Parent = Slider.Drag

            Slider.UICorner7.Parent = Slider.Fill

            Slider.Circle.AnchorPoint = Vector2.new(1, 0.5)
            Slider.Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Slider.Circle.BorderSizePixel = 0
            Slider.Circle.Position = UDim2.new(1, 0, 0.5, 0)
            Slider.Circle.Size = UDim2.new(0, 6, 0, 6)
            Slider.Circle.Parent = Slider.Fill

            Slider.UICorner8.CornerRadius = UDim.new(1, 0)
            Slider.UICorner8.Parent = Slider.Circle

            Slider.Title.Font = Enum.Font.GothamMedium
            Slider.Title.Text = title
            Slider.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Slider.Title.TextScaled = true
            Slider.Title.TextSize = 14
            Slider.Title.TextTransparency = 0.5
            Slider.Title.TextXAlignment = Enum.TextXAlignment.Left
            Slider.Title.AnchorPoint = Vector2.new(0, 0.5)
            Slider.Title.BackgroundTransparency = 1
            Slider.Title.BorderSizePixel = 0
            Slider.Title.Position = UDim2.new(0, 0, 0.4, 0)
            Slider.Title.Size = UDim2.new(0, 172, 0, 12)
            Slider.Title.Parent = Slider.Frame

            Slider.Value.Font = Enum.Font.GothamMedium
            Slider.Value.Text = tostring(default)
            Slider.Value.TextColor3 = Color3.fromRGB(255, 255, 255)
            Slider.Value.TextScaled = true
            Slider.Value.TextSize = 14
            Slider.Value.TextTransparency = 0.5
            Slider.Value.TextXAlignment = Enum.TextXAlignment.Right
            Slider.Value.AnchorPoint = Vector2.new(1, 0.5)
            Slider.Value.BackgroundTransparency = 1
            Slider.Value.BorderSizePixel = 0
            Slider.Value.Position = UDim2.new(1, 0, 0.4, 0)
            Slider.Value.Size = UDim2.new(0, 42, 0, 12)
            Slider.Value.Parent = Slider.Frame

            Slider.ValueTextConstraint.MaxTextSize = 12
            Slider.ValueTextConstraint.MinTextSize = 12
            Slider.ValueTextConstraint.Parent = Slider.Value

            local function update_slider(input)
                local drag_size = Slider.Drag.AbsoluteSize.X
                local drag_position = Slider.Drag.AbsolutePosition.X
                local mouse_x = input.Position.X
                local relative_x = math.clamp(mouse_x - drag_position, 0, drag_size)
                local percentage = relative_x / drag_size
                local value = math.floor(Util:map(percentage, 0, 1, min, max) + 0.5)
                Slider.CurrentValue = value
                Slider.Fill.Size = UDim2.new(0, relative_x, 0, 4)
                Slider.Value.Text = tostring(value)
                if callback then
                    callback(value)
                end
            end

            Slider.Frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    update_slider(input)
                    local connection
                    connection = UserInputService.InputChanged:Connect(function(changed_input)
                        if changed_input.UserInputType == Enum.UserInputType.MouseMovement or changed_input.UserInputType == Enum.UserInputType.Touch then
                            update_slider(changed_input)
                        end
                    end)
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            connection:Disconnect()
                        end
                    end)
                end
            end)

            return Slider
        end

        function Module:CreateDropdown(title, options, multi, default, callback)
            local Dropdown = {
                Frame = Instance.new("TextButton"),
                Title = Instance.new("TextLabel"),
                Box = Instance.new("Frame"),
                UICorner5 = Instance.new("UICorner"),
                OptionsFrame = Instance.new("Frame"),
                List = Instance.new("ScrollingFrame"),
                UIListLayout3 = Instance.new("UIListLayout"),
                Header = Instance.new("ImageButton"),
                Arrow = Instance.new("ImageLabel"),
                OptionText = Instance.new("TextLabel"),
                Selected = multi and (default or {}) or (default or options[1]),
                Open = false
            }

            Dropdown.Frame.Font = Enum.Font.SourceSans
            Dropdown.Frame.Text = ""
            Dropdown.Frame.TextColor3 = Color3.fromRGB(0, 0, 0)
            Dropdown.Frame.TextSize = 14
            Dropdown.Frame.AutoButtonColor = false
            Dropdown.Frame.BackgroundTransparency = 1
            Dropdown.Frame.BorderSizePixel = 0
            Dropdown.Frame.Size = UDim2.new(0, 216, 0, 127)
            Dropdown.Frame.Parent = Module.Settings

            local UIPadding1 = Instance.new("UIPadding")
            UIPadding1.PaddingTop = UDim.new(0, 3)
            UIPadding1.Parent = Dropdown.Frame

            Dropdown.Title.Font = Enum.Font.GothamMedium
            Dropdown.Title.Text = title
            Dropdown.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Dropdown.Title.TextScaled = true
            Dropdown.Title.TextSize = 14
            Dropdown.Title.TextTransparency = 0.5
            Dropdown.Title.TextXAlignment = Enum.TextXAlignment.Left
            Dropdown.Title.BackgroundTransparency = 1
            Dropdown.Title.BorderSizePixel = 0
            Dropdown.Title.Size = UDim2.new(0, 215, 0, 12)
            Dropdown.Title.Parent = Dropdown.Frame

            local UITextSizeConstraint3 = Instance.new("UITextSizeConstraint")
            UITextSizeConstraint3.MaxTextSize = 12
            UITextSizeConstraint3.MinTextSize = 12
            UITextSizeConstraint3.Parent = Dropdown.Title

            Dropdown.Box.AnchorPoint = Vector2.new(0.5, 0)
            Dropdown.Box.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
            Dropdown.Box.BackgroundTransparency = 1
            Dropdown.Box.BorderSizePixel = 0
            Dropdown.Box.Position = UDim2.new(0.5, 0, 1.3, 0)
            Dropdown.Box.Size = UDim2.new(0, 218, 0, 18)
            Dropdown.Box.Parent = Dropdown.Title

            Dropdown.UICorner5.CornerRadius = UDim.new(0, 5)
            Dropdown.UICorner5.Parent = Dropdown.Box

            Dropdown.OptionsFrame.AnchorPoint = Vector2.new(0.5, 0)
            Dropdown.OptionsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Dropdown.OptionsFrame.BackgroundTransparency = 1
            Dropdown.OptionsFrame.BorderSizePixel = 0
            Dropdown.OptionsFrame.ClipsDescendants = true
            Dropdown.OptionsFrame.Position = UDim2.new(0.5, 0, 1.1, 0)
            Dropdown.OptionsFrame.Size = UDim2.new(0, 218, 0, 0)
            Dropdown.OptionsFrame.Parent = Dropdown.Box

            Dropdown.List.AutomaticCanvasSize = Enum.AutomaticSize.XY
            Dropdown.List.CanvasSize = UDim2.new(0, 0, 0.5, 0)
            Dropdown.List.ScrollBarImageTransparency = 1
            Dropdown.List.ScrollBarThickness = 0
            Dropdown.List.Active = true
            Dropdown.List.BackgroundTransparency = 1
            Dropdown.List.BorderSizePixel = 0
            Dropdown.List.Position = UDim2.new(0.5, 0, 0, 0)
            Dropdown.List.Size = UDim2.new(0, 218, 0, 85)
            Dropdown.List.Parent = Dropdown.OptionsFrame

            Dropdown.UIListLayout3.HorizontalAlignment = Enum.HorizontalAlignment.Center
            Dropdown.UIListLayout3.Parent = Dropdown.List

            Dropdown.Header.Image = "rbxassetid://70783523951929"
            Dropdown.Header.BackgroundTransparency = 1
            Dropdown.Header.BorderSizePixel = 0
            Dropdown.Header.Position = UDim2.new(0, 0, -0.5, 0)
            Dropdown.Header.Size = UDim2.new(0, 218, 0, 18)
            Dropdown.Header.Parent = Dropdown.Box

            Dropdown.Arrow.Image = "rbxassetid://136776761805636"
            Dropdown.Arrow.ImageTransparency = 0.5
            Dropdown.Arrow.BackgroundTransparency = 1
            Dropdown.Arrow.BorderSizePixel = 0
            Dropdown.Arrow.Position = UDim2.new(0.93, 0, 0.25, 0)
            Dropdown.Arrow.Rotation = -90
            Dropdown.Arrow.Size = UDim2.new(0, 10, 0, 10)
            Dropdown.Arrow.Parent = Dropdown.Header

            Dropdown.OptionText.Font = Enum.Font.GothamMedium
            Dropdown.OptionText.Text = multi and table.concat(Dropdown.Selected, ", ") or Dropdown.Selected
            Dropdown.OptionText.TextColor3 = Color3.fromRGB(255, 255, 255)
            Dropdown.OptionText.TextSize = 12
            Dropdown.OptionText.TextTransparency = 0.5
            Dropdown.OptionText.TextXAlignment = Enum.TextXAlignment.Left
            Dropdown.OptionText.AnchorPoint = Vector2.new(0.5, 0)
            Dropdown.OptionText.BackgroundTransparency = 1
            Dropdown.OptionText.BorderSizePixel = 0
            Dropdown.OptionText.Position = UDim2.new(0.5, 0, 0.1, 0)
            Dropdown.OptionText.Size = UDim2.new(0, 194, 0, 12)
            Dropdown.OptionText.Parent = Dropdown.Header

            local UITextSizeConstraint9 = Instance.new("UITextSizeConstraint")
            UITextSizeConstraint9.MaxTextSize = 12
            UITextSizeConstraint9.MinTextSize = 12
            UITextSizeConstraint9.Parent = Dropdown.OptionText

            local function toggle_dropdown()
                Dropdown.Open = not Dropdown.Open
                local targetSize = Dropdown.Open and UDim2.new(0, 218, 0, 85) or UDim2.new(0, 218, 0, 0)
                TweenService:Create(Dropdown.OptionsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Size = targetSize}):Play()
                TweenService:Create(Dropdown.Arrow, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Rotation = Dropdown.Open and 90 or -90}):Play()
            end

            Dropdown.Header.MouseButton1Click:Connect(toggle_dropdown)

            for _, option in ipairs(options) do
                local Option = Instance.new("TextButton")
                Option.Font = Enum.Font.GothamMedium
                Option.Text = option
                Option.TextColor3 = Color3.fromRGB(255, 255, 255)
                Option.TextSize = 12
                Option.TextTransparency = (multi and table.find(Dropdown.Selected, option)) and 0 or 0.8
                Option.TextXAlignment = Enum.TextXAlignment.Left
                Option.BackgroundTransparency = 1
                Option.BorderSizePixel = 0
                Option.Size = UDim2.new(0, 205, 0, 17)
                Option.ZIndex = 2
                Option.Parent = Dropdown.List

                local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
                UITextSizeConstraint.MaxTextSize = 12
                UITextSizeConstraint.MinTextSize = 12
                UITextSizeConstraint.Parent = Option

                local UIGradient = Instance.new("UIGradient")
                UIGradient.Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.758, 0),
                    NumberSequenceKeypoint.new(0.93, 0.269),
                    NumberSequenceKeypoint.new(1, 1)
                }
                UIGradient.Parent = Option

                Option.MouseButton1Click:Connect(function()
                    if multi then
                        if table.find(Dropdown.Selected, option) then
                            Library:remove_table_value(Dropdown.Selected, option)
                        else
                            table.insert(Dropdown.Selected, option)
                        end
                        Option.TextTransparency = table.find(Dropdown.Selected, option) and 0 or 0.8
                        Dropdown.OptionText.Text = table.concat(Dropdown.Selected, ", ")
                    else
                        Dropdown.Selected = option
                        Dropdown.OptionText.Text = option
                        for _, opt in ipairs(Dropdown.List:GetChildren()) do
                            if opt:IsA("TextButton") then
                                opt.TextTransparency = opt.Text == option and 0 or 0.8
                            end
                        end
                        toggle_dropdown()
                    end
                    if callback then
                        callback(Dropdown.Selected)
                    end
                end)
            end

            return Dropdown
        end

        function Module:CreateKeybind(title, default, callback)
            local Keybind = {
                Frame = Instance.new("TextButton"),
                Background = Instance.new("Frame"),
                UICorner9 = Instance.new("UICorner"),
                String = Instance.new("TextLabel"),
                Delete = Instance.new("ImageLabel"),
                Edit = Instance.new("ImageLabel"),
                Title = Instance.new("TextLabel"),
                CurrentKey = default or "None"
            }

            Keybind.Frame.Font = Enum.Font.SourceSans
            Keybind.Frame.Text = ""
            Keybind.Frame.TextColor3 = Color3.fromRGB(0, 0, 0)
            Keybind.Frame.TextSize = 14
            Keybind.Frame.AutoButtonColor = false
            Keybind.Frame.AnchorPoint = Vector2.new(0, 0.5)
            Keybind.Frame.BackgroundTransparency = 1
            Keybind.Frame.BorderSizePixel = 0
            Keybind.Frame.Position = UDim2.new(0, 0, 0.5, 0)
            Keybind.Frame.Size = UDim2.new(0, 33, 0, 28)
            Keybind.Frame.Parent = Module.Header

            Keybind.Background.AnchorPoint = Vector2.new(0.5, 0.5)
            Keybind.Background.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
            Keybind.Background.BackgroundTransparency = 0.5
            Keybind.Background.BorderSizePixel = 0
            Keybind.Background.Position = UDim2.new(0.5, 0, 0.5, 0)
            Keybind.Background.Size = UDim2.new(0, 20, 0, 20)
            Keybind.Background.Parent = Keybind.Frame

            Keybind.UICorner9.CornerRadius = UDim.new(0, 4)
            Keybind.UICorner9.Parent = Keybind.Background

            Keybind.String.Font = Enum.Font.Gotham
            Keybind.String.Text = default or "None"
            Keybind.String.TextColor3 = Color3.fromRGB(255, 255, 255)
            Keybind.String.TextSize = 11
            Keybind.String.TextTransparency = 0.5
            Keybind.String.AnchorPoint = Vector2.new(0.5, 0.5)
            Keybind.String.BackgroundTransparency = 1
            Keybind.String.BorderSizePixel = 0
            Keybind.String.Position = UDim2.new(0.5, 0, 0.5, 0)
            Keybind.String.Size = UDim2.new(0, 12, 0, 12)
            Keybind.String.Visible = true
            Keybind.String.Parent = Keybind.Background

            Keybind.Delete.Image = "rbxassetid://79831062733212"
            Keybind.Delete.AnchorPoint = Vector2.new(0.5, 0.5)
            Keybind.Delete.BackgroundTransparency = 1
            Keybind.Delete.BorderSizePixel = 0
            Keybind.Delete.Position = UDim2.new(0.5, 0, 0.5, 0)
            Keybind.Delete.Size = UDim2.new(0, 10, 0, 10)
            Keybind.Delete.Visible = false
            Keybind.Delete.Parent = Keybind.Background

            Keybind.Edit.Image = "rbxassetid://10734887784"
            Keybind.Edit.AnchorPoint = Vector2.new(0.5, 0.5)
            Keybind.Edit.BackgroundTransparency = 1
            Keybind.Edit.BorderSizePixel = 0
            Keybind.Edit.Position = UDim2.new(0.5, 0, 0.5, 0)
            Keybind.Edit.Size = UDim2.new(0, 10, 0, 10)
            Keybind.Edit.Visible = true
            Keybind.Edit.Parent = Keybind.Background

            Keybind.Title.Font = Enum.Font.Gotham
            Keybind.Title.Text = title
            Keybind.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Keybind.Title.TextScaled = true
            Keybind.Title.TextSize = 14
            Keybind.Title.TextTransparency = 0.5
            Keybind.Title.TextXAlignment = Enum.TextXAlignment.Left
            Keybind.Title.AnchorPoint = Vector2.new(0, 0.5)
            Keybind.Title.BackgroundTransparency = 1
            Keybind.Title.BorderSizePixel = 0
            Keybind.Title.Position = UDim2.new(1, 0, 0.5, 0)
            Keybind.Title.Size = UDim2.new(0, 156, 0, 12)
            Keybind.Title.Parent = Keybind.Frame

            local UITextSizeConstraint13 = Instance.new("UITextSizeConstraint")
            UITextSizeConstraint13.MaxTextSize = 12
            UITextSizeConstraint13.MinTextSize = 12
            UITextSizeConstraint13.Parent = Keybind.Title

            local binding = false
            Keybind.Frame.MouseButton1Click:Connect(function()
                if binding then return end
                binding = true
                Keybind.String.Text = "..."
                Keybind.Edit.Visible = false
                Keybind.Delete.Visible = true
                local connection
                connection = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        Keybind.CurrentKey = input.KeyCode.Name
                        Keybind.String.Text = input.KeyCode.Name
                        if callback then
                            callback(input.KeyCode.Name)
                        end
                    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Keybind.CurrentKey = "None"
                        Keybind.String.Text = "None"
                        if callback then
                            callback("None")
                        end
                    end
                    binding = false
                    Keybind.Edit.Visible = true
                    Keybind.Delete.Visible = false
                    connection:Disconnect()
                end)
            end)

            return Keybind
        end

        return Module
    end

    return TabManager
end

function Library:update_sections(left_section, right_section)
    for _, section in pairs(Converted["_Sections"]:GetChildren()) do
        section.Visible = section == left_section or section == right_section
    end
end

return Library