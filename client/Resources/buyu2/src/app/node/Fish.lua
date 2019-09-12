local Fish = class("Fish", function()
		return cc.Node:create()
end)

--local G_FPS_TIME_STD=0.0333334

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
 	self.NextPoint = cc.p(0,0)
 	self.rate = fish_multiple[fishKind]  --鱼的倍率
 	self.Starpoint = Starpoint
 	self.block = false -- 是否锁定
 	self.fishwidow = false  --是否处于屏幕内
	self.behaviors_ = behaviors or {}
	self.boolfire = true --判断鱼能否碰撞
	self.count = 0 --判断点击次数
	self.cotime = 0 --判断点击时间
 	self:create()

 	self.G_FPS_TIME_STD = 0.0166667
	if csFish ==  2 then self.G_FPS_TIME_STD = 0.0333334 end

 	self:enableNodeEvents(true)

 	self.m_mov_timer = 0
 	self.stop_count_ = 0
 	self.current_stop_count_ = 0
 	self.stop_index_ = 0
 	self.trace = nil
 	self.trace_index_ = 0
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
	--print("fk = ",fk)
	if fk >= 1 and fk <= 24 then
		self.sp = ActionEx:createFishAndAnimation(fk)
		if fk == 23 or fk == 24 then
			self.bomfish = {}
		end
	elseif fk == 25 then
		self.sp = Dsyuan.new(1)
	elseif fk == 26 then
		self.sp = Dsyuan.new(2)
	elseif fk == 27 then
		self.sp = DSxfish.new()
	elseif fk >= 28 and fk <= 37 then
		self.sp = FishBoom.new(fk - 28)
		self.bomfish = {}
	end

	self:addChild(self.sp)
    self.width = self.sp:getContentSize().width * 0.8
    self.height = self.sp:getContentSize().height * 0.8

 	if fk == 25 or fk == 26 then
    	self.width = 330 * 0.8
    	self.height = 230 * 0.8
    elseif fk == 27 then
    	self.width = 320 * 0.8
    	self.height = 320 * 0.8
    elseif fk >= 28 and fk <= 37 then
    	self.width = 256 * 0.8
    	self.height = 140 * 0.8
    end

    local body = cc.PhysicsBody:createBox(cc.size(self.width, self.height))
	body:setGroup(-2)
	body:setDynamic(false)
	body:setGravityEnable(false)
	body:setContactTestBitmask(1)
	self:setPhysicsBody(body)

	--[[
	local fk = self.fishKind + 1
	local fps
	if fk >= 1 and fk <= 24 then
		if fk == 1 then
			fps = 10
		elseif fk == 2 then
			fps = 10
		elseif fk == 3 then
			fps = 12
		elseif fk == 4 then
			fps = 12
		elseif fk == 5 then
			fps = 12
		elseif fk == 6 then
			fps = 12
		elseif fk == 7 then
			fps = 10
		elseif fk == 8 then
			fps = 12
		elseif fk == 9 then
			fps = 12
		elseif fk == 10 then
			fps = 10
		elseif fk == 11 then
			fps = 10
		elseif fk == 12 then
			fps = 10
		elseif fk == 13 then
			fps = 10
		elseif fk == 14 then
			fps = 10
		elseif fk == 15 then
			fps = 10
		elseif fk == 16 then
			fps = 10
		elseif fk == 17 then
			fps = 10
		elseif fk == 18 then
			fps = 12
		elseif fk == 19 then
			fps = 4
		elseif fk == 20 then
			fps = 4
		elseif fk == 21 then
			fps = 4
			self.rateTex = ScoreLab.new()
			self:addChild(self.rateTex,6)
			self.rateTex:setPosition(90,0)
			self.rateTex:setSa(1.5)
			self.rateTex:setVisible(false)
		elseif fk == 22 then
			fps = 3
		elseif fk == 23 then
			self.bomfish = {}
			fps = 4
		elseif fk == 24 then
			self.bomfish = {}
			fps = 8
		end
		local filename = "buyu2/res/xfish/fish"..fk..".png"
		self.sp = Action:creatsp(filename,FishCreateTable[self.fishKind],1/fps)
		self:addChild(self.sp)
		self.width = self.sp:getContentSize().width
		self.height = self.sp:getContentSize().height
		if self.fishKind == 23 then
			local action = cc.RotateBy:create(4.0,360)
			self.sp:runAction(cc.RepeatForever:create(action))
		end
	end
	if fk == 25 then
		self.sp = Dsyuan.new(1)
		self:addChild(self.sp)
	elseif fk == 26 then
		self.sp = Dsyuan.new(2)
		self:addChild(self.sp)
	elseif fk == 27 then
		self.sp = DSxfish.new()
		self:addChild(self.sp)
	elseif fk == 28 then
		self.sp = FishBoom.new(0)
		self:addChild(self.sp)
		self.bomfish = {}
	elseif fk == 29 then
		self.sp = FishBoom.new(1)
		self:addChild(self.sp)
		self.bomfish = {}
	elseif fk == 30 then
		self.sp = FishBoom.new(2)
		self:addChild(self.sp)
		self.bomfish = {}
	elseif fk == 31 then
		self.sp = FishBoom.new(3)
		self:addChild(self.sp)
		self.bomfish = {}
	elseif fk == 32 then
		self.sp = FishBoom.new(4)
		self:addChild(self.sp)
		self.bomfish = {}
	elseif fk == 33 then
		self.sp = FishBoom.new(5)
		self:addChild(self.sp)
		self.bomfish = {}
	elseif fk == 34 then
		self.sp = FishBoom.new(6)
		self:addChild(self.sp)
		self.bomfish = {}
	elseif fk == 35 then
		self.sp = FishBoom.new(7)
		self:addChild(self.sp)
		self.bomfish = {}
	elseif fk == 36 then
		self.sp = FishBoom.new(8)
		self:addChild(self.sp)
		self.bomfish = {}
	elseif fk == 37 then
		self.sp = FishBoom.new(9)
		self:addChild(self.sp)
		self.bomfish = {}
	end
	local body = cc.PhysicsBody:createBox(cc.size(self.width, self.height))
	body:setGroup(-2)
	body:setDynamic(false)
	body:setGravityEnable(false)
	body:setContactTestBitmask(1)
	self:setPhysicsBody(body)
	--]]
end
--死亡动作执行
function Fish:playac()
	self:removeFromPhysicsWorld()

	self.speed = 0
	local fd = self.fishKind + 1
	local fps
	if fd >= 25 and fd <= 37 then
		if fd >= 25 and fd <= 27 then
			self.sp:stop1()
			Action:crDsBoom(cc.p(self:getPositionX(),self:getPositionY()))
			self:removeFromParent()
		elseif fd >= 28 then
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
			fps = 12
		elseif fd == 6 then
			fps = 14
		elseif fd == 7 then
			fps = 12
		elseif fd == 8 then
			fps = 18
		elseif fd == 9 then
			fps = 12
		elseif fd == 10 then
			fps = 12
		elseif fd == 11 then
			fps = 12
		elseif fd == 12 then
			fps = 12
		elseif fd == 13 then
			fps = 12
		elseif fd == 14 then
			fps = 12
		elseif fd == 15 then
			fps = 10
		elseif fd == 16 then
			fps = 16
		elseif fd == 17 then
			fps = 16
		elseif fd == 18 then
			fps = 12
			--Action:crICeBoom(cc.p(self:getPositionX(),self:getPositionY()))
		elseif fd == 19 then
			fps = 12
			Action:crICeBoom(cc.p(self:getPositionX(),self:getPositionY()))
		elseif fd == 20 then
			fps = 12
			Action:crICeBoom(cc.p(self:getPositionX(),self:getPositionY()))
		elseif fd == 21 then
			fps = 12
			Action:crICeBoom(cc.p(self:getPositionX(),self:getPositionY()))
		elseif fd == 22 then
			fps = 1
			Action:crDing(cc.p(self:getPositionX(),self:getPositionY()))
		elseif fd == 23 then
			fps = 10
			Action:crBBom(cc.p(self:getPositionX(),self:getPositionY()))
		elseif fd == 24 then
			fps = 2
			Action:crBoom(cc.p(self:getPositionX(),self:getPositionY()))
		end
		local function Endcallback()
			self:removeFromParent()
		end
		local filename = "buyu2/res/xfish/fish"..fd.."_d.png"
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
					if self.fishKind < 18 or self.fishKind == 21 then
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