local Fusion = require "../../../../Packages/Fusion"

local DefaultProps = require "../DefaultProps"

return function(Scope: any, props: any)
	return Scope:New "UIPadding"(DefaultProps({
		PaddingTop = props.PaddingTop,
		PaddingBottom = props.PaddingBottom,
		PaddingLeft = props.PaddingLeft,
		PaddingRight = props.PaddingRight,
	}, props))
end
