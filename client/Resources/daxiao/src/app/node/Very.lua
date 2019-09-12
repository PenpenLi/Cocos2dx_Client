local Very = class("Very", function()
    return cc.Node:create()
end)

local G_FPS_TIME_STD=0.0333334
local RADIANTO = 57.29577951308

local orginx = 0
local orginy = 0
local width = 1280
local height = 720

function Very:ctor(a,sum,android_chairid)
  self.FishSuId = 0
  self.VeryId = 0
  self.playID = sum
  self.android_chairid_=android_chairid 
  local pon = sum + 1
  self.Rate = 1
  self.speed = 0
  self.rotaion = 0
  self.butype = a
  self.bullet_multiple = 0
  self.fishnet = 0
  local file = nil

  self.spp = cc.Sprite:createWithSpriteFrameName(BulletSet[self.playID][a])
  local anim = animateCache:getAnimation(BulletAnimSet[self.playID][a])
  local action = cc.Animate:create(anim)
  self.spp:runAction(cc.RepeatForever:create(action))
  self.spp:setScale(1.0)
  self:addChild(self.spp)
  self:enableNodeEvents(true)


  self.trace_index_ = 0
  self.trace_ = nil
  self.m_movTimer = 0

  if self.playID == num then
    bullnum = bullnum + 1
  end

  local size = self.spp:getContentSize()
  local body = cc.PhysicsBody:createBox(size)
  body:setGroup(-1)
  body:setGravityEnable(false)
  body:setContactTestBitmask(1)
  self:setPhysicsBody(body)

  self:Update()
end


function Very:SetMoveSpeed(angle,speed)
    self.speedLen = speed;
    self.speedX = speed * math.cos(DEGREES_TO_RADIANS(angle))
    self.speedY = speed * math.sin(DEGREES_TO_RADIANS(angle))
    self:setRotation(90-angle)
    --cclog("speed = %d",speed)
end

function Very:Update()
  self.schedulerID = scheduler:scheduleScriptFunc(function (dt)
    local x,y = self:getPosition()

    if self.FishSuId > 0 and fishMap[self.FishSuId] then
            local fx,fy = fishMap[self.FishSuId]:getPosition()
            local np = subTwoPoints(cc.p(fx,fy),cc.p(x,y))
            local ag = GetPointAngle(np.x,np.y)
            self.speedX = math.cos(ag) * self.speedLen
            self.speedY = math.sin(ag) * self.speedLen
            self:setRotation(-RADIANS_TO_DEGREES(ag)+90)
    end


    self:setPosition(cc.p(x + self.speedX * dt,y + self.speedY * dt))

    if x > (width + orginx) and self.speedX > 0 then
        self.speedX = self.speedX * -1
        self:setRotation(-self:getRotation())
        self.FishSuId = 0
    elseif x < orginx and self.speedX < 0 then
        self.speedX = self.speedX * -1
        self:setRotation(-self:getRotation())
        self.FishSuId = 0
    end

    if y > (height + orginy) and self.speedY > 0 then
        self.speedY = self.speedY * -1
        self:setRotation(180-self:getRotation())
        self.FishSuId = 0
    elseif y < orginy and self.speedY < 0 then
        self.speedY = self.speedY * -1
        self:setRotation(180-self:getRotation())
        self.FishSuId = 0
    end
  end, 0, false)
end

function Very:getBulletHeight()
  return self.spp:getContentSize().height
end

function Very:getandroid()
  return self.android_chairid_
end

function Very:setRota(rotaion_)
  --self.spp:setRotation(rotaion_)
  self.rotaion = rotaion_
end
function Very:setScale(a)
  self.spp:setScale(a)
end
function Very:setSpeed(speed_)
  self.speed = speed_
end
function Very:setBu_multiple(rate)
  self.bullet_multiple = rate
  if rate >= 1000 and rate <= 9900 then
    self.fishnet = 4
  elseif rate >= 100 and rate < 1000 then
    self.fishnet = 3
  else
    self.fishnet = 2
  end
end
function Very:onExit()
  cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
  self.schedulerID = nil

  if self.trace_ then
    self.trace_:Release()
    self.trace_ = nil
  end
  if self.playID == num then
    bullnum = bullnum - 1
  end
end

function Very:setTrace(trace)
  if self.trace_ then
    self.trace_:Release()
  end
  self.trace_ = trace
end

function Very:OnFrame( delta_time )
  if self.trace_index_ >= self.trace_:Size() then return true end

  self.m_movTimer = self.m_movTimer + delta_time
  if self.m_movTimer > G_FPS_TIME_STD then
    self.m_movTimer = self.m_movTimer - G_FPS_TIME_STD
    if self.m_movTimer > G_FPS_TIME_STD then self.m_movTimer = 0 end --后台返回之类
    self.trace_index_ = self.trace_index_ + 1
    if self.trace_index_ >= self.trace_:Size() then
      return true
    else
      local x,y = self.trace_:Index(self.trace_index_)
      if x <= 0 or y <= 0 or x >= 1280 or y >= 720 then
        return true
      end
      self:setPosition(cc.p(x, y))

      --锁鱼状态改变子弹的轨迹，防止锁鱼状态打不中鱼
      if self.FishSuId > 0 and fishMap[self.FishSuId] and self.trace_index_ >= 5 and self.trace_:Size() >= 5 then
        local canget, fishx, fishy = fishMap[self.FishSuId]:GetCurPos()
        local x0, y0 = self.trace_:Index(self.trace_index_)
        self.trace_index_ = 0
        local angle = math.rad(self.rotaion)
        if canget then
          angle = MathAide:CalcAngle(fishx, fishy, x0, y0)
          self:setRotation(angle*57.29577951308)
        end
        local x1, y1 = MathAide:GetTargetPoint(x0, y0, angle)
        local trace = MathAide:BuildLinear(x0, x1, y0, y1, self.speed)
        self:setTrace(trace)
      end
    end
  end
end

function Very:GetCurPos(  )
  if self.trace_index_ >= self.trace_:Size() then
    local x,y = self.trace_:Index(self.trace_index_ - 1)
    return x, y
  end
  return self.trace_:Index(self.trace_index_)
end

function Very:Rebound()
  if self.trace_:Size() == 0 then
    --撒网
    local fishnet = Fishnet.new(self.fishnet)
    local point = cc.p(self:getPositionX(),self:getPositionY())
    fishnet:setPosition(point)
    fishnet:setRotation(self:getRotation())
    verylayer:addChild(fishnet,2)
    bulletMap[self.VeryId] = nil
    self:removeFromParent()
    soundManager:PlayGameEffect(1)

    return
  end
  self.FishSuId = 0
  local backx, backy = self:GetCurPos()
  local frontx, fronty = self.trace_:Index(0)
  local x0, y0 = backx, backy
  local screen_width = 1280
  local screen_height = 720
  local tem_if_re = 0
  local angle

  if backx > 0 and backy > 0 and backx < screen_width and backy < screen_height then
    angle = math.rad(self.rotaion)
  else
    tem_if_re = 1
    if frontx > 0 and frontx < screen_width and fronty > 0 and fronty < screen_height then
      angle = math.atan2(math.abs(backy-fronty), math.abs(backx-frontx))
      self:setRota(math.deg(angle))
    else
      angle = math.rad(self.rotaion)
    end
  end

  local direction
  if backx <= 0 then
    if fronty - backy > 0 then
      direction = 3
      if tem_if_re then
          self:setRotation(self:getRotation() - (math.pi-2*angle)*RADIANTO)
      end
    else
      direction = 2
      if tem_if_re then
          self:setRotation(self:getRotation() + (math.pi-2*angle)*RADIANTO)
      end
    end
  elseif backy <= 0 then
    if frontx - backx > 0 then
      if tem_if_re then
        self:setRotation(self:getRotation() + (2*angle*RADIANTO))
      end
      direction = 0
    else
      if tem_if_re then
        self:setRotation(self:getRotation() - (2*angle*RADIANTO))
      end
      direction = 1
    end
  elseif backx >= screen_width then
    if fronty - backy > 0 then
      if tem_if_re then
        self:setRotation(self:getRotation() + (math.pi-2*angle)*RADIANTO)
      end
      direction = 3
    else
      if tem_if_re then
        self:setRotation(self:getRotation() - (math.pi-2*angle)*RADIANTO)
      end
      direction = 2
    end
  elseif backy >= screen_height then
    if frontx - backx > 0 then
      if tem_if_re then
        self:setRotation(self:getRotation() - (2*angle)*RADIANTO)
      end
      direction = 0
    else
      if tem_if_re then
        self:setRotation(self:getRotation() + (2*angle)*RADIANTO)
      end
      direction = 1
    end
  end

  local x1, y1
  if tem_if_re then
    x1, y1 = MathAide:GetReboundTargetPoint(x0, y0, angle, direction)
  else
    x1, y1 = MathAide:GetTargetPoint(x0, y0, angle)
  end
  local trace = MathAide:BuildLinear(x0, x1, y0, y1, self.speed)
  self:setTrace(trace)
  self.trace_index_ = 0
end

function Very:Fire(x0, y0)
  --[[
  local angle = math.rad(self.rotaion)
  local x1, y1 = MathAide:GetTargetPoint(x0, y0, angle)
  local trace = MathAide:BuildLinear(x0, x1, y0, y1, self.speed)
  self:setTrace(trace)]]

  soundManager:PlayGameEffect(3)
end

return Very