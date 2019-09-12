local Mask = class("Mask", function()
		return cc.Node:create()
end)

function Mask:ctor()
		self.btimer = 0
		--self.boolma = false
		self:Boco()
	--创建一个裁剪节点用来实现遮罩的效果
		local  clippingNode = cc.ClippingNode:create()
		self:addChild(clippingNode,2)
		--向裁剪节点中加入内容，这里加入的是一个透明的层
		--local layer = cc.LayerColor:create(cc.c4f(-winwidth/2,-winheight/2,0,200))
		--self:addChild(layer)
		--继续向裁剪节点中加入内容，这里加入的是一个精灵
		local function onTouch1(sender, eventType)
			if eventType == ccui.TouchEventType.began then
				self.Selected1 = cc.Sprite:create("buyu2/res/fishui/Selected.png")
				clippingNode:addChild(self.Selected1,1)
				self.Selected1:setPosition(cc.p(self.Coinopbtn:getPositionX(),self.Coinopbtn:getPositionY()))
			end
			if eventType == ccui.TouchEventType.ended then
				--倍率表显示
				local director = cc.Director:getInstance()
				local running_scene = director:getRunningScene()
				running_scene.Rate:setVisible(true)
				self.Selected1:removeFromParent()
			end
		end
		self.Coinopbtn = ccui.Button:create("buyu2/res/rate1.png","buyu2/res/rate2.png")
		self.Coinopbtn:addTouchEventListener(onTouch1)
		self.Coinopbtn:setPosition(cc.p(0,139))
		clippingNode:addChild(self.Coinopbtn,2)
		self.Coinopbtn:setScale(0.8)



		local function onTouch3(sender, eventType)
			if eventType == ccui.TouchEventType.began then
				self.Selected3 = cc.Sprite:create("buyu2/res/fishui/Selected.png")
				clippingNode:addChild(self.Selected3,1)
				self.Selected3:setPosition(cc.p(self.Setupbtn:getPositionX(),self.Setupbtn:getPositionY()))
			end
			if eventType == ccui.TouchEventType.ended then
    			if keyF4Pressed == false then
	    			PopUpView.showPopUpView(SoundSetting)
				end
				self.Selected3:removeFromParent()
			end
		end
		self.Setupbtn = ccui.Button:create("buyu2/res/fishui/Setupbtn.png","buyu2/res/fishui/Setupbtn2.png")
		self.Setupbtn:addTouchEventListener(onTouch3)
		self.Setupbtn:setPosition(cc.p(0,47))
		clippingNode:addChild(self.Setupbtn,2)
		self.Setupbtn:setScale(0.8)

		local function onTouch4(sender, eventType)
			if g_protion ~= nil then
				if eventType == ccui.TouchEventType.began then
					self.Selected4 = cc.Sprite:create("buyu2/res/fishui/Selected.png")
					clippingNode:addChild(self.Selected4,1)
					self.Selected4:setPosition(cc.p(self.Sioutbtn:getPositionX(),self.Sioutbtn:getPositionY()))
					if global.g_mainPlayer:isInMatchRoom() == false then
	  					global.g_mainPlayer:setPlayerScore(math.floor(g_score[num] * g_protion))
	  				end
					WarnTips.showTips({
							text = LocalLanguage:getLanguageString("L_6ceb2e80d33e115e"),
							confirm = exit_buyu2,
						})
				end
				if eventType == ccui.TouchEventType.ended then
					self.Selected4:removeFromParent()
				end
			end
		end
		self.Sioutbtn = ccui.Button:create("buyu2/res/fishui/Sioutbtn.png","buyu2/res/fishui/Sioutbtn2.png")
		self.Sioutbtn:addTouchEventListener(onTouch4)
		self.Sioutbtn:setPosition(cc.p(0,-46))
		clippingNode:addChild(self.Sioutbtn,2)
		self.Sioutbtn:setScale(0.8)

		local function onTouch5(sender, eventType)
			if eventType == ccui.TouchEventType.began then
				self:updata()
				self.Recovbtn:setEnabled(false)
				self.Coinopbtn:setEnabled(false)
				--self.Settlbtn:setEnabled(false)
				self.Setupbtn:setEnabled(false)
				self.Sioutbtn:setEnabled(false)
				self.Selected5 = cc.Sprite:create("buyu2/res/fishui/Selected.png")
				clippingNode:addChild(self.Selected5,1)
				self.Selected5:setPosition(cc.p(self.Recovbtn:getPositionX(),self.Recovbtn:getPositionY()))
			end
			if eventType == ccui.TouchEventType.ended then
				self.Selected5:removeFromParent()
			end
		end
		self.Recovbtn = ccui.Button:create("buyu2/res/fishui/Recovbtn.png","buyu2/res/fishui/Recovbtn2.png")
		self.Recovbtn:addTouchEventListener(onTouch5)
		self.Recovbtn:setPosition(cc.p(0,-142))
		clippingNode:addChild(self.Recovbtn,2)

		--向裁剪节点中加入精灵，精灵的位置和裁剪的位置相同，所以最后让裁剪掉了
		local sprite2 = cc.Sprite:create("buyu2/res/fishui/Drdownback.png")
		clippingNode:addChild(sprite2,1)

		--创建模板，裁剪节点将按照这个模板来裁剪区域
		self.stencil = cc.Sprite:create("buyu2/res/fishui/Coinopbtn2.png")
		self.stencil:setScaleY(0.01)
		self.stencil:setScaleX(1.2)
		self.stencil:setPosition(cc.p(0,-190))
		clippingNode:setStencil(self.stencil)
		--这个是用来设置显示裁剪区域还是非裁剪区域的
		clippingNode:setInverted(true)
		--我们之前放了一张裁剪的模板，按照这个模板裁剪的时候同时按照这个alpha的值裁剪，这个值的范围是0-1
		--设为0就把透明的区域裁剪掉了
		--0clippingNode->setAlphaThreshold(0)

function Mask:fadeMask()
	self:updata()
	cclog("playUpdate")
	self.Recovbtn:setEnabled(false)
	self.Coinopbtn:setEnabled(false)
				--self.Settlbtn:setEnabled(false)
	self.Setupbtn:setEnabled(false)
	self.Sioutbtn:setEnabled(false)
end
end
function Mask:updata()
	local crtimer = 0
	self.schedulerID = scheduler:scheduleScriptFunc(function (dt)
		crtimer = crtimer + dt
        local y = 376 * crtimer
        self.baoc:setPosition(0,y-204)
		self.scalY = 2 * y / (self.stencil:getContentSize().height)
		self.stencil:setScaleY(self.scalY)
		if crtimer >= 1 then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
            --self.Recovbtn:setEnabled(true)
			--self.Coinopbtn:setEnabled(true)
			--self.Settlbtn:setEnabled(true)
			--self.Setupbtn:setEnabled(true)
			--self.Sioutbtn:setEnabled(true)
			--self.baoc:setPosition(50*78/103,53*78/103)
			--self.stencil:setScaleY(5)
			local function onTouch(sender, eventType)
				if eventType == ccui.TouchEventType.began then
					self.btimer = 2
					self:updata1()
					self.Recovbtn:setEnabled(false)
					self.Coinopbtn:setEnabled(false)
					--self.Settlbtn:setEnabled(false)
					self.Setupbtn:setEnabled(false)
					self.Sioutbtn:setEnabled(false)
				end
			end
			self.btn = ccui.Button:create("buyu2/res/fishui/Boco2.png","buyu2/res/fishui/Boco2.png")
			self.btn:addTouchEventListener(onTouch)
			self.btn:setPosition(cc.p(0,200))
			self.btn:setScale(105/78)
			self:addChild(self.btn,6)
			local function callback1()
				self.btimer = 1
			end
			local funcall = cc.CallFunc:create(callback1)
			local seq1 = cc.Sequence:create(cc.RotateTo:create(1.5,720),funcall)
			self.btn:runAction(seq1)
		end
	end,1/60, false)
end
function Mask:Boco()
	self.scalY = 0.01
	self.baoc = cc.Sprite:create("buyu2/res/fishui/Boco.png")
	self.baoc:setPosition(0,-204)
	self:addChild(self.baoc,3)

	local baoc1 = cc.Sprite:create("buyu2/res/fishui/Boco.png")
	baoc1:setPosition(0,204)
	baoc1:setScaleY(-1)
	self:addChild(baoc1,3)
end
function Mask:updata1( ... )
	self.btn:removeFromParent()
	local dtimer = 0
	self.schedulerID1 = scheduler:scheduleScriptFunc(function (dt)
		dtimer = dtimer + dt
		local y = 376 * dtimer
		self.baoc:setPosition(0,187 - y)
		self.scalY = 2 *(376 - y)  / (self.stencil:getContentSize().height)
		self.stencil:setScaleY(self.scalY)
		if dtimer >= 1 then
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID1)
		    self.Recovbtn:setEnabled(true)
		    self.Coinopbtn:setEnabled(true)
		    --self.Settlbtn:setEnabled(true)
		    self.Setupbtn:setEnabled(true)
		    self.Sioutbtn:setEnabled(true)
		    self.stencil:setScaleY(0.01)
		    self.baoc:setPosition(0,-204)
		end
	end,1/60, false)
end

return Mask