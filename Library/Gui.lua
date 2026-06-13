local Base = "https://raw.githubusercontent.com/jaeelin/Terminal/main/Library/"

local Core = loadstring(game:HttpGet(Base .. "Core.lua"))()
local Themes = loadstring(game:HttpGet(Base .. "Themes.lua"))()
local Assets = loadstring(game:HttpGet(Base .. "Assets.lua"))()

local TweenService = Core.TweenService
local LocalPlayer = Core.LocalPlayer

local function GetGui()
	local gui = Instance.new("ScreenGui")
	gui.Name = "Terminal"
	gui.ScreenInsets = Enum.ScreenInsets.None
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = 2147483647
	gui.Parent = Core.RunService:IsStudio() 
		and LocalPlayer:FindFirstChild("PlayerGui")
		or (gethui and gethui())
		or (cloneref and cloneref(Core.GetService("CoreGui"))) or Core.GetService("CoreGui")
	return gui
end

local function AddHover(Button: GuiButton, OnClick: () -> ())
	local tween_info = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

	Button.MouseEnter:Connect(function()
		TweenService:Create(Button, tween_info, { BackgroundTransparency = 0.6 }):Play()
	end)

	Button.MouseLeave:Connect(function()
		TweenService:Create(Button, tween_info, { BackgroundTransparency = 1 }):Play()
	end)

	if OnClick then
		Button.MouseButton1Click:Connect(OnClick)
	end
end

local function Build(OnClose: () -> (), OnMinimize: () -> (), OnMaximize : () -> ())
	local terminal = GetGui()

	local Background = Instance.new("Frame")
	Background.Name = "Background"
	Background.Parent = terminal
	Background.AnchorPoint = Vector2.new(0.5, 0.5)
	Background.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Background.BorderSizePixel = 0
	Background.Position = UDim2.new(0.5, 0, 0.5, 0)
	Background.Size = UDim2.new(0.4, 0, 0.55, 0)
	Themes.Register(Background, "BackgroundColor3", "Core")

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0.025, 0)
	UICorner.Parent = Background

	local Body = Instance.new("Frame")
	Body.Name = "Body"
	Body.Parent = Background
	Body.AnchorPoint = Vector2.new(0, 1)
	Body.BackgroundTransparency = 1
	Body.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Body.BorderSizePixel = 0
	Body.Position = UDim2.new(0, 0, 1, 0)
	Body.Size = UDim2.new(1, 0, 0.92, 0)
	Body.ZIndex = 2
	Themes.Register(Body, "BackgroundColor3", "Body")

	local Top = Instance.new("Frame")
	Top.Name = "Top"
	Top.Parent = Background
	Top.AnchorPoint = Vector2.new(1, 0)
	Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Top.BorderSizePixel = 0
	Top.Position = UDim2.new(1, 0, 0, 0)
	Top.Size = UDim2.new(1, 0, 0.08, 0)
	Themes.Register(Top, "BackgroundColor3", "Top")

	local UICorner2 = Instance.new("UICorner")
	UICorner2.CornerRadius = UDim.new(0.1, 0)
	UICorner2.Parent = Top

	local function MakeCornerFill(Anchor: number)
		local corner = Instance.new("Frame")
		corner.Name = "Corner"
		corner.AnchorPoint = Vector2.new(Anchor, 1)
		corner.BorderColor3 = Color3.fromRGB(0, 0, 0)
		corner.BorderSizePixel = 0
		corner.Position = UDim2.new(Anchor, 0, 1, 0)
		corner.Size = UDim2.new(0.05, 0, 0.2, 0)
		corner.Parent = Top
		Themes.Register(corner, "BackgroundColor3", "Top")
	end

	MakeCornerFill(0)
	MakeCornerFill(1)

	local Buttons = Instance.new("Frame")
	Buttons.Name = "Buttons"
	Buttons.AnchorPoint = Vector2.new(1, 1)
	Buttons.BackgroundTransparency = 1
	Buttons.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Buttons.BorderSizePixel = 0
	Buttons.Position = UDim2.new(1, 0, 1, 0)
	Buttons.Size = UDim2.new(0.25, 0, 1, 0)
	Buttons.Parent = Top

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0, 0)
	UIListLayout.Parent = Buttons

	local function MakeButton(Name: string, Key: string, Order: number, Offset: number)
		local button = Instance.new("ImageButton")
		button.Name = Name
		button.BackgroundTransparency = 1
		button.BorderColor3 = Color3.fromRGB(0, 0, 0)
		button.BorderSizePixel = 0
		button.Position = UDim2.new(0.9, 0, 0.35, 0)
		button.Size = UDim2.new(0.25, 0, 1, 0)
		button.LayoutOrder = Order
		button.Parent = Buttons
		Themes.Register(button, "BackgroundColor3", Key)

		local icon = Instance.new("ImageLabel")
		icon.Parent = button
		icon.BackgroundTransparency = 1
		icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		icon.BorderSizePixel = 0
		icon.AnchorPoint = Vector2.new(0.5, 0.5)
		icon.Position = UDim2.new(0.5, 0, 0.5, 0)
		icon.Size = UDim2.new(0.4, 0, 0.4, 0)
		icon.Image = Assets.Grid
		icon.ImageRectSize = Vector2.new(256, 256)
		icon.ImageRectOffset = Vector2.new(Offset, 0)
		Themes.Register(icon, "ImageColor3", "Icons")

		local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
		UIAspectRatioConstraint.Parent = button

		return button
	end

	local Minimize = MakeButton("Minimize", "Minimize", 1, 0)
	local Maximize = MakeButton("Maximize", "Maximize", 2, 512)
	local Close = MakeButton("Close", "Close", 3, 768)

	local Output = Instance.new("ScrollingFrame")
	Output.Name = "TerminalOutput"
	Output.BackgroundTransparency = 1
	Output.Size = UDim2.new(1, -10, 1, -10)
	Output.Position = UDim2.new(0, 5, 0, 5)
	Output.CanvasSize = UDim2.new(0, 0, 0, 0)
	Output.ScrollBarThickness = 4
	Output.BorderSizePixel = 0
	Output.ZIndex = 5
	Output.Parent = Body
	Themes.Register(Output, "ScrollBarImageColor3", "ScrollBar")

	local UIList = Instance.new("UIListLayout")
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	UIList.Parent = Output

	AddHover(Close, OnClose)
	AddHover(Minimize, OnMinimize)
	AddHover(Maximize, OnMaximize)

	return {
		terminal = terminal,
		Background = Background,
		Body = Body,
		Top = Top,
		Output = Output,
		UIList = UIList,
		Close = Close,
		Minimize = Minimize,
		Maximize = Maximize,
	}
end

return Build