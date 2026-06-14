local DefaultCommands = {}

function DefaultCommands.Register(WindowFunctions: {}, PrintLine: () -> (), InputContext: {})
	WindowFunctions:AddCommand("help", function()
		PrintLine("Available commands:")
		
		for i = 1, #WindowFunctions.CommandOrder do
			local name = WindowFunctions.CommandOrder[i]
			local data = WindowFunctions.Commands[name]

			if data then
				PrintLine("  " .. name .. " - " .. data.description)
			end
		end
	end, "Display the supported commands.")

	WindowFunctions:AddCommand("cls", function()
		local output = WindowFunctions.Output
		if not output then return end

		local children = output:GetChildren()

		for i = 1, #children do
			local child = children[i]

			if child:IsA("TextLabel") then
				child:Destroy()
			end
		end
	end, "Clear the contents of the terminal.")

	WindowFunctions:AddCommand("echo", function(arguments)
		PrintLine(table.concat(arguments, " "))
	end, "Repeat the given text.")
	
	WindowFunctions:AddCommand("title", function(arguments)
		if arguments[1] then
			WindowFunctions.Title.Text = arguments[1]
		end
	end, "Change the terminal title.")

	WindowFunctions:AddCommand("cd", function(arguments)
		if arguments[1] then
			InputContext.directory = arguments[1]
		end
	end, "Change the current directory.")

	WindowFunctions:AddCommand("theme", function(arguments)
		if not arguments[1] then
			PrintLine("Usage: theme <name>")
			return
		end

		local ok, err = WindowFunctions:SetTheme(arguments[1])

		if not ok then
			PrintLine("Error: " .. err)
		else
			PrintLine("Theme set to '" .. arguments[1] .. "'.")
		end
	end, "Set the terminal theme.")

	WindowFunctions:AddCommand("themes", function()
		PrintLine("Available themes: ")
		
		local themes = WindowFunctions:GetThemes()

		for i = 1, #themes do
			local theme = themes[i]
			PrintLine("  - " .. theme)
		end
	end, "List all available themes.")

	WindowFunctions:AddCommand("version", function()
		PrintLine("Terminal Version: " .. (WindowFunctions.Version or "unknown"))
	end, "Display the terminal version.")

end

return DefaultCommands