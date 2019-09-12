require ("buyu2.src.app.node.Digital")
local Pao = class("Pao", function()
    return cc.Node:create()
end)
function Pao:ctor()
	self.sum = 1
	self.suofishid = 0
	self.suoFish = nil
	self.point = cc.p(0,0)

    self.pao = cc.Sprite:createWithSpriteFrameName("YQS_P101_00.png")
    self.pao:setAnchorPoint(cc.p(0.5,0.29))
    self.pao:setScale(1.0)
    self:addChild(self.pao)
    self.rotate = 0
    self:addRate()
    self.oldIndex = 1
    self.preIndex = 0
end
function Pao:addRate()
	self.RateScore = Digital:create("0","buyu2/res/fishui/NumPaoTai.png",16,23,string.byte("0"))
    self.RateScore:setNumber(0)
    self:addChild(self.RateScore)
    self.RateScore:setAnchorPoint(cc.p(0.5,0))
    self.RateScore:setScale(0.8)
    self.RateScore:setPosition(cc.p(self:getContentSize().width/2,self:getContentSize().height/2-20))
end

function Pao:ResetRateNumerPosition(chair_id)
    local yDist = 20
    if chair_id == 1 or chair_id == 2 or chair_id == 7 then
        yDist = -20
    end
    self.RateScore:setPosition(cc.p(self:getContentSize().width/2,self:getContentSize().height/2-yDist))
end

function Pao:setRateNumber(num)
    self.RateScore:setNumber(num)
end

function Pao:setRateNumRot(rot,x,y)
    self.RateScore:setRotation(rot)
    self.RateScore:setPosition(cc.p(self:getContentSize().width/2+x,(self:getContentSize().height/2-20)+y))
end

function Pao:setRsc()
	self.RateScore:setScale(-0.8)
    self.RateScore:setPosition(cc.p(self:getContentSize().width/2,self:getContentSize().height/2+30))
end
function Pao:setPoint(point)
	self.point = point
end

function Pao:SwitchFrame(idx)
    if self.oldIndex ==  idx then return end
   -- print("self.oldIndex = "..self.oldIndex.." newidx = "..idx)
    self.pao:stopAllActions()
    self.oldIndex = idx
    local function paocallfun()
        self.pao:setScale(1.0)
    end
    if idx == 1 then
        self.sum = 1
        self.pao:setSpriteFrame(frameCache:getSpriteFrame(CannonFrameSet[1]))
    elseif idx == 2 then
        self.sum = 2
        self.pao:setSpriteFrame(frameCache:getSpriteFrame(CannonFrameSet[2]))
    elseif idx == 3 then
        self.sum = 3
        self.pao:setSpriteFrame(frameCache:getSpriteFrame(CannonFrameSet[3]))
    elseif idx == 0 then
        self.sum = 4
        self.pao:setSpriteFrame(frameCache:getSpriteFrame(CannonFrameSet[3]))
    elseif idx == 5 then
        self.sum = 1
        self.pao:setSpriteFrame(frameCache:getSpriteFrame(CannonFrameSet[5]))
    elseif idx == 6 then
        self.sum = 2
        self.pao:setSpriteFrame(frameCache:getSpriteFrame(CannonFrameSet[6]))
    elseif idx == 7 then
        self.sum = 3
        self.pao:setSpriteFrame(frameCache:getSpriteFrame(CannonFrameSet[7]))
    elseif idx == 8 then
        self.sum = 3
        self.pao:setSpriteFrame(frameCache:getSpriteFrame(CannonFrameSet[8]))
    end

    self.pao:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1,1.5),cc.ScaleTo:create(0.1,1.0),cc.CallFunc:create(paocallfun)))


    local fw = cc.Sprite:createWithSpriteFrameName("YQS_AimFW00.png")
    fw:setScale(1.5)
    function fwCallback()
        fw:removeFromParent()
    end
    self:addChild(fw)
    fw:runAction(cc.Sequence:create(ActionEx:createGameObjectAnimation("Firework"),
                      cc.CallFunc:create(fwCallback)))

end


function Pao:OtherUserSwitchFrame(idx)
    if self.oldIndex ==  idx then return end
    self.pao:stopAllActions()
    self.oldIndex = idx
    if idx == 1 then
        self.sum = 1
        self.pao:setSpriteFrame(frameCache:getSpriteFrame(CannonFrameSet[1]))
    elseif idx == 2 then
        self.sum = 2
        self.pao:setSpriteFrame(frameCache:getSpriteFrame(CannonFrameSet[2]))
    elseif idx == 3 then
        self.sum = 3
        self.pao:setSpriteFrame(frameCache:getSpriteFrame(CannonFrameSet[3]))
    elseif idx == 0 then
        self.sum = 4
        self.pao:setSpriteFrame(frameCache:getSpriteFrame(CannonFrameSet[3]))
    elseif idx == 5 then
        self.sum = 1
        self.pao:setSpriteFrame(frameCache:getSpriteFrame(CannonFrameSet[5]))
    elseif idx == 6 then
        self.sum = 2
        self.pao:setSpriteFrame(frameCache:getSpriteFrame(CannonFrameSet[6]))
    elseif idx == 7 then
        self.sum = 3
        self.pao:setSpriteFrame(frameCache:getSpriteFrame(CannonFrameSet[7]))
    elseif idx == 8 then
        self.sum = 3
        self.pao:setSpriteFrame(frameCache:getSpriteFrame(CannonFrameSet[8]))
    end

end

function Pao:getBarrelLenth( )
    return self.pao:getContentSize().height
end

function Pao:SetToSuperBarrel()
    self.pao:stopAllActions()
    self.oldIndex = self.oldIndex + 4
    self.pao:setSpriteFrame(frameCache:getSpriteFrame(barrelFramseSet[self.oldIndex]))
    local function paocallfun()
        self.pao:setScale(1.0)
    end
    self.pao:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1,1.5),cc.ScaleTo:create(0.1,1.0),cc.CallFunc:create(paocallfun)))


    local fw = cc.Sprite:createWithSpriteFrameName("YQS_AimFW00.png")
    fw:setScale(1.5)
    function fwCallback()
        fw:removeFromParent()
    end
    self:addChild(fw)
    fw:runAction(cc.Sequence:create(ActionEx:createGameObjectAnimation("Firework"),
                      cc.CallFunc:create(fwCallback)))
end

function Pao:SetToNolmalBarrel()
    self.pao:stopAllActions()
    self.oldIndex = self.oldIndex - 4
    self.pao:setSpriteFrame(frameCache:getSpriteFrame(barrelFramseSet[self.oldIndex]))
    local function paocallfun()
        self.pao:setScale(1.0)
    end
    self.pao:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1,1.5),cc.ScaleTo:create(0.1,1.0),cc.CallFunc:create(paocallfun)))


    local fw = cc.Sprite:createWithSpriteFrameName("YQS_AimFW00.png")
    fw:setScale(1.5)
    function fwCallback()
        fw:removeFromParent()
    end
    self:addChild(fw)
    fw:runAction(cc.Sequence:create(ActionEx:createGameObjectAnimation("Firework"),
                      cc.CallFunc:create(fwCallback)))
end

function Pao:setTexture(a)
	local texture1 = "buyu2/res/fishui/1p.png"
	local texture2 = "buyu2/res/fishui/2p.png"
	local texture3 = "buyu2/res/fishui/3p.png"
	local texture4 = "buyu2/res/fishui/4p.png"
	if a == 1 then
		self.sum = 1
		self.pao:setTexture(texture1)
	elseif a == 2 then
		self.sum = 2
		self.pao:setTexture(texture2)
	elseif a == 3 then
		self.sum = 3
		self.pao:setTexture(texture3)
	elseif a == 0 then
		self.sum = 4
	    self.pao:setTexture(texture4)
	end
end
function Pao:getRect()
	return self.pao:getContentSize()
end
function Pao:Rotation(a)
	self.pao:setRotation(a)
	self.rotate = a
end

function Pao:getPaoRot()
    return self.rotate
end

function Pao:setSca(a)
	self.pao:setScaleY(a)
end

function Pao:addBlast()
	local blast = nil
    if self.sum <= 1    then
        blast = Blast.new(1)
    elseif self.sum == 2 then
        blast = Blast.new(2)
    elseif self.sum > 2 then
        blast = Blast.new(3)
    end
    self.pao:addChild(blast)
    blast:setPosition(self.pao:getContentSize().width / 2,self.pao:getContentSize().height+10)
end
function Pao:play()
	local action = cc.MoveBy:create(2/60,cc.p(-6*math.sin(math.rad(self.rotate)),-6*math.cos(math.rad(self.rotate))))
    local action1 = action:reverse()
    self.pao:runAction(cc.Sequence:create(action, action1))
end
function Pao:stop()
	self.pao:setScale(1.0)
    self.pao:setPosition(0,0)
    self.pao:stopAllActions()
end
return Pao