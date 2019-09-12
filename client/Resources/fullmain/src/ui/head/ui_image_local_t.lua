ui_image_local_t = class("ui_image_local_t", NodeBase)

function ui_image_local_t:ctor(pathImage, sizeImage, pathMask, rect9Mask, sizeMask)
    ui_image_local_t.super.ctor(self)

    local imageSprite = cc.Sprite:create(pathImage)

    if sizeImage then
        local size = imageSprite:getContentSize()
        local scale = sizeImage.width / size.width
        imageSprite:setScale(scale)
    end

    if pathMask then
        local maskSprite = ccui.Scale9Sprite:create(rect9Mask, pathMask)
        maskSprite:setContentSize(sizeMask)

        local clipingNode = cc.ClippingNode:create(maskSprite)
        clipingNode:setInverted(false)
        clipingNode:setAlphaThreshold(0.5)
        self:addChild(clipingNode)
    else
        self:addChild(imageSprite)
    end
end