local Action = class("Action")

function Action:ctor()	
end

--切割图片创建精灵
function Action:creatsp(bimg, rectTab, times) 
  local textureDog = cc.Director:getInstance():getTextureCache():addImage(tostring(bimg))
  local tab = {}  
  local spriteDog = nil  
  for i=1, #rectTab do  
    local frame = cc.SpriteFrame:createWithTexture(textureDog, rectTab[i])  
    table.insert(tab, i, frame)   
    if i == 1 then  
      spriteDog = cc.Sprite:createWithSpriteFrame(frame)    
    end  
  end  
  local animation = cc.Animation:createWithSpriteFrames(tab, times)  
  local animate = cc.Animate:create(animation)
  spriteDog:runAction(cc.RepeatForever:create(animate))  
  return spriteDog	
end

--切割图片创建动作
function Action:creatac(bimg, rectTab, times)
  local textureDog = cc.Director:getInstance():getTextureCache():addImage(tostring(bimg))
  local tab = {}    
  for i=1, #rectTab do  
    local frame = cc.SpriteFrame:createWithTexture(textureDog, rectTab[i])  
    table.insert(tab, i, frame)    
  end  
  local animation = cc.Animation:createWithSpriteFrames(tab, times)  
  local animate = cc.Animate:create(animation)
  return animate
end

--切割图片创建精灵  重载
function Action:creatsp1(bimg, rectTab, times, keep) 
  local textureDog = cc.Director:getInstance():getTextureCache():addImage(tostring(bimg))
  local tab = {}  
  local spriteDog = nil 
  local function Endcallback()
    if not keep then
      spriteDog:getParent():removeFromParent()
    end
  end 
  for i=1, #rectTab do  
    local frame = cc.SpriteFrame:createWithTexture(textureDog, rectTab[i])  
    table.insert(tab, i, frame)   
    if i == 1 then  
      spriteDog = cc.Sprite:createWithSpriteFrame(frame)    
    end  
  end  
  local animation = cc.Animation:createWithSpriteFrames(tab, times)  
  local animate = cc.Animate:create(animation)
  local funcall = cc.CallFunc:create(Endcallback)
  local seq = cc.Sequence:create(animate,funcall)
  spriteDog:runAction(seq)  
  return spriteDog 
end

--一网打尽爆炸
function Action:crICeBoom(point)

  local tex1 = cc.Director:getInstance():getTextureCache():addImage("qj_animal/res/game_res/Particle/light0.png")
  local tex2 = cc.Director:getInstance():getTextureCache():addImage("qj_animal/res/game_res/Particle/ring1.png")
  local tex3 = cc.Director:getInstance():getTextureCache():addImage("qj_animal/res/game_res/Particle/light7.png")
  local tex4 = cc.Director:getInstance():getTextureCache():addImage("qj_animal/res/game_res/Particle/light8.png")
  local tex5 = cc.Director:getInstance():getTextureCache():addImage("qj_animal/res/game_res/Particle/light9.png")

  local emitter1 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Particle/CoinRingEx.plist") 
  emitter1:setTexture(tex2)
  emitter1:setBlendAdditive(true) 
  emitter1:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
  emitter1:setPosition(point)  
  fishlayer:addChild(emitter1,4)
  
  
  local emitter2 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Particle/CoinBoomLight.plist") 
  emitter2:setTexture(tex1)
  emitter2:setBlendAdditive(true) 
  emitter2:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
  emitter2:setPosition(point)  
  fishlayer:addChild(emitter2,5)
  

  local emitter3 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Particle/CoinBoom.plist") 
  emitter3:setTexture(tex3)
  emitter3:setBlendAdditive(true) 
  emitter3:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
  emitter3:setPosition(point)  
  fishlayer:addChild(emitter3,5)
  

  local emitter4 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Particle/CoinBoom.plist") 
  emitter4:setTexture(tex4)
  emitter4:setBlendAdditive(true) 
  emitter4:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
  emitter4:setPosition(point)  
  fishlayer:addChild(emitter4,5)
  
  
  local emitter5 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Particle/CoinBoom.plist") 
  emitter5:setTexture(tex5)
  emitter5:setBlendAdditive(true) 
  emitter5:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
  emitter5:setPosition(point)  
  fishlayer:addChild(emitter5,4)

  global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHAKE_SCREEN)
end

--大炸弹
function Action:crBoom(point)
  local tex1 = cc.Director:getInstance():getTextureCache():addImage("qj_animal/res/game_res/Particle/ring6.png")
  local tex2 = cc.Director:getInstance():getTextureCache():addImage("qj_animal/res/game_res/Particle/light6.png")
  local emitter1 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Particle/BoomRingEx.plist") 
  emitter1:setTexture(tex1)
  emitter1:setBlendAdditive(true) 
  emitter1:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
  emitter1:setPosition(point)  
  fishlayer:addChild(emitter1,5)

  local emitter2 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Particle/Boom.plist") 
  emitter2:setTexture(tex2)
  emitter2:setBlendAdditive(true) 
  emitter2:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
  emitter2:setPosition(point)  
  fishlayer:addChild(emitter2,5)

  global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHAKE_SCREEN)
end

--小炸弹
function Action:crBBom(point)
  local tex1 = cc.Director:getInstance():getTextureCache():addImage("qj_animal/res/game_res/Particle/ring6.png")
  local tex2 = cc.Director:getInstance():getTextureCache():addImage("qj_animal/res/game_res/Particle/light6.png")
  local emitter1 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Particle/BoomRingEx.plist") 
  emitter1:setTexture(tex1)
  emitter1:setBlendAdditive(true) 
  emitter1:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
  emitter1:setPosition(point)  
  fishlayer:addChild(emitter1,5)

  local emitter2 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Particle/Boom.plist") 
  emitter2:setTexture(tex2)
  emitter2:setBlendAdditive(true) 
  emitter2:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
  emitter2:setPosition(point)  
  fishlayer:addChild(emitter2,5)

  global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHAKE_SCREEN)
end

--同类型鱼炸弹
function Action:crFishBoom(point)
   
  local tex1 = cc.Director:getInstance():getTextureCache():addImage("qj_animal/res/game_res/Particle/ring3.png")
  local tex2 = cc.Director:getInstance():getTextureCache():addImage("qj_animal/res/game_res/Particle/ring2.png")
  local tex3 = cc.Director:getInstance():getTextureCache():addImage("qj_animal/res/game_res/Particle/light1.png")
  local tex4 = cc.Director:getInstance():getTextureCache():addImage("qj_animal/res/game_res/Particle/light2.png")
  local tex5 = cc.Director:getInstance():getTextureCache():addImage("qj_animal/res/game_res/Particle/light3.png")
  --[[
  local emitter1 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Particle/IceRingEx.plist") 
  emitter1:setTexture(tex1)
  emitter1:setBlendAdditive(true) 
  emitter1:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
  emitter1:setPosition(point)  
  fishlayer:addChild(emitter1,4)
 --]]

  local emitter2 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Particle/IceRingEx1.plist") 
  emitter2:setTexture(tex2)
  emitter2:setBlendAdditive(true) 
  emitter2:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
  emitter2:setPosition(point)  
  fishlayer:addChild(emitter2,4)


  local emitter3 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Particle/IceBoom1.plist") 
  emitter3:setTexture(tex3)
  emitter3:setBlendAdditive(true) 
  emitter3:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
  emitter3:setPosition(point)  
  fishlayer:addChild(emitter3,5)


  local emitter4 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Particle/IceBoom2.plist") 
  emitter4:setTexture(tex4)
  emitter4:setBlendAdditive(true) 
  emitter4:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
  emitter4:setPosition(point)  
  fishlayer:addChild(emitter4,5)


  local emitter5 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Particle/IceBoom3.plist") 
  emitter5:setTexture(tex5)
  emitter5:setBlendAdditive(true) 
  emitter5:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
  emitter5:setPosition(point)  
  fishlayer:addChild(emitter5,5)

  global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHAKE_SCREEN)
end

--海啸来袭爆炸
function Action:crDsBoom(point) 
  --local tex1 = cc.Director:getInstance():getTextureCache():addImage("qj_animal/res/game_res/Particle/ring3.png")
  local tex2 = cc.Director:getInstance():getTextureCache():addImage("qj_animal/res/game_res/Particle/ring3.png")
  local tex3 = cc.Director:getInstance():getTextureCache():addImage("qj_animal/res/game_res/Particle/light1.png")
  local tex4 = cc.Director:getInstance():getTextureCache():addImage("qj_animal/res/game_res/Particle/light2.png")
  local tex5 = cc.Director:getInstance():getTextureCache():addImage("qj_animal/res/game_res/Particle/light3.png")

  --[[
  local emitter1 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Particle/IceRingEx.plist") 
  emitter1:setTexture(tex1)
  emitter1:setBlendAdditive(true) 
  emitter1:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
  emitter1:setPosition(point)  
  fishlayer:addChild(emitter1,4)
 --]]

  local emitter2 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Particle/IceRingEx1.plist") 
  emitter2:setTexture(tex2)
  emitter2:setBlendAdditive(true) 
  emitter2:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
  emitter2:setPosition(point)  
  fishlayer:addChild(emitter2,4)


  local emitter3 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Particle/IceBoom1.plist") 
  emitter3:setTexture(tex3)
  emitter3:setBlendAdditive(true) 
  emitter3:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
  emitter3:setPosition(point)  
  fishlayer:addChild(emitter3,5)


  local emitter4 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Particle/IceBoom2.plist") 
  emitter4:setTexture(tex4)
  emitter4:setBlendAdditive(true) 
  emitter4:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
  emitter4:setPosition(point)  
  fishlayer:addChild(emitter4,5)


  local emitter5 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Particle/IceBoom3.plist") 
  emitter5:setTexture(tex5)
  emitter5:setBlendAdditive(true) 
  emitter5:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
  emitter5:setPosition(point)  
  fishlayer:addChild(emitter5,5)

  global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHAKE_SCREEN)
end

--定海
function Action:crDing(point)
  local tex1 = cc.Director:getInstance():getTextureCache():addImage("qj_animal/res/game_res/Particle/light5.png")
  local emitter1 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Particle/ding.plist") 
  emitter1:setTexture(tex1)
  emitter1:setBlendAdditive(true) 
  emitter1:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
  emitter1:setPosition(point)  
  fishlayer:addChild(emitter1,5)
  boodr = false --- 定鱼开启

  global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHAKE_SCREEN)
end

--金币特效
function Action:crCoin(num1,point1,point2,roat)
  local sum = nil
  if num1 ~= nil then
    if num1 >= 2  and num1 <= 10000 then
      self:crSmallCoin(4,point1,point2,roat)
    elseif num1 >= 10001 and num1 <= 100000 then
      self:crSmallCoin(6,point1,point2,roat)
    elseif num1 >= 100001 and num1 <= 200000 then
      self:crBigCoin(12,point1,point2,roat)
    elseif num1 >= 200001 and num1 <= 300000 then
      self:crBigCoin(16,point1,point2,roat)
    elseif num1 > 300000 then
      self:crBigCoin(20,point1,point2,roat)
    end
  end                
end
function Action:crBigCoin(m,point1,point2,roat)
  for i = 1,m/2 do
    local coin = Coin.new()
    coin:setPosition(point1.x+(i-m/4)*60*math.sin(roat),point1.y+(i-m/4)*60*math.cos(roat))
    lablayer:addChild(coin,5)
    local moveto1 = cc.MoveTo:create(1.78,point2)
    local scato = cc.ScaleTo:create(1.78,0.3)
    local function Endcallback()
      coin:removeFromParent()
    end
    local swap = cc.Spawn:create(moveto1,scato)
    local funcall = cc.CallFunc:create(Endcallback)
    local seq = cc.Sequence:create(swap,funcall)
    coin:runAction(seq)
  end
  for i = m/2+1,m do 
    local coin = Coin.new()
    coin:setPosition(point1.x+(i-m*3/4)*60*math.sin(roat),point1.y+(i-m*3/4)*60*math.cos(roat)+50)
    lablayer:addChild(coin,5)
    local moveto1 = cc.MoveTo:create(1.78,point2)
    local scato = cc.ScaleTo:create(1.78,0.3)
    local function Endcallback()
      coin:removeFromParent()
    end
    local swap = cc.Spawn:create(moveto1,scato)
    local funcall = cc.CallFunc:create(Endcallback)
    local seq = cc.Sequence:create(swap,funcall)
    coin:runAction(seq)
  end
end

function Action:crSmallCoin(m,point1,point2,roat)
  for i = 1,m do 
    local coin = Coin.new()                    
    coin:setPosition(point1.x+(i-m/2)*60*math.sin(roat),point1.y+(i-m/2)*60*math.cos(roat))
    lablayer:addChild(coin,5)
    local moveto1 = cc.MoveTo:create(1.78,point2)
    local scato = cc.ScaleTo:create(1.78,0.3)
    local function Endcallback()
      coin:removeFromParent()
    end
    local swap = cc.Spawn:create(moveto1,scato)
    local funcall = cc.CallFunc:create(Endcallback)
    local seq = cc.Sequence:create(swap,funcall)
    coin:runAction(seq)
  end 
end

--金币lab
function Action:SCo(point,good)
  if good > 0 then
    local scorelab = nil
    local function Endcallback()
      scorelab:removeFromParent()
    end
    scorelab = ScoreLab.new()
    scorelab:setPosition(point)
    lablayer:addChild(scorelab,4)
    local goldd = "+"..tostring(good)
    scorelab:setS(goldd)
    scorelab:setSa(1.8)
    local funcall = cc.CallFunc:create(Endcallback)
    local moveby = cc.MoveBy:create(0.4,cc.p(0,20))
    local moveb = moveby:reverse()                                 
    local seq = cc.Sequence:create(moveby,moveb,funcall)
    scorelab:runAction(seq)
  end 
end

return Action