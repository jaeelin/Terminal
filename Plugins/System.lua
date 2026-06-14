local System = {}

local Players = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

function System.Register(WindowFunctions: {}, PrintLine: () -> (), Directory: string, PluginContext: {})
	local System = PluginContext.System

	WindowFunctions:AddCommand("whoami", function()
		PrintLine(System.Username)
	end, "Displays the current user name.")

	WindowFunctions:AddCommand("hostname", function()
		PrintLine(System.Hostname)
	end, "Displays the host name.")

	WindowFunctions:AddCommand("pwd", function()
		PrintLine(Directory)
	end, "Displays the current directory.")

	WindowFunctions:AddCommand("path", function()
		PrintLine("PATH=" .. Directory)
	end, "Displays the search path.")

	WindowFunctions:AddCommand("date", function()
		PrintLine(string.format("The current date is: %s", os.date("%a %m/%d/%Y")))
	end, "Displays the current date.")

	WindowFunctions:AddCommand("time", function()
		PrintLine(string.format("The current time is: %s.%02d", os.date("%H:%M:%S"), math.floor((tick() % 1) * 100)))
	end, "Displays the current system time.")

	WindowFunctions:AddCommand("systeminfo", function()
		PrintLine("")
		PrintLine("Host Name:                 " .. System.Hostname)
		PrintLine("OS Name:                   " .. System.Os)
		PrintLine("User Name:                 " .. System.Username)
		PrintLine("Boot Time:                 " .. os.date("%c", System.BootTime))
		PrintLine("IPv4 Address:              " .. System.Ip)
		PrintLine("Physical Address:          " .. System.MacAddress)
	end, "Displays system configuration information.")

	WindowFunctions:AddCommand("getmac", function()
		PrintLine("")
		PrintLine("Physical Address    Transport Name")
		PrintLine("=================== =======================================")
		PrintLine(System.MacAddress .. "     \\Device\\Tcpip_{SIMULATED}")
	end, "Displays the MAC address.")

	WindowFunctions:AddCommand("ipconfig", function()
		PrintLine("")
		PrintLine("Windows IP Configuration")
		PrintLine("")
		PrintLine("Ethernet adapter Ethernet:")
		PrintLine("")
		PrintLine("   IPv4 Address . . . . . . . . . . : " .. System.Ip)
	end, "Displays IP configuration.")

	WindowFunctions:AddCommand("exit", function()
		WindowFunctions:Unload()
	end, "Closes the terminal.")
end

return System