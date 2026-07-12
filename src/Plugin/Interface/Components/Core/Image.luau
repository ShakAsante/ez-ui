local Fusion = require "../../../../Packages/Fusion"

local DefaultProps = require "../DefaultProps"

return function(Scope: any, props: any)
	local Image = Scope:New "ImageLabel"(DefaultProps({
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		ImageTransparency = props.transparency,
		Image = props.texture,
	}, props.native))
	return Image
end
