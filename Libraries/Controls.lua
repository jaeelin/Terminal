local Controls = {}
 
local ContextActionService = cloneref and cloneref(game:GetService("ContextActionService")) or game:GetService("ContextActionService")
 
local BlockedKeys = {
	Enum.KeyCode.W,
	Enum.KeyCode.A,
	Enum.KeyCode.S,
	Enum.KeyCode.D,
	Enum.KeyCode.Space,
	Enum.KeyCode.Up,
	Enum.KeyCode.Down,
	Enum.KeyCode.Left,
	Enum.KeyCode.Right,
	Enum.KeyCode.O,
	Enum.KeyCode.I,
	Enum.KeyCode.P,
	Enum.KeyCode.Slash,
	Enum.KeyCode.Period,
}
 
function Controls.Block()
	ContextActionService:BindActionAtPriority(
		"Terminal",
		function()
			return Enum.ContextActionResult.Sink
		end,
		false,
		999999,
		table.unpack(BlockedKeys)
	)
end
 
function Controls.Unblock()
	ContextActionService:UnbindAction("Terminal")
end
 
return Controls