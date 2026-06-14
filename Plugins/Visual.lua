local Visual = {}

function Visual.Register(WindowFunctions: {}, PrintLine: () -> (), Directory: string, PluginContext: {})
	WindowFunctions:AddCommand("snow", function(Arguments: {string})
		local duration = tonumber(Arguments[1]) or 3
		local width = 300
		local height = 10

		local flakes = {}

		for i = 1, 80 do
			flakes[i] = {x = math.random(1, width), y = math.random(1, height)}
		end

		local start = os.clock()

		while os.clock() - start < duration do
			local grid = {}

			for i = 1, height do
				grid[i] = {}
				for j = 1, width do
					grid[i][j] = " "
				end
			end

			for i = 1, #flakes do
				local flake = flakes[i]
				flake.y = flake.y + 1

				if flake.y > height then
					flake.y = 1
					flake.x = math.random(1, width)
				end

				grid[flake.y][flake.x] = "*"
			end

			for y = 1, height do
				local line = ""

				for x = 1, width do
					line = line .. grid[y][x]
				end

				PrintLine(line)
			end

			PrintLine("")
			
			task.wait(0.1)
		end
	end, "Falling snow animation.")
end

return Visual