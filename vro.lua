-- Flow UI Library
-- This is a simple Roblox UI library based on the provided structure.
-- It creates a customizable UI with tabs, modules, dropdowns, sliders, and keybinds.
-- Functionality has been added for interactions like toggling, selecting, dragging, and binding keys.

local FlowLibrary = {}

function FlowLibrary:CreateWindow(clientName)
    local Flow = Instance.new("ScreenGui")
    Flow.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Flow.Name = "Flow"
    Flow.Parent = game:GetService("CoreGui")

    local Container = Instance.new("Frame")
    Container.Active = true
    Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Container.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
    Container.BackgroundTransparency = 0.1
    Container.BorderSizePixel = 0
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.Size = UDim2.new(0, 640, 0, 355)
    Container.Name = "Container"
    Container.Parent = Flow

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Container

    local Header = Instance.new("Frame")
    Header.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
    Header.BackgroundTransparency = 0.5
    Header.BorderSizePixel = 0
    Header.Position = UDim2.new(0.0125, 0, 0.0225, 0)
    Header.Size = UDim2.new(0, 624, 0, 24)
    Header.Name = "Header"
    Header.Parent = Container

    local UICorner1 = Instance.new("UICorner")
    UICorner1.CornerRadius = UDim.new(0, 5)
    UICorner1.Parent = Header

    local Client = Instance.new("TextLabel")
    Client.Font = Enum.Font.Unknown
    Client.Text = clientName or "Flow"
    Client.TextColor3 = Color3.fromRGB(255, 255, 255)
    Client.TextScaled = true
    Client.TextSize = 14
    Client.TextWrapped = true
    Client.TextXAlignment = Enum.TextXAlignment.Left
    Client.AnchorPoint = Vector2.new(0, 0.5)
    Client.BackgroundTransparency = 1
    Client.BorderSizePixel = 0
    Client.Position = UDim2.new(0.044, 0, 0.5, 0)
    Client.Size = UDim2.new(0, 78, 0, 12)
    Client.Name = "Client"
    Client.Parent = Header

    local Tabs = Instance.new("ScrollingFrame")
    Tabs.AutomaticCanvasSize = Enum.AutomaticSize.X
    Tabs.CanvasSize = UDim2.new(0, 0, 0.5, 0)
    Tabs.ScrollBarImageTransparency = 1
    Tabs.ScrollBarThickness = 0
    Tabs.Active = true
    Tabs.BackgroundTransparency = 1
    Tabs.BorderSizePixel = 0
    Tabs.Position = UDim2.new(0.0125, 0, 0.11, 0)
    Tabs.Size = UDim2.new(0, 138, 0, 308)
    Tabs.Name = "Tabs"
    Tabs.Parent = Container

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 6)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Tabs

    local Sections = Instance.new("Folder")
    Sections.Name = "Sections"
    Sections.Parent = Container

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
    LeftSection.Name = "LeftSection"
    LeftSection.Parent = Sections

    local UIListLayout1 = Instance.new("UIListLayout")
    UIListLayout1.Padding = UDim.new(0, 6)
    UIListLayout1.Parent = LeftSection

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
    RightSection.Name = "RightSection"
    RightSection.Parent = Sections

    local UIListLayout4 = Instance.new("UIListLayout")
    UIListLayout4.Padding = UDim.new(0, 6)
    UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout4.Parent = RightSection

    -- Library object
    local self = {}
    self.Flow = Flow
    self.Tabs = Tabs
    self.LeftSection = LeftSection
    self.RightSection = RightSection
    self.CurrentTab = nil
    self.TabSections = {}  -- To handle multiple tabs

    function self:AddTab(name, icon)
        local Tab = Instance.new("TextButton")
        Tab.Font = Enum.Font.SourceSans
        Tab.Text = ""
        Tab.AutoButtonColor = false
        Tab.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
        Tab.BackgroundTransparency = 0.5
        Tab.BorderSizePixel = 0
        Tab.Size = UDim2.new(0, 138, 0, 27)
        Tab.Name = "Tab"

        local UICorner3 = Instance.new("UICorner")
        UICorner3.CornerRadius = UDim.new(0, 5)
        UICorner3.Parent = Tab

        local Icon1 = Instance.new("ImageLabel")
        Icon1.Image = icon or "rbxassetid://10709810463"
        Icon1.AnchorPoint = Vector2.new(0, 0.5)
        Icon1.BackgroundTransparency = 1
        Icon1.BorderSizePixel = 0
        Icon1.Position = UDim2.new(0.1, 0, 0.5, 0)
        Icon1.Size = UDim2.new(0, 12, 0, 12)
        Icon1.Name = "Icon"
        Icon1.Parent = Tab

        local Title = Instance.new("TextLabel")
        Title.Font = Enum.Font.Unknown
        Title.Text = name
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextScaled = true
        Title.TextSize = 14
        Title.TextWrapped = true
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.AnchorPoint = Vector2.new(0, 0.5)
        Title.BackgroundTransparency = 1
        Title.BorderSizePixel = 0
        Title.Position = UDim2.new(0.225, 0, 0.5, 0)
        Title.Size = UDim2.new(0, 75, 0, 12)
        Title.Name = "Title"
        Title.Parent = Tab

        Tab.Parent = Tabs

        -- Create tab-specific sections
        local TabLeft = LeftSection:Clone()
        TabLeft.Name = name .. "_Left"
        TabLeft.Parent = Sections
        TabLeft.Visible = false

        local TabRight = RightSection:Clone()
        TabRight.Name = name .. "_Right"
        TabRight.Parent = Sections
        TabRight.Visible = false

        self.TabSections[name] = {Left = TabLeft, Right = TabRight}

        -- Tab switching
        Tab.MouseButton1Click:Connect(function()
            if self.CurrentTab then
                self.TabSections[self.CurrentTab].Left.Visible = false
                self.TabSections[self.CurrentTab].Right.Visible = false
            end
            TabLeft.Visible = true
            TabRight.Visible = true
            self.CurrentTab = name
        end)

        if not self.CurrentTab then
            TabLeft.Visible = true
            TabRight.Visible = true
            self.CurrentTab = name
        end

        local tabObj = {}
        function tabObj:AddModule(name, side)
            local Module = Instance.new("Frame")
            Module.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
            Module.BackgroundTransparency = 0.5
            Module.BorderSizePixel = 0
            Module.ClipsDescendants = true
            Module.Size = UDim2.new(0, 237, 0, 28)  -- Start collapsed
            Module.Name = "Module"

            local UICorner4 = Instance.new("UICorner")
            UICorner4.CornerRadius = UDim.new(0, 5)
            UICorner4.Parent = Module

            local Header2 = Instance.new("ImageButton")
            Header2.Image = "rbxassetid://72035547110749"  -- Placeholder image
            Header2.ImageTransparency = 0.5
            Header2.BackgroundTransparency = 1
            Header2.BorderSizePixel = 0
            Header2.Size = UDim2.new(0, 237, 0, 28)
            Header2.Name = "Header"
            Header2.Parent = Module

            local Arrow1 = Instance.new("ImageLabel")
            Arrow1.Image = "rbxassetid://136776761805636"  -- Placeholder
            Arrow1.ImageTransparency = 0.5
            Arrow1.BackgroundTransparency = 1
            Arrow1.BorderSizePixel = 0
            Arrow1.Position = UDim2.new(0.9, 0, 0.286, 0)
            Arrow1.Rotation = -90  -- Pointing right (collapsed)
            Arrow1.Size = UDim2.new(0, 11, 0, 11)
            Arrow1.Name = "Arrow"
            Arrow1.Parent = Header2

            local Title3 = Instance.new("TextLabel")
            Title3.Font = Enum.Font.Unknown
            Title3.Text = name
            Title3.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title3.TextScaled = true
            Title3.TextSize = 14
            Title3.TextTransparency = 0.5
            Title3.TextWrapped = true
            Title3.TextXAlignment = Enum.TextXAlignment.Left
            Title3.AnchorPoint = Vector2.new(0, 0.5)
            Title3.BackgroundTransparency = 1
            Title3.BorderSizePixel = 0
            Title3.Position = UDim2.new(0.14, 0, 0.5, 0)  -- Adjusted for keybind
            Title3.Size = UDim2.new(0, 156, 0, 12)
            Title3.Name = "Title"
            Title3.Parent = Header2

            local Settings = Instance.new("Frame")
            Settings.AnchorPoint = Vector2.new(0, 1)
            Settings.BackgroundTransparency = 1
            Settings.BorderSizePixel = 0
            Settings.ClipsDescendants = true
            Settings.Position = UDim2.new(0, 0, 1, 0)
            Settings.Size = UDim2.new(0, 237, 0, 0)  -- Start hidden
            Settings.Name = "Settings"
            Settings.Parent = Module

            local UIListLayout2 = Instance.new("UIListLayout")
            UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
            UIListLayout2.Parent = Settings

            -- Toggle functionality
            local expanded = false
            Header2.MouseButton1Click:Connect(function()
                expanded = not expanded
                if expanded then
                    Arrow1.Rotation = 0  -- Point down
                    Module.Size = UDim2.new(0, 237, 0, 28 + Settings.AbsoluteSize.Y)
                    Settings.Size = UDim2.new(0, 237, 0, Settings.UIListLayout.AbsoluteContentSize.Y)
                else
                    Arrow1.Rotation = -90
                    Module.Size = UDim2.new(0, 237, 0, 28)
                    Settings.Size = UDim2.new(0, 237, 0, 0)
                end
            end)

            if side == "left" then
                Module.Parent = self.TabSections[self.CurrentTab].Left
            else
                Module.Parent = self.TabSections[self.CurrentTab].Right
            end

            local moduleObj = {}
            function moduleObj:AddDropdown(title, options, callback)
                local Dropdown = Instance.new("TextButton")
                Dropdown.Font = Enum.Font.SourceSans
                Dropdown.Text = ""
                Dropdown.AutoButtonColor = false
                Dropdown.BackgroundTransparency = 1
                Dropdown.BorderSizePixel = 0
                Dropdown.Size = UDim2.new(0, 216, 0, 31)  -- Adjusted for title + box
                Dropdown.Name = "Dropdown"
                Dropdown.Parent = Settings

                local Title1 = Instance.new("TextLabel")
                Title1.Font = Enum.Font.GothamMedium
                Title1.Text = title
                Title1.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title1.TextScaled = true
                Title1.TextSize = 12
                Title1.TextTransparency = 0.5
                Title1.TextWrapped = true
                Title1.TextXAlignment = Enum.TextXAlignment.Left
                Title1.BackgroundTransparency = 1
                Title1.BorderSizePixel = 0
                Title1.Size = UDim2.new(0, 215, 0, 12)
                Title1.Name = "Title"
                Title1.Parent = Dropdown

                local Box = Instance.new("Frame")
                Box.AnchorPoint = Vector2.new(0.5, 0)
                Box.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
                Box.BackgroundTransparency = 1
                Box.BorderSizePixel = 0
                Box.Position = UDim2.new(0.5, 0, 1.3, 0)
                Box.Size = UDim2.new(0, 218, 0, 18)
                Box.Name = "Box"
                Box.Parent = Title1

                local UICorner5 = Instance.new("UICorner")
                UICorner5.CornerRadius = UDim.new(0, 5)
                UICorner5.Parent = Box

                local Header1 = Instance.new("ImageLabel")
                Header1.Image = "rbxassetid://70783523951929"  -- Placeholder
                Header1.BackgroundTransparency = 1
                Header1.BorderSizePixel = 0
                Header1.Position = UDim2.new(0, 0, -0.5, 0)
                Header1.Size = UDim2.new(0, 218, 0, 18)
                Header1.Name = "Header"
                Header1.Parent = Box

                local Arrow = Instance.new("ImageLabel")
                Arrow.Image = "rbxassetid://136776761805636"  -- Placeholder
                Arrow.ImageTransparency = 0.5
                Arrow.BackgroundTransparency = 1
                Arrow.BorderSizePixel = 0
                Arrow.Position = UDim2.new(0.93, 0, 0.25, 0)
                Arrow.Rotation = -90
                Arrow.Size = UDim2.new(0, 10, 0, 10)
                Arrow.Name = "Arrow"
                Arrow.Parent = Header1

                local Option5 = Instance.new("TextLabel")
                Option5.Font = Enum.Font.GothamMedium
                Option5.Text = options[1]  -- Default selected
                Option5.TextColor3 = Color3.fromRGB(255, 255, 255)
                Option5.TextSize = 12
                Option5.TextTransparency = 0.5
                Option5.TextXAlignment = Enum.TextXAlignment.Left
                Option5.AnchorPoint = Vector2.new(0.5, 0)
                Option5.BackgroundTransparency = 1
                Option5.BorderSizePixel = 0
                Option5.Position = UDim2.new(0.5, 0, 0.1, 0)
                Option5.Size = UDim2.new(0, 194, 0, 12)
                Option5.Name = "Option"
                Option5.Parent = Header1

                local Options = Instance.new("Frame")
                Options.AnchorPoint = Vector2.new(0.5, 0)
                Options.BackgroundTransparency = 1
                Options.BorderSizePixel = 0
                Options.ClipsDescendants = true
                Options.Position = UDim2.new(0.5, 0, 1.1, 0)
                Options.Size = UDim2.new(0, 218, 0, 0)  -- Hidden
                Options.Name = "Options"
                Options.Parent = Box

                local List = Instance.new("ScrollingFrame")
                List.AutomaticCanvasSize = Enum.AutomaticSize.XY
                List.ScrollBarImageTransparency = 1
                List.ScrollBarThickness = 0
                List.Active = true
                List.BackgroundTransparency = 1
                List.BorderSizePixel = 0
                List.Position = UDim2.new(0.5, 0, 0, 0)
                List.Size = UDim2.new(0, 218, 0, 0)
                List.Name = "List"
                List.Parent = Options

                local UIListLayout3 = Instance.new("UIListLayout")
                UIListLayout3.HorizontalAlignment = Enum.HorizontalAlignment.Center
                UIListLayout3.Parent = List

                -- Add options
                for _, opt in ipairs(options) do
                    local Option = Instance.new("TextButton")
                    Option.Font = Enum.Font.GothamMedium
                    Option.Text = opt
                    Option.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Option.TextSize = 12
                    Option.TextTransparency = 0.5
                    Option.TextXAlignment = Enum.TextXAlignment.Left
                    Option.BackgroundTransparency = 1
                    Option.BorderSizePixel = 0
                    Option.Size = UDim2.new(0, 205, 0, 17)
                    Option.ZIndex = 2
                    Option.Name = "Option"
                    Option.Parent = List

                    Option.MouseButton1Click:Connect(function()
                        Option5.Text = opt
                        callback(opt)
                        -- Close dropdown
                        Arrow.Rotation = -90
                        Options.Size = UDim2.new(0, 218, 0, 0)
                        List.Size = UDim2.new(0, 218, 0, 0)
                        Module.Size = UDim2.new(0, 237, 0, 28 + Settings.UIListLayout.AbsoluteContentSize.Y)
                    end)
                end

                -- Toggle dropdown
                local dropExpanded = false
                Dropdown.MouseButton1Click:Connect(function()
                    dropExpanded = not dropExpanded
                    if dropExpanded then
                        Arrow.Rotation = 0
                        Options.Size = UDim2.new(0, 218, 0, List.UIListLayout.AbsoluteContentSize.Y)
                        List.Size = UDim2.new(0, 218, 0, List.UIListLayout.AbsoluteContentSize.Y)
                    else
                        Arrow.Rotation = -90
                        Options.Size = UDim2.new(0, 218, 0, 0)
                        List.Size = UDim2.new(0, 218, 0, 0)
                    end
                    Module.Size = UDim2.new(0, 237, 0, 28 + Settings.UIListLayout.AbsoluteContentSize.Y)
                end)
            end

            function moduleObj:AddSlider(title, min, max, default, callback)
                local Slider = Instance.new("TextButton")
                Slider.Font = Enum.Font.SourceSans
                Slider.Text = ""
                Slider.AutoButtonColor = false
                Slider.BackgroundTransparency = 1
                Slider.BorderSizePixel = 0
                Slider.Size = UDim2.new(0, 216, 0, 27)
                Slider.Name = "Slider"
                Slider.Parent = Settings

                local Drag = Instance.new("Frame")
                Drag.AnchorPoint = Vector2.new(0.5, 1)
                Drag.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
                Drag.BackgroundTransparency = 0.5
                Drag.BorderSizePixel = 0
                Drag.Position = UDim2.new(0.5, 0, 0.8, 0)
                Drag.Size = UDim2.new(0, 217, 0, 4)
                Drag.Name = "Drag"
                Drag.Parent = Slider

                local UICorner6 = Instance.new("UICorner")
                UICorner6.Parent = Drag

                local Fill1 = Instance.new("Frame")
                Fill1.AnchorPoint = Vector2.new(0, 0.5)
                Fill1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Fill1.BackgroundTransparency = 0.5
                Fill1.BorderSizePixel = 0
                Fill1.Position = UDim2.new(0, 0, 0.5, 0)
                Fill1.Size = UDim2.new((default - min) / (max - min), 0, 0, 4)
                Fill1.Name = "Fill"
                Fill1.Parent = Drag

                local UICorner7 = Instance.new("UICorner")
                UICorner7.Parent = Fill1

                local Circle = Instance.new("Frame")
                Circle.AnchorPoint = Vector2.new(1, 0.5)
                Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Circle.BorderSizePixel = 0
                Circle.Position = UDim2.new(1, 0, 0.5, 0)
                Circle.Size = UDim2.new(0, 6, 0, 6)
                Circle.Name = "Circle"
                Circle.Parent = Fill1

                local UICorner8 = Instance.new("UICorner")
                UICorner8.CornerRadius = UDim.new(1, 0)
                UICorner8.Parent = Circle

                local Title2 = Instance.new("TextLabel")
                Title2.Font = Enum.Font.GothamMedium
                Title2.Text = title
                Title2.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title2.TextScaled = true
                Title2.TextSize = 12
                Title2.TextTransparency = 0.5
                Title2.TextWrapped = true
                Title2.TextXAlignment = Enum.TextXAlignment.Left
                Title2.AnchorPoint = Vector2.new(0, 0.5)
                Title2.BackgroundTransparency = 1
                Title2.BorderSizePixel = 0
                Title2.Position = UDim2.new(0, 0, 0.4, 0)
                Title2.Size = UDim2.new(0, 172, 0, 12)
                Title2.Name = "Title"
                Title2.Parent = Slider

                local Value = Instance.new("TextLabel")
                Value.Font = Enum.Font.GothamMedium
                Value.Text = tostring(default)
                Value.TextColor3 = Color3.fromRGB(255, 255, 255)
                Value.TextScaled = true
                Value.TextSize = 12
                Value.TextTransparency = 0.5
                Value.TextWrapped = true
                Value.TextXAlignment = Enum.TextXAlignment.Right
                Value.AnchorPoint = Vector2.new(1, 0.5)
                Value.BackgroundTransparency = 1
                Value.BorderSizePixel = 0
                Value.Position = UDim2.new(1, 0, 0.4, 0)
                Value.Size = UDim2.new(0, 42, 0, 12)
                Value.Name = "Value"
                Value.Parent = Slider

                -- Slider functionality
                local dragging = false
                Slider.MouseButton1Down:Connect(function()
                    dragging = true
                end)
                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                Slider.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local relativeX = math.clamp((input.Position.X - Drag.AbsolutePosition.X) / Drag.AbsoluteSize.X, 0, 1)
                        local val = math.floor(min + relativeX * (max - min))
                        Fill1.Size = UDim2.new(relativeX, 0, 0, 4)
                        Value.Text = tostring(val)
                        callback(val)
                    end
                end)
            end

            function moduleObj:AddKeybind(title, default, callback)
                local Keybind = Instance.new("TextButton")
                Keybind.Font = Enum.Font.SourceSans
                Keybind.Text = ""
                Keybind.AutoButtonColor = false
                Keybind.AnchorPoint = Vector2.new(0, 0.5)
                Keybind.BackgroundTransparency = 1
                Keybind.BorderSizePixel = 0
                Keybind.Position = UDim2.new(0, 0, 0.5, 0)
                Keybind.Size = UDim2.new(0, 33, 0, 28)
                Keybind.Name = "Keybind"
                Keybind.Parent = Header2  -- Attached to header

                local Background = Instance.new("Frame")
                Background.AnchorPoint = Vector2.new(0.5, 0.5)
                Background.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
                Background.BackgroundTransparency = 0.5
                Background.BorderSizePixel = 0
                Background.Position = UDim2.new(0.5, 0, 0.5, 0)
                Background.Size = UDim2.new(0, 20, 0, 20)
                Background.Name = "Background"
                Background.Parent = Keybind

                local UICorner9 = Instance.new("UICorner")
                UICorner9.CornerRadius = UDim.new(0, 4)
                UICorner9.Parent = Background

                local String = Instance.new("TextLabel")
                String.Font = Enum.Font.Unknown
                String.Text = default or "R"
                String.TextColor3 = Color3.fromRGB(255, 255, 255)
                String.TextSize = 10
                String.TextTransparency = 0.5
                String.AnchorPoint = Vector2.new(0.5, 0.5)
                String.BackgroundTransparency = 1
                String.BorderSizePixel = 0
                String.Position = UDim2.new(0.5, 0, 0.5, 0)
                String.Size = UDim2.new(0, 12, 0, 12)
                String.Name = "String"
                String.Parent = Background

                -- Keybind functionality
                local binding = false
                Keybind.MouseButton1Click:Connect(function()
                    binding = true
                    String.Text = "..."
                end)
                game:GetService("UserInputService").InputBegan:Connect(function(input)
                    if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                        String.Text = input.KeyCode.Name
                        callback(input.KeyCode)
                        binding = false
                    end
                end)
            end

            return moduleObj
        end

        return tabObj
    end

    return self
end

return FlowLibrary