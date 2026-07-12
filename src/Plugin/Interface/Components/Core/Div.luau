local Fusion = require "../../../../Packages/Fusion"

local DefaultProps = require "../DefaultProps"

local function Div(scope: any, props: any)
	return scope:New "Frame"(DefaultProps({
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
	}, props.native))
end

return Div
