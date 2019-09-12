-- @Author: Marte
-- @Date:   2017-10-17 11:16:57
-- @Last Modified by:   Marte
-- @Last Modified time: 2017-11-27 11:20:13
local ActionEx = class("ActionEx")
function ActionEx:ctor()
end

function ActionEx:createGameObjectAnimation(name)
  local goNum = table.getn(GameObjAnimSet)
  local idx = -1
    for i=1,goNum do
      if GameObjAnimSet[i].name == name then
          idx = i
      end
    end

    if idx == -1 then return end

  local anim = animateCache:getAnimation(GameObjAnimSet[idx].name)
  local action = cc.Animate:create(anim)
  return action

end

function ActionEx:createGameObjectAnimationRep(name)
  local goNum = table.getn(GameObjAnimSet)
  local idx = -1
    for i=1,goNum do
      if GameObjAnimSet[i].name == name then
          idx = i
      end
  end

    if idx == -1 then return end

  local anim = animateCache:getAnimation(GameObjAnimSet[idx].name)
  local action = cc.Animate:create(anim)
  local rep = cc.RepeatForever:create(action)
  return rep

end

function ActionEx:createDieFishScore(pos,score)
  if score <= 0 then return end
  local num = nil
  local function endCall()
    num:removeFromParent()
  end

  num = Digital:create("0","buyu1/res/fishui/num_defen.png",40,50,string.byte("0"))
  num:setNumber(score)
  lablayer:addChild(num,5)
  num:setAnchorPoint(cc.p(0.5,0.0))
  num:setPosition(pos)
  num:setOpacity(0)


  num:runAction(cc.Sequence:create(cc.DelayTime:create(0.05),cc.FadeIn:create(0.05),cc.DelayTime:create(1),
          cc.FadeOut:create(0.2),cc.CallFunc:create(endCall)))


  local sr = 0.4 + (score / 30.0) * 0.6
  if sr > 1.0  then sr = 1.0 end

  num:setScale(sr)
  num:runAction(cc.Sequence:create(cc.MoveBy:create(0.2,cc.p(0,30)),cc.MoveBy:create(0.2,cc.p(0,-30))))
end

function ActionEx:createFlyCoins(num,pos1,pos2,rot)
  local goldCoinNumber = 0
  local silverCoinNumber = 0
  if num < 10 then
    silverCoinNumber = num
  else
    goldCoinNumber = num / 5
    silverCoinNumber = num % 5
    if (num % 5) >= 1 then goldCoinNumber = goldCoinNumber +1 end
    if goldCoinNumber > 8 then goldCoinNumber = 8 end

  end

  local dOwnerAngle = rot
  local ownerAngle = DEGREES_TO_RADIANS(dOwnerAngle)
  local goalPosition = pos2
  local bcos = math.cos(ownerAngle + 0.2)
  local bsin = math.sin(ownerAngle + 0.2)
  local pdist = (silverCoinNumber*45.0 + goldCoinNumber * 68.0) / -2.0
  local startPos = cc.p(pos1.x+(pdist*bcos),pos1.y+(pdist*bsin))

  if silverCoinNumber > 0 then
    local  moveSU = cc.p(45.0 * bcos, 45.0 * bsin)
    for i=0,silverCoinNumber do
      startPos.x = startPos.x + moveSU.x
      local coin = cc.Sprite:createWithSpriteFrameName("XY_jinbi_y00.png")
      coin:setPosition(startPos)
      coin:setRotation(dOwnerAngle)
      lablayer:addChild(coin,5)

      local anim = animateCache:getAnimation("CoinSilver")
      local action = cc.Animate:create(anim)
      coin:runAction(cc.RepeatForever:create(action))
      coin:setScale(0)
      coin:runAction(cc.ScaleTo:create(0.15,1.2,1.2))

      local function Endcallback()
        coin:removeFromParent()
      end
      coin:runAction(cc.Sequence:create(cc.MoveTo:create(cc.pGetDistance(pos2,startPos)/400.0,pos2),cc.CallFunc:create(Endcallback)))
    end
  end

  if goldCoinNumber > 0 then
    local  moveSU = cc.p(45.0 * bcos, 45.0 * bsin)
    for i=0,goldCoinNumber do
      startPos.x = startPos.x + moveSU.x
      local coin = cc.Sprite:createWithSpriteFrameName("XY_jinbi_j00.png")
      coin:setPosition(startPos)
      coin:setRotation(dOwnerAngle)
      lablayer:addChild(coin,5)

      local anim = animateCache:getAnimation("CoinGold")
      local action = cc.Animate:create(anim)
      coin:runAction(cc.RepeatForever:create(action))
      coin:setScale(0)
      coin:runAction(cc.ScaleTo:create(0.15,1.2,1.2))

      local function Endcallback()
        coin:removeFromParent()
      end
      coin:runAction(cc.Sequence:create(cc.MoveTo:create(cc.pGetDistance(pos2,startPos)/400.0,pos2),cc.CallFunc:create(Endcallback)))
    end
  end

end

function ActionEx:createBomb(BombName,BombAnimN,pos)
  --print("----------------create bomb----------------")
  local bomb = cc.Sprite:createWithSpriteFrameName(BombName)
  bomb:setPosition(pos)
  bomb:setScale(1.5)
  local goNum = table.getn(GameObjAnimSet)
  local idx = -1
    for i=1,goNum do
      if GameObjAnimSet[i].name == BombAnimN then
          idx = i
      end
  end

  local function Endcallback()
      bomb:removeFromParent()
  end

  local anim = animateCache:getAnimation(GameObjAnimSet[idx].name)
  local action = cc.Animate:create(anim)
  local callfun = cc.CallFunc:create(Endcallback)
  bomb:runAction(cc.Sequence:create(action,callfun))

  return bomb
end

--创建活鱼动画
function ActionEx:createFishAndAnimation(fishKind)
  -- body
  local fish = cc.Sprite:createWithSpriteFrameName(fishFrameSet[fishKind])
  local anim = animateCache:getAnimation(fishAnimSet[fishKind].name)
  local action = cc.Animate:create(anim)
  fish:runAction(cc.RepeatForever:create(action))
  return fish
end

function ActionEx:getDieFishAnimRemainTime(fishKind)
  return animateCache:getAnimation(d_fishAnimSet[fishKind].name):getDuration()
end

function ActionEx:createThunder( point1,point2,times )
  local p1 = point1
  local p2 = point2
  local sd = cc.Sprite:createWithSpriteFrameName("XY_s_00.png")
  sd:setAnchorPoint(cc.p(0.048,0.5))
  sd:setPosition(p1)
  sd:setRotation(-RADIANS_TO_DEGREES(cc.pToAngleSelf(cc.pSub(p2,p1))))
  sd:setScaleX(math.abs(cc.pGetDistance(p1, p2))/(sd:getContentSize().width - 10))

  local anim = animateCache:getAnimation("Thunder")
  local action = cc.Animate:create(anim)
  local rep = cc.RepeatForever:create(action)
  sd:runAction(rep)

  local function Endcallback()
      --print("=========================================i m delete func")
      sd:removeFromParent()
  end

  local seq = cc.Sequence:create(cc.DelayTime:create(times),cc.CallFunc:create(Endcallback))
  sd:runAction(seq)

  return sd
end

return ActionEx