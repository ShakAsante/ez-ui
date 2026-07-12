local Object = require "../Object"
local Plugin = require "./Plugin"
local Fusion = require "../Packages/Fusion"

local Settings = Object:Extend()

type SettingsTree = { [any]: any }
type SettingsPath = { string }

local SETTINGS_TEMPLATE = {
	converter = {
		framework = "native",
	},

	figma = {
		-- roblosecurity = "",
		-- port = 8080,
	},
}

function Settings:Init()
	self.plugin = Plugin:GetPlugin()

	self.scope = Fusion.scoped(Fusion)
	self.data = self:ToStates(self.scope, SETTINGS_TEMPLATE)

	self:LoadSettings()
end

--[=[
	Recursively rebuilds `template` with every leaf value wrapped in a Fusion
	`Value`, so settings can be observed/bound to UI. Nested tables stay as
	plain tables of states.

	@param scope Fusion scope used to own the created `Value` states
	@param template SettingsTree
	@return SettingsTree
]=]
function Settings:ToStates(scope, template: SettingsTree): SettingsTree
	local states = {}

	for key, value in pairs(template) do
		if type(value) == "table" then
			states[key] = self:ToStates(scope, value)
		else
			states[key] = scope:Value(value)
		end
	end

	return states
end

--[=[
	Recursively writes plain `values` into an existing state tree (as produced
	by `ToStates`) via `:set`, preserving state object identity so anything
	already bound to those states keeps observing them.

	@param states SettingsTree
	@param values SettingsTree
]=]
function Settings:ApplyValues(states: SettingsTree, values: SettingsTree): ()
	for key, value in pairs(values) do
		local state = states[key]

		if type(state) == "table" and state.type == "State" then
			state:set(value)
		elseif type(state) == "table" and type(value) == "table" then
			self:ApplyValues(state, value)
		end
	end
end

--[=[
	Recursively unwraps a state tree (as produced by `ToStates`) back into
	plain values, so it can be serialized via `plugin:SetSetting`.

	@param states SettingsTree
	@return SettingsTree
]=]
function Settings:ToValues(states: SettingsTree): SettingsTree
	local values = {}

	for key, state in pairs(states) do
		if type(state) == "table" and state.type == "State" then
			values[key] = Fusion.peek(state)
		elseif type(state) == "table" then
			values[key] = self:ToValues(state)
		end
	end

	return values
end

--[=[
	Walks `path` (a sequence of nested keys, e.g. `{ "figma", "port" }`) down
	the settings state tree and returns whatever state object lives there.

	@param path SettingsPath
	@return Fusion state object, or nil if the path doesn't resolve to one
]=]
function Settings:GetState(path: SettingsPath): any
	local node = self.data

	for _, key in ipairs(path) do
		if type(node) ~= "table" then
			return nil
		end

		node = node[key]
	end

	return node
end

--[=[
	Reads the current value of an individual setting, without affecting any
	other setting.

	@param path SettingsPath
	@return any
]=]
function Settings:Get(path: SettingsPath): any
	local state = self:GetState(path)

	if type(state) == "table" and state.type == "State" then
		return Fusion.peek(state)
	end

	return nil
end

--[=[
	Sets an individual setting's value in place, leaving every other setting
	untouched, by walking `path` down to its state and calling `:set` on it.

	@param path SettingsPath
	@param value any
	@error "Unknown setting path" -- thrown if `path` doesn't resolve to a state
]=]
function Settings:Set(path: SettingsPath, value: any): ()
	local state = self:GetState(path)

	assert(type(state) == "table" and state.type == "State", "Unknown setting path")

	state:set(value)
end

function Settings:LoadSettings()
	local saved = self.plugin:GetSetting "Settings"

	if saved then
		self:ApplyValues(self.data, saved)
	end
end

function Settings:SaveSettings()
	self.plugin:SetSetting("Settings", self:ToValues(self.data))
end

return Settings
