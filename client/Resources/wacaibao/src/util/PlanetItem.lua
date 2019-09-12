PlanetItem = class("PlanetItem", function()
    return cc.Sprite:create()
end)

function PlanetItem:ctor(x, y, planetIndex, randomNum)
    self:setSpriteFrame("icon_"  .. planetIndex .. ".png")

    self.x = x 
    self.y = y
    self.planetType = nil -- 类型  
    self.planetIndex = nil
    self.isActive = false -- 是否激活
    self.isIgnoreCheck = false -- 是否忽略检查
    self.isMarkRemove = false -- 是否标记删除 -- 消除泥土的时候用到  消除星球的时候防止重复消除 
    self.isIntersection = false -- 是否是交点
    self.isForthwithRemove = true -- 是否立即消除  新合成的宝石 如果是火焰宝石检测 那么本次不消除 如果是闪电宝石检测  那么本次消除
    self.HP = nil -- 生命值

    self:setIndex(planetIndex, randomNum)
    self:setType(PLANET_TYPE.NORMAL)
    self:initHP(randomNum) -- 初始化生命值
    self:setEyeAnimation(randomNum) -- 设置眨眼睛动画
end 

function PlanetItem:setActive(bActive)
    self.isActive = bActive
end

function PlanetItem:setType(pType)
    self.planetType = pType + self.planetIndex * 8 
end

function PlanetItem:getType()
    local pType = self.planetType - self.planetIndex * 8 
    local findFlag = false 
    for k, v in pairs(PLANET_TYPE) do 
        if pType == v then
            findFlag = true 
            break 
        end 
    end 
    if findFlag then 
        return pType
    else 
        -- 有人作弊 
        print("you ren zuo bi, type error...................")
        gamesvr.sendRemoveData(0, 1, 22) -- 发送消除数据  md5校验不过  直接退出游戏
        return 0
    end 
end

function PlanetItem:getIndex(randomNum)
    local index = (self.planetIndex - 2017 - self.x * self.y) / randomNum  -- 加密方式 planetIndex * 随机数 + 2017 * x * y 
    local len = #E_PLANET_INDEX
    local findFlag = false 
    for i = 1, len do 
        if index == E_PLANET_INDEX[i] then
            findFlag = true 
            break 
        end 
    end 

    if findFlag then 
        return index
    else 
        -- 有人作弊 
        print("you ren zuo bi, index error...................")
        gamesvr.sendRemoveData(0, 1, 22) -- 发送消除数据  md5校验不过  直接退出游戏
        return 0 
    end 
end 

function PlanetItem:setIndex(index, randomNum)
    self.planetIndex = index * randomNum + 2017 + self.x * self.y 
end 

function PlanetItem:setIndexAndType(index, randomNum)
    local pType = self:getType()
    self:setIndex(index, randomNum)
    self:setType(pType)
end 

function PlanetItem.getWidth()
    return 100
end

-- 初始化生命值
function PlanetItem:initHP(randomNum)
    local index = self:getIndex(randomNum)
    if  index == 10 then 
        self.HP = 2
    elseif index == 14 then 
        self.HP = 3
    else 
        self.HP = 1
    end 
end 

-- 设置眼睛动画
function PlanetItem:setEyeAnimation(randomNum)
    local index = self:getIndex(randomNum) 
    if index > 6 then 
        return 
    end 
     -- 加载资源
    cc.SpriteFrameCache:getInstance():addSpriteFrames("wacaibao/res/common/plist/resources_2.plist")

    local sp = cc.Sprite:createWithSpriteFrameName("icon_" .. index .. "_1.png")
    local action = createWithSingleFrameName("icon_" .. index .. "_", 0.15, 1000000) 
    sp:runAction(action)
    sp:setPosition(cc.p(50,50))
    self:addChild(sp, 1)
end 

-- 设置超新星类型
function PlanetItem:setSupernovaType()  
    self:setType(PLANET_TYPE.SUPERNOVA)
    self:removeAllChildren()
    local lab = cc.LabelTTF:create("cxx", " ", 34) 
    lab:setPosition(cc.p(50,50))
    lab:setColor(cc.c3b(0, 0, 0))
    self:addChild(lab)
end

-- 设置神灯类型
function PlanetItem:setMagicLampType(randomNum) 
    AudioEngine.playEffect("wacaibao/res/common/sound/compositeMaglcLamp.mp3")

     -- 加载资源
    cc.SpriteFrameCache:getInstance():addSpriteFrames("wacaibao/res/common/plist/resources_2.plist")

    self:setSpriteFrame("icon_7.png") 
    self:setIndex(7, randomNum)
    self:setType(PLANET_TYPE.MAGIC_LAMP)
    self:removeAllChildren()
    self:setLocalZOrder(14)

    local sp = cc.Sprite:createWithSpriteFrameName("icon_7.png")
    local action_1 = createWithSingleFrameName("icon_7_", 0.1, 1000000) 
    sp:runAction(action_1)
    sp:setPosition(cc.p(50,50))
    self:addChild(sp)
end

-- 设置火焰类型
function PlanetItem:setFlameType(randomNum)  
    AudioEngine.playEffect("wacaibao/res/common/sound/compositeFlame.mp3")

     -- 加载资源
    cc.SpriteFrameCache:getInstance():addSpriteFrames("wacaibao/res/common/plist/resources_6.plist")

    self:setType(PLANET_TYPE.FLAME)

    self:removeAllChildren() 
    self:setEyeAnimation(randomNum)

    local sp = cc.Sprite:createWithSpriteFrameName("flame_1.png")
    sp:runAction(createWithSingleFrameName("flame_", 0.04, 1000000))
    sp:setPosition(cc.p(50,50))
    self:addChild(sp, -1)
end

-- 设置闪电类型
function PlanetItem:setLightningType(randomNum)  
    AudioEngine.playEffect("wacaibao/res/common/sound/compositeLightning.mp3")

    self:setType(PLANET_TYPE.LIGHTNING)
    self:setLocalZOrder(14)

    self:removeAllChildren() 
    self:setEyeAnimation(randomNum)

     -- 加载资源
    cc.SpriteFrameCache:getInstance():addSpriteFrames("wacaibao/res/common/plist/resources_6.plist")

    local sp = cc.Sprite:createWithSpriteFrameName("star_1.png")
    sp:runAction(createWithSingleFrameName("star_", 0.04, 1000000))
    sp:setPosition(cc.p(50,50))
    self:addChild(sp, -1)
end

-- 设置冰冻类型
function PlanetItem:setFrozenType() 
    self:setType(PLANET_TYPE.FROZEN)
    self.HP = 2 

     -- 加载资源
    cc.SpriteFrameCache:getInstance():addSpriteFrames("wacaibao/res/common/plist/resources_6.plist")

    local sp = cc.Sprite:createWithSpriteFrameName("iceAnimation_1.png")
    --sp:setBlendFunc(gl.SRC_ALPHA,gl.ONE) -- gl.SRC_COLOR,gl.ONE
    sp:runAction(createWithSingleFrameName("iceAnimation_", 0.1, 1000000))
    sp:setPosition(cc.p(50,50))
    self:addChild(sp, 2)
end 








