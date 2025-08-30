-- ByteUI (ModuleScript)
-- Place in ReplicatedStorage as "ByteUI"
-- Polished visual library: CreateWindow, AddTab, AddSection, AddToggle, AddDropdown, AddSlider

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ByteUI = {}
ByteUI.__index = ByteUI

-- small utility
local function create(className, props, children)
    local obj = Instance.new(className)
    if props then
        for k, v in pairs(props) do obj[k] = v end
    end
    if children then
        for _, c in ipairs(children) do c.Parent = obj end
    end
    return obj
end

local function cloneProps(tbl) local out = {} for k,v in pairs(tbl) do out[k]=v end return out end

local function safeParent(gui)
    local success, pg = pcall(function() return LocalPlayer:WaitForChild("PlayerGui", 5) end)
    if success and pg then
        gui.Parent = pg
    else
        gui.Parent = game:GetService("CoreGui") -- last resort (may need exploit env)
    end
end

-- Theme
local Theme = {
    BG = Color3.fromRGB(14,14,14),
    Panel = Color3.fromRGB(26,26,26),
    Panel2 = Color3.fromRGB(34,34,34),
    Stroke = Color3.fromRGB(60,60,60),
    Accent = Color3.fromRGB(96,160,255),
    Muted = Color3.fromRGB(155,155,155),
    Text = Color3.fromRGB(232,232,232),
    Shadow = Color3.fromRGB(0,0,0)
}

-- Icon assets (swap if you want different)
local ICONS = {
    Dot = "rbxassetid://7072719186",
    Search = "rbxassetid://7072718362",
    Chevron = "rbxassetid://7072719342",
    ToggleOn = "rbxassetid://7072721395",
    ToggleOff = "rbxassetid://7072721406",
    Check = "rbxassetid://7072721665"
}

-- Drag helper
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

-- small tween wrapper
local function tTween(object, props, info)
    info = info or TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tw = TweenService:Create(object, info, props)
    tw:Play()
    return tw
end

-- create the main window
function ByteUI:CreateWindow(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "Byte - 2025"

    local screenGui = create("ScreenGui", {
        Name = "ByteUI",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
    })

    -- try protect (exploit env compatibility)
    if syn and syn.protect_gui then
        pcall(syn.protect_gui, screenGui)
    end

    -- Root + shadow
    local root = create("Frame", {
        Name = "Root",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(820, 460),
        BackgroundTransparency = 1,
    })

    local shadow = create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://4593978981", -- subtle shadow image (works as overlay)
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(20,20,180,180),
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        AnchorPoint = Vector2.new(0,0),
        ImageColor3 = Color3.new(0,0,0),
        ImageTransparency = 0.7,
    })

    local main = create("Frame", {
        Name = "Main",
        BackgroundColor3 = Theme.Panel,
        BackgroundTransparency = 0.02,
        Size = UDim2.new(1, 0, 1, 0),
        ClipsDescendants = true,
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 12) }),
    })

    -- glass overlay effect: gradient + noise texture
    local glass = create("ImageLabel", {
        Name = "Glass",
        BackgroundTransparency = 1,
        Image = "rbxassetid://7030150859", -- optional subtle noise texture (replace if needed)
        ImageTransparency = 0.88,
        Size = UDim2.new(1,0,1,0),
    }, {
        create("UIGradient", { Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(28,28,28)), ColorSequenceKeypoint.new(1, Color3.fromRGB(22,22,22)) }) }),
    })

    -- inner panel with stroke
    local inner = create("Frame", {
        Name = "Inner",
        Size = UDim2.new(1, -8, 1, -8),
        Position = UDim2.new(0, 4, 0, 4),
        BackgroundColor3 = Theme.Panel2,
        BackgroundTransparency = 0.03,
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 10) }),
        create("UIStroke", { Color = Theme.Stroke, Transparency = 0.35 })
    })

    -- Top bar
    local topBar = create("Frame", {
        Name = "TopBar",
        Parent = inner,
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundTransparency = 1,
    })

    local titleLbl = create("TextLabel", {
        Parent = topBar,
        Text = title,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Theme.Text,
        Position = UDim2.new(0, 18, 0, 10),
        Size = UDim2.new(0.6, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    -- search bar (right aligned)
    local searchBoxBg = create("Frame", {
        Parent = topBar,
        Size = UDim2.new(0, 260, 0, 30),
        Position = UDim2.new(1, -18-260, 0, 9),
        BackgroundColor3 = Theme.Panel,
    }, {
        create("UICorner", { CornerRadius = UDim.new(0,8) }),
        create("UIStroke", { Color = Theme.Stroke, Transparency = 0.4 })
    })

    local searchIcon = create("ImageLabel", {
        Parent = searchBoxBg,
        Image = ICONS.Search,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0, 10, 0.5, -9)
    })

    local searchBox = create("TextBox", {
        Parent = searchBoxBg,
        BackgroundTransparency = 1,
        PlaceholderText = "Search",
        Text = "",
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = Theme.Text,
        Size = UDim2.new(1, -36, 1, 0),
        Position = UDim2.new(0, 36, 0, 0),
        ClearTextOnFocus = false,
    })

    -- layout structure
    local leftWidth = 200
    local sidebar = create("Frame", {
        Parent = inner,
        Size = UDim2.new(0, leftWidth, 1, -64),
        Position = UDim2.new(0, 12, 0, 56),
        BackgroundTransparency = 1,
    })

    local sidebarCard = create("Frame", {
        Parent = sidebar,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.Panel,
    }, {
        create("UICorner",{ CornerRadius = UDim.new(0, 10) }),
        create("UIStroke",{ Color = Theme.Stroke, Transparency = 0.45 }),
    })

    local sideList = create("UIListLayout", { Parent = sidebarCard, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,8) })
    create("UIPadding", { Parent = sidebarCard, PaddingTop = UDim.new(0,10), PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10) })

    local content = create("Frame", {
        Parent = inner,
        Size = UDim2.new(1, -leftWidth - 44, 1, -72),
        Position = UDim2.new(0, leftWidth + 24, 0, 56),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
    })

    -- tabs folder (each tab is a page inside)
    local pages = create("Folder", { Parent = content, Name = "Pages" })

    -- instantiate GUI hierarchy
    root.Parent = screenGui
    shadow.Parent = root
    main.Parent = root
    glass.Parent = main
    inner.Parent = main

    -- attempt to parent to PlayerGui
    safeParent(screenGui)

    makeDraggable(root, topBar)

    -- Window object to return
    local win = setmetatable({
        _screen = screenGui,
        _root = root,
        _main = main,
        _inner = inner,
        _topBar = topBar,
        _sidebar = sidebarCard,
        _content = content,
        _pages = pages,
        _tabs = {},
        _controls = {},
        _theme = Theme,
        _searchBox = searchBox
    }, { __index = ByteUI })

    -- Search functionality: hides controls that don't match query
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = string.lower(searchBox.Text)
        for _, ctl in pairs(win._controls) do
            local lbl = ctl._searchText or ""
            local visible = (q == "") or (string.find(string.lower(lbl), q, 1, true) ~= nil)
            ctl._root.Visible = visible
        end
    end)

    return win
end

-- Add a new tab: returns a Tab object
function ByteUI:AddTab(opts)
    opts = opts or {}
    local name = opts.Name or "Tab"
    local icon = opts.Icon

    -- sidebar button
    local btn = create("TextButton", {
        Parent = self._sidebar,
        Size = UDim2.new(1, -6, 0, 42),
        BackgroundColor3 = self._theme.Panel2,
        AutoButtonColor = true,
        Text = "",
    }, {
        create("UICorner", { CornerRadius = UDim.new(0,8) }),
        create("UIStroke", { Color = self._theme.Stroke, Transparency = 0.5 })
    })

    local ic = create("ImageLabel", {
        Parent = btn,
        Image = icon or ICONS.Dot,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 10, 0.5, -10)
    })

    local lbl = create("TextLabel", {
        Parent = btn,
        Text = name,
        BackgroundTransparency = 1,
        TextColor3 = self._theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        Position = UDim2.new(0, 40, 0, 0),
        Size = UDim2.new(1, -44, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- page
    local page = create("ScrollingFrame", {
        Parent = self._pages,
        Name = name .. "_Page",
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,1,0),
        CanvasSize = UDim2.new(0,0,0,0),
        ScrollBarThickness = 6,
        Visible = false,
        Active = true,
    })

    local pad = create("UIPadding", { Parent = page, PaddingLeft = UDim.new(0, 6), PaddingTop = UDim.new(0, 8), PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 12) })
    local layout = create("UIListLayout", { Parent = page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12) })

    local tabObj = {
        _button = btn,
        _label = lbl,
        _icon = ic,
        _page = page,
        _controls = {},
        Name = name,
        ParentWindow = self
    }

    -- when clicked, activate tab
    btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(self._tabs) do
            t._page.Visible = false
            t._button.BackgroundColor3 = self._theme.Panel2
        end
        page.Visible = true
        btn.BackgroundColor3 = self._theme.Panel
    end)

    -- first tab auto-select
    if #self._tabs == 0 then
        btn:CaptureFocus()
        btn.BackgroundColor3 = self._theme.Panel
        page.Visible = true
    end

    table.insert(self._tabs, tabObj)
    return tabObj
end

-- Add a section (card) inside a tab
function ByteUI:AddSectionTo(tabObj, title)
    local card = create("Frame", {
        Parent = tabObj._page,
        BackgroundColor3 = self._theme.Panel,
        Size = UDim2.new(1, 0, 0, 96),
        AutomaticSize = Enum.AutomaticSize.Y,
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 10) }),
        create("UIStroke", { Color = self._theme.Stroke, Transparency = 0.44 })
    })

    local lbl = create("TextLabel", {
        Parent = card,
        Text = title or "",
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = self._theme.Muted,
        Position = UDim2.new(0, 12, 0, 8),
        Size = UDim2.new(1, -24, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local cont = create("Frame", {
        Parent = card,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 36),
        Size = UDim2.new(1, -24, 0, 40),
    })

    local layout = create("UIListLayout", { Parent = cont, FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Left, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 12) })

    local sec = {
        _card = card,
        _container = cont,
        _title = title,
        _tab = tabObj,
        _window = self
    }

    -- internal helper to register controls for search/visibility
    function sec:_registerControl(root, text)
        root.Parent = self._container
        local control = { _root = root, _searchText = text or "" }
        table.insert(self._tab._controls, control)
        table.insert(self._window._controls, control)
        return control
    end

    -- Toggle (stylish switch)
    function sec:AddToggle(opts)
        opts = opts or {}
        local text = opts.Text or "Toggle"
        local default = opts.Default or false
        local cb = opts.Callback or function() end

        local holder = create("Frame", { Size = UDim2.new(0, 260, 1, 0), BackgroundTransparency = 1 })
        local btn = create("TextButton", {
            Parent = holder,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = self._window._theme.Panel2,
            AutoButtonColor = false,
            Text = "",
        }, {
            create("UICorner", { CornerRadius = UDim.new(0,8) }),
            create("UIStroke", { Color = self._window._theme.Stroke, Transparency = 0.6 })
        })

        local label = create("TextLabel", {
            Parent = btn,
            Text = text,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = self._window._theme.Text,
            Position = UDim2.new(0, 12, 0, 0),
            Size = UDim2.new(1, -92, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left
        })

        -- switch
        local switchBg = create("Frame", {
            Parent = btn,
            Size = UDim2.new(0, 56, 0, 28),
            Position = UDim2.new(1, -70, 0.5, -14),
            BackgroundColor3 = Color3.fromRGB(60,60,60)
        }, { create("UICorner", { CornerRadius = UDim.new(0, 14) }) })

        local knob = create("Frame", {
            Parent = switchBg,
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(default and 1 or 0, -26, 0.5, -12),
            BackgroundColor3 = default and self._window._theme.Accent or Color3.fromRGB(220,220,220)
        }, { create("UICorner",{ CornerRadius = UDim.new(0,12) }) })

        -- initialize visuals
        switchBg.BackgroundColor3 = default and Color3.fromRGB(28,72,140) or Color3.fromRGB(60,60,60)

        local state = default
        btn.MouseButton1Click:Connect(function()
            state = not state
            local targetX = state and UDim.new(1, -26) or UDim.new(0, 0)
            tTween(knob, { Position = UDim2.new(targetX.Scale, targetX.Offset, 0.5, -12) })
            switchBg.BackgroundColor3 = state and self._window._theme.Accent or Color3.fromRGB(60,60,60)
            knob.BackgroundColor3 = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(220,220,220)
            task.spawn(cb, state)
        end)

        local control = sec:_registerControl(holder, text)
        control.Set = function(v) if v ~= state then btn:CaptureFocus(); btn:MouseButton1Click() end end
        control.Get = function() return state end
        return control
    end

    -- Dropdown (clean, animated)
    function sec:AddDropdown(opts)
        opts = opts or {}
        local text = opts.Text or "Dropdown"
        local options = opts.Options or {}
        local default = opts.Default or options[1]
        local cb = opts.Callback or function() end

        local holder = create("Frame", { Size = UDim2.new(0, 260, 0, 36), BackgroundTransparency = 1 })
        local mainBtn = create("TextButton", {
            Parent = holder,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = self._window._theme.Panel2,
            AutoButtonColor = false,
            Text = "",
        }, {
            create("UICorner", { CornerRadius = UDim.new(0,8) }),
            create("UIStroke", { Color = self._window._theme.Stroke, Transparency = 0.45 })
        })

        local label = create("TextLabel", {
            Parent = mainBtn,
            Text = text,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = self._window._theme.Text,
            Position = UDim2.new(0, 12, 0, 0),
            Size = UDim2.new(1, -48, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local valueLabel = create("TextLabel", {
            Parent = mainBtn,
            Text = tostring(default or ""),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = self._window._theme.Muted,
            Position = UDim2.new(1, -36, 0, 0),
            Size = UDim2.new(0, 120, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Right
        })

        local caret = create("ImageLabel", {
            Parent = mainBtn,
            Image = ICONS.Chevron,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 12, 0, 12),
            Position = UDim2.new(1, -16, 0.5, -6)
        })

        local listBG = create("Frame", {
            Parent = holder,
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 0, 1, 6),
            BackgroundColor3 = self._window._theme.Panel,
            Visible = false,
            ZIndex = 20
        }, {
            create("UICorner", { CornerRadius = UDim.new(0,8) }),
            create("UIStroke", { Color = self._window._theme.Stroke, Transparency = 0.45 })
        })

        local scroll = create("ScrollingFrame", {
            Parent = listBG,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            CanvasSize = UDim2.new(0,0,0,0),
            ScrollBarThickness = 6,
            Active = true,
        })
        local layout = create("UIListLayout", { Parent = scroll, Padding = UDim.new(0,6) })
        create("UIPadding", { Parent = scroll, PaddingTop = UDim.new(0,8), PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10), PaddingBottom = UDim.new(0,8) })

        local function rebuild()
            -- clear children
            for _, v in ipairs(scroll:GetChildren()) do if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then v:Destroy() end end
            for i, opt in ipairs(options) do
                local item = create("TextButton", {
                    Parent = scroll,
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 0,
                    AutoButtonColor = false,
                    Text = tostring(opt),
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    TextColor3 = self._window._theme.Text
                }, {
                    create("UICorner", { CornerRadius = UDim.new(0,6) })
                })
                item.MouseButton1Click:Connect(function()
                    default = opt
                    valueLabel.Text = tostring(default)
                    listBG.Visible = false
                    tTween(caret, { Rotation = 0 })
                    task.spawn(cb, default)
                end)
            end
            local count = #options
            listBG.Size = UDim2.new(1, 0, 0, math.clamp(count * 36 + 12, 0, 220))
            scroll.CanvasSize = UDim2.new(0, 0, 0, count * 36 + 6)
        end
        rebuild()

        local opened = false
        mainBtn.MouseButton1Click:Connect(function()
            opened = not opened
            listBG.Visible = opened
            tTween(caret, { Rotation = opened and 180 or 0 }, TweenInfo.new(0.2))
        end)

        local control = sec:_registerControl(holder, text .. " " .. table.concat(options, " "))
        control.Get = function() return default end
        control.Set = function(v) default = v valueLabel.Text = tostring(v) task.spawn(cb, v) end
        control.SetOptions = function(newopts) options = cloneProps(newopts) rebuild() end
        return control
    end

    -- Slider
    function sec:AddSlider(opts)
        opts = opts or {}
        local text = opts.Text or "Slider"
        local min = opts.Min or 0
        local max = opts.Max or 100
        local step = opts.Step or 1
        local default = math.clamp(opts.Default or min, min, max)
        local cb = opts.Callback or function() end

        local holder = create("Frame", { Size = UDim2.new(0, 360, 0, 42), BackgroundTransparency = 1 })
        local bg = create("Frame", { Parent = holder, BackgroundColor3 = self._window._theme.Panel2, Size = UDim2.new(1, 0, 1, 0) }, {
            create("UICorner",{ CornerRadius = UDim.new(0,8) }),
            create("UIStroke",{ Color = self._window._theme.Stroke, Transparency = 0.45 })
        })

        local label = create("TextLabel", {
            Parent = bg,
            Text = text .. "  " .. tostring(default),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = self._window._theme.Text,
            Position = UDim2.new(0, 12, 0, 4),
            Size = UDim2.new(1, -24, 0, 18),
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local barBg = create("Frame", {
            Parent = bg,
            Size = UDim2.new(1, -24, 0, 10),
            Position = UDim2.new(0, 12, 0, 24),
            BackgroundColor3 = Color3.fromRGB(46,46,46)
        }, { create("UICorner", { CornerRadius = UDim.new(0,6) }) })

        local fill = create("Frame", {
            Parent = barBg,
            Size = UDim2.new((default - min) / math.max(1, (max - min)), 0, 1, 0),
            BackgroundColor3 = self._window._theme.Accent,
        }, { create("UICorner",{ CornerRadius = UDim.new(0,6) }) })

        local knob = create("ImageButton", {
            Parent = barBg,
            Size = UDim2.new(0, 18, 0, 18),
            BackgroundTransparency = 1,
            Image = "rbxassetid://3926305904",
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(8,8,24,24),
        })
        knob.Position = UDim2.new(fill.Size.X.Scale, -9, 0.5, -9)

        local dragging = false
        local function setFromX(x)
            local left = barBg.AbsolutePosition.X
            local width = barBg.AbsoluteSize.X
            local rel = math.clamp((x - left) / width, 0, 1)
            local raw = min + rel * (max - min)
            local snapped = math.floor(raw/step+0.5)*step
            snapped = math.clamp(snapped, min, max)
            fill.Size = UDim2.new((snapped - min) / math.max(1, (max - min)), 0, 1, 0)
            knob.Position = UDim2.new(fill.Size.X.Scale, -9, 0.5, -9)
            label.Text = text .. "  " .. tostring(snapped)
            default = snapped
            task.spawn(cb, snapped)
        end

        barBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                setFromX(input.Position.X)
                input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
            end
        end)
        barBg.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                setFromX(input.Position.X)
            end
        end)

        local control = sec:_registerControl(holder, text)
        control.Get = function() return default end
        control.Set = function(v) default = math.clamp(v, min, max) setFromX(barBg.AbsolutePosition.X + fill.AbsoluteSize.X) end
        return control
    end

    return sec
end

-- Shortcuts to use (keeps compatibility)
function ByteUI:AddTab(opts) return ByteUI.AddTab(self, opts) end
function ByteUI:AddSection(tabObj, title) return ByteUI.AddSectionTo(self, tabObj, title) end

-- Convenience wrappers for users who call win:AddTab():AddSection()
-- We'll add methods on tab objects so user code matches earlier examples.
setmetatable(ByteUI, { __index = function(_, k) return rawget(ByteUI, k) end })

-- Helper: allow older API (tab:AddSection(...))
-- We create a metatable in AddTab return to host methods.
local oldAddTab = ByteUI.AddTab
function ByteUI:AddTab(opts)
    local tabObj = oldAddTab(self, opts)
    -- wrap tabObj into a table that provides tab:AddSection
    local wrapper = setmetatable({
        _button = tabObj._button,
        _label = tabObj._label,
        _icon = tabObj._icon,
        _page = tabObj._page,
        _controls = tabObj._controls,
        Name = tabObj.Name,
        ParentWindow = tabObj.ParentWindow
    }, {
        __index = function(t, key)
            if key == "AddSection" then
                return function(_, title)
                    return self:AddSectionTo(t, title)
                end
            else
                return tabObj[key]
            end
        end
    })
    -- replace tab in internal list for consistency
    for i,v in ipairs(self._tabs) do
        if v == tabObj then self._tabs[i] = wrapper break end
    end
    return wrapper
end

return ByteUI
