
require ("buyu2.src.app.node.Digital")

local winCoinItem = class("winCoinItem", function()
    return cc.Node:create()
end)

function winCoinItem:ctor(score,number,bgColor,index,id)
    self.id = id
    self.index = index
    self.num = number
    self.score = score
    self.bgColor = bgColor
    self.cnt = 0
    self.numTxt = nil
    self.numBg = nil
    self.timerdt = 0
    self.sp = cc.Sprite:createWithSpriteFrameName("YQS_itemCoin_f00.png")
    local anim = ActionEx:createGameObjectAnimationRep("ScroeItemCoin")
    self.sp:runAction(cc.RepeatForever:create(anim))
    self:addChild(self.sp)

    local move = cc.MoveBy:create(self.num * 0.05,cc.p(0,5*self.num))
    local function CoinMoveEnd()
        self.sp:removeFromParent()
        local len = getNumLen(self.score)
        if len <= 0 then len = 1
        elseif len > 10 then len = 10
        end
        if self.bgColor == 1 then
            self.numBg = cc.Sprite:createWithSpriteFrameName("YQS_G0"..len..".png")
        else
            self.numBg = cc.Sprite:createWithSpriteFrameName("YQS_R0"..len..".png")
        end
        self.numBg:setPosition(cc.p(0,5*self.num - 5))
        self.numBg:setAnchorPoint(cc.p(0.5,0))
        self:addChild(self.numBg)

        self.numTxt = Digital:create("0","buyu2/res/fishui/item_shuzi.png",9,18,string.byte("0"))
        self.numTxt:setNumber(self.score)
        self:addChild(self.numTxt,1)
        self.numTxt:setPosition(cc.p(-(len*9)/2,5*self.num - 5))
        --self.numTxt:setScale(-1)
    end
    local func = cc.CallFunc:create(CoinMoveEnd)
    self.sp:runAction(cc.Sequence:create(move,func))

    self:AddItem()
end

function winCoinItem:AddItem()
    if  self.cnt < self.num  then
        local item = cc.Sprite:createWithSpriteFrameName("YQS_itemCoin.png")
        item:setPosition(cc.p(0,self.cnt * 5))
        self:addChild(item)
        self.cnt = self.cnt + 1

        local dly = cc.DelayTime:create(0.05)
        local function callBack()
            self:AddItem()
        end
        local fun = cc.CallFunc:create(callBack)

        self:runAction(cc.Sequence:create(dly,fun))
    end
end



function winCoinItem:onExit()
  cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
  self.schedulerID = nil
end

return winCoinItem