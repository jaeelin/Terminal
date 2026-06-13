local Themes = {}

local ThemedElements = {}
local ThemedCallbacks = {}
local CurrentTheme = "Calamari"

Themes.Definitions = {
	Calamari = {
		Core = Color3.fromRGB(14, 12, 22),
		Body = Color3.fromRGB(18, 16, 28),
		Top = Color3.fromRGB(24, 20, 36),
		Close = Color3.fromRGB(190, 175, 230),
		Maximize = Color3.fromRGB(18, 16, 28),
		Minimize = Color3.fromRGB(18, 16, 28),
		Caret = Color3.fromRGB(200, 180, 255),
		ActivePrompt = Color3.fromRGB(235, 230, 255),
		OutputLine = Color3.fromRGB(190, 175, 230),
		ScrollBar = Color3.fromRGB(140, 120, 200),
		Icons = Color3.fromRGB(230, 225, 255),
	},
	Dark = {
		Core = Color3.fromRGB(12, 12, 14),
		Body = Color3.fromRGB(18, 18, 20),
		Top = Color3.fromRGB(22, 22, 26),
		Close = Color3.fromRGB(45, 45, 50),
		Maximize = Color3.fromRGB(45, 45, 50),
		Minimize = Color3.fromRGB(45, 45, 50),
		Caret = Color3.fromRGB(0, 255, 160),
		ActivePrompt = Color3.fromRGB(240, 240, 240),
		OutputLine = Color3.fromRGB(170, 170, 170),
		ScrollBar = Color3.fromRGB(90, 90, 90),
		Icons = Color3.fromRGB(255, 255, 255),
	},
	Light = {
		Core = Color3.fromRGB(245, 245, 245),
		Body = Color3.fromRGB(255, 255, 255),
		Top = Color3.fromRGB(235, 235, 235),
		Close = Color3.fromRGB(230, 230, 230),
		Maximize = Color3.fromRGB(230, 230, 230),
		Minimize = Color3.fromRGB(230, 230, 230),
		Caret = Color3.fromRGB(0, 0, 0),
		ActivePrompt = Color3.fromRGB(20, 20, 20),
		OutputLine = Color3.fromRGB(80, 80, 80),
		ScrollBar = Color3.fromRGB(140, 140, 140),
		Icons = Color3.fromRGB(0, 0, 0),
	},
	Nord = {
		Core = Color3.fromRGB(46, 52, 64),
		Body = Color3.fromRGB(59, 66, 82),
		Top = Color3.fromRGB(67, 76, 94),
		Close = Color3.fromRGB(67, 76, 94),
		Maximize = Color3.fromRGB(67, 76, 94),
		Minimize = Color3.fromRGB(67, 76, 94),
		Caret = Color3.fromRGB(236, 239, 244),
		ActivePrompt = Color3.fromRGB(236, 239, 244),
		OutputLine = Color3.fromRGB(180, 190, 200),
		ScrollBar = Color3.fromRGB(129, 161, 193),
		Icons = Color3.fromRGB(255, 255, 255),
	},
	Sapphire = {
		Core = Color3.fromRGB(10, 14, 20),
		Body = Color3.fromRGB(16, 22, 30),
		Top = Color3.fromRGB(22, 30, 40),
		Close = Color3.fromRGB(40, 45, 55),
		Maximize = Color3.fromRGB(40, 45, 55),
		Minimize = Color3.fromRGB(40, 45, 55),
		Caret = Color3.fromRGB(120, 200, 255),
		ActivePrompt = Color3.fromRGB(220, 240, 255),
		OutputLine = Color3.fromRGB(160, 180, 200),
		ScrollBar = Color3.fromRGB(80, 110, 140),
		Icons = Color3.fromRGB(200, 220, 255),
	},
	Obsidian = {
		Core = Color3.fromRGB(8, 8, 10),
		Body = Color3.fromRGB(12, 12, 14),
		Top = Color3.fromRGB(18, 18, 20),
		Close = Color3.fromRGB(35, 35, 35),
		Maximize = Color3.fromRGB(35, 35, 35),
		Minimize = Color3.fromRGB(35, 35, 35),
		Caret = Color3.fromRGB(0, 255, 180),
		ActivePrompt = Color3.fromRGB(230, 230, 230),
		OutputLine = Color3.fromRGB(150, 150, 150),
		ScrollBar = Color3.fromRGB(70, 70, 70),
		Icons = Color3.fromRGB(255, 255, 255),
	},
	Aurora = {
		Core = Color3.fromRGB(18, 10, 24),
		Body = Color3.fromRGB(24, 14, 32),
		Top = Color3.fromRGB(30, 18, 40),
		Close = Color3.fromRGB(50, 30, 60),
		Maximize = Color3.fromRGB(50, 30, 60),
		Minimize = Color3.fromRGB(50, 30, 60),
		Caret = Color3.fromRGB(255, 80, 200),
		ActivePrompt = Color3.fromRGB(240, 220, 255),
		OutputLine = Color3.fromRGB(200, 160, 220),
		ScrollBar = Color3.fromRGB(180, 100, 255),
		Icons = Color3.fromRGB(255, 255, 255),
	},
	Carbon = {
		Core = Color3.fromRGB(20, 20, 20),
		Body = Color3.fromRGB(25, 25, 25),
		Top = Color3.fromRGB(30, 30, 30),
		Close = Color3.fromRGB(45, 45, 45),
		Maximize = Color3.fromRGB(45, 45, 45),
		Minimize = Color3.fromRGB(45, 45, 45),
		Caret = Color3.fromRGB(255, 255, 255),
		ActivePrompt = Color3.fromRGB(220, 220, 220),
		OutputLine = Color3.fromRGB(160, 160, 160),
		ScrollBar = Color3.fromRGB(110, 110, 110),
		Icons = Color3.fromRGB(235, 235, 235),
	},
	Emerald = {
		Core = Color3.fromRGB(8, 18, 12),
		Body = Color3.fromRGB(12, 24, 16),
		Top = Color3.fromRGB(16, 32, 22),
		Close = Color3.fromRGB(30, 50, 35),
		Maximize = Color3.fromRGB(30, 50, 35),
		Minimize = Color3.fromRGB(30, 50, 35),
		Caret = Color3.fromRGB(0, 255, 140),
		ActivePrompt = Color3.fromRGB(200, 255, 220),
		OutputLine = Color3.fromRGB(140, 200, 160),
		ScrollBar = Color3.fromRGB(60, 140, 100),
		Icons = Color3.fromRGB(180, 255, 210),
	},
}

function Themes.Register(Instance: Instance, Property: string, Key: string)
	table.insert(ThemedElements, {
		instance = Instance,
		property = Property,
		key = Key,
	})
	
	Instance[Property] = Themes.Definitions[CurrentTheme][Key]
end

function Themes.RegisterCallback(Callback: (string) -> ())
	table.insert(ThemedCallbacks, Callback)
	Callback(CurrentTheme)
end

function Themes.Set(Theme: string): (boolean, string?)
	if not Themes.Definitions[Theme] then
		return false, "Theme '" .. Theme .. "' does not exist."
	end

	CurrentTheme = Theme

	for _, entry in next, ThemedElements do
		if entry.instance and entry.instance.Parent then
			entry.instance[entry.property] = Themes.Definitions[Theme][entry.key]
		end
	end

	for _, callback in next, ThemedCallbacks do
		callback(Theme)
	end

	return true
end

function Themes.GetCurrent(): string
	return CurrentTheme
end

function Themes.GetAll(): {string}
	local list = {}
	
	for name in next, Themes.Definitions do
		table.insert(list, name)
	end
	
	table.sort(list)
	
	return list
end

return Themes