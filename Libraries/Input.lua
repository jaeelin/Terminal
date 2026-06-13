local Input = {}

local UserInputService = cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")

local Shifted = {
	[";"] = ":",
	["'"] = "\"",
	[","] = "<",
	["."] = ">",
	["/"] = "?",
	["["] = "{",
	["]"] = "}",
	["-"] = "_",
	["="] = "+",
}

local Punctuation = {
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

function Input.Bind(Context: {})
	local caps = false
	local last_key = {}

	Context.Background.InputBegan:Connect(function(Input: Enum)
		if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

		Context.focused = true
		Context.Controls.Block()
	end)

	UserInputService.InputBegan:Connect(function(Input: Enum)
		if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

		if not Context.focused then return end

		local mouse = UserInputService:GetMouseLocation()
		local position  = Context.Output.AbsolutePosition
		local size = Context.Output.AbsoluteSize

		local inside =
			mouse.X >= position.X and mouse.X <= position.X + size.X and
			mouse.Y >= position.Y and mouse.Y <= position.Y + size.Y

		if not inside then
			Context.focused = false
			Context.Controls.Unblock()
		end
	end)

	UserInputService.InputBegan:Connect(function(Input: Enum)
		if Input.KeyCode == Enum.KeyCode.CapsLock then
			caps = not caps
		end
	end)

	UserInputService.InputBegan:Connect(function(Input: Enum)
		if not Context.active_prompt or not Context.focused or Context.command_busy then return end

		local key = Input.KeyCode

		if key == Enum.KeyCode.Return then
			local raw = Context.active_prompt.Text:sub(#Context.directory + 3)
			Context.OnSubmit(raw)
			return
		end

		if key == Enum.KeyCode.Backspace then
			local raw = Context.active_prompt.Text:sub(#Context.directory + 3)
			raw = raw:sub(1, #raw - 1)
			Context.active_prompt.Text = Context.directory .. "> " .. raw
			Context.caret.Position = UDim2.new(0, Context.active_prompt.TextBounds.X + 2, 0, 0)
			return
		end

		if key == Enum.KeyCode.Up then
			Context.history_index = math.clamp(Context.history_index - 1, 1, #Context.history)
			local cmd = Context.history[Context.history_index] or ""
			Context.active_prompt.Text = Context.directory .. "> " .. cmd
			Context.caret.Position = UDim2.new(0, Context.active_prompt.TextBounds.X + 2, 0, 0)
			return
		end

		if key == Enum.KeyCode.Down then
			Context.history_index = math.clamp(Context.history_index + 1, 1, #Context.history)
			local cmd = Context.history[Context.history_index] or ""
			Context.active_prompt.Text = Context.directory .. "> " .. cmd
			Context.caret.Position = UDim2.new(0, Context.active_prompt.TextBounds.X + 2, 0, 0)
			return
		end

		local now = os.clock()

		if last_key[key] and now - last_key[key] < 0.03 then return end

		last_key[key] = now

		local character = UserInputService:GetStringForKeyCode(key)

		if (not character or character == "") and Punctuation[key] then
			character = Punctuation[key]
		end

		if not character or character == "" then return end

		local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)

		if shift and Shifted[character] then
			character = Shifted[character]
		else
			if caps ~= shift then
				character = string.upper(character)
			else
				character = string.lower(character)
			end
		end

		Context.active_prompt.Text ..= character

		task.defer(function()
			if Context.caret then
				Context.caret.Position = UDim2.new(0, Context.active_prompt.TextBounds.X + 10, 0, 0)
			end
		end)
	end)
end

return Input