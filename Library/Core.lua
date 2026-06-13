local Core = {
	Version = "1.0.0",
	Folder = "Terminal",
}

function Core.GetService(Service: string)
	return cloneref and cloneref(game:GetService(Service)) or game:GetService(Service)
end

Core.Players = Core.GetService("Players")
Core.RunService = Core.GetService("RunService")
Core.UserInputService = Core.GetService("UserInputService")
Core.ContextActionService = Core.GetService("ContextActionService")
Core.TweenService = Core.GetService("TweenService")

Core.LocalPlayer = Core.Players.LocalPlayer
Core.IsStudio = Core.RunService:IsStudio()

return Core