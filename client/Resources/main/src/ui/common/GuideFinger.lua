GuideFinger = class("GuideFinger", NodeBase)

function GuideFinger:ctor()
	GuideFinger.super.ctor(self)

	local animateSprite = cc.Sprite:create("fullmain/res/guide/finger/YD_0.png")
	local actionSprite = createAnimateWithPathFormat(0, "fullmain/res/guide/finger/YD_%d.png", 0.05, 10000000000)
	animateSprite:runAction(actionSprite)
	self:addChild(animateSprite)
end