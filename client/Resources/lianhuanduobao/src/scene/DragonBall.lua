DragonBall = class("DragonBall", LayerBase)

function DragonBall:ctor()
	DragonBall.super.ctor(self)
	self:initUIView()
	self.bDone = false
end

function DragonBall:initUIView( )
	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("lianhuanduobao/res/json/dballpanel.json")
	root:setAnchorPoint(0, 0)
	self:addChild(root)

	self.confirmBtn = ccui.Helper:seekWidgetByName(root, 'confirm')
	self.confirmBtn:addTouchEventListener(makeClickHandler(self, self.onConfirmClicked))

	self.helpBtn = ccui.Helper:seekWidgetByName(root, "wen")
	self.helpBtn:addTouchEventListener(makeClickHandler(self, self.onHelpClick))

	self.accumLb = ccui.Helper:seekWidgetByName(root, 'AtlasLabel_26')
	self.totalPointLb = ccui.Helper:seekWidgetByName(root, 'allcountLabel')
	self.nowPointLb = ccui.Helper:seekWidgetByName(root, 'currcountLabel')
	self.linePointLb = ccui.Helper:seekWidgetByName(root, 'dlineCountLabel')
	self.lineLb = ccui.Helper:seekWidgetByName(root, 'lineCountLabel')
	self.bonusClo = ccui.Helper:seekWidgetByName(root, 'reward')
	self.bonusLb = ccui.Helper:seekWidgetByName(root, 'bonus')
	self.bonusClo:setVisible(false)

	self.rewardLbs = {}
	for i = 1, 5 do
		self.rewardLbs[i] = ccui.Helper:seekWidgetByName(root, 'box'..i):getChildByName('value')
	end


	self.lineSubBtn = ccui.Helper:seekWidgetByName(root, 'lineSubBtn')
	self.lineSubBtn:addTouchEventListener(makeClickHandler(self, self.onLineSubBtnClicked))

	self.lineAddBtn = ccui.Helper:seekWidgetByName(root, 'lineAddBtn')
	self.lineAddBtn:addTouchEventListener(makeClickHandler(self, self.onLineAddBtnClicked))

	self.dlineSubBtn = ccui.Helper:seekWidgetByName(root, 'dlineSubBtn')
	self.dlineSubBtn:addTouchEventListener(makeClickHandler(self, self.onDlineSubBtnClicked))

	self.dlineAddBtn = ccui.Helper:seekWidgetByName(root, 'dlineAddBtn')
	self.dlineAddBtn:addTouchEventListener(makeClickHandler(self, self.onDlineAddBtnClicked))

	self.tgBtn = ccui.Helper:seekWidgetByName(root, 'tg')
	self.tgBtn:addTouchEventListener(makeClickHandler(self, self.onTgBtnClicked))

	self.startBtn = ccui.Helper:seekWidgetByName(root, 'start')
	self.startBtn:addTouchEventListener(makeClickHandler(self, self.onConfirmClicked))
	self.startBtn:setVisible(false)

	self.exitBtn = ccui.Helper:seekWidgetByName(root, 'exitBtn')
	self.exitBtn:addTouchEventListener(makeClickHandler(self, self.onConfirmClicked))
	self.exitBtn:setVisible(false)
	
	--獎勵
	self.awardBtn = ccui.Helper:seekWidgetByName(root, "awardBtn")
	self.awardBtn:addTouchEventListener(makeClickHandler(self, self.onAwardBtnClick))
	
	self.labaBtn = ccui.Helper:seekWidgetByName(root, 'laba')
	self.labaBtn:addTouchEventListener(makeClickHandler(self, self.onVolumeClick))

	-- 初始化宝石图
	self:initGemLayout(root)
end

function DragonBall:initGemLayout( root )
	self.showArea = ccui.Helper:seekWidgetByName(root, 'showArea')
	self.gemPos = {}
	for i = 0, 10 do
		local gem = ccui.Helper:seekWidgetByName(root, 'gem'..i)
		local pos = cc.p(gem:getPosition())
		gem:setVisible(false)
		self.gemPos[i] = pos
	end
	for i,v in ipairs(self.rewardLbs) do
		local pos = cc.p(v:getParent():getPosition())
		self.gemPos[10 + i] = pos
	end
	local gemIndex = {ZUAN_SHI, 
					  LAN_BAO_SHI,LAN_BAO_SHI, 
					  HUANG_BAO_SHI,HUANG_BAO_SHI,HUANG_BAO_SHI,
					  LV_BAO_SHI,LV_BAO_SHI,LV_BAO_SHI,LV_BAO_SHI,
					}
	for i,v in ipairs(gemIndex) do
		local anim = createGemAni(v)
		self.showArea:addChild(anim)
		anim:setAnchorPoint(0.5, 0.5)
		anim:setPosition(self.gemPos[i])
	end
	self.ball = cc.Sprite:create('lianhuanduobao/res/img/dragonball.png')
	self.showArea:addChild(self.ball)
	self.ball:setAnchorPoint(0.5, 0.5)
	local ballpos = self.gemPos[0]
	ballpos.y=ballpos.y+32
	self.ball:setPosition(ballpos)
	self.ball:setVisible(false)
end

function DragonBall:onConfirmClicked( )
	AudioEngine.playEffect(SOUND_BT)
	if not self.bDone then
		return
	end
	self:removeFromParent()
end

function DragonBall:onLineSubBtnClicked( )
	AudioEngine.playEffect(SOUND_BT)
end


function DragonBall:onLineAddBtnClicked( )
	AudioEngine.playEffect(SOUND_BT)
end

function DragonBall:onDlineSubBtnClicked( )
	AudioEngine.playEffect(SOUND_BT)
end

function DragonBall:onDlineAddBtnClicked( )
	AudioEngine.playEffect(SOUND_BT)
end

function DragonBall:onTgBtnClicked( )
	AudioEngine.playEffect(SOUND_BT)
end

function DragonBall:onAwardBtnClick()
	print('onAwardBtnClick')
	PopUpView.showPopUpView(AwardView)
end


function DragonBall:onHelpClick()
	print('DragonBall.onHelpClick')

	PopUpView.showPopUpView(HelpView)
end

function DragonBall:setData( data )
	self.bDone = false
	self.bonusClo:setVisible(false)
	self.data = data
	self:refreshView()
	self:findPath()
	self:playAnimation()
end

function DragonBall:refreshView( )
	self.accumLb:setString(tostring(self.data.lCurrentTotal))
	self.linePointLb:setString(tostring(self.data.lBetPoint))
	self.lineLb:setString(tostring(self.data.lBetCount))
	self.totalPointLb:setString(tostring(self.data.lCardPoint-self.data.pDragonBall[self.data.cTarget]))
--	self.nowPointLb:setString(tostring(self.data.lNowPoint))
	self.nowPointLb:setString(tostring(0))
	for i = 1, 5 do
		self.rewardLbs[i]:setString(tostring(self.data.pDragonBall[i]))
	end
end

function DragonBall:findPath( )
	print('DragonBall.findPath')
	local addedIndex = {0, 1, 3, 6, 10}
	local pos = self.data.cTarget
	self.path = {}
	for i = 5, 1, -1 do
		-- print('DragonBall.findPath index', i)
		self.path[i] = pos + addedIndex[i]
		if pos == i then  -- 最右边
			pos = i - 1
		elseif pos > 1 then  -- 不在最左边
			local r = math.random()
			if r < 0.5 then  -- 有一半概率往左上走
				pos = pos - 1
			end
		end
	end
end

function DragonBall:playAnimation( )
	print('DragonBall.playAnimation')
	local actions = {}
	for i,v in ipairs(self.path) do
		local time = i > 1 and 0.5 or 0.3
		local ballpos=self.gemPos[v]
		ballpos.y=ballpos.y+32
		local moveAction = cc.JumpTo:create(time, self.gemPos[v], 90, 1)
		table.insert(actions, moveAction)
	end
	local function setDone( )
		self.bDone = true
		self.ball:setVisible(false)
		self.bonusClo:setVisible(true)
		self.bonusLb:setString(tostring(self.data.pDragonBall[self.data.cTarget]))

		self.startBtn:setVisible(true)
		self.exitBtn:setVisible(true)
		self.totalPointLb:setString(tostring(self.data.lCardPoint))
	end
	local callAction = cc.CallFunc:create(setDone)
	table.insert(actions, callAction)
	self.ball:setVisible(true)
	self.ball:runAction(cc.Sequence:create(actions))
end


function DragonBall:onVolumeClick( )
	PopUpView.showPopUpView(ui_setting_t)
end