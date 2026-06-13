local DefaultCommands = {}

function DefaultCommands.Register(WindowFunctions: {}, PrintLine: () -> (), Directory: string)
	WindowFunctions:AddCommand("help", function()
		PrintLine("Available commands:")
		for name, data in next, WindowFunctions.Commands do
			PrintLine("  " .. name .. " - " .. data.description)
		end
	end, "No Description.")

	WindowFunctions:AddCommand("clear", function()
		local output = WindowFunctions.Output
		if not output then return end

		local children = output:GetChildren()

		for i = 1, #children do
			local child = children[i]

			if child:IsA("TextLabel") then
				child:Destroy()
			end
		end
	end, "No Description")

	WindowFunctions:AddCommand("echo", function(args)
		PrintLine(table.concat(args, " "))
	end, "No Description")

	WindowFunctions:AddCommand("cd", function(args)
		if args[1] then
			Directory = args[1]
		end
	end, "No Description")

	WindowFunctions:AddCommand("theme", function(args)
		if not args[1] then
			PrintLine("Usage: theme <name>")
			PrintLine("Available themes:")
			
			local themes = WindowFunctions:GetThemes()
			
			for i = 1, #themes do
				local theme = themes[i]
				PrintLine("  - " .. theme)
			end

			return
		end

		local ok, err = WindowFunctions:SetTheme(args[1])

		if not ok then
			PrintLine("Error: " .. err)
		else
			PrintLine("Theme set to '" .. args[1] .. "'.")
		end
	end, "No Description")

	WindowFunctions:AddCommand("themes", function()
		PrintLine("Available themes: " .. table.concat(WindowFunctions:GetThemes(), ", "))
	end, "No Description")

	WindowFunctions:AddCommand("version", function()
		PrintLine("Terminal Version: " .. (WindowFunctions.Version or "unknown"))
	end, "No Description")

end

return DefaultCommands