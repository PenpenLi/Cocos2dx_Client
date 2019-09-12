PlanetItem = class("PlanetItem", function()
    return cc.Sprite:create()
end)

function PlanetItem:ctor(x, y, planetIndex, randomNum)
    self:setSpriteFrame("icon_"  .. planetIndex .. ".png")

    self.x = x 
    self.y = y
    self.planetType = nil -- ����  
    self.planetIndex = nil
    self.isActive = false -- �Ƿ񼤻�
    self.isIgnoreCheck = false -- �Ƿ���Լ��
    self.isMarkRemove = false -- �Ƿ���ɾ�� -- ����������ʱ���õ�  ���������ʱ���ֹ�ظ����� 
    self.isIntersection = false -- �Ƿ��ǽ���
    self.isForthwithRemove = true -- �Ƿ���������  �ºϳɵı�ʯ ����ǻ��汦ʯ��� ��ô���β����� ��������籦ʯ���  ��ô��������
    self.HP = nil -- ����ֵ

    self:setIndex(planetIndex, randomNum)
    self:setType(PLANET_TYPE.NORMAL)
    self:initHP(randomNum) -- ��ʼ������ֵ
    self:setEyeAnimation(randomNum) -- ����գ�۾�����
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
        -- �������� 
        print("you ren zuo bi, type error...................")
        gamesvr.sendRemoveData(0, 1, 22) -- ������������  md5У�鲻��  ֱ���˳���Ϸ
        return 0
    end 
end

function PlanetItem:getIndex(randomNum)
    local index = (self.planetIndex - 2017 - self.x * self.y) / randomNum  -- ���ܷ�ʽ planetIndex * ����� + 2017 * x * y 
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
        -- �������� 
        print("you ren zuo bi, index error...................")
        gamesvr.sendRemoveData(0, 1, 22) -- ������������  md5У�鲻��  ֱ���˳���Ϸ
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

-- ��ʼ������ֵ
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

-- �����۾�����
function PlanetItem:setEyeAnimation(randomNum)
    local index = self:getIndex(randomNum) 
    if index > 6 then 
        return 
    end 
     -- ������Դ
    cc.SpriteFrameCache:getInstance():addSpriteFrames("wacaibao/res/common/plist/resources_2.plist")

    local sp = cc.Sprite:createWithSpriteFrameName("icon_" .. index .. "_1.png")
    local action = createWithSingleFrameName("icon_" .. index .. "_", 0.15, 1000000) 
    sp:runAction(action)
    sp:setPosition(cc.p(50,50))
    self:addChild(sp, 1)
end 

-- ���ó���������
function PlanetItem:setSupernovaType()  
    self:setType(PLANET_TYPE.SUPERNOVA)
    self:removeAllChildren()
    local lab = cc.LabelTTF:create("cxx", " ", 34) 
    lab:setPosition(cc.p(50,50))
    lab:setColor(cc.c3b(0, 0, 0))
    self:addChild(lab)
end

-- �����������
function PlanetItem:setMagicLampType(randomNum) 
    AudioEngine.playEffect("wacaibao/res/common/sound/compositeMaglcLamp.mp3")

     -- ������Դ
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

-- ���û�������
function PlanetItem:setFlameType(randomNum)  
    AudioEngine.playEffect("wacaibao/res/common/sound/compositeFlame.mp3")

     -- ������Դ
    cc.SpriteFrameCache:getInstance():addSpriteFrames("wacaibao/res/common/plist/resources_6.plist")

    self:setType(PLANET_TYPE.FLAME)

    self:removeAllChildren() 
    self:setEyeAnimation(randomNum)

    local sp = cc.Sprite:createWithSpriteFrameName("flame_1.png")
    sp:runAction(createWithSingleFrameName("flame_", 0.04, 1000000))
    sp:setPosition(cc.p(50,50))
    self:addChild(sp, -1)
end

-- ������������
function PlanetItem:setLightningType(randomNum)  
    AudioEngine.playEffect("wacaibao/res/common/sound/compositeLightning.mp3")

    self:setType(PLANET_TYPE.LIGHTNING)
    self:setLocalZOrder(14)

    self:removeAllChildren() 
    self:setEyeAnimation(randomNum)

     -- ������Դ
    cc.SpriteFrameCache:getInstance():addSpriteFrames("wacaibao/res/common/plist/resources_6.plist")

    local sp = cc.Sprite:createWithSpriteFrameName("star_1.png")
    sp:runAction(createWithSingleFrameName("star_", 0.04, 1000000))
    sp:setPosition(cc.p(50,50))
    self:addChild(sp, -1)
end

-- ���ñ�������
function PlanetItem:setFrozenType() 
    self:setType(PLANET_TYPE.FROZEN)
    self.HP = 2 

     -- ������Դ
    cc.SpriteFrameCache:getInstance():addSpriteFrames("wacaibao/res/common/plist/resources_6.plist")

    local sp = cc.Sprite:createWithSpriteFrameName("iceAnimation_1.png")
    --sp:setBlendFunc(gl.SRC_ALPHA,gl.ONE) -- gl.SRC_COLOR,gl.ONE
    sp:runAction(createWithSingleFrameName("iceAnimation_", 0.1, 1000000))
    sp:setPosition(cc.p(50,50))
    self:addChild(sp, 2)
end 








