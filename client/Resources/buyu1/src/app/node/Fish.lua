require ("buyu1.src.app.node.Digital")
local Fish = class("Fish", function()
		return cc.Node:create()
end)

--local G_FPS_TIME_STD=0.0333334
--local G_FPS_TIME_STD=0.0166667

function Fish:ctor(fishKind,fishID,points,type, behaviors,csFish)
 	self.fishID = fishID
 	self.rotation = 0
 	self.speed = fishSpeed
 	self.EndTimer = 0
 	self.CurrTimer = 0
 	self.width = fish_width[fishKind]
 	self.height = fish_height[fishKind]
 	self.fishKind = fishKind
 	self.type = type
 	self.gType = 0
 	self.NextPoint = cc.p(0,0)
 	self.rate = fish_multiple[fishKind]  --鱼的倍率
 	self.Starpoint = Starpoint
 	self.block = false -- 是否锁定
 	self.fishwidow = false  --是否处于屏幕内
	self.behaviors_ = behaviors or {}
	self.boolfire = true --判断鱼能否碰撞
	self.count = 0 --判断点击次数
	self.cotime = 0 --判断点击时间
	self.G_FPS_TIME_STD = 0.0166667
	if csFish ==  2 then self.G_FPS_TIME_STD = 0.0333334 end
	--cclog("self.G_FPS_TIME_STD = %f",self.G_FPS_TIME_STD)

	self.m_mov_timer = 0
 	self.stop_count_ = 0
 	self.current_stop_count_ = 0
 	self.stop_index_ = 0
 	self.trace = nil
 	self.trace_index_ = 0

	self.schedulerID = nil
 	self:create()
 	self:enableNodeEvents(true)
 	--self:Update()
end

function Fish:updataSuoD(dt,pao)
	if self.count == 1 then
		self.cotime = self.cotime + dt
		if self.cotime >= 1 then
			self.count = 0
			self.cotime = 0
		end
	end
end

function Fish:setRo(rota)
	self.rotation = rota
end
--鱼的创建
function Fish:create()
	local fk = self.fishKind + 1
	--	cclog("fk = %d",fk)
	if fk >= 1 and fk <= 24 then
		self.sp = ActionEx:createFishAndAnimation(fk)
		if fk == 23 or fk == 24 then
			self.bomfish = {}
		elseif fk == 21 then
		  self.rateTex = Digital:create("0","buyu1/res/fishui/num_defen.png",40,50,string.byte("0"))
	      self.rateTex:setNumber(self.rate)
	      self:addChild(self.rateTex,1)
	      self.rateTex:setAnchorPoint(cc.p(0.5,0.5))
	      self.rateTex:setPosition(cc.p(0,0))
		end
	elseif fk >= 25 and fk <= 27 then
		local ft = 3
		if fk == 26 then ft = 4
		elseif fk == 27 then ft = 6 end
		self.sp = Dsyuan.new(ft)
		self.gType = ft
	elseif fk >= 28 and fk <= 30 then
		local ft = 5
		if fk == 29 then ft = 7
		elseif fk == 30 then ft = 9 end
		self.sp = DSxfish.new(ft)
		self.gType = ft
	elseif fk >= 31 and fk <= 40 then
		self.sp = FishBoom.new(fk - 31)
		self.bomfish = {}
		self.gType = fk - 31
	end
	if self.sp then
		self:addChild(self.sp)    
    	self.width = self.sp:getContentSize().width * 0.8
	    self.height = self.sp:getContentSize().height * 0.8
    end
	if fk == 24 then
    	self.width = self.width * 0.8
    	self.height = self.height * 0.8
    elseif fk >= 25 and fk <= 27 then
    	self.width = 360 * 0.8
    	self.height = 120 * 0.8
    elseif fk >= 28 and fk <= 30 then
    	self.width = 480 * 0.8
    	self.height = 120 * 0.8
    elseif fk >= 31 and fk <= 40 then
    	self.width = 120 * 0.8
    	self.height = 120 * 0.8
    end


  local body = cc.PhysicsBody:createBox(cc.size(self.width, self.height))
  body:setGroup(-2)
  body:setDynamic(false)
  body:setGravityEnable(false)
  body:setContactTestBitmask(1)
  self:setPhysicsBody(body)
end

function Fish:Update()

  self.schedulerID = scheduler:scheduleScriptFunc(function (delta_time)

  if self.trace_index_ >= self.trace:Size() then

  	fishMap[self.fishID] = nil
    self:removeFromParent()
  end

  self.m_mov_timer = self.m_mov_timer + delta_time
  if self.m_mov_timer > self.G_FPS_TIME_STD then

		local Mov_Step = 1
		self.m_mov_timer = self.m_mov_timer - self.G_FPS_TIME_STD
		if self.fishKind == 20 and self.fishKind == 23 then
			--不补帧
		else
			while(self.m_mov_timer > self.G_FPS_TIME_STD)
			do
				self.m_mov_timer = self.m_mov_timer - self.G_FPS_TIME_STD
				Mov_Step = Mov_Step + 1
			end
		end

		if self.stop_count_ > 0 and self.trace_index_ >= self.stop_index_ and self.current_stop_count_ < self.stop_count_ then
			self.current_stop_count_ = self.current_stop_count_ + Mov_Step
			if self.current_stop_count_ >= self.stop_count_ then self:SetFishStop(0, 0) end
		else
			--print(boodr)
			if boodr then

				--cclog("fishupdate")
				self.trace_index_ = self.trace_index_ + Mov_Step
				if self.trace_index_ >= self.trace:Size() then
					fishMap[self.fishID] = nil
    				self:removeFromParent()
				else
					local x,y,angle = self.trace:Index(self.trace_index_)
					local show_angle = angle
					if self.fishKind < 25 then
						show_angle = show_angle - math.pi/2
					end
					if self.fishKind == 23 then
						show_angle = 0
					end
					self.rotation = show_angle*57.29577951308
					self:setRotation(self.rotation)
					self:setPosition(cc.p(x, y))
				end
			end
		end
	end
  end, 0, false)
end

--死亡动作执行
function Fish:playac()
	self:removeFromPhysicsWorld()

	self.speed = 0
	local fd = self.fishKind + 1
	local fps
	if fd == 9 or (fd >= 22 and fd <= 40) then
		if fd == 9 then
			self:stop()
			self:removeFromParent()
		elseif fd == 22 then
			self:stop()
			Action:crDing(cc.p(self:getPositionX(),self:getPositionY()))
			self:removeFromParent()
		elseif fd == 23 then
			self:stop()
			Action:crBBom(cc.p(self:getPositionX(),self:getPositionY()))
			self:removeFromParent()
		elseif fd == 24 then
			self:stop()
			Action:crBoom(cc.p(self:getPositionX(),self:getPositionY()))
			self:removeFromParent()
		elseif fd >= 25 and fd <= 30 then
			self.sp:stop1()
			Action:crDsBoom(cc.p(self:getPositionX(),self:getPositionY()))
			self:removeFromParent()
		elseif fd >= 31 then
			Action:crFishBoom(cc.p(self:getPositionX(),self:getPositionY()))
			self:removeFromParent()
		end
	else
		if fd == 1 then
			fps = 16
		elseif fd == 2 then
			fps = 16
		elseif fd == 3 then
			fps = 12
		elseif fd == 4 then
			fps = 12
		elseif fd == 5 then
			fps = 16
		elseif fd == 6 then
			fps = 14
		elseif fd == 7 then
			fps = 18
		elseif fd == 8 then
			fps = 18
		elseif fd == 10 then
			fps = 9
		elseif fd == 11 then
			fps = 12
		elseif fd == 12 then
			fps = 12
		elseif fd == 13 then
			fps = 16
		elseif fd == 14 then
			fps = 12
		elseif fd == 15 then
			fps = 10
		elseif fd == 16 then
			fps = 26
		elseif fd == 17 then
			fps = 20
		elseif fd == 18 then
			fps = 20
			Action:crICeBoom(cc.p(self:getPositionX(),self:getPositionY()))
		elseif fd == 19 then
			fps = 30
			Action:crICeBoom(cc.p(self:getPositionX(),self:getPositionY()))
		elseif fd == 20 then
			fps = 14
			Action:crICeBoom(cc.p(self:getPositionX(),self:getPositionY()))
		elseif fd == 21 then
			fps = 30
			Action:crICeBoom(cc.p(self:getPositionX(),self:getPositionY()))
		end
		local function Endcallback()
			self:removeFromParent()
		end
		local filename = "buyu1/res/xfish/fish"..fd.."_d.png"
		local action = Action:creatac(filename,FishDeathTable[self.fishKind],1/fps)
		local funcall = cc.CallFunc:create(Endcallback)
		local seq = cc.Sequence:create(action,funcall)
		self:stop()
		self.sp:runAction(seq)
	end
end

function Fish:stop()
	self.sp:stopAllActions()
end

function Fish:onExit()
	if self.schedulerID ~= nil then
	    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
	    self.schedulerID = nil
  	end

	if self.trace then
		self.trace:Release()
		self.trace = nil
	end
	for _, v in pairs(bulletMap) do
		if v.FishSuId == self.fishID then
			v.FishSuId = 0
		end
	end
end

function InsideScreen(x, y)
	if x > 0 and x < 1280 and y > 0 and y < 720 then
		return true
	end
	return false
end

function Fish:GetCurPos( )
	local size = self.trace:Size()
	if self.trace_index_ >= size then
		local x, y = self.trace:Index(size - 1)
		return false, x, y
	end
	local x,y = self.trace:Index(self.trace_index_)
	if InsideScreen(x,y) then
		return true, x, y
	end
	return false
end

function Fish:SetFishStop(stop_index, stop_count)
	self.stop_index_ = stop_index
	self.stop_count_ = stop_count
	self.current_stop_count_ = 0
end

function Fish:OnFrame(delta_time, lock)
	if self.trace_index_ >= self.trace:Size() then return true end

	self.m_mov_timer = self.m_mov_timer + delta_time
	if self.m_mov_timer > self.G_FPS_TIME_STD then
		local Mov_Step = 1
		self.m_mov_timer = self.m_mov_timer - self.G_FPS_TIME_STD
		if self.fishKind == 20 and self.fishKind == 23 then
			--不补帧
		else
			while(self.m_mov_timer > self.G_FPS_TIME_STD)
			do
				self.m_mov_timer = self.m_mov_timer - self.G_FPS_TIME_STD
				Mov_Step = Mov_Step + 1
			end
		end

		if self.stop_count_ > 0 and self.trace_index_ >= self.stop_index_ and self.current_stop_count_ < self.stop_count_ then
			self.current_stop_count_ = self.current_stop_count_ + Mov_Step
			if self.current_stop_count_ >= self.stop_count_ then self:SetFishStop(0, 0) end
		else
			if not lock then
				self.trace_index_ = self.trace_index_ + Mov_Step
				if self.trace_index_ >= self.trace:Size() then
					return true
				else
					local x,y,angle = self.trace:Index(self.trace_index_)
					local show_angle = angle
					if self.fishKind < 23 then
						show_angle = show_angle - math.pi/2
					end
					if self.fishKind == 23 then
						show_angle = 0
					end
					self.rotation = show_angle*57.29577951308
					self:setRotation(self.rotation)
					self:setPosition(cc.p(x, y))
				end
			end
		end
	end

	return false
end

return Fish