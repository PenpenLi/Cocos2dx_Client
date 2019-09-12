director = cc.Director:getInstance()
frameCache = cc.SpriteFrameCache:getInstance()
textureCache = director:getTextureCache()
animateCache = cc.AnimationCache:getInstance()

ResourceFormat = {
    cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888,
    cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888,
    cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444,
    cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444,
    cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444,
    cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444,
}

UiJsonTable = {
  [4] = "buyu1/res/Json/FishUI_1_4.json",
  [6] = "buyu1/res/Json/FishUI_1_6.json",
  [8] = "buyu1/res/Json/FishUI_1_8.json",
}


GameObjAnimSet = {
  {name = "ShuiWen",    form = "XY_shui_%02d.png",       sleepTime = 0.1 },
  {name = "Pao1",       form = "XY_P101_%02d.png",         sleepTime = 0.05 },
  {name = "Pao2",       form = "XY_P102_%02d.png",         sleepTime = 0.05 },
  {name = "Pao3",       form = "XY_P103_%02d.png",         sleepTime = 0.05 },
  {name = "SPao1",      form = "XY_S101_%02d.png",         sleepTime = 0.05 },
  {name = "SPao2",      form = "XY_S102_%02d.png",         sleepTime = 0.05 },
  {name = "SPao3",      form = "XY_S103_%02d.png",         sleepTime = 0.05 },

  {name = "FireSpr_1",  form = "XY_fire1_%02d.png",      sleepTime = 0.05 },
  {name = "FireSpr_2",  form = "XY_fire2_%02d.png",      sleepTime = 0.05 },
  {name = "FireSpr_3",  form = "XY_fire3_%02d.png",      sleepTime = 0.05 },

  {name = "CJP",        form = "XY_caijinpan_%02d.png",  sleepTime = 0.1 },

  {name = "Bullet_1_1",  form = "XY_b101_%02d.png",      sleepTime = 0.1 },
  {name = "Bullet_1_2",  form = "XY_b102_%02d.png",      sleepTime = 0.1 },
  {name = "Bullet_1_3",  form = "XY_b103_%02d.png",      sleepTime = 0.1 },
  {name = "Bullet_1_4",  form = "XY_b104_%02d.png",      sleepTime = 0.1 },

  {name = "Bullet_2_1",  form = "XY_b201_%02d.png",      sleepTime = 0.1 },
  {name = "Bullet_2_2",  form = "XY_b202_%02d.png",      sleepTime = 0.1 },
  {name = "Bullet_2_3",  form = "XY_b203_%02d.png",      sleepTime = 0.1 },
  {name = "Bullet_2_4",  form = "XY_b204_%02d.png",      sleepTime = 0.1 },

  {name = "Bullet_3_1",  form = "XY_b301_%02d.png",      sleepTime = 0.1 },
  {name = "Bullet_3_2",  form = "XY_b302_%02d.png",      sleepTime = 0.1 },
  {name = "Bullet_3_3",  form = "XY_b303_%02d.png",      sleepTime = 0.1 },
  {name = "Bullet_3_4",  form = "XY_b304_%02d.png",      sleepTime = 0.1 },

  {name = "SBullet_1",  form = "XY_sb01_%02d.png",      sleepTime = 0.1 },
  {name = "SBullet_2",  form = "XY_sb02_%02d.png",      sleepTime = 0.1 },
  {name = "SBullet_3",  form = "XY_sb03_%02d.png",      sleepTime = 0.1 },

  {name = "Net2",       form = "XY_net2_%02d.png",      sleepTime = 0.05 },
  {name = "Net3",       form = "XY_net3_%02d.png",      sleepTime = 0.05 },
  {name = "Net4",       form = "XY_net4_%02d.png",      sleepTime = 0.05 },

  {name = "Firework",   form = "XY_AimFW%02d.png",       sleepTime = 0.03 },
  {name = "ScroeItemCoin", form = "XY_itemCoin_f%02d.png",    sleepTime = 0.1 },

  {name = "CoinSilver", form = "XY_jinbi_y%02d.png",     sleepTime = 0.05 },
  {name = "CoinGold",   form = "XY_jinbi_j%02d.png",     sleepTime = 0.05 },

  {name = "Thunder",    form = "XY_s_%02d.png",          sleepTime = 0.1 },

  {name = "Bomb1",      form = "XY_TX_%02d.png",         sleepTime = 0.12 },
  {name = "CoinLight",  form = "XY_Coin_Light_%02d.png", sleepTime = 0.12 },
  {name = "DPBomb",     form = "XY_Bing_%02d.png",         sleepTime = 0.1 },
}

FishNetFrame = {[2] = "XY_net2_00.png",[3] = "XY_net3_00.png",[4] = "XY_net4_00.png"}
FishNetAnim = {[2] = "Net2",[3] = "Net3",[4] = "Net4"}

bombFrameSet = {[0] = "XY_TX_00.png",[1] = "XY_Coin_Light_00.png",[2] = "XY_Bing_00.png"}
bombAnimSet = {[0] = "Bomb1",[1] = "CoinLight",[2] = "DPBomb"}

dsyPos = {cc.p(0,0),cc.p(-120,0),cc.p(120,0)}
dsxPos = {cc.p(60,0),cc.p(-60,0),cc.p(180,0),cc.p(-180,0)}
bulletSpeed = {
  [0] = 700,
  [1] = 700,
  [2] = 700,
  [3] = 700,
  [4] = 900,
  [5] = 900,
  [6] = 900,
  [7] = 900,
}

BulletSet = {
    [0] = {[0] = "XY_b101_00.png",[1] = "XY_b201_00.png",[2] = "XY_b301_00.png",[3] = "XY_b301_00.png",
           [4] = "XY_sb01_00.png",[5] = "XY_sb02_00.png",[6] = "XY_sb03_00.png",[7] = "XY_sb04_00.png"},

    [1] = {[0] = "XY_b102_00.png",[1] = "XY_b202_00.png",[2] = "XY_b302_00.png",[3] = "XY_b302_00.png",
           [4] = "XY_sb01_00.png",[5] = "XY_sb02_00.png",[6] = "XY_sb03_00.png",[7] = "XY_sb04_00.png"},

    [2] = {[0] = "XY_b103_00.png",[1] = "XY_b203_00.png",[2] = "XY_b303_00.png",[3] = "XY_b303_00.png",
           [4] = "XY_sb01_00.png",[5] = "XY_sb02_00.png",[6] = "XY_sb03_00.png",[7] = "XY_sb04_00.png"},

    [3] = {[0] = "XY_b104_00.png",[1] = "XY_b204_00.png",[2] = "XY_b304_00.png",[3] = "XY_b304_00.png",
           [4] = "XY_sb01_00.png",[5] = "XY_sb02_00.png",[6] = "XY_sb03_00.png",[7] = "XY_sb04_00.png"},

    [4] = {[0] = "XY_b101_00.png",[1] = "XY_b201_00.png",[2] = "XY_b301_00.png",[3] = "XY_b301_00.png",
           [4] = "XY_sb01_00.png",[5] = "XY_sb02_00.png",[6] = "XY_sb03_00.png",[7] = "XY_sb04_00.png"},

    [5] = {[0] = "XY_b102_00.png",[1] = "XY_b202_00.png",[2] = "XY_b302_00.png",[3] = "XY_b302_00.png",
           [4] = "XY_sb01_00.png",[5] = "XY_sb02_00.png",[6] = "XY_sb03_00.png",[7] = "XY_sb04_00.png"},

    [6] = {[0] = "XY_b103_00.png",[1] = "XY_b203_00.png",[2] = "XY_b303_00.png",[3] = "XY_b303_00.png",
           [4] = "XY_sb01_00.png",[5] = "XY_sb02_00.png",[6] = "XY_sb03_00.png",[7] = "XY_sb04_00.png"},

    [7] = {[0] = "XY_b104_00.png",[1] = "XY_b204_00.png",[2] = "XY_b304_00.png",[3] = "XY_b304_00.png",
           [4] = "XY_sb01_00.png",[5] = "XY_sb02_00.png",[6] = "XY_sb03_00.png",[7] = "XY_sb04_00.png"},
}

BulletAnimSet = {
    [0] = {[0] = "Bullet_1_1",[1] = "Bullet_2_1",[2] = "Bullet_3_1",[3] = "Bullet_3_1",
           [4] = "SBullet_1", [5] = "SBullet_2", [6] = "SBullet_3", [7] = "SBullet_3"},

    [1] = {[0] = "Bullet_1_2",[1] = "Bullet_2_2",[2] = "Bullet_3_2",[3] = "Bullet_3_2",
           [4] = "SBullet_1", [5] = "SBullet_2", [6] = "SBullet_3", [7] = "SBullet_3"},

    [2] = {[0] = "Bullet_1_3",[1] = "Bullet_2_3",[2] = "Bullet_3_3",[3] = "Bullet_3_3",
           [4] = "SBullet_1", [5] = "SBullet_2", [6] = "SBullet_3", [7] = "SBullet_3"},

    [3] = {[0] = "Bullet_1_4",[1] = "Bullet_2_4",[2] = "Bullet_3_4",[3] = "Bullet_3_4",
           [4] = "SBullet_1", [5] = "SBullet_2", [6] = "SBullet_3", [7] = "SBullet_3"},

    [4] = {[0] = "Bullet_1_1",[1] = "Bullet_2_1",[2] = "Bullet_3_1",[3] = "Bullet_3_1",
           [4] = "SBullet_1", [5] = "SBullet_2", [6] = "SBullet_3", [7] = "SBullet_3"},

    [5] = {[0] = "Bullet_1_2",[1] = "Bullet_2_2",[2] = "Bullet_3_2",[3] = "Bullet_3_2",
           [4] = "SBullet_1", [5] = "SBullet_2", [6] = "SBullet_3", [7] = "SBullet_3"},

    [6] = {[0] = "Bullet_1_3",[1] = "Bullet_2_3",[2] = "Bullet_3_3",[3] = "Bullet_3_3",
           [4] = "SBullet_1", [5] = "SBullet_2", [6] = "SBullet_3", [7] = "SBullet_3"},

    [7] = {[0] = "Bullet_1_4",[1] = "Bullet_2_4",[2] = "Bullet_3_4",[3] = "Bullet_3_4",
           [4] = "SBullet_1", [5] = "SBullet_2", [6] = "SBullet_3", [7] = "SBullet_3"},
}

CannonFrameSet = {
    "XY_P101_00.png","XY_P102_00.png","XY_P103_00.png","XY_P103_00.png",
    "XY_S101_00.png","XY_S102_00.png","XY_S103_00.png","XY_S103_00.png",
}

barrelFramseSet = {
    "XY_P101_00.png","XY_P102_00.png","XY_P103_00.png","XY_P103_00.png",
    "XY_S101_00.png","XY_S102_00.png","XY_S103_00.png","XY_S103_00.png",
}

fireFrameSet = {[1]="XY_fire1_00.png",[2]="XY_fire2_00.png",[3]="XY_fire3_00.png"}
fireAnimSet = {[1]="FireSpr_1",[2]="FireSpr_2",[3]="FireSpr_3"}

fishAnimSet = {
    {name = "fish01", form = "XY_fish01_%02d.png",      sleepTime = 0.05 },
    {name = "fish02", form = "XY_fish02_%02d.png",      sleepTime = 0.05 },
    {name = "fish03", form = "XY_fish03_%02d.png",      sleepTime = 0.05 },
    {name = "fish04", form = "XY_fish04_%02d.png",      sleepTime = 0.05 },
    {name = "fish05", form = "XY_fish05_%02d.png",      sleepTime = 0.05 },
    {name = "fish06", form = "XY_fish06_%02d.png",      sleepTime = 0.05 },
    {name = "fish07", form = "XY_fish07_%02d.png",      sleepTime = 0.05 },
    {name = "fish08", form = "XY_fish08_%02d.png",      sleepTime = 0.05 },
    {name = "fish09", form = "XY_fish09_%02d.png",      sleepTime = 0.05 },
    {name = "fish10", form = "XY_fish10_%02d.png",      sleepTime = 0.05 },
    {name = "fish11", form = "XY_fish11_%02d.png",      sleepTime = 0.05 },
    {name = "fish12", form = "XY_fish12_%02d.png",      sleepTime = 0.05 },
    {name = "fish13", form = "XY_fish13_%02d.png",      sleepTime = 0.05 },
    {name = "fish14", form = "XY_fish14_%02d.png",      sleepTime = 0.05 },
    {name = "fish15", form = "XY_fish15_%02d.png",      sleepTime = 0.05 },
    {name = "fish16", form = "XY_fish16_%02d.png",      sleepTime = 0.05 },
    {name = "fish17", form = "XY_fish17_%02d.png",      sleepTime = 0.05 },
    {name = "fish18", form = "XY_fish18_%02d.png",      sleepTime = 0.05 },
    {name = "fish19", form = "XY_fish19_%02d.png",      sleepTime = 0.05 },
    {name = "fish20", form = "XY_fish20_%02d.png",      sleepTime = 0.05 },
    {name = "fish21", form = "XY_fish21_%02d.png",      sleepTime = 0.05 },
    {name = "fish22", form = "XY_fish22_%02d.png",      sleepTime = 0.05 },
    {name = "fish23", form = "XY_fish23_%02d.png",      sleepTime = 0.05 },
    {name = "fish24", form = "XY_fish24_%02d.png",      sleepTime = 0.05 },
    {name = "simRound", form = "XY_simRound_%02d.png",  sleepTime = 0.05 },
    {name = "groupRound", form = "XY_groupRound_%02d.png",sleepTime = 0.05 },
  }

  d_fishAnimSet = {
    {name = "dfish01", form = "XY_d_fish01_%02d.png",      sleepTime = 0.05 },
    {name = "dfish02", form = "XY_d_fish02_%02d.png",      sleepTime = 0.05 },
    {name = "dfish03", form = "XY_d_fish03_%02d.png",      sleepTime = 0.05 },
    {name = "dfish04", form = "XY_d_fish04_%02d.png",      sleepTime = 0.05 },
    {name = "dfish05", form = "XY_d_fish05_%02d.png",      sleepTime = 0.05 },
    {name = "dfish06", form = "XY_d_fish06_%02d.png",      sleepTime = 0.05 },
    {name = "dfish07", form = "XY_d_fish07_%02d.png",      sleepTime = 0.05 },
    {name = "dfish08", form = "XY_d_fish08_%02d.png",      sleepTime = 0.05 },
    {name = "dfish09", form = "XY_d_fish09_%02d.png",      sleepTime = 0.05 },
    {name = "dfish10", form = "XY_d_fish10_%02d.png",      sleepTime = 0.05 },
    {name = "dfish11", form = "XY_d_fish11_%02d.png",      sleepTime = 0.05 },
    {name = "dfish12", form = "XY_d_fish12_%02d.png",      sleepTime = 0.05 },
    {name = "dfish13", form = "XY_d_fish13_%02d.png",      sleepTime = 0.05 },
    {name = "dfish14", form = "XY_d_fish14_%02d.png",      sleepTime = 0.05 },
    {name = "dfish15", form = "XY_d_fish15_%02d.png",      sleepTime = 0.05 },
    {name = "dfish16", form = "XY_d_fish16_%02d.png",      sleepTime = 0.05 },
    {name = "dfish17", form = "XY_d_fish17_%02d.png",      sleepTime = 0.05 },
    {name = "dfish18", form = "XY_d_fish18_%02d.png",      sleepTime = 0.05 },
    {name = "dfish19", form = "XY_d_fish19_%02d.png",      sleepTime = 0.05 },
    {name = "dfish20", form = "XY_d_fish20_%02d.png",      sleepTime = 0.05 },
    {name = "dfish21", form = "XY_d_fish21_%02d.png",      sleepTime = 0.05 },
    {name = "dfish22", form = "XY_d_fish22_%02d.png",      sleepTime = 0.05 },
    {name = "dfish23", form = "XY_d_fish23_%02d.png",      sleepTime = 0.05 },
    {name = "dfish24", form = "XY_d_fish24_%02d.png",      sleepTime = 0.05 },
    {name = "dsimRound", form = "XY_d_simRound_%02d.png",      sleepTime = 0.05 },
    {name = "dgroupRound", form = "XY_d_groupRound_%02d.png",      sleepTime = 0.05 },
  }

fishFrameSet = {}
dfishFrameSet = {}
function CreateFishAnimate(name,form,num,sleepTime,loops)
    local animation = cc.Animation:create()
    local number = num;
    if number == 0 then
        number = 100
    end
    for i=0,number do
        local frameName = string.format(form,i)
        if i == 0 then
            table.insert(fishFrameSet,frameName)
            print(fishFrameSet[#fishFrameSet])
        end
        --cclog("frameName = %s", frameName)
        local spriteFrame = frameCache:getSpriteFrame(frameName)
        if spriteFrame == nil then
            cclog("frameName = %s not found", frameName)
            break
        end
        animation:addSpriteFrame(spriteFrame)
    end

    animation:setDelayPerUnit(sleepTime*2)              --设置两个帧播放时间
    animation:setRestoreOriginalFrame(true)     --动画执行后还原初始状态
    --animation:setLoops(isLoop)
    animateCache:addAnimation(animation, name)
    --return animation
end

function CreateDFishAnimate(name,form,num,sleepTime,loops)
    local animation = cc.Animation:create()
    local number = num;
    if number == 0 then
        number = 100
    end
    for i=0,number do
        local frameName = string.format(form,i)
        if i == 0 then
            table.insert(dfishFrameSet,frameName)
            print(dfishFrameSet[#dfishFrameSet])
        end
        --cclog("frameName = %s", frameName)
        local spriteFrame = frameCache:getSpriteFrame(frameName)
        if spriteFrame == nil then
            cclog("frameName = %s not found", frameName)
            break
        end
        animation:addSpriteFrame(spriteFrame)
    end

    animation:setDelayPerUnit(sleepTime*2)              --设置两个帧播放时间
    animation:setRestoreOriginalFrame(true)     --动画执行后还原初始状态
    --animation:setLoops(isLoop)
    animateCache:addAnimation(animation, name)
    --return animation
end

function CreateAnimate(name,form,num,sleepTime,loops)
    local animation = cc.Animation:create()
    local number = num;
    if number == 0 then
        number = 100
    end
    for i=0,number do
        local frameName = string.format(form,i)
        --cclog("frameName = %s", frameName)
        local spriteFrame = frameCache:getSpriteFrame(frameName)
        if spriteFrame == nil then
            cclog("frameName = %s not found", frameName)
            break
        end
        animation:addSpriteFrame(spriteFrame)
    end

    animation:setDelayPerUnit(sleepTime)              --设置两个帧播放时间
    animation:setRestoreOriginalFrame(false)     --动画执行后还原初始状态
    --animation:setLoops(isLoop)
    animateCache:addAnimation(animation, name)
    --return animation
end


function  addTwoPoints( p1,p2 )
  -- body
  return cc.p(p1.x+p2.x,p1.y+p2.y)
end

function subTwoPoints(p1,p2)
  return cc.p(p1.x-p2.x,p1.y-p2.y)
end

function RADIANS_TO_DEGREES(_angle)
  return _angle * 57.29577951
end

function DEGREES_TO_RADIANS(_angle)
  return _angle * 0.01745329252
end

function GetPointAngle(x,y)
  return math.atan2(y,x)
end
--function PointToAngle()

--shanDian->setRotation(-CC_RADIANS_TO_DEGREES((pos2 - pos1).getAngle()));

function getTwoPointsRotation(p1,p2)
  local newP = subTwoPoints(p2,p1)
  local pAngle = GetPointAngle(newP.x,newP.y)
  local rot = -RADIANS_TO_DEGREES(pAngle)
  return rot
end

function getNumLen(num)
  local i = 1
  while (num >= 10) do
    i = i+1
    num = num / 10
  end
  return i
end