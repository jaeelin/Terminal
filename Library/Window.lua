local Base = "https://raw.githubusercontent.com/jaeelin/Terminal/main/Library/"

local Core = loadstring(game:HttpGet(Base .. "Core.lua"))()
local Themes = loadstring(game:HttpGet(Base .. "Themes.lua"))()
local BuildGui = loadstring(game:HttpGet(Base .. "Gui.lua"))()
local InitInput = loadstring(game:HttpGet(Base .. "Input.lua"))()
local InitCommands = loadstring(game:HttpGet(Base .. "Commands.lua"))()

local LocalPlayer = Core.LocalPlayer

local Terminal = {
	Version = Core.Version,
	Folder = Core.Folder,
	GetService = Core.GetService,
}

function Terminal:Window(Settings: {any}?)
	Settings = Settings or {}

	if Settings.Theme then
		Themes.Set(Settings.Theme)
	end

	local WindowFunctions = {
		Settings = Settings,
		Commands = {},
		History = {},
		HistoryIndex = 0,
	}

	local State = {
		active_prompt = nil,
		focused = false,
		caps = false,
		command_busy = false,
		caret = nil,
		caret_visible = true,
		directory = "C:\\Users\\" .. (LocalPlayer and LocalPlayer.Name or "User"),
		History = WindowFunctions.History,
		HistoryIndex = WindowFunctions.HistoryIndex,
		Output = nil,
		Version = Core.Version,
	}

	local unload_callback = nil
	local gui
	local UIList

	function WindowFunctions:AddCommand(Name: string, Callback: () -> (), Description: string?)
		self.Commands[Name] = {
			callback = Callback,
			description = Description or "No description",
		}
	end

	function WindowFunctions:SetTheme(Name: string)
		return Themes.Set(Name)
	end

	function WindowFunctions:GetTheme()
		return Themes.GetCurrent()
	end

	function WindowFunctions:GetThemes()
		return Themes.GetAll()
	end

	function WindowFunctions:Unload()
		if unload_callback then unload_callback() end
		
		gui.terminal:Destroy()
	end

	function WindowFunctions.OnUnloaded(Callback: () -> ())
		unload_callback = Callback
	end

	local function PrintLine(Text: string)
		local label = Instance.new("TextLabel")
		label.Parent = State.Output
		label.BackgroundTransparency = 1
		label.Size = UDim2.new(1, -5, 0, 20)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Text = Text
		label.Font = Enum.Font.Code
		label.TextSize = 18
		label.ZIndex = 5
		Themes.Register(label, "TextColor3", "OutputLine")

		State.Output.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 10)
		State.Output.CanvasPosition = Vector2.new(0, State.Output.CanvasSize.Y.Offset)
	end

	local function NewPrompt()
		if State.caret then State.caret:Destroy() end

		local line = Instance.new("TextLabel")
		line.Parent = State.Output
		line.BackgroundTransparency = 1
		line.Size = UDim2.new(1, -5, 0, 20)
		line.TextXAlignment = Enum.TextXAlignment.Left
		line.Font = Enum.Font.Code
		line.TextSize = 18
		line.ZIndex = 5
		line.Text = State.directory .. "> "
		Themes.Register(line, "TextColor3", "ActivePrompt")

		State.active_prompt = line

		local caret = Instance.new("TextLabel")
		caret.Parent = line
		caret.BackgroundTransparency = 1
		caret.Size = UDim2.new(0, 10, 1, 0)
		caret.Position = UDim2.new(0, State.active_prompt.TextBounds.X + 2, 0, 0)
		caret.Text = "_"
		caret.Font = Enum.Font.Code
		caret.TextSize = 18
		caret.ZIndex = 6
		Themes.Register(caret, "TextColor3", "Caret")

		State.caret = caret

		task.spawn(function()
			while State.caret and State.caret.Parent do
				State.caret_visible = not State.caret_visible
				State.caret.Visible = State.caret_visible
				task.wait(0.5)
			end
		end)

		State.Output.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 10)
		State.Output.CanvasPosition = Vector2.new(0, State.Output.CanvasSize.Y.Offset)
	end

	local function RunCommand(Text: string)
		if State.command_busy then return end
		
		State.command_busy = true

		table.insert(WindowFunctions.History, Text)
		
		WindowFunctions.HistoryIndex = #WindowFunctions.History + 1
		State.HistoryIndex = WindowFunctions.HistoryIndex

		local split = Text:split(" ")
		local cmd = split[1]:lower()
		local arguments = {}

		for i = 2, #split do
			table.insert(arguments, split[i])
		end

		local command = WindowFunctions.Commands[cmd]
		if command then
			local ok, err = pcall(command.callback, arguments)
			if not ok then
				PrintLine("Error: " .. tostring(err))
			end
		else
			PrintLine("'" .. cmd .. "' is not recognized as an internal or external command.")
		end

		State.command_busy = false
		
		NewPrompt()
	end

	gui = BuildGui(
		function() WindowFunctions:Unload() end,
		function() end,
		function() end
	)

	State.Output = gui.Output
	UIList = gui.UIList

	gui.Background.InputBegan:Connect(function(Input: InputObject)
		if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
		State.Focus()
	end)

	InitInput(State, RunCommand, gui.Output)
	InitCommands(WindowFunctions, PrintLine, State, Themes)

	WindowFunctions.Print = PrintLine

	PrintLine(string.format("Calamari.xxx [Version %s]", Core.Version))
	PrintLine("(c) Calamari Softwares. All rights reserved.")
	PrintLine("")

	NewPrompt()

	WindowFunctions.OnUnloaded(function()
		State.UnblockControls()
	end)

	Themes.Set(Themes.GetCurrent())

	return WindowFunctions
end

return Terminal