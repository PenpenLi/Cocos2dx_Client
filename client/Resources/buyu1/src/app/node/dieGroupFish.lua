local dieGroupFish = class("dieGroupFish", function()
    return cc.Node:create()
end)

function dieGroupFish:ctor(num,gft,fish)
    --local rot = fish:getRotation()
    --local x,y = fish:getPosition()
    if num == 3 then
        for i = 1,3 do
            local nx = dsyPos[i].x
            local ny = dsyPos[i].y
            local round = cc.Sprite:createWithSpriteFrameName("XY_dish.png")
            round:setPosition(cc.p(nx,ny))
            --round:setRotation(rot)
            self:addChild(round)
            round:runAction(cc.RepeatForever:create(cc.RotateBy:create(1,360)))

            local dFish = cc.Sprite:createWithSpriteFrameName(dfishFrameSet[gft])
            --dFish:setRotation(rot)
            dFish:setPosition(cc.p(nx,ny))
            self:addChild(dFish)
            local anim = animateCache:getAnimation(d_fishAnimSet[gft].name)
            local animation = cc.Animate:create(anim)
            dFish:runAction(cc.RepeatForever:create(animation))
            --dFish:setScale(round:getContentSize().width / dFish:getContentSize().width + 0.2)
        end
    else if num == 4 then
        for i = 1,4 do
            local nx = dsxPos[i].x
            local ny = dsxPos[i].y
            local round = cc.Sprite:createWithSpriteFrameName("XY_dish.png")
            round:setPosition(cc.p(nx,ny))
            --round:setRotation(rot)
            self:addChild(round)
            round:runAction(cc.RepeatForever:create(cc.RotateBy:create(1,360)))

            local dFish = cc.Sprite:createWithSpriteFrameName(dfishFrameSet[gft])
            --dFish:setRotation(rot)
            dFish:setPosition(cc.p(nx,ny))
            self:addChild(dFish)
            local anim = animateCache:getAnimation(d_fishAnimSet[gft].name)
            local animation = cc.Animate:create(anim)
            dFish:runAction(cc.RepeatForever:create(animation))
            --dFish:setScale(round:getContentSize().width / dFish:getContentSize().width + 0.2)
        end
    end
    end
end

return dieGroupFish