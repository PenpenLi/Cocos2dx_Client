ui_head_local_t = class("ui_head_local_t", NodeBase)

function ui_head_local_t:ctor(pathHead, sizeHead, pathMask, rect9Mask, sizeMask)
	ui_head_local_t.super.ctor(self)

	local headSprite = cc.Sprite:create(pathHead)
    local size = headSprite:getContentSize()
    local scale = sizeHead.width / size.width
    headSprite:setScale(scale)
    self:addChild(headSprite)

    local maskSprite = ccui.Scale9Sprite:create(rect9Mask, pathMask)
    maskSprite:setContentSize(sizeMask)

    local clipingNode = cc.ClippingNode:create(maskSprite)
	clipingNode:setInverted(false)
	clipingNode:setAlphaThreshold(0.5)
	self:addChild(clipingNode)
end