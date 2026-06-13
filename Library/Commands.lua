local function Init(WindowFunctions, PrintLine, State, Themes)
	WindowFunctions:AddCommand("help", function()
		PrintLine("Available commands:")
		for name, data in next, WindowFunctions.Commands do
			PrintLine("  " .. name .. " - " .. data.description)
		end
	end, "No description")

	WindowFunctions:AddCommand("clear", function()
		for _, child in ipairs(State.Output:GetChildren()) do
			if child:IsA("TextLabel") then
				child:Destroy()
			end
		end
	end, "No description")

	WindowFunctions:AddCommand("echo", function(args)
		PrintLine(table.concat(args, " "))
	end, "No description")

	WindowFunctions:AddCommand("cd", function(args)
		if args[1] then
			State.directory = args[1]
		else
			PrintLine(State.directory)
		end
	end, "No description")

	WindowFunctions:AddCommand("theme", function(args)
		if not args[1] then
			PrintLine("Current theme: " .. Themes.GetCurrent())
			PrintLine("Available themes:")

			for _, theme in next, Themes.GetAll() do
				PrintLine("  - " .. theme)
			end

			return
		end

		local ok, err = Themes.Set(args[1])
		if ok then
			PrintLine("Theme set to '" .. args[1] .. "'.")
		else
			PrintLine("Error: " .. err)
		end
	end, "No description")

	WindowFunctions:AddCommand("version", function()
		PrintLine("Calamari Terminal [Version " .. (State.Version) .. "]")
	end, "No description")
end

return Init