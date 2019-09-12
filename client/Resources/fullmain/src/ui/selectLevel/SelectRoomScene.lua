SelectRoomScene = class("SelectRoomScene", LayerBase)

function SelectRoomScene:ctor(gameId, ignoreSitDownOnce)
	self.keypadHanlder_ = {
	  [6] = self.keyboardBackClicked,
	}
	SelectRoomScene.super.ctor(self)

	self.gameId_ = gameId
	self.ignore_sitdown = ignoreSitDownOnce

	local pathJson = getLayoutJson("fullmain/res/json/selectLevel/vertical/ui_main_v_select_level.json")
	local root = ccs.GUIReader:getInstance():widgetFromJsonFile(pathJson)
	root:setClippingEnabled(true)
	self:addChild(root)

	local title = ccui.Helper:seekWidgetByName(root, "Image_3")
	title:loadTexture(string.format("fullmain/res/selectLevel/gameTitles/%d.png", self.gameId_))

	self.btnBack = ccui.Helper:seekWidgetByName(root, "Button_2")
	self.btnBack:setPressedActionEnabled(true)
	self.btnBack:addTouchEventListener(makeClickHandler(self, self.onBack))

	--金币文本
	self.goodtext_ = ccui.Helper:seekWidgetByName(root,"goodtext")
	self.goodtext_:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	self.goodtext_:setString(global.g_mainPlayer:getPlayerScore())

	--左按钮
	local leftbtn = ccui.Helper:seekWidgetByName(root,"leftbtn")
	leftbtn:addTouchEventListener(makeClickHandler(self, self.LefFun))

	local actionL = cc.RepeatForever:create(cc.Spawn:create(
				{
					cc.Sequence:create(
						{
							cc.TintBy:create(0.5, -80, -80, -80),
							cc.TintBy:create(0.5, 80, 80, 80),
						}
					),
					cc.Sequence:create(
						{
							cc.ScaleTo:create(0.5, 0.8),
							cc.ScaleTo:create(0.5, 1.2),
						}
					),
				}
			)
		)
	leftbtn:runAction(actionL)

	--右按钮
	local rightbtn = ccui.Helper:seekWidgetByName(root,"rightbtn")
	rightbtn:addTouchEventListener(makeClickHandler(self, self.RigFun))

	local actionR = cc.RepeatForever:create(cc.Spawn:create(
				{
					cc.Sequence:create(
						{
							cc.TintBy:create(0.5, -80, -80, -80),
							cc.TintBy:create(0.5, 80, 80, 80),
						}
					),
					cc.Sequence:create(
						{
							cc.ScaleTo:create(0.5, 0.8),
							cc.ScaleTo:create(0.5, 1.2),
						}
					),
				}
			)
		)
	rightbtn:runAction(actionR)

	-- --头像
	-- local hepo = ccui.Helper:seekWidgetByName(root,"hepo")

	-- local px, py = hepo:getPosition()
	-- local nodeClip = cc.ClippingNode:create(cc.Sprite:create("fullmain/res/login/head1.png"))
	-- nodeClip:setInverted(false)
	-- nodeClip:setAlphaThreshold(0.5)
	-- nodeClip:setPosition(cc.p(px, py))
	-- hepo:getParent():addChild(nodeClip, 2)

	-- local scale=1
	-- if global.g_mainPlayer:isLogin3rdAvailable() then
	-- 	local data = global.g_mainPlayer:getLoginData3rd()
	-- 	local faceUrl = data.icon
	-- 	global.g_mainPlayer:cacheHead3rd(global.g_mainPlayer:getPlayerId(), faceUrl)
	-- 	gatesvr.sendSetWxFace(faceUrl)
	-- end
	-- --local headPath, scale = getPlayerHeadPath()
	-- -- self.iconHead_ = cc.Sprite:create(headPath)
	-- self.iconHead_ = ui_head_t.new(global.g_mainPlayer:getPlayerId(), cc.size(92, 92), "fullmain/res/hall/maskHead.png", cc.rect(24, 24, 44, 44), cc.size(92, 92))
	-- self.iconHead_:setScale(scale)
	-- self.iconHead_:setPosition(cc.p(49, 49))
	-- hepo:addChild(self.iconHead_,10)

	local playerId = global.g_mainPlayer:getPlayerId()
	local playerLevel = global.g_mainPlayer:getPlayerLevel()
	local panelHead = ccui.Helper:seekWidgetByName(root, "Panel_Head")
	local nodeHead = HeadSmallView.new(playerId, playerLevel)
	panelHead:addChild(nodeHead)

	local labelId = ccui.Helper:seekWidgetByName(root, "Label_Id")
	labelId:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	labelId:setString(global.g_mainPlayer:getGameId())

	local rooms = global.g_mainPlayer:getRoomList()
	local roomListView = ccui.Helper:seekWidgetByName(root, "ListView_88")
	roomListView:addEventListener(handler(self, self.onListViewHandler))

	for i = 1, #rooms do
		local serverId = rooms[i]
		local item = ui_room_item_t.new(serverId)
		item.node_:setTag(serverId)
		roomListView:pushBackCustomItem(item.node_)
	end

	self.roomListView = roomListView

	self.curSelectedIndex = 0
end

-- function SelectRoomScene:onNodeEnterTransitionFinish()
-- 	local scheduleId
-- 	local function onComplete()
-- 		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduleId)

-- 		gatesvr.sendInsureInfoQuery(true)
-- 	end
-- 	scheduleId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onComplete, 0.1, false)
-- end

function SelectRoomScene:scheduleUpdateScoreStart()
	self:scheduleUpdateScoreStop()

	local function onComplete()
		gatesvr.sendInsureInfoQuery(true)
	end
	self.scheduleScore_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onComplete, 5, false)
end

function SelectRoomScene:scheduleUpdateScoreStop()
	if not self.scheduleScore_ then return end

	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleScore_)
	self.scheduleScore_ = nil
end

function SelectRoomScene:onListViewHandler(sender, eventType)
	if eventType == 1 then
		local index = sender:getCurSelectedIndex()
		local item = sender:getItem(index)
		local serverId = item:getTag()
		local rd = global.g_mainPlayer:getRoomData(serverId)
		local gameNum = nil
		local cfg = games_config[rd.kindId]
		if cfg.style == 1 then
			if rd.nodeId == 6 then
				gameNum = 6
			elseif rd.nodeId == 8 then
				gameNum = 8 
			end
			global.g_mainPlayer:setCurrentGameNum(gameNum or 4)
		end
		self:enterRoom(serverId)
	end
end

function SelectRoomScene:enterRoom(serverId)
	local rd = global.g_mainPlayer:getRoomData(serverId)
	local score = global.g_mainPlayer:getPlayerScore()
	if rd.enterScore > score then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_ea69a52c2203c9fa"),
					style = WarnTips.STYLE_YN,
					confirm = function()
							-- local layer = createObj(ui_recharge_t)
							-- replaceScene(layer:getCCScene(),layer)
							replaceScene(RechargeScene, TRANS_CONST.TRANS_SCALE)
						end
				}
			)
	else
		LoadingView.showTips()

		netmng.gsClose()

		global.g_mainPlayer:setCurrentRoom(serverId)

		local handlerId = nil
		handlerId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(handlerId)

				netmng.setGsNetAddress(rd.serverUrl, rd.serverPort)
				gamesvr.sendLoginRoom()
			end, 0.5, false)
	end
end

function SelectRoomScene:keyboardBackClicked()
	self:onBack()
	self:keyboardHandleRelease()
end

function SelectRoomScene:onBack()
	self.btnBack:setTouchEnabled(false)
	netmng.gsClose()

	-- local layer = createObj(hall_scene_t)
	-- replaceScene(layer:getCCScene(),layer)
	replaceScene(HallScene, TRANS_CONST.TRANS_SCALE)
end

function SelectRoomScene:onLoginRoomSuccess()
	LoadingView.showTips()
	
	local ownerId = global.g_mainPlayer:getPlayerId()
	local pd = global.g_mainPlayer:getRoomPlayer(ownerId)
	if pd.tableId>-1 and  pd.chairId>-1 then
			print("断线重连")
			self:startGame()
		else
			print("第一次启动")
			gamesvr.sendRequireSitdown(-1, -1, "")
	end
end

function SelectRoomScene:onEnterRoomFailed()
	WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_00e6204209e85303"),
				style = WarnTips.STYLE_Y
			}
		)
end

function SelectRoomScene:onHallScoreChange()
	self.goodtext_:setString(global.g_mainPlayer:getPlayerScore())
end

function SelectRoomScene:startGame()
	local handlerId = nil
	handlerId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
			self:_startGame()
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(handlerId)
		end, 0.05, false)
end

function SelectRoomScene:_startGame()
	LoadingView.closeTips()
	
	local gameId = global.g_mainPlayer:getCurrentGameId()
	local cfg = games_config[gameId]
	local funcName = string.format("start_%s", cfg.path)

	require_ex(string.format("%s.src.main", cfg.path))
	_G[funcName]()
end

function SelectRoomScene:ignoreSitDownOnce()
	self.ignore_sitdown = true
end

function SelectRoomScene:onRoomUserSitdown(playerId, tableId, chairId, status)
	print("玩家坐下")
	local ownerId = global.g_mainPlayer:getPlayerId()
	if ownerId == playerId then
		--玩家本人
		local gameId = global.g_mainPlayer:getCurrentGameId()
		if self.ignore_sitdown then
			self.ignore_sitdown = false
			return
		end
		if gameId == 123 or gameId == 219 or gameId == 133  or gameId == 220 or gameId == 508 or gameId == 500 or gameId == 502 then --水果世界、飞禽走兽 连环夺宝,att连环炮
			self:startGame()
		end
	else
		--其他玩家
	end
end

function SelectRoomScene:onRoomUserReady(playerId, tableId, chairId, status)
	print("玩家准备")
	local ownerId = global.g_mainPlayer:getPlayerId()
	if ownerId == playerId then
		--玩家本人
	else
		--其他玩家
	end
end

function SelectRoomScene:onRoomUserPlay(playerId, tableId, chairId, status)
	print("玩家游戏")
	local ownerId = global.g_mainPlayer:getPlayerId()
	if ownerId == playerId then
		--玩家本人
		self:startGame()
	else
		--其他玩家
	end
end

function SelectRoomScene:LefFun()
	if self.isScrolling then return end
	self.isScrolling = true
 	local inner = self.roomListView:getInnerContainer()
	local sizeScrollView = self.roomListView:getContentSize()
	local sizeContainer = self.roomListView:getInnerContainerSize()
	local pX = -inner:getPositionX()
	self.curSelectedIndex = math.abs(math.ceil(pX / 306))
	if self.curSelectedIndex == 0  then
		self.isScrolling = false
		return 
	end
	self.curSelectedIndex = self.curSelectedIndex - 1
	local action = cc.Sequence:create(
		cc.MoveTo:create(0.5, cc.p(-(self.curSelectedIndex * 306), inner:getPositionY())),
		cc.CallFunc:create(function() self.isScrolling = false end)
	)
	inner:runAction(action)
end

function SelectRoomScene:RigFun()
	if self.isScrolling then return end
	self.isScrolling = true
 	local inner = self.roomListView:getInnerContainer()
	local sizeScrollView = self.roomListView:getContentSize()
	local sizeContainer = self.roomListView:getInnerContainerSize()
	local pX = -inner:getPositionX()
	self.curSelectedIndex = math.abs(math.floor(pX / 306))
	if #self.roomListView:getItems() - self.curSelectedIndex <= 3 then
		self.isScrolling = false
		return 
	end
	self.curSelectedIndex = self.curSelectedIndex + 1
	local action = cc.Sequence:create(
		cc.MoveTo:create(0.5, cc.p(-(self.curSelectedIndex * 306), inner:getPositionY())),
		cc.CallFunc:create(function() self.isScrolling = false end)
	)
	inner:runAction(action)
end

function SelectRoomScene:onEndEnterTransition()
	gatesvr.sendInsureInfoQuery(true)
	-- self:scheduleUpdateScoreStart()
	
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAME_SERVER_CONNECT_FAILED, self, self.onEnterRoomFailed)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_LOGIN_ROOM, self, self.onLoginRoomSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_HALL_SCORE_CHANGE, self, self.onHallScoreChange)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_SITDOWN, self, self.onRoomUserSitdown)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_READY, self, self.onRoomUserReady)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_PLAY, self, self.onRoomUserPlay)
end

function SelectRoomScene:onStartExitTransition()
	self:scheduleUpdateScoreStop()

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAME_SERVER_CONNECT_FAILED, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_LOGIN_ROOM, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_HALL_SCORE_CHANGE, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_SITDOWN, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_READY, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_PLAY, self)
end
