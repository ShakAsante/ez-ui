local Object = require "../Object"
local Plugin = Object:Extend()

function Plugin:Init()
	self.plugin = nil
	self.version = "0.0.3"
	self.name = "UI X"
	self.description = "A semantic UI plugin for Roblox"
	self.author = "@OfficialShakRBLX"
end

function Plugin:SetPlugin(plugin: Plugin)
	self.plugin = plugin
end

function Plugin:GetPlugin(): Plugin
	return self.plugin
end

function Plugin:GetVersion(): string
	return self.version
end

function Plugin:CreateActions()
	local actions = { {
		"",
		"Binds",
		"",
	} }

	return actions
end

return Plugin
