--!strict
-- ByteUI Library (PC + Mobile) - 2025
-- Drop as ModuleScript "ByteUILibrary" in ReplicatedStorage, then require from a LocalScript.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

local function New(class, props, children)
	local inst = Instance.new(class)
	for k, v in pairs(props or {}) do
		(inst :: any)[k] = v
	end
	for _, c in ipairs(children or {}) do
		c.Parent = inst
	end
	return inst
end

local function MakeCorner(parent, r)
	New("UICorner", { CornerRadius = UDim.new(0, r), Parent = parent })
end

local function Draggable(frame: Frame, handle: GuiObject)
	local dragging = false
	local dragStart, startPos
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragging and dragStart then
				local delta = input.Position - dragStart
				frame.Position = UDim2.new(
					startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y
				)
			end
		end
	end)
end

local function Resizable(frame: Frame, handle: GuiObject, minSize: Vector2)
	local resizing = false
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = true
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					resizing = false
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local abs = frame.AbsolutePosition
			local mx = input.Position.X
			local my = input.Position.Y
			local w = math.max(minSize.X, mx - abs.X)
			local h = math.max(minSize.Y, my - abs.Y)
			frame.Size = UDim2.fromOffset(w, h)
		end
	end)
end

local ByteUI = {}
ByteUI.__index = ByteUI

export type Window = {
	Main: Frame,
	RightPane: Frame,
	LeftPane: Frame,
	Topbar: Frame,
	Tabs: {[string]: any},
	Flags: {[string]: any},
	_CreateTab: (self: Window, name: string) -> any,
	CreateTab: (self: Window, name: string) -> any,
	Notify: (self: Window, text: string, time: number?) -> (),
	SaveJSON: (self: Window) -> string,
	LoadJSON: (self: Window, json: string?) -> (),
}

export type Tab = {
	Frame: ScrollingFrame,
	Name: string,
	Sections: {[string]: any},
	CreateSection: (self: Tab, title: string) -> any,
	CreateLabel: (self: Tab, text: string) -> TextLabel,
	CreateButton: (self: Tab, text: string, cb: ()->()) -> TextButton,
	CreateToggle: (self: Tab, text: string, flag: string, default: boolean?, cb: (boolean)->()) -> Frame,
	CreateSlider: (self: Tab, text: string, flag: string, min: number, max: number, default: number, cb: (number)->()) -> Frame,
	CreateDropdown: (self: Tab, text: string, flag: string, options: {string}, defaultOpt: string?, cb: (string)->()) -> Frame,
	CreateKeybind: (self: Tab, text: string, flag: string, default: Enum.KeyCode?, cb: ()->()) -> Frame,
	CreateColorPicker: (self: Tab, text: string, flag: string, default: Color3?, cb: (Color3)->()) -> Frame,
}

local function MakeList(container: Instance, padding: number, horizontal: boolean?)
	if horizontal then
		New("UIListLayout", { Parent = container, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, padding), SortOrder = Enum.SortOrder.LayoutOrder })
	else
		New("UIListLayout", { Parent = container, Padding = UDim.new(0, padding), SortOrder = Enum.SortOrder.LayoutOrder })
	end
	New("UIPadding", { Parent = container, PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8) })
end

function ByteUI:CreateWindow(title: string?): Window
	local isTouch = UserInputService.TouchEnabled
	local width = isTouch and 620 or 760
	local height = isTouch and 420 or 520

	local gui = New("ScreenGui", {
		Name = "ByteUI",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = LocalPlayer:WaitForChild("PlayerGui")
	})

	local main = New("Frame", {
		Name = "Main",
		Size = UDim2.fromOffset(width, height),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(12, 12, 12),
		BorderSizePixel = 0,
		Parent = gui
	})
	MakeCorner(main, 10)

	local topbar = New("Frame", {
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BorderSizePixel = 0,
		Parent = main
	})
	MakeCorner(topbar, 10)

	local titleLbl = New("TextLabel", {
		Text = title or "Byte - 2025",
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextColor3 = Color3.new(1,1,1),
		BackgroundTransparency = 1,
		Size = UDim2.new(0.6, 0, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
		Position = UDim2.new(0, 12, 0, 0),
		Parent = topbar
	})

	local search = New("TextBox", {
		PlaceholderText = "Search",
		Text = "",
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = Color3.new(1,1,1),
		BackgroundColor3 = Color3.fromRGB(45,45,45),
		Size = UDim2.fromOffset(150, 24),
		Position = UDim2.new(1, -170, 0.5, -12),
		Parent = topbar
	})
	MakeCorner(search, 6)

	-- window controls
	local btnRow = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(72, 24),
		Position = UDim2.new(1, -240, 0.5, -12),
		Parent = topbar
	})
	MakeList(btnRow, 8, true)

	local minimize = New("TextButton", {
		Text = "–",
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextColor3 = Color3.new(1,1,1),
		BackgroundColor3 = Color3.fromRGB(50,50,50),
		Size = UDim2.fromOffset(28, 24),
		Parent = btnRow
	})
	MakeCorner(minimize, 6)

	local close = New("TextButton", {
		Text = "×",
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextColor3 = Color3.new(1,1,1),
		BackgroundColor3 = Color3.fromRGB(60,35,35),
		Size = UDim2.fromOffset(28, 24),
		Parent = btnRow
	})
	MakeCorner(close, 6)

	local body = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, -36),
		Position = UDim2.new(0, 0, 0, 36),
		Parent = main
	})

	local left = New("Frame", {
		BackgroundColor3 = Color3.fromRGB(22,22,22),
		Size = UDim2.new(0, 180, 1, 0),
		Parent = body
	})
	MakeCorner(left, 10)

	local tabsColumn = New("ScrollingFrame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0,0,0,0),
		ScrollBarThickness = 3,
		Size = UDim2.new(1, 0, 1, 0),
		Parent = left
	})
	MakeList(tabsColumn, 6, false)

	local right = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -190, 1, 0),
		Position = UDim2.new(0, 190, 0, 0),
		Parent = body
	})

	local pages = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Parent = right
	})

	local resizer = New("Frame", {
		Size = UDim2.fromOffset(14, 14),
		Position = UDim2.new(1, -14, 1, -14),
		BackgroundColor3 = Color3.fromRGB(45,45,45),
		Parent = main
	})
	MakeCorner(resizer, 3)

	Draggable(main, topbar)
	Resizable(main, resizer, Vector2.new(520, 340))

	local notifHolder = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Parent = gui
	})

	local function Notify(text: string, timeSec: number?)
		timeSec = timeSec or 2
		local bubble = New("TextLabel", {
			Text = text,
			Font = Enum.Font.Gotham,
			TextSize = 14,
			TextColor3 = Color3.new(1,1,1),
			BackgroundColor3 = Color3.fromRGB(32,32,32),
			AutomaticSize = Enum.AutomaticSize.XY,
			Parent = notifHolder
		})
		MakeCorner(bubble, 8)
		New("UIPadding", { Parent = bubble, PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8) })
		bubble.Position = UDim2.new(1, -20, 1, -20)
		bubble.AnchorPoint = Vector2.new(1,1)
		bubble.BackgroundTransparency = 1
		bubble.TextTransparency = 1
		TweenService:Create(bubble, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
		task.delay(timeSec, function()
			local t = TweenService:Create(bubble, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextTransparency = 1})
			t:Play()
			t.Completed:Wait()
			bubble:Destroy()
		end)
	end

	minimize.MouseButton1Click:Connect(function()
		if body.Visible then
			body.Visible = false
			resizer.Visible = false
			minimize.Text = "+"
			main.Size = UDim2.fromOffset(main.AbsoluteSize.X, 36)
		else
			body.Visible = true
			resizer.Visible = true
			minimize.Text = "–"
			main.Size = UDim2.fromOffset(width, height)
		end
	end)

	close.MouseButton1Click:Connect(function()
		gui:Destroy()
	end)

	local window: Window = setmetatable({
		Main = main,
		RightPane = pages,
		LeftPane = tabsColumn,
		Topbar = topbar,
		Tabs = {},
		Flags = {},
	}, ByteUI)

	function window:_CreateTab(name: string)
		local btn = New("TextButton", {
			Text = name,
			Font = Enum.Font.Gotham,
			TextSize = 14,
			TextColor3 = Color3.fromRGB(210,210,210),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 30),
			Parent = tabsColumn
		})

		local page = New("ScrollingFrame", {
			Visible = false,
			BackgroundTransparency = 1,
			CanvasSize = UDim2.new(0,0,0,0),
			ScrollBarThickness = 3,
			Size = UDim2.new(1, 0, 1, 0),
			Parent = pages
		})
		MakeList(page, 8, false)

		btn.MouseButton1Click:Connect(function()
			for _, f in ipairs(pages:GetChildren()) do
				if f:IsA("ScrollingFrame") then f.Visible = false end
			end
			page.Visible = true
		end)

		-- first tab visible by default
		if #pages:GetChildren() == 1 then
			page.Visible = true
		end

		local tab: Tab = {} :: any

		function tab:CreateSection(title: string)
			local box = New("Frame", {
				BackgroundColor3 = Color3.fromRGB(26,26,26),
				Size = UDim2.new(1, -10, 0, 10),
				Parent = page
			})
			MakeCorner(box, 8)
			MakeList(box, 6, false)

			New("TextLabel", {
				Text = title,
				Font = Enum.Font.GothamBold,
				TextSize = 14,
				TextColor3 = Color3.fromRGB(230,230,230),
				BackgroundTransparency = 1,
				Size = UDim2.new(1,0,0,18),
				Parent = box
			})

			return box
		end

		local function addControl(container: Instance, height: number)
			local f = New("Frame", {
				BackgroundColor3 = Color3.fromRGB(40,40,40),
				Size = UDim2.new(1, 0, 0, height),
				Parent = container
			})
			MakeCorner(f, 6)
			return f
		end

		function tab:CreateLabel(text: string)
			local f = addControl(page, 28)
			New("TextLabel", {
				Text = text,
				Font = Enum.Font.Gotham,
				TextSize = 14,
				TextColor3 = Color3.new(1,1,1),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -10, 1, 0),
				Position = UDim2.new(0, 8, 0, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = f
			})
			return f
		end

		function tab:CreateButton(text: string, cb: ()->())
			local f = addControl(page, 30)
			local b = New("TextButton", {
				Text = text,
				Font = Enum.Font.Gotham,
				TextSize = 14,
				TextColor3 = Color3.new(1,1,1),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -10, 1, 0),
				Position = UDim2.new(0, 8, 0, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = f
			})
			b.MouseButton1Click:Connect(function()
				if cb then cb() end
			end)
			return b
		end

		function tab:CreateToggle(text: string, flag: string, default: boolean?, cb: (boolean)->())
			local f = addControl(page, 30)
			local lbl = New("TextLabel", {
				Text = text,
				Font = Enum.Font.Gotham,
				TextSize = 14,
				TextColor3 = Color3.new(1,1,1),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -60, 1, 0),
				Position = UDim2.new(0, 8, 0, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = f
			})
			local btn = New("TextButton", {
				Text = (default and "ON" or "OFF"),
				Font = Enum.Font.GothamBold,
				TextSize = 12,
				TextColor3 = Color3.new(1,1,1),
				BackgroundColor3 = default and Color3.fromRGB(0,170,255) or Color3.fromRGB(70,70,70),
				Size = UDim2.fromOffset(44, 20),
				Position = UDim2.new(1, -52, 0.5, -10),
				Parent = f
			})
			MakeCorner(btn, 6)

			local state = default == true
			window.Flags[flag] = state

			local function setState(v: boolean)
				state = v
				window.Flags[flag] = v
				btn.Text = v and "ON" or "OFF"
				btn.BackgroundColor3 = v and Color3.fromRGB(0,170,255) or Color3.fromRGB(70,70,70)
				if cb then cb(v) end
			end

			btn.MouseButton1Click:Connect(function()
				setState(not state)
			end)

			return f
		end

		function tab:CreateSlider(text: string, flag: string, min: number, max: number, default: number, cb: (number)->())
			local f = addControl(page, 46)
			local lbl = New("TextLabel", {
				Text = string.format("%s: %d", text, default),
				Font = Enum.Font.Gotham,
				TextSize = 14,
				TextColor3 = Color3.new(1,1,1),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -10, 0, 20),
				Position = UDim2.new(0, 8, 0, 4),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = f
			})

			local bar = New("Frame", {
				BackgroundColor3 = Color3.fromRGB(60,60,60),
				Size = UDim2.new(1, -16, 0, 6),
				Position = UDim2.new(0, 8, 0, 30),
				Parent = f
			})
			MakeCorner(bar, 3)
			local fill = New("Frame", {
				BackgroundColor3 = Color3.fromRGB(0,170,255),
				Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
				Parent = bar
			})
			MakeCorner(fill, 3)

			window.Flags[flag] = default
			local dragging = false
			bar.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
					dragging = true
				end
			end)
			UserInputService.InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)
			UserInputService.InputChanged:Connect(function(i)
				if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
					local rel = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
					fill.Size = UDim2.new(rel, 0, 1, 0)
					local value = math.floor(min + (max - min) * rel)
					window.Flags[flag] = value
					lbl.Text = string.format("%s: %d", text, value)
					if cb then cb(value) end
				end
			end)
			return f
		end

		function tab:CreateDropdown(text: string, flag: string, options: {string}, defaultOpt: string?, cb: (string)->())
			local f = addControl(page, 30)
			local lbl = New("TextLabel", {
				Text = text,
				Font = Enum.Font.Gotham,
				TextSize = 14,
				TextColor3 = Color3.new(1,1,1),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -10, 1, 0),
				Position = UDim2.new(0, 8, 0, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = f
			})

			local drop = New("Frame", {
				BackgroundColor3 = Color3.fromRGB(35,35,35),
				Size = UDim2.new(0, 180, 0, 24),
				Position = UDim2.new(1, -188, 0.5, -12),
				Parent = f
			})
			MakeCorner(drop, 6)

			local chosen = defaultOpt or options[1] or ""
			window.Flags[flag] = chosen

			local txt = New("TextLabel", {
				Text = chosen,
				Font = Enum.Font.Gotham,
				TextSize = 14,
				TextColor3 = Color3.new(1,1,1),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -24, 1, 0),
				Position = UDim2.new(0, 8, 0, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = drop
			})

			local arrow = New("TextButton", {
				Text = "▼",
				Font = Enum.Font.GothamBold,
				TextSize = 12,
				TextColor3 = Color3.new(1,1,1),
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(20, 24),
				Position = UDim2.new(1, -22, 0, 0),
				Parent = drop
			})

			local list = New("Frame", {
				Visible = false,
				BackgroundColor3 = Color3.fromRGB(30,30,30),
				Size = UDim2.new(1, 0, 0, #options * 24),
				Position = UDim2.new(0, 0, 1, 2),
				Parent = drop
			})
			MakeCorner(list, 6)
			MakeList(list, 0, false)

			for _, opt in ipairs(options) do
				local b = New("TextButton", {
					Text = opt,
					Font = Enum.Font.Gotham,
					TextSize = 14,
					TextColor3 = Color3.fromRGB(220,220,220),
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -10, 0, 24),
					Position = UDim2.new(0, 5, 0, 0),
					Parent = list
				})
				b.MouseButton1Click:Connect(function()
					chosen = opt
					txt.Text = opt
					window.Flags[flag] = opt
					list.Visible = false
					if cb then cb(opt) end
				end)
			end

			arrow.MouseButton1Click:Connect(function()
				list.Visible = not list.Visible
			end)

			return f
		end

		function tab:CreateKeybind(text: string, flag: string, default: Enum.KeyCode?, cb: ()->())
			local f = addControl(page, 30)
			New("TextLabel", {
				Text = text,
				Font = Enum.Font.Gotham,
				TextSize = 14,
				TextColor3 = Color3.new(1,1,1),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -120, 1, 0),
				Position = UDim2.new(0, 8, 0, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = f
			})

			local keyBtn = New("TextButton", {
				Text = default and default.Name or "Set Key",
				Font = Enum.Font.Gotham,
				TextSize = 14,
				TextColor3 = Color3.new(1,1,1),
				BackgroundColor3 = Color3.fromRGB(45,45,45),
				Size = UDim2.fromOffset(100, 24),
				Position = UDim2.new(1, -108, 0.5, -12),
				Parent = f
			})
			MakeCorner(keyBtn, 6)

			local bind = default or Enum.KeyCode.Unknown
			window.Flags[flag] = bind.Name

			keyBtn.MouseButton1Click:Connect(function()
				keyBtn.Text = "Press..."
				local conn; conn = UserInputService.InputBegan:Connect(function(inp, gpe)
					if gpe then return end
					if inp.KeyCode ~= Enum.KeyCode.Unknown then
						bind = inp.KeyCode
						window.Flags[flag] = bind.Name
						keyBtn.Text = bind.Name
						conn:Disconnect()
					end
				end)
			end)

			UserInputService.InputBegan:Connect(function(inp, gpe)
				if gpe then return end
				if inp.KeyCode == bind then
					if cb then cb() end
				end
			end)

			return f
		end

		function tab:CreateColorPicker(text: string, flag: string, default: Color3?, cb: (Color3)->())
			local f = addControl(page, 36)
			local lbl = New("TextLabel", {
				Text = text,
				Font = Enum.Font.Gotham,
				TextSize = 14,
				TextColor3 = Color3.new(1,1,1),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -120, 1, 0),
				Position = UDim2.new(0, 8, 0, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = f
			})

			local swatch = New("TextButton", {
				BackgroundColor3 = default or Color3.fromRGB(0,170,255),
				Size = UDim2.fromOffset(32, 24),
				Position = UDim2.new(1, -40, 0.5, -12),
				Parent = f
			})
			MakeCorner(swatch, 6)

			window.Flags[flag] = swatch.BackgroundColor3

			local picker = New("Frame", {
				Visible = false,
				BackgroundColor3 = Color3.fromRGB(30,30,30),
				Size = UDim2.fromOffset(220, 130),
				Position = UDim2.new(1, -228, 1, 6),
				Parent = f
			})
			MakeCorner(picker, 8)
			MakeList(picker, 6, false)

			local function mkSlider(rowName)
				local row = New("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(210, 30), Parent = picker })
				local tl = New("TextLabel", {
					Text = rowName,
					Font = Enum.Font.Gotham,
					TextSize = 14,
					TextColor3 = Color3.fromRGB(230,230,230),
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(30, 30),
					Parent = row
				})
				local bar = New("Frame", {
					BackgroundColor3 = Color3.fromRGB(60,60,60),
					Size = UDim2.fromOffset(160, 6),
					Position = UDim2.new(0, 40, 0.5, -3),
					Parent = row
				})
				MakeCorner(bar, 3)
				local fill = New("Frame", { BackgroundColor3 = Color3.fromRGB(0,170,255), Size = UDim2.fromOffset(80, 6), Parent = bar })
				MakeCorner(fill, 3)
				return bar, fill
			end

			local rBar, rFill = mkSlider("R")
			local gBar, gFill = mkSlider("G")
			local bBar, bFill = mkSlider("B")

			local function setSwatch(c: Color3)
				swatch.BackgroundColor3 = c
				window.Flags[flag] = c
				if cb then cb(c) end
			end

			local function syncFromColor(c: Color3)
				local r,g,b = c.R, c.G, c.B
				rFill.Size = UDim2.fromOffset(math.floor(160 * r), 6)
				gFill.Size = UDim2.fromOffset(math.floor(160 * g), 6)
				bFill.Size = UDim2.fromOffset(math.floor(160 * b), 6)
			end

			syncFromColor(swatch.BackgroundColor3)

			local function hook(bar: Frame, fill: Frame, idx: number)
				local dragging = false
				bar.InputBegan:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
						dragging = true
					end
				end)
				UserInputService.InputEnded:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
						dragging = false
					end
				end)
				UserInputService.InputChanged:Connect(function(i)
					if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
						local rel = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
						fill.Size = UDim2.fromOffset(math.floor(160 * rel), 6)
						local col = swatch.BackgroundColor3
						local r,g,b = col.R, col.G, col.B
						if idx == 1 then r = rel elseif idx == 2 then g = rel else b = rel end
						setSwatch(Color3.new(r,g,b))
					end
				end)
			end

			hook(rBar, rFill, 1); hook(gBar, gFill, 2); hook(bBar, bFill, 3)

			swatch.MouseButton1Click:Connect(function()
				picker.Visible = not picker.Visible
				syncFromColor(swatch.BackgroundColor3)
			end)

			return f
		end

		self.Tabs[name] = tab
		return tab
	end

	function window:CreateTab(name: string)
		return self:_CreateTab(name)
	end

	-- live search: hide controls not matching text
	search:GetPropertyChangedSignal("Text"):Connect(function()
		local q = string.lower(search.Text)
		for _, sf in ipairs(pages:GetChildren()) do
			if sf:IsA("ScrollingFrame") then
				for _, item in ipairs(sf:GetDescendants()) do
					if item:IsA("TextLabel") or item:IsA("TextButton") then
						local parentFrame = item:FindFirstAncestorOfClass("Frame")
						if parentFrame and parentFrame.Parent == sf then
							local t = ""
							for _, d in ipairs(parentFrame:GetDescendants()) do
								if d:IsA("TextLabel") or d:IsA("TextButton") then
									t ..= " " .. string.lower(d.Text or "")
								end
							end
							parentFrame.Visible = (q == "" or string.find(t, q) ~= nil)
						end
					end
				end
			end
		end
	end)

	function window:Notify(text: string, timeSec: number?)
		Notify(text, timeSec)
	end

	function window:SaveJSON(): string
		-- convert Color3/KeyCode values
		local out = {}
		for k, v in pairs(self.Flags) do
			if typeof(v) == "Color3" then
				out[k] = {__type="Color3", r=v.R, g=v.G, b=v.B}
			else
				out[k] = v
			end
		end
		return HttpService:JSONEncode(out)
	end

	function window:LoadJSON(json: string?)
		if not json or json == "" then return end
		local ok, data = pcall(function() return HttpService:JSONDecode(json) end)
		if not ok or type(data) ~= "table" then return end
		for k, v in pairs(data) do
			if type(v) == "table" and v.__type == "Color3" then
				self.Flags[k] = Color3.new(v.r, v.g, v.b)
			else
				self.Flags[k] = v
			end
		end
	end

	return window
end

return setmetatable({}, ByteUI)
