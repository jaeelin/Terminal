local Input = {}

local UserInputService = cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local RunService = cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")

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

function Input.Bind(WindowFunctions: {}, Context: {})
	local caps = false
	local last_key = {}
	
	local dragging = false

	local drag_start = nil
	local start_position = nil
	local target_position = nil
	
	local last_click = 0

	Context.Top.InputBegan:Connect(function(Input: Enum)
		if not Context.can_drag then return end
		
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			local now = tick()

			if now - last_click <= 0.25 then
				WindowFunctions:Maximize()
				last_click = 0
				return
			end

			last_click = now

			dragging = true
			drag_start = Input.Position
			start_position = Context.Background.Position
		end
	end)

	Context.Top.InputEnded:Connect(function(Input: Enum)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(Input: Enum)
		if not Context.can_drag then return end

		if dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
			if Context.maximized then
				local mouse = Input.Position

				local relativeX = (mouse.X - Context.Background.AbsolutePosition.X) / Context.Background.AbsoluteSize.X

				local relativeY = (mouse.Y - Context.Background.AbsolutePosition.Y) / Context.Background.AbsoluteSize.Y

				Context.Background.Size = UDim2.new(0.4, 0, 0.55, 0)

				local new_size = Context.Background.AbsoluteSize

				start_position = UDim2.fromOffset(
					mouse.X - new_size.X * relativeX + new_size.X * 0.5,
					mouse.Y - new_size.Y * relativeY + new_size.Y * 0.5
				)

				drag_start = mouse

				Context.maximized = false
			end
			
			local delta = Input.Position - drag_start
			target_position = UDim2.new(
				start_position.X.Scale,
				start_position.X.Offset + delta.X,
				start_position.Y.Scale,
				start_position.Y.Offset + delta.Y
			)
		end
	end)

	RunService.RenderStepped:Connect(function()
		if not Context.can_drag or not dragging or not target_position then return end
		
		Context.Background.Position = Context.Background.Position:Lerp(target_position, 0.35)
	end)

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
	
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.V and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			local prompt = Context.active_prompt
			if not prompt then return end

			Context.InputBox.Text = ""
			Context.InputBox:CaptureFocus()

			task.wait()
			
			local pasted = Context.InputBox.Text
			Context.InputBox:ReleaseFocus()

			if pasted == "" then return end

			prompt.Text = prompt.Text .. pasted

			if Context.caret then
				Context.caret.Position = UDim2.new(0, prompt.TextBounds.X + 2, 0, 0)
			end
		end
	end)
end

return Input