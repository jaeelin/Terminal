local Players = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local VariableController = {}

function VariableController.Register(WindowFunctions: {}, PrintLine: () -> (), Directory: string, PluginContext: {})
	PluginContext.System = {
		Username = LocalPlayer.Name,
		Hostname = "DESKTOP-4K8P7A2",

		Ip = "192.168.1.104",
		MacAddress = "00-1A-2B-3C-4D-5E",

		Os = string.format("Calamari [Version %s]", WindowFunctions.Version or "unknown"),

		BootTime = os.time(),
	}
end

return VariableController