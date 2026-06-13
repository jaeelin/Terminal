local Base = "https://raw.githubusercontent.com/jaeelin/Terminal/main/Library/"
local Core = loadstring(game:HttpGet(Base .. "Core.lua"))()

local UserInputService = Core.UserInputService
local ContextActionService = Core.ContextActionService

local function Init(State: {any}, RunCommand: () -> (), Output: Instance)
	local shifted = {
		[";"] = ":", ["'"] = "\"", [","] = "<", ["."] = ">",
		["/"] = "?", ["["] = "{", ["]"] = "}", ["-"] = "_", ["="] = "+",
	}

	local punctuation = {
		[Enum.KeyCode.Semicolon] = ";",
		[Enum.KeyCode.Quote] = "'",
		[Enum.KeyCode.Comma] = ",",
		[Enum.KeyCode.Period] = ".",
		[Enum.KeyCode.Slash] = "/",
		[Enum.KeyCode.BackSlash] = "\\",
		[Enum.KeyCode.LeftBracket] = "[",
		[Enum.KeyCode.RightBracket] = "]",
		[Enum.KeyCode.Minus] = "-",
		[Enum.KeyCode.Equals] = "=",
	}

	local function BlockControls()
		ContextActionService:BindActionAtPriority(
			"Terminal",
			function() return Enum.ContextActionResult.Sink end,
			false,
			999999,
			Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D,
			Enum.KeyCode.Space, Enum.KeyCode.Up, Enum.KeyCode.Down,
			Enum.KeyCode.Left, Enum.KeyCode.Right,
			Enum.KeyCode.O, Enum.KeyCode.I, Enum.KeyCode.P,
			Enum.KeyCode.Slash, Enum.KeyCode.Period
		)
	end

	local function UnblockControls()
		ContextActionService:UnbindAction("Terminal")
	end

	State.BlockControls = BlockControls
	State.UnblockControls = UnblockControls

	function State.Focus()
		State.focused = true
		BlockControls()
	end

	function State.Blur()
		State.focused = false
		UnblockControls()
	end

	local last_key = {}

	UserInputService.InputBegan:Connect(function(Input: InputObject)
		if not State.active_prompt or not State.focused or State.command_busy then return end

		local key = Input.KeyCode

		if key == Enum.KeyCode.Return then
			local raw = State.active_prompt.Text:sub(#State.directory + 3)
			RunCommand(raw)
			return
		end

		if key == Enum.KeyCode.Backspace then
			local raw = State.active_prompt.Text:sub(#State.directory + 3)
			raw = raw:sub(1, #raw - 1)
			State.active_prompt.Text = State.directory .. "> " .. raw
			State.caret.Position = UDim2.new(0, State.active_prompt.TextBounds.X + 2, 0, 0)
			return
		end

		if key == Enum.KeyCode.Up then
			State.HistoryIndex = math.clamp(State.HistoryIndex - 1, 1, #State.History)
			local cmd = State.History[State.HistoryIndex] or ""
			State.active_prompt.Text = State.directory .. "> " .. cmd
			State.caret.Position = UDim2.new(0, State.active_prompt.TextBounds.X + 2, 0, 0)
			return
		end

		if key == Enum.KeyCode.Down then
			State.HistoryIndex = math.clamp(State.HistoryIndex + 1, 1, #State.History)
			local cmd = State.History[State.HistoryIndex] or ""
			State.active_prompt.Text = State.directory .. "> " .. cmd
			State.caret.Position = UDim2.new(0, State.active_prompt.TextBounds.X + 2, 0, 0)
			return
		end

		local now = os.clock()
		if last_key[key] and now - last_key[key] < 0.03 then return end
		last_key[key] = now

		local character = UserInputService:GetStringForKeyCode(key)
		if (not character or character == "") and punctuation[key] then
			character = punctuation[key]
		end
		if not character or character == "" then return end

		local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
			or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)

		if shift and shifted[character] then
			character = shifted[character]
		elseif State.caps ~= shift then
			character = string.upper(character)
		else
			character = string.lower(character)
		end

		State.active_prompt.Text ..= character

		task.defer(function()
			if State.caret then
				State.caret.Position = UDim2.new(0, State.active_prompt.TextBounds.X + 10, 0, 0)
			end
		end)
	end)

	UserInputService.InputBegan:Connect(function(Input: InputObject)
		if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
		if not State.focused then return end

		local mouse_location = UserInputService:GetMouseLocation()
		local absolute_position = Output.AbsolutePosition
		local absolute_size = Output.AbsoluteSize

		local inside =
			mouse_location.X >= absolute_position.X and mouse_location.X <= absolute_position.X + absolute_size.X and
			mouse_location.Y >= absolute_position.Y and mouse_location.Y <= absolute_position.Y + absolute_size.Y

		if not inside then
			State.Blur()
		end
	end)

	UserInputService.InputBegan:Connect(function(Input: InputObject)
		if Input.KeyCode == Enum.KeyCode.CapsLock then
			State.caps = not State.caps
		end
	end)
end

return Init