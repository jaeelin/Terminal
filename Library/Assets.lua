local Base = "https://raw.githubusercontent.com/jaeelin/Terminal/main/Library/"
local Core = loadstring(game:HttpGet(Base .. "Core.lua"))()

if Core.IsStudio then
	return { Grid = "rbxassetid://0" }
end

local AssetLoader = loadstring(game:HttpGet("https://raw.githubusercontent.com/jaeelin/Terminal/refs/heads/main/Utilities/AssetLoader.lua"))()

return {
	Grid = AssetLoader:Get("", "Grid1.png")
}