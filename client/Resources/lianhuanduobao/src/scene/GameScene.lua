GameScene = class("GameScene", LayerBase)

local MAXCOUNT = 200
local ADDVALUE = 10
local MAXLINECOUNT = 5

local zuanWidth = 65 --钻头宽度
local zuanHeight = 68 --钻头高度

local ZHUANTUO_COUNT = 15
local LASTLEVEL = 3

function GameScene:ctor()
	GameScene.super.ctor(self)

	gamesvr.sendLoginGame()
	gamesvr.sendUserReady()

	
	GameScene.gold_ = global.g_mainPlayer:getPlayerScore()
	GameScene.score_ = 0
	local ratio = global.g_mainPlayer:getCurrentRoomBeilv()
	GameScene.score_ = math.floor(GameScene.gold_ * ratio)
	GameScene.gold_ = 0

	self.lBetPoint = ADDVALUE --每个钻的值
	self.lBetCount = 1  --多少个钻 倍数

	self.isTuoGuan = false
	self.gameing = false

	self.awardItems = {}
	self:initUIView()
	self:refreshZuanNode()
end

function GameScene:initUIView( )
	print('GameScene.initUIView')
	AudioEngine.playMusic(SOUND_BACK, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("lianhuanduobao/res/json/mainpanel.json")
	root:setClippingEnabled(true)
	self:addChild(root)
	self.confirmBtn = ccui.Helper:seekWidgetByName(root, "confirm")

	self.helpBtn = ccui.Helper:seekWidgetByName(root, "wenBtn")
	self.helpBtn:addTouchEventListener(makeClickHandler(self, self.onHelpClick))


	self.labaBtn = ccui.Helper:seekWidgetByName(root, "labaBtn")
	self.labaBtn:addTouchEventListener(makeClickHandler(self, self.onLabaBtnClick))

	self.volumeBtn = ccui.Helper:seekWidgetByName(root, "labaBtn")
	self.volumeBtn:addTouchEventListener(makeClickHandler(self, self.onVolumeClick))


	self.exitBtn = ccui.Helper:seekWidgetByName(root, "backBtn")
	self.exitBtn:addTouchEventListener(makeClickHandler(self, self.onExitClick))

	self.lineSubBtn = ccui.Helper:seekWidgetByName(root, "lineSubBtn")
	self.lineSubBtn:addTouchEventListener(makeClickHandler(self, self.onlineSubBtnClick))

	self.lineAddBtn = ccui.Helper:seekWidgetByName(root, "lineAddBtn")
	self.lineAddBtn:addTouchEventListener(makeClickHandler(self, self.onlineAddBtnClick))

	self.lineLb = ccui.Helper:seekWidgetByName(root, "lineLabel")

	self.dlineSubBtn = ccui.Helper:seekWidgetByName(root, "dlineSubBtn")
	self.dlineSubBtn:addTouchEventListener(makeClickHandler(self, self.ondlineSubBtnClick))

	self.dlineAddBtn = ccui.Helper:seekWidgetByName(root, "dlineAddBtn")
	self.dlineAddBtn:addTouchEventListener(makeClickHandler(self, self.ondlineAddBtnClick))

	self.dlineLb = ccui.Helper:seekWidgetByName(root, "dlineLabel")

	self.allPointLb = ccui.Helper:seekWidgetByName(root, "allCountLabel")
	self.nowPointLb = ccui.Helper:seekWidgetByName(root, "currCountLabel")
	self.accumLb = ccui.Helper:seekWidgetByName(root, "AtlasLabel_13")  -- 累积奖
	self.stageImg = ccui.Helper:seekWidgetByName(root, "guanqia")  -- 累积奖
	self.allPointLb:setString('')
	self.nowPointLb:setString('')
	self.accumLb:setString('')
	self.wallMap = {}
	for i=1,3 do
		self.wallMap[i] = {}
		local tag
		if i == 1 then
			tag = 'r_'
		elseif i == 2 then 
			tag = 'l_'
		elseif i == 3 then
			tag = 'b_'
		end
		for j=1,15 do
			self.wallMap[i][j] = ccui.Helper:seekWidgetByName(root, "Image_"..tag..j)
		end
	end
	--确定
	self.confirmBtn = ccui.Helper:seekWidgetByName(root, "confirmBtn")
	self.confirmBtn:addTouchEventListener(makeClickHandler(self, self.onconfirmBtnClick))

	--托管
	self.tgBtn = ccui.Helper:seekWidgetByName(root, "tgBtn")
	self.tgBtn:addTouchEventListener(makeClickHandler(self, self.ondtgBtnClick))

	--獎勵
	self.awardBtn = ccui.Helper:seekWidgetByName(root, "awardBtn")
	self.awardBtn:addTouchEventListener(makeClickHandler(self, self.onAwardBtnClick))

	--停止
	self.stopBtn = ccui.Helper:seekWidgetByName(root, "stopBtn")
	self.stopBtn:addTouchEventListener(makeClickHandler(self, self.onstopBtnClick))
	self.stopBtn:setVisible(false)

	self.awardPanel = ccui.Helper:seekWidgetByName(root, "awardPanel")

	self.contentPanel = ccui.Helper:seekWidgetByName(root, "contentPanel")

	self.currCenterCount = ccui.Helper:seekWidgetByName(root,"currCenterCount")
	self.currCenterCount:setVisible(false)
	
	self.zuanNodes = {}
	for i = 1,MAXLINECOUNT do
		local zuan = ccui.Helper:seekWidgetByName(root, string.format("zuan%d",i))

		local zuanValue = ccui.Helper:seekWidgetByName(zuan, "zuanValue")
		local icon = ccui.Helper:seekWidgetByName(zuan, "icon")

		local spriteFrame = cc.SpriteFrame:create("lianhuanduobao/res/img/flag.png", cc.rect(0,0, zuanWidth,zuanHeight))
		local nIcon = cc.Sprite:createWithSpriteFrame(spriteFrame)
		nIcon:setScale(0.7)
		icon:getParent():addChild(nIcon)
		nIcon:setAnchorPoint(cc.p(0, 0.5))
		nIcon:setPosition(cc.p(icon:getPositionX(),icon:getPositionY()))
		icon:getParent():removeChild(icon)

		table.insert(self.zuanNodes,{icon = nIcon,value = zuanValue})
	end

	-- 添加事件监听
    local function onKeyReleased(keyCode, event)
        if keyCode == cc.KeyCode.KEY_BACK then
          -- self:onExitClick()
        elseif keyCode == cc.KeyCode.KEY_MENU  then
					self:onstopBtnClick()
        end
    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )

    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.awardPanel)
end


function GameScene:getAwardItem(gemType,count)
	local awardItem = ccs.GUIReader:getInstance():widgetFromJsonFile("lianhuanduobao/res/json/awardItem.json")

	local gemSprite = getGemRes(gemType)

	local icon = ccui.Helper:seekWidgetByName(awardItem, "Panel_Icon")
	local count1 = ccui.Helper:seekWidgetByName(awardItem, "count1")
	local count2 = ccui.Helper:seekWidgetByName(awardItem, "count2")

	-- sprite:setAnchorPoint(cc.p())
	-- gemSprite:setPosition(cc.p(icon:getPositionX(),icon:getPositionY()))
	icon:addChild(gemSprite)
	-- icon:removeSelf()

	count1:setString(count)

	local index = gemType - (self.cStage - 1) * 5
	local getCount = GEM_POINTS[self.cStage][count][index]/10

	local aCount = getCount * self.lBetPoint * self.lBetCount
	count2:setString(aCount)
	return awardItem,aCount
end

-------------------------------------------------------------------------------------------------------------------
-- 广播事件处理 
-------------------------------------------------------------------------------------------------------------------

function GameScene:onStartEnterTransition()
	global.g_gameDispatcher:addMessageListener(GAME_LHDB_GAME_START, self, self.onGameData)
	global.g_gameDispatcher:addMessageListener(GAME_LHDB_GAME_NEXT, self, self.onGameData)
	global.g_gameDispatcher:addMessageListener(GAME_LHDB_GAME_BOMB, self, self.onBomb)
	global.g_gameDispatcher:addMessageListener(GAME_LHDB_GAME_NOBOMB, self, self.onNoBomb)

	global.g_gameDispatcher:addMessageListener(GAME_LHDB_GAME_EXIT, self, self.onExitCallback)
end

function GameScene:onStartExitTransition()
	global.g_gameDispatcher:removeMessageListener(GAME_LHDB_GAME_START, self)
	global.g_gameDispatcher:removeMessageListener(GAME_LHDB_GAME_NEXT, self)
	global.g_gameDispatcher:removeMessageListener(GAME_LHDB_GAME_BOMB, self)
	global.g_gameDispatcher:removeMessageListener(GAME_LHDB_GAME_NOBOMB, self)

	global.g_gameDispatcher:removeMessageListener(GAME_LHDB_GAME_EXIT, self)
end

function GameScene:onExitCallback(bSave)
	print('GameScene onExitCallback', bSave)
	exit_lianhuanduobao()
end

local awardH = 250
local maxItemCount = 3
function GameScene:onBomb( param )
	print("爆炸啦")
	--dump(param)
	if param.gemType == ZUAN_TOU then
		self:wallBomb()
		return
	end

	if #self.awardItems < maxItemCount then
		local item,count = self:getAwardItem(param.gemType,#param.gemIdxs)
		self.awardPanel:addChild(item)
		table.insert(self.awardItems,{item = item,count = count})

		local mY = awardH - (#self.awardItems ) * awardH/maxItemCount
		item:runAction(cc.MoveTo:create(0.3 * mY/(awardH * 2 / maxItemCount), cc.p(0, mY)))
	else

		local function educk()
			local item,count = self:getAwardItem(param.gemType,#param.gemIdxs)
			self.awardPanel:addChild(item)
			table.insert(self.awardItems,{item = item,count = count})
		end

		for i,v in pairs(self.awardItems) do
			local moveBy = cc.MoveBy:create(0.3/2, cc.p(0, awardH/maxItemCount))
			-- v:runAction(cc.MoveBy:create(0.3/2, cc.p(0, awardH/3)))

			if i == 1 then
		  		local CallFunc = cc.CallFunc:create(educk)
		  		local seq = cc.Sequence:create(moveBy,CallFunc)
		  		v.item:runAction(seq)
			else
		  		v.item:runAction(moveBy)
			end
		end
	end

end

function GameScene.clearState(self)
	self:onstopBtnClick()
	self:initWall(1,ZHUANTUO_COUNT)
	self.currCenterCount:setVisible(false)

	self.awardPanel:removeAllChildren()
	self.awardItems = {}

	self.lBetCount = 1
	self.lBetPoint = 10

	self:refreshZuanNode()

	self.nowPointLb:setString(0)
	self.gameing = false

	self.cStage = 1
	self:refreshStage()

end

function GameScene:onNoBomb(  )
	print("无法消除，游戏结束")
	self.nowPointLb:setString(tostring(self.lNowPoint))
	self.allPointLb:setString(tostring(self.lCardPoint))
	if self.cTarget >= 0 then
		local Point = self.lCardPoint-self.pDragonBall[self.cTarget+1]+self.lNowPoint		
		self.allPointLb:setString(tostring(Point))
		self.gameing = false
		local count = 0
		for i,v in pairs(self.awardItems) do
			count = v.count + count
		end

		self.currCenterCount:setVisible(true)
		self.currCenterCount:setString(tostring(count))

		local scheduler
		local schedulerid
		function runDragon()
			self.allPointLb:setString(tostring(self.lCardPoint))
			local dragonBall = DragonBall.new()
			self:addChild(dragonBall)

			local data = {}
			data.lCurrentTotal = self.lCurrentTotal
			data.lBetPoint = self.lBetPoint
			data.lBetCount = self.lBetCount
			data.lCardPoint = self.lCardPoint
			data.lNowPoint = self.lNowPoint
			data.pDragonBall = self.pDragonBall
			data.cTarget = self.cTarget + 1
			self.contentPanel:removeAllChildren()
			self:clearState()
			dragonBall:setData(data)
			scheduler:unscheduleScriptEntry(schedulerid)
		end
		scheduler=cc.Director:getInstance():getScheduler()
		schedulerid=scheduler:scheduleScriptFunc(runDragon, 1, false)
		-- local dragonBall = DragonBall.new()
		-- self:addChild(dragonBall)

		-- local data = {}
		-- data.lCurrentTotal = self.lCurrentTotal
		-- data.lBetPoint = self.lBetPoint
		-- data.lBetCount = self.lBetCount
		-- data.lCardPoint = self.lCardPoint
		-- data.lNowPoint = self.lNowPoint
		-- data.pDragonBall = self.pDragonBall
		-- data.cTarget = self.cTarget + 1
		-- dragonBall:setData(data)
	end

	-- if self.isTuoGuan then
		-- self.nowPointLb:setString(tostring(self.lNowPoint))
		-- self.allPointLb:setString(tostring(self.lCardPoint))
	-- end

	if self.cStage == LASTLEVEL and self.cBrickLeft == 0 then
		-- self.contentPanel:removeAllChildren()
		-- self:clearState()
		-- self.allPointLb:setString(tostring(self.lCardPoint))
		-- self.nowPointLb:setString(tostring(self.lNowPoint))
		--return
	else
		self.gameing = false
		
		
		
		if self.isTuoGuan then
			gamesvr.sendBet(self.lBetCount, self.lBetPoint)
		end

		local count = 0
		for i,v in pairs(self.awardItems) do
			count = v.count + count
		end

		self.currCenterCount:setVisible(true)
		self.currCenterCount:setString(tostring(count))
	end


	-- self.gameing = false
end

function GameScene.setPledgeCash(self)
	if tonumber(self.nowPointLb:getString()) - self.lBetPoint * self.lBetCount < 0 then
		self.nowPointLb:setString(0)
	else
		self.nowPointLb:setString(tonumber(self.nowPointLb:getString()) - self.lBetPoint * self.lBetCount)
	end

	if tonumber(self.allPointLb:getString()) - self.lBetPoint * self.lBetCount < 0 then
		self.allPointLb:setString(0)
	else
		self.allPointLb:setString(tonumber(self.allPointLb:getString()) - self.lBetPoint * self.lBetCount)
	end

end


function GameScene:initWall(stage, ileft)
	for i=1,3 do
		local list = self.wallMap[i]
		for j=1,15 do
			local wall = list[j]
			if i<stage then
				wall:setVisible(false)
			elseif i == stage then
				if j <= 15-ileft then
					wall:setVisible(false)
				else
					wall:setVisible(true)
				end
			elseif i > stage then
				wall:setVisible(true)
			end
		end
	end
	self.curState = stage
	self.nextWall = 15 - ileft + 1
end

function GameScene:wallBomb(  )
	local wm = self.wallMap[self.curState]
	if wm then
		local wall = wm[self.nextWall]
		wall:setVisible(false)
	end

	self.nextWall = self.nextWall + 1
	if self.nextWall > 15 then
		self.curState = self.curState + 1
		self.nextWall = 1
	end
end

-- 保存或者更新服务端下发数据
function GameScene:onGameData( param )
	self.awardPanel:removeAllChildren()

	self.currCenterCount:setVisible(false)
	self.awardItems = {}

	for k,v in pairs(param) do
		self[k] = v
	end
	self:refreshZuanNode()
	self:refreshPoints()
	self:refreshStage()
	if param.gameTable and #param.gameTable>0 then
		local function begin()
			node = performanceNode(param.gameTable,  STAGE_SIZE[param.cStage], GEM_WIDE, STAGE_SIZE[param.cStage])
			self.contentPanel:addChild(node)
			node:setTag(1)
			local sX = 96
			local posxs = {sX,sX-10,sX-64}
			node:setPosition(posxs[param.cStage],52)
		end

		local node = self.contentPanel:getChildByTag(1)
		if node then
			freeGemBoard(node, function()
			node:removeSelf()
			begin()
			end)	
		else
			begin()
		end

		if not self.isTuoGuan then
			self:setPledgeCash()
		end
		self.gameing = true
	else
		self.allPointLb:setString(tostring(self.lCardPoint))
		self.nowPointLb:setString(0)
		self:initWall(param.cStage, param.cBrickLeft)
	end
end

-- 保存或者更新服务端下发数据
function GameScene:onExitCallback( param )
	exit_lianhuanduobao()
end

-------------------------------------------------------------------------------------------------------------------

function GameScene:refreshZuanNode()
	for i = 1,MAXLINECOUNT do
		-- self.zuanNodes
		local icon = self.zuanNodes[i].icon
		local zuanValue = self.zuanNodes[i].value

		if i <= self.lBetCount then
			-- icon:setVisible(true)
			local spriteFrame = cc.SpriteFrame:create("lianhuanduobao/res/img/flag.png", cc.rect(0,0, zuanWidth,zuanHeight))
			local nIcon = cc.Sprite:createWithSpriteFrame(spriteFrame)
			icon:getParent():addChild(nIcon)
			nIcon:setAnchorPoint(cc.p(0, 0.5))
			nIcon:setPosition(cc.p(icon:getPositionX(),icon:getPositionY()))
			icon:getParent():removeChild(icon)

			-- self:replaceIcon(icon,i,1)
			self.zuanNodes[i].icon = nIcon
			nIcon:setScale(0.7)
			zuanValue:setVisible(true)
		else
			local spriteFrame = cc.SpriteFrame:create("lianhuanduobao/res/img/flag.png", cc.rect(zuanWidth,0, zuanWidth,zuanHeight))
			local nIcon = cc.Sprite:createWithSpriteFrame(spriteFrame)
			icon:getParent():addChild(nIcon)
			nIcon:setAnchorPoint(cc.p(0, 0.5))
			nIcon:setPosition(cc.p(icon:getPositionX(),icon:getPositionY()))
			icon:getParent():removeChild(icon)

			-- self:replaceIcon(icon,i,1)
			self.zuanNodes[i].icon = nIcon
			nIcon:setScale(0.7)
			-- icon:setVisible(false)
			zuanValue:setVisible(false)
		end

		zuanValue:setString(self.lBetPoint)
	end
	self.lineLb:setString(tostring(self.lBetCount))
	self.dlineLb:setString(tostring(self.lBetPoint))
end

-- 更新累积奖、总点数及当前点数
function GameScene:refreshPoints( )
	-- self.allPointLb:setString(tostring(self.lCardPoint))
	-- self.nowPointLb:setString(tostring(self.lNowPoint))
	self.accumLb:setString(tostring(self.lCurrentTotal))
end

function GameScene:refreshStage( )
	local icon = "lianhuanduobao/res/img/"..self.cStage.."level.png"
	self.stageImg:loadTexture(icon)
end

function GameScene:onconfirmBtnClick()
	print('onconfirmBtnClick')
	AudioEngine.playEffect(SOUND_BT)
	if not self.gameing then
		gamesvr.sendBet(self.lBetCount, self.lBetPoint)
		-- self.nowPointLb:setString(0)
		-- self.gameing = true
	end
end

function GameScene:ondtgBtnClick()
	print('ondtgBtnClick')
	self.isTuoGuan = true
	AudioEngine.playEffect(SOUND_BT)
	self.tgBtn:setVisible(false)
	self.stopBtn:setVisible(true)

	if not self.gameing then
		gamesvr.sendBet(self.lBetCount, self.lBetPoint)
		-- self.gameing = true
		-- self.nowPointLb:setString(0)
	end
end

function GameScene:onstopBtnClick()
	self.isTuoGuan = false
	AudioEngine.playEffect(SOUND_BT)
	self.tgBtn:setVisible(true)
	self.stopBtn:setVisible(false)
end

function GameScene:onlineSubBtnClick()
	print('onlineSubBtnClick')
	AudioEngine.playEffect(SOUND_BT)

	if self.isTuoGuan or self.gameing then
		return
	end

	if self.lBetCount <= 1 then
		self.lBetCount = MAXLINECOUNT
	else
		self.lBetCount = self.lBetCount - 1
	end
	self:refreshZuanNode()
end

function GameScene:onlineAddBtnClick()
	print('onlineAddBtnClick')
	AudioEngine.playEffect(SOUND_BT)

	if self.isTuoGuan or self.gameing  then
		return
	end

	if self.lBetCount >= MAXLINECOUNT then
		self.lBetCount = 1
	else
		self.lBetCount = self.lBetCount + 1
	end

	self:refreshZuanNode()

end

function GameScene:ondlineSubBtnClick()
	print('ondlineSubBtnClick')
	AudioEngine.playEffect(SOUND_BT)

	if self.isTuoGuan or self.gameing  then
		return
	end

	if self.lBetPoint <= 10 then
		self.lBetPoint = MAXCOUNT
	else
		self.lBetPoint = self.lBetPoint - ADDVALUE
	end

	self:refreshZuanNode()
end

function GameScene:ondlineAddBtnClick()
	print('ondlineAddBtnClick')
	AudioEngine.playEffect(SOUND_BT)

	if self.isTuoGuan or self.gameing  then
		return
	end

	if self.lBetPoint >= MAXCOUNT then
		self.lBetPoint = ADDVALUE
	else
		self.lBetPoint = self.lBetPoint + ADDVALUE
	end

	self:refreshZuanNode()

end

function GameScene:onExitClick()
	print('onExitClick')

	PopUpView.showPopUpView(ExitView)
end


function GameScene:onHelpClick()
	print('onHelpClick')

	PopUpView.showPopUpView(HelpView)
end

function GameScene:onLabaBtnClick()
	print('onHelpClick')
	PopUpView.showPopUpView(ui_setting_t)
end

function GameScene:onAwardBtnClick()
	print('onAwardBtnClick')
	PopUpView.showPopUpView(AwardView)
end

function GameScene:onVolumeClick( )
	PopUpView.showPopUpView(ui_setting_t)
	-- local dragonBall = DragonBall.new()
	-- self:addChild(dragonBall)

	-- local data = {}
	-- data.lCurrentTotal = self.lCurrentTotal
	-- data.lBetPoint = self.lBetPoint
	-- data.lBetCount = self.lBetCount
	-- data.lCardPoint = self.lCardPoint
	-- data.lNowPoint = self.lNowPoint
	-- data.pDragonBall = self.pDragonBall
	-- data.cTarget = self.cTarget
	-- -- Test Data
	-- data.pDragonBall = {12960, 11880, 10800, 9720, 8640}
	-- data.cTarget = 2
	-- dragonBall:setData(data)
end