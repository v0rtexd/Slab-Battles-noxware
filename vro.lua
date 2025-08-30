-- AnerialUI Library
local AnerialUI = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Utility
local function create(instanceType, props)
    local obj = Instance.new(instanceType)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

-- Library Core
function AnerialUI:CreateWindow(title)
    local screenGui = create("ScreenGui", {
        Name = "AnerialUI",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })

    local main = create("Frame", {
        Name = "Main",
        BackgroundColor3 = Color3.fromRGB(12, 12, 12),
        BackgroundTransparency = 0.1,
        Position = UDim2.new(0.3, 0, 0.3, 0),
        Size = UDim2.new(0, 569, 0, 288),
        BorderSizePixel = 0,
        Parent = screenGui
    })
    create("UICorner", {CornerRadius = UDim.new(0, 9), Parent = main})

    -- Dragging system
    local dragBar = create("TextButton", {
        Name = "DragBar",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 25),
        Text = "",
        Parent = main
    })

    -- Simple drag logic
    local dragging, dragInput, startPos, startInput
    dragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = main.Position
            startInput = input.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    dragBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - startInput
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Tab system
    local tabHolder = create("Frame", {
        Name = "TabHolder",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 130, 1, -25),
        Position = UDim2.new(0, 0, 0, 25),
        Parent = main
    })

    local contentHolder = create("Frame", {
        Name = "ContentHolder",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -130, 1, -25),
        Position = UDim2.new(0, 130, 0, 25),
        Parent = main
    })

    local tabs = {}

    function AnerialUI:CreateTab(name)
        local button = create("TextButton", {
            Name = name .. "TabButton",
            Text = name,
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            Size = UDim2.new(1, 0, 0, 25),
            Parent = tabHolder
        })

        local tabFrame = create("ScrollingFrame", {
            Name = name .. "Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0,0,0,0),
            Visible = false,
            Parent = contentHolder
        })

        tabs[#tabs+1] = {Button = button, Frame = tabFrame}

        button.MouseButton1Click:Connect(function()
            for _, t in ipairs(tabs) do
                t.Frame.Visible = false
                t.Button.TextColor3 = Color3.fromRGB(170,170,170)
            end
            tabFrame.Visible = true
            button.TextColor3 = Color3.fromRGB(255,255,255)
        end)

        if #tabs == 1 then
            tabFrame.Visible = true
            button.TextColor3 = Color3.fromRGB(255,255,255)
        end

        -- Add functions for modules
        local moduleY = 0
        local function newModule(title)
            local holder = create("Frame", {
                Size = UDim2.new(1, -10, 0, 40),
                Position = UDim2.new(0, 5, 0, moduleY),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0,
                Parent = tabFrame
            })
            create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = holder})

            local lbl = create("TextLabel", {
                Text = title,
                TextColor3 = Color3.fromRGB(200,200,200),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Parent = holder
            })

            moduleY = moduleY + 45
            tabFrame.CanvasSize = UDim2.new(0,0,0,moduleY)

            return holder
        end

        function tabFrame:AddButton(name, callback)
            local module = newModule(name)
            local btn = create("TextButton", {
                Text = "Enable",
                Size = UDim2.new(0,80,0,25),
                Position = UDim2.new(1,-90,0.5,-12),
                BackgroundColor3 = Color3.fromRGB(60,60,60),
                TextColor3 = Color3.fromRGB(255,255,255),
                Parent = module
            })
            create("UICorner", {CornerRadius = UDim.new(0,5), Parent = btn})
            btn.MouseButton1Click:Connect(callback)
        end

        function tabFrame:AddSlider(name, min, max, default, callback)
            local module = newModule(name)
            local sliderBack = create("Frame", {
                BackgroundColor3 = Color3.fromRGB(60,60,60),
                Size = UDim2.new(0.6,0,0,6),
                Position = UDim2.new(0.3,0,0.5,-3),
                Parent = module
            })
            local fill = create("Frame", {
                BackgroundColor3 = Color3.fromRGB(200,200,200),
                Size = UDim2.new((default-min)/(max-min),0,1,0),
                Parent = sliderBack
            })

            local valueLabel = create("TextLabel", {
                Text = tostring(default),
                Size = UDim2.new(0,40,0,20),
                Position = UDim2.new(1,-45,0.5,-10),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(200,200,200),
                Parent = module
            })

            local uis = game:GetService("UserInputService")
            local dragging = false
            sliderBack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            uis.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            uis.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local rel = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
                    local val = math.floor(min + (max-min)*rel)
                    fill.Size = UDim2.new(rel,0,1,0)
                    valueLabel.Text = tostring(val)
                    callback(val)
                end
            end)
        end

        return tabFrame
    end

    return main
end

return AnerialUI
