--动画工具类
module("AnimationUtil", package.seeall)

function handCardsAnimation(rootLayer, cardFace, cardBack)
    local x, y = cardFace:getPosition();
    cardBack:setPosition(x, y);
    local aniTime = 0.05

    rootLayer:runAction(cc.Repeat:create(cc.Sequence:create(cc.CallFunc:create(function(sender)
        cardFace:setVisible(true)
        cardBack:setVisible(false)
        cardFace:runAction(cc.OrbitCamera:create(aniTime / 2, 1, 0, 0, 80, 0, 0))
        end),
        cc.DelayTime:create(aniTime / 2),
        cc.CallFunc:create(function(sender)
            cardFace:setVisible(false)
            cardBack:setVisible(true)
            cardBack:runAction(cc.OrbitCamera:create(aniTime, 1, 0, 80, 90, 0, 0))
        end),
        cc.DelayTime:create(aniTime),
        cc.CallFunc:create(function(sender)
            cardFace:runAction(cc.OrbitCamera:create(aniTime / 2, 1, 0, 0, 0, 0, 0))
        end),
        cc.DelayTime:create(aniTime / 2)), 1))
end