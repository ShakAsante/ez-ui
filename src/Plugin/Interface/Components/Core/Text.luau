local Fusion = require "../../../../Packages/Fusion"
local DefaultProps = require "../DefaultProps"

return function(Scope: any, props: any)
	local Text = Scope:New "TextLabel"(DefaultProps({
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Text = props.text,
		Font = props.font,
		TextScaled = props.scaled,
		TextColor3 = props.color,
	}, props.native))

	return Text
end
