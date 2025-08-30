-- ByteUI (ModuleScript)
-- Location: ReplicatedStorage/ByteUI
-- API:
--   local UI = require(path.ByteUI)
--   local win = UI:CreateWindow({ Title = "Byte - 2025" })
--   local tab = win:AddTab({ Name = "Blatant", Icon = "rbxassetid://6031091004" })
--   local sec = tab:AddSection("Auto Parry")
--   sec:AddToggle({ Text="Auto Parry", Default=false, Callback=function(v) end })
--   sec:AddDropdown({ Text="Mode", Options={"Custom","Random","Backwards","Dot"}, Default="Custom", Callback=function(v) end })
--   sec:AddSlider({ Text="Parry_Accuracy", Min=1, Max=10, Default=1, Callback=function(v) end })
--   -- Search: win:SetSearchBar("...")

local ByteUI = {}
ByteUI.__index = ByteUI

-- utilities
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function create(className, props, children)
    local obj = Instance.new(className)
    if props then
        for k, v in pairs(props) do
            obj[k] = v
        end
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = obj
        end
    end
    return obj
end

local function round(num, factor)
    factor = factor or 1
    return math.floor(num / factor + 0.5) * factor
end

-- theme
local Theme = {
    BG = Color3.fromRGB(18,18,18),
    Panel = Color3.fromRGB(27,27,27),
    Panel2 = Color3.fromRGB(33,33,33),
    Stroke = Color3.fromRGB(55,55,55),
    Accent = Color3.fromRGB(120,170,255),
    Text = Color3.fromRGB(230,230,230),
    Muted = Color3.fromRGB(170,170,170),
    Green = Color3.fromRGB(90,200,120),
    Red = Color3.fromRGB(240,90,90)
}

local Icons = {
    Dot = "rbxassetid://7072719186",
    Search = "rbxassetid://7072718362",
    ChevronDown = "rbxassetid://7072719342",
    Check = "rbxassetid://7072721665",
    ToggleOn = "rbxassetid://7072721395",
    ToggleOff = "rbxassetid://7072721406"
}

-- dragging helper
local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Window object
local Window = {}
Window.__index = Window

function ByteUI:CreateWindow(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "Byte - 2025"

    local screenGui = create("ScreenGui", {
        Name = "ByteUI",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
    })

    if syn and syn.protect_gui then pcall(syn.protect_gui, screenGui) end
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- root
    local main = create("Frame", {
        Name = "Main",
        Parent = screenGui,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(760, 420),
        BackgroundColor3 = Theme.Panel,
        BackgroundTransparency = 0.05,
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 12) }),
        create("UIStroke", { Color = Theme.Stroke, Thickness = 1, Transparency = 0.25 }),
    })

    -- subtle gradient
    create("UIGradient", {
        Parent = main,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(26,26,26)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(20,20,20)),
        })
    })

    -- TopBar
    local topBar = create("Frame", {
        Name = "TopBar",
        Parent = main,
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Theme.Panel2,
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 12) }),
        create("UIStroke", { Color = Theme.Stroke, Thickness = 1, Transparency = 0.35 }),
    })

    local titleLabel = create("TextLabel", {
        Parent = topBar,
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 0),
        Size = UDim2.new(0, 200, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    -- Search box (top-right)
    local search = create("TextBox", {
        Parent = topBar,
        PlaceholderText = "Search",
        Text = "",
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = Theme.Text,
        PlaceholderColor3 = Theme.Muted,
        BackgroundColor3 = Theme.Panel,
        Size = UDim2.fromOffset(220, 28),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -14, 0.5, 0),
        ClearTextOnFocus = false,
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 8) }),
        create("UIStroke", { Color = Theme.Stroke, Transparency = 0.35 }),
        create("UIPadding", { PaddingLeft = UDim.new(0, 30), PaddingRight = UDim.new(0, 8) }),
    })

    -- search icon
    local sIcon = create("ImageLabel", {
        Parent = search,
        BackgroundTransparency = 1,
        Image = Icons.Search,
        Size = UDim2.fromOffset(16,16),
        Position = UDim2.new(0, 8, 0.5, -8),
    })

    -- Sidebar
    local side = create("Frame", {
        Name = "Sidebar",
        Parent = main,
        Position = UDim2.new(0, 0, 0, 44),
        Size = UDim2.new(0, 180, 1, -44),
        BackgroundColor3 = Theme.Panel,
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 12) }),
        create("UIStroke", { Color = Theme.Stroke, Thickness = 1, Transparency = 0.35 }),
    })

    local sideList = create("UIListLayout", {
        Parent = side,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
    })

    create("UIPadding", { Parent = side, PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10) })

    -- Content panel (right)
    local content = create("Frame", {
        Name = "Content",
        Parent = main,
        Position = UDim2.new(0, 188, 0, 52),
        Size = UDim2.new(1, -196, 1, -60),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
    })

    local tabFolder = create("Folder", { Parent = content, Name = "Tabs" })

    makeDraggable(main, topBar)

    -- actual Window object
    local self = setmetatable({
        _gui = screenGui,
        Main = main,
        TopBar = topBar,
        Sidebar = side,
        Content = content,
        TabsFolder = tabFolder,
        SearchBox = search,
        _tabs = {},
        _theme = Theme,
    }, Window)

    -- live search (hides controls that don't match)
    search:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(search.Text)
        for _, tab in pairs(self._tabs) do
            for _, control in pairs(tab._controls) do
                local label = control._searchText or ""
                local match = (query == "") or string.find(string.lower(label), query, 1, true)
                control._root.Visible = match ~= nil
            end
        end
    end)

    return self
end

-- Tabs
local Tab = {}
Tab.__index = Tab

function Window:AddTab(opts)
    opts = opts or {}
    local name = opts.Name or "Tab"
    local icon = opts.Icon or Icons.Dot

    -- button in sidebar
    local btn = create("TextButton", {
        Parent = self.Sidebar,
        Size = UDim2.new(1, -4, 0, 36),
        BackgroundColor3 = self._theme.Panel2,
        Text = "",
        AutoButtonColor = true,
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 10) }),
        create("UIStroke", { Color = self._theme.Stroke, Transparency = 0.4 }),
    })

    local ic = create("ImageLabel", {
        Parent = btn,
        BackgroundTransparency = 1,
        Image = icon,
        Size = UDim2.fromOffset(18,18),
        Position = UDim2.new(0, 10, 0.5, -9),
    })

    local lbl = create("TextLabel", {
        Parent = btn,
        BackgroundTransparency = 1,
        Text = name,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = self._theme.Text,
        Position = UDim2.new(0, 36, 0, 0),
        Size = UDim2.new(1, -40, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    -- content page
    local page = create("ScrollingFrame", {
        Parent = self.TabsFolder,
        Name = name .. "_Page",
        Active = true,
        Visible = false,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0,0,0,0),
        ScrollBarThickness = 4,
        BorderSizePixel = 0,
    })

    local layout = create("UIListLayout", {
        Parent = page,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
    })

    create("UIPadding", {
        Parent = page,
        PaddingTop = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 12),
    })

    local tabObj = setmetatable({
        _window = self,
        _button = btn,
        _page = page,
        _controls = {},
        Name = name
    }, Tab)

    -- Sidebar button logic
    local function activate()
        for _, t in pairs(self._tabs) do
            t._page.Visible = false
            t._button.BackgroundColor3 = self._theme.Panel2
        end
        page.Visible = true
        btn.BackgroundColor3 = self._theme.Panel
    end

    btn.MouseButton1Click:Connect(activate)

    -- select the first added tab by default
    if #self._tabs == 0 then
        activate()
    end

    table.insert(self._tabs, tabObj)
    return tabObj
end

-- Sections (a titled block)
function Tab:AddSection(title)
    local card = create("Frame", {
        Parent = self._page,
        BackgroundColor3 = self._window._theme.Panel,
        Size = UDim2.new(1, -6, 0, 64),
        AutomaticSize = Enum.AutomaticSize.Y,
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 10) }),
        create("UIStroke", { Color = self._window._theme.Stroke, Transparency = 0.35 }),
        create("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10) }),
    })

    local header = create("TextLabel", {
        Parent = card,
        Text = title or "",
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextColor3 = self._window._theme.Muted,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local list = create("UIListLayout", {
        Parent = card,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
    })

    local sec = {
        _tab = self,
        _card = card,
        _container = card,
        _window = self._window
    }

    function sec:_addControl(root, searchText)
        root.Parent = self._container
        local control = { _root = root, _searchText = searchText }
        table.insert(self._tab._controls, control)
        return control
    end

    -- Toggle
    function sec:AddToggle(opts)
        opts = opts or {}
        local text = opts.Text or "Toggle"
        local default = opts.Default or false
        local callback = opts.Callback or function() end

        local btn = create("TextButton", {
            BackgroundColor3 = self._window._theme.Panel2,
            Size = UDim2.new(1, 0, 0, 36),
            Text = "",
            AutoButtonColor = true,
        }, {
            create("UICorner", { CornerRadius = UDim.new(0, 8) }),
            create("UIStroke", { Color = self._window._theme.Stroke, Transparency = 0.45 }),
        })

        local label = create("TextLabel", {
            Parent = btn,
            BackgroundTransparency = 1,
            Text = text,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = self._window._theme.Text,
            Size = UDim2.new(1, -44, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local icon = create("ImageLabel", {
            Parent = btn,
            BackgroundTransparency = 1,
            Image = default and Icons.ToggleOn or Icons.ToggleOff,
            Size = UDim2.fromOffset(28, 28),
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -6, 0.5, 0),
        })

        local state = default
        btn.MouseButton1Click:Connect(function()
            state = not state
            icon.Image = state and Icons.ToggleOn or Icons.ToggleOff
            task.spawn(callback, state)
        end)

        local c = self:_addControl(btn, text)
        c.Get = function() return state end
        c.Set = function(v)
            state = not not v
            icon.Image = state and Icons.ToggleOn or Icons.ToggleOff
            task.spawn(callback, state)
        end
        return c
    end

    -- Dropdown
    function sec:AddDropdown(opts)
        opts = opts or {}
        local text = opts.Text or "Dropdown"
        local options = opts.Options or {}
        local default = opts.Default or options[1]
        local callback = opts.Callback or function() end

        local root = create("Frame", {
            BackgroundColor3 = self._window._theme.Panel2,
            Size = UDim2.new(1, 0, 0, 70),
        }, {
            create("UICorner", { CornerRadius = UDim.new(0, 8) }),
            create("UIStroke", { Color = self._window._theme.Stroke, Transparency = 0.45 }),
        })

        local label = create("TextLabel", {
            Parent = root,
            BackgroundTransparency = 1,
            Text = text,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = self._window._theme.Text,
            Size = UDim2.new(1, -16, 0, 22),
            Position = UDim2.new(0, 10, 0, 6),
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local box = create("TextButton", {
            Parent = root,
            Text = tostring(default or ""),
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = self._window._theme.Text,
            BackgroundColor3 = self._window._theme.Panel,
            AutoButtonColor = true,
            Size = UDim2.new(1, -16, 0, 28),
            Position = UDim2.new(0, 8, 0, 34),
        }, {
            create("UICorner", { CornerRadius = UDim.new(0, 8) }),
            create("UIStroke", { Color = self._window._theme.Stroke, Transparency = 0.4 }),
        })

        local chev = create("ImageLabel", {
            Parent = box,
            BackgroundTransparency = 1,
            Image = Icons.ChevronDown,
            Size = UDim2.fromOffset(16,16),
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -8, 0.5, 0),
        })

        local listBG = create("Frame", {
            Parent = root,
            BackgroundColor3 = self._window._theme.Panel,
            Size = UDim2.new(1, -16, 0, 110),
            Position = UDim2.new(0, 8, 0, 66),
            Visible = false,
            ZIndex = 5,
        }, {
            create("UICorner", { CornerRadius = UDim.new(0, 8) }),
            create("UIStroke", { Color = self._window._theme.Stroke, Transparency = 0.3 }),
        })

        local listScroll = create("ScrollingFrame", {
            Parent = listBG,
            Active = true,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0,0,0,0),
            ScrollBarThickness = 4,
            BorderSizePixel = 0,
        })
        create("UIListLayout", { Parent = listScroll, Padding = UDim.new(0, 4) })
        create("UIPadding", { Parent = listScroll, PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 6) })

        local function rebuild()
            listScroll:ClearAllChildren()
            create("UIListLayout", { Parent = listScroll, Padding = UDim.new(0, 4) })
            create("UIPadding", { Parent = listScroll, PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 6) })
            for _, opt in ipairs(options) do
                local item = create("TextButton", {
                    Parent = listScroll,
                    Size = UDim2.new(1, 0, 0, 26),
                    BackgroundColor3 = (opt == default) and self._window._theme.Panel2 or self._window._theme.Panel,
                    Text = tostring(opt),
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    TextColor3 = self._window._theme.Text,
                    AutoButtonColor = true,
                }, {
                    create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                    create("UIStroke", { Color = self._window._theme.Stroke, Transparency = 0.5 }),
                })
                item.MouseButton1Click:Connect(function()
                    default = opt
                    box.Text = tostring(default)
                    listBG.Visible = false
                    task.spawn(callback, default)
                    rebuild()
                end)
            end
            listScroll.CanvasSize = UDim2.new(0, 0, 0, #options * 30 + 12)
        end
        rebuild()

        box.MouseButton1Click:Connect(function()
            listBG.Visible = not listBG.Visible
        end)

        local c = self:_addControl(root, text .. " " .. table.concat(options, " "))
        c.SetOptions = function(newList)
            options = newList
            rebuild()
        end
        c.Get = function() return default end
        c.Set = function(v)
            default = v
            box.Text = tostring(default)
            task.spawn(callback, default)
            rebuild()
        end
        return c
    end

    -- Slider
    function sec:AddSlider(opts)
        opts = opts or {}
        local text = opts.Text or "Slider"
        local min = opts.Min or 0
        local max = opts.Max or 100
        local default = math.clamp(opts.Default or min, min, max)
        local step = opts.Step or 1
        local callback = opts.Callback or function() end

        local root = create("Frame", {
            BackgroundColor3 = self._window._theme.Panel2,
            Size = UDim2.new(1, 0, 0, 50),
        }, {
            create("UICorner", { CornerRadius = UDim.new(0, 8) }),
            create("UIStroke", { Color = self._window._theme.Stroke, Transparency = 0.45 }),
        })

        local label = create("TextLabel", {
            Parent = root,
            BackgroundTransparency = 1,
            Text = string.format("%s  %s", text, tostring(default)),
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = self._window._theme.Text,
            Size = UDim2.new(1, -16, 0, 20),
            Position = UDim2.new(0, 10, 0, 6),
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local bar = create("Frame", {
            Parent = root,
            BackgroundColor3 = self._window._theme.Panel,
            Size = UDim2.new(1, -20, 0, 6),
            Position = UDim2.new(0, 10, 0, 34),
        }, {
            create("UICorner", { CornerRadius = UDim.new(0, 6) }),
            create("UIStroke", { Color = self._window._theme.Stroke, Transparency = 0.6 }),
        })

        local fill = create("Frame", {
            Parent = bar,
            BackgroundColor3 = self._window._theme.Accent,
            Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        }, { create("UICorner", { CornerRadius = UDim.new(0, 6) }) })

        local dragging = false
        local function setFromX(x)
            local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local raw = min + rel * (max - min)
            local snapped = round(raw, step)
            snapped = math.clamp(snapped, min, max)
            fill.Size = UDim2.new((snapped - min) / (max - min), 0, 1, 0)
            label.Text = string.format("%s  %s", text, tostring(snapped))
            default = snapped
            task.spawn(callback, snapped)
        end

        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                setFromX(input.Position.X)
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        bar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                setFromX(input.Position.X)
            end
        end)

        local c = self:_addControl(root, text)
        c.Get = function() return default end
        c.Set = function(v)
            v = math.clamp(v, min, max)
            fill.Size = UDim2.new((v - min) / (max - min), 0, 1, 0)
            label.Text = string.format("%s  %s", text, tostring(v))
            default = v
            task.spawn(callback, v)
        end
        return c
    end

    return sec
end

function Window:SetSearchBar(text)
    self.SearchBox.Text = text or ""
end

return setmetatable({}, ByteUI)
