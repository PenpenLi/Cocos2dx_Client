HallScene = class("HallScene", LayerBase)

local fileUtils = cc.FileUtils:getInstance()

local H_GAP = 280
local SCALE_GAP = 1

local XIU_XIAN_CHANG = 0
local BU_YU_CHANG = 1
local JING_JI_CHANG = 2

local BTN_BACK_RES = "fullmain/res/hall/btn_back.png"
local BTN_EXIT_RES = "fullmain/res/hall/btn_tuichu.png"

local responseEmail = false
local responseMessage = false

HALL_SWITCH_CODE = {
	SWITCH_NORMAL = 1, --普通界面
	SWITCH_MATCH = 2, --比赛界面
}

function HallScene:loadPlist()
	local frameCache = cc.SpriteFrameCache:getInstance()
	frameCache:addSpriteFrames("fullmain/res/hall/hallLight.plist")
end

function HallScene:ctor()
	self.keypadHanlder_ = {
		[6] = self.keyboardBackClicked,
	}
	HallScene.super.ctor(self)

	self.show_type = 0 --显示的是游戏类型

	self.frameTextures = {}

	self:loadPlist()
	local pathJson = getLayoutJson("fullmain/res/json/ui_main_hall.json")
	local root = ccs.GUIReader:getInstance():widgetFromJsonFile(pathJson)
	root:setClippingEnabled(true)
	self:addChild(root)

	local btnShop = ccui.Helper:seekWidgetByName(root, "Button_45")
	btnShop:setPressedActionEnabled(true)
	btnShop:addTouchEventListener(makeClickHandler(self, self.onShopHandler))

	local btnChat = ccui.Helper:seekWidgetByName(root, "Button_Chat")
	btnChat:setPressedActionEnabled(true)
	btnChat:addTouchEventListener(makeClickHandler(self, self.onChatHandler))

  local sizeChat = btnChat:getContentSize()
  self.customerHeddot = cc.Sprite:create("fullmain/res/privateMessage/tips_1.png")
  local chatAction = createWithFileName("fullmain/res/privateMessage/tips_", 0.05, 99999999)
  self.customerHeddot:runAction(chatAction)
  self.customerHeddot:setPosition(cc.p(sizeChat.width - 20, sizeChat.height - 10))
  btnChat:addChild(self.customerHeddot)
  self.customerHeddot:setVisible(false)

	local btnRecharge = ccui.Helper:seekWidgetByName(root, "Button_44")
	btnRecharge:setOpacity(0)
	btnRecharge:addTouchEventListener(makeClickHandler(self, self.onRechargeHandler))
	local sp = cc.Sprite:create("fullmain/res/hall/btn_chongzhi/btn_chongzhi_1.png")
	local action, frameTextures = createWithFrameFileName("fullmain/res/hall/btn_chongzhi/btn_chongzhi_", 0.05, 10000000000)
	sp:runAction(action)
	local sizeRecharge = btnRecharge:getContentSize()
	sp:setPosition(cc.p(sizeRecharge.width / 2, sizeRecharge.height / 2))
	btnRecharge:addChild(sp)
	self:addFrameTexture(frameTextures)

	local btnBank = ccui.Helper:seekWidgetByName(root, "Button_43")
	btnBank:setPressedActionEnabled(true)
	btnBank:addTouchEventListener(makeClickHandler(self, self.onBankHandler))

	local btnLockMachine = ccui.Helper:seekWidgetByName(root, "Button_46")
	btnLockMachine:setPressedActionEnabled(true)
	btnLockMachine:addTouchEventListener(makeClickHandler(self, self.onLockMachineHandler))

	self.btnAuction_ = ccui.Helper:seekWidgetByName(root, "Button_Auction")
	self.btnAuction_:setPressedActionEnabled(true)
	self.btnAuction_:addTouchEventListener(makeClickHandler(self, self.onAuctionHandler))
	self.btnAuction_:setOpacity(0)
	local sp = cc.Sprite:create("fullmain/res/auction/btnAuction/PMH_1.png")
	local action, frameTextures = createAnimateWithPathFormat(1, "fullmain/res/auction/btnAuction/PMH_%d.png", 0.05, 1)
	sp:runAction(cc.RepeatForever:create(cc.Sequence:create(action, cc.DelayTime:create(2))))
	local size = self.btnAuction_:getContentSize()
	sp:setPosition(cc.p(size.width / 2, size.height / 2))
	self.btnAuction_:addChild(sp)
	self:addFrameTexture(frameTextures)

	self.btnEmail_ = ccui.Helper:seekWidgetByName(root, "Button_47")
	-- self.btnEmail_:setPressedActionEnabled(true)
	-- self.btnEmail_:addTouchEventListener(makeClickHandler(self, self.onEmailHandler))
	-- self.btnEmail_.redPoint = ccui.Helper:seekWidgetByName(self.btnEmail_, "Image_RedPoint")
	-- self.btnEmail_.redPoint.labelCount = ccui.Helper:seekWidgetByName(self.btnEmail_.redPoint, "Label_Count")
	-- self.btnEmail_.redPoint.labelCount:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	-- self.btnEmail_:setCascadeColorEnabled(true)
	-- self.btnEmail_.redPoint:setCascadeColorEnabled(true)

	self.btnDaySign_ = ccui.Helper:seekWidgetByName(root, "Button_26")
	self.btnDaySign_:setPressedActionEnabled(true)
	self.btnDaySign_:addTouchEventListener(makeClickHandler(self, self.onDaySignHandler))

	self.animateDaySign_ = cc.Sprite:create("fullmain/res/hall/btn_jiangli/btn_jiangli_1.png")
	local action, frameTextures = createWithFrameFileName("fullmain/res/hall/btn_jiangli/btn_jiangli_", 0.05, 10000000000)
	self.animateDaySign_:runAction(action)
	local size = self.btnDaySign_:getContentSize()
	self.animateDaySign_:setPosition(cc.p(size.width / 2 + 5, size.height / 2 + 55))
	self.btnDaySign_:addChild(self.animateDaySign_)
	self:addFrameTexture(frameTextures)
	self.animateDaySign_:setVisible(false)

	-- --公告按钮
	local noticebtn = ccui.Helper:seekWidgetByName(root,"noticebtn")
	noticebtn:setPressedActionEnabled(true)
	noticebtn:addTouchEventListener(makeClickHandler(self, self.NoTFun))

	local btnMusic = ccui.Helper:seekWidgetByName(root,"Button_5")
	btnMusic:setPressedActionEnabled(true)
	btnMusic:addTouchEventListener(makeClickHandler(self, self.onMusic))

	local btnWechat = ccui.Helper:seekWidgetByName(root, "Button_27")
	btnWechat:setPressedActionEnabled(true)
	btnWechat:addTouchEventListener(makeClickHandler(self, self.onWechat))
	-- btnWechat:setVisible(cc.PLATFORM_OS_WINDOWS ~= PLATFROM and not global.g_mainPlayer:isLogin3rdBind())
	btnWechat:setVisible(false)

	self.btnScan_ = ccui.Helper:seekWidgetByName(root, "Button_22")
	self.btnScan_:setPressedActionEnabled(true)
	self.btnScan_:addTouchEventListener(makeClickHandler(self, self.onScan))
	self.btnScan_:setVisible(cc.PLATFORM_OS_WINDOWS ~= PLATFROM)

	self.btnLogout_ = ccui.Helper:seekWidgetByName(root, "Button_Logout")
	self.btnLogout_:setPressedActionEnabled(true)
	self.btnLogout_:addTouchEventListener(makeClickHandler(self, self.onLogoutAppHandler))

	if global.g_mainPlayer:isAppLogin() then
		self.btnScan_:setVisible(false)
		self.btnLogout_:setVisible(cc.PLATFORM_OS_WINDOWS ~= PLATFROM)
	else
		self.btnLogout_:setVisible(false)
		self.btnScan_:setVisible(cc.PLATFORM_OS_WINDOWS ~= PLATFROM)
	end
	self.btnScan_:setVisible(false)

	self.btnExit = ccui.Helper:seekWidgetByName(root, "Button_10")
	self.btnExit:setPressedActionEnabled(true)
	self.btnExit:addTouchEventListener(makeClickHandler(self, self.onExitHandler))

	local btnSXFen = ccui.Helper:seekWidgetByName(root,"Button_8")
	btnSXFen:setPressedActionEnabled(true)
	btnSXFen:addTouchEventListener(makeClickHandler(self, self.onShangXiaFen))

	local btnRefresh = ccui.Helper:seekWidgetByName(root, "Button_Refresh")
	btnRefresh:setPressedActionEnabled(true)
	btnRefresh:addTouchEventListener(makeClickHandler(self, self.onRefresh))
	btnRefresh:setVisible(true)

	local Button_privateMessage = ccui.Helper:seekWidgetByName(root, "Button_privateMessage")
	Button_privateMessage:setPressedActionEnabled(true)
	Button_privateMessage:addTouchEventListener(makeClickHandler(self, self.onPrivateMessag))
	local size_Button_privateMessage = Button_privateMessage:getContentSize()
	self.imgSign = cc.Sprite:create("fullmain/res/privateMessage/tips_1.png")
	local imgSignAction = createWithFileName("fullmain/res/privateMessage/tips_", 0.05, 99999999)
	self.imgSign:runAction(imgSignAction)
	self.imgSign:setPosition(cc.p(size_Button_privateMessage.width - 20, size_Button_privateMessage.height - 10))
	Button_privateMessage:addChild(self.imgSign)
	self:displaySign(false)

	self.btnMatch_ = ccui.Helper:seekWidgetByName(root, "Button_1")
	self.btnMatch_:setPressedActionEnabled(true)
	self.btnMatch_:addTouchEventListener(makeClickHandler(self, self.onMatch))

	self.matchFlash_ = ccui.Helper:seekWidgetByName(root, "Image_66")
	self.btnMatch_.flash_ = false

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

	self.leftbtn = leftbtn
	self.rightbtn = rightbtn

	--金币文本
	self.goodtext_ = ccui.Helper:seekWidgetByName(root,"goodtext")
	self.goodtext_:setString(global.g_mainPlayer:getPlayerScore())
	self.goodtext_:enableOutline(cc.c4b(0, 0, 0, 255), 1)

	local btnHead = ccui.Helper:seekWidgetByName(root, "Image_Frame")
	btnHead:addTouchEventListener(makeClickHandler(self, self.onHead))

	local playerId = global.g_mainPlayer:getPlayerId()
	local playerLevel = global.g_mainPlayer:getPlayerLevel()
	local panelHead = ccui.Helper:seekWidgetByName(root, "Panel_Head")
	local nodeHead = HeadSmallView.new(playerId, playerLevel)
	panelHead:addChild(nodeHead)

	self.flashSprite_ = cc.Sprite:create()
	local action = createWithFileName("fullmain/res/hall/headFlash/headFlash_", 0.1, 9999999)
	self.flashSprite_:runAction(cc.RepeatForever:create(action))
	panelHead:addChild(self.flashSprite_)
	self.flashSprite_:setScale(0.6)
	self.flashSprite_:setVisible(false)

	local labelId = ccui.Helper:seekWidgetByName(root, "Label_Id")
	labelId:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	labelId:setString(global.g_mainPlayer:getGameId())

	self.panelLoad_ = ccui.Helper:seekWidgetByName(root, "Panel_Load")

	--取消下载
	local btnCancel = ccui.Helper:seekWidgetByName(root,"Button_6")
	btnCancel:setPressedActionEnabled(true)
	btnCancel:addTouchEventListener(makeClickHandler(self, self.onCancelDownload))

	self.labelProgress_ = ccui.Helper:seekWidgetByName(root, "Label_54")
	self.labelProgress_:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	self.labelProgress_:setString("0%")
	self.progressBar_ = ccui.Helper:seekWidgetByName(root,"ProgressBar_52")
	self.progressBg_ = ccui.Helper:seekWidgetByName(root,"Image_51")
	self.progressLight_ = ccui.Helper:seekWidgetByName(root, "Image_53")
	self.maxWidth_ = self.progressBar_:getContentSize().width
	self.startX_ = self.progressLight_:getPositionX()-10

	self.panel_type = ccui.Helper:seekWidgetByName(root, "Panel_37")
	self.panel_list = ccui.Helper:seekWidgetByName(root, "Panel_14")
	self.gamePanel_ = ccui.Helper:seekWidgetByName(root, "Panel_Game")

	self.jingJiChang = ccui.Helper:seekWidgetByName(self.panel_type, "Image_38")
	self.jingJiChang:addTouchEventListener(makeClickHandler(self, self.onjingJiChang))
	self.jingJiChang:setOpacity(0)
	local sp3 = cc.Sprite:create("fullmain/res/hall/btn_jingjichang/btn_jingjichang_1.png")
	local action, frameTextures = createWithFrameFileName("fullmain/res/hall/btn_jingjichang/btn_jingjichang_", 0.05, 10000000000)
	sp3:runAction(action)
	local size = self.jingJiChang:getContentSize()
	sp3:setPosition(cc.p(size.width / 2, size.height / 2))
	self.jingJiChang:addChild(sp3)
	self:addFrameTexture(frameTextures)

	self.buYuChang = ccui.Helper:seekWidgetByName(self.panel_type, "Image_39")
	self.buYuChang:addTouchEventListener(makeClickHandler(self, self.onbuYuChang))
	self.buYuChang:setOpacity(0)
	local sp4 = cc.Sprite:create("fullmain/res/hall/btn_buyuchang/btn_buyuchang_1.png")
	local action, frameTextures = createWithFrameFileName("fullmain/res/hall/btn_buyuchang/btn_buyuchang_", 0.05, 10000000000)
	sp4:runAction(action)
	local size = self.buYuChang:getContentSize()
	sp4:setPosition(cc.p(size.width / 2, size.height / 2))
	self.buYuChang:addChild(sp4)
	self:addFrameTexture(frameTextures)

	self.xiuXianChang = ccui.Helper:seekWidgetByName(self.panel_type, "Image_40")
	self.xiuXianChang:addTouchEventListener(makeClickHandler(self, self.onxiuXianChang))
	self.xiuXianChang:setOpacity(0)
	local sp5 = cc.Sprite:create("fullmain/res/hall/btn_xiuxianchang/btn_xiuxianchang_1.png")
	local action, frameTextures = createWithFrameFileName("fullmain/res/hall/btn_xiuxianchang/btn_xiuxianchang_", 0.05, 10000000000)
	sp5:runAction(action)
	local size = self.xiuXianChang:getContentSize()
	sp5:setPosition(cc.p(size.width / 2, size.height / 2))
	self.xiuXianChang:addChild(sp5)
	self:addFrameTexture(frameTextures)

	local notice = ccui.Helper:seekWidgetByName(root, "Label_39") 
	self:showNotice(notice) 

	self.wkf_tips = ccui.Helper:seekWidgetByName(root, "Image_wkf") 

	self:setProgressVisible(false)

	local panelRank = ccui.Helper:seekWidgetByName(root, "Panel_Rank")

	self.rankFull_ = RankView.new()
	self.rankFull_:setVisible(false)
	self.rankFull_:setPosition(cc.p(-545, 0))
	panelRank:addChild(self.rankFull_)

	self.switchCode_ = HALL_SWITCH_CODE.SWITCH_NORMAL

	self.panelMatch_ = ccui.Helper:seekWidgetByName(root, "Panel_Match")
	self.panelMatch_:setVisible(false)

	self.nodeRanks_ = {}
	for i = 1, 10 do
		local itemRank = ccui.Helper:seekWidgetByName(self.panelMatch_, "Image_Rank" .. i)
		itemRank.labelName = ccui.Helper:seekWidgetByName(itemRank, "Label_Name")
		itemRank.labelName:enableOutline(cc.c4b(0, 0, 0, 255), 1)
		itemRank.labelName:setTextColor(cc.c4b(231, 211, 141, 255))

		if i > 3 then
			itemRank:enableOutline(cc.c4b(0, 0, 0, 255), 1)
			itemRank:setTextColor(cc.c4b(180, 139, 83, 255))
		end

		self.nodeRanks_[i] = itemRank
	end

	self.btnMatchJoin_ = ccui.Helper:seekWidgetByName(self.panelMatch_, "Button_Join")
	self.btnMatchJoin_:setPressedActionEnabled(true)
	self.btnMatchJoin_:addTouchEventListener(makeClickHandler(self, self.onMatchJoin))

	self.labelMatchCountDown_ = ccui.Helper:seekWidgetByName(self.panelMatch_, "Label_Time")
	self.labelMatchCountDown_:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	self.labelMatchCountDown_:setTextColor(cc.c4b(255, 228, 178, 255))

	self.labelMatchName_ = ccui.Helper:seekWidgetByName(self.panelMatch_, "Label_MatchName")
	self.labelMatchName_:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	self.labelMatchName_:setTextColor(cc.c4b(255, 255, 0, 255))

	self.labelMatchTimeStart_ = ccui.Helper:seekWidgetByName(self.panelMatch_, "Label_TimeStart")
	self.labelMatchTimeStart_:enableOutline(cc.c4b(0, 0, 0, 255), 1)

	self.labelMatchTimeEnd_ = ccui.Helper:seekWidgetByName(self.panelMatch_, "Label_TimeEnd")
	self.labelMatchTimeEnd_:enableOutline(cc.c4b(0, 0, 0, 255), 1)

	self.labelMatchPrize_ = ccui.Helper:seekWidgetByName(self.panelMatch_, "Label_MatchPrize")
	self.labelMatchPrize_:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	self.labelMatchPrize_:setTextColor(cc.c4b(255, 255, 0, 255))

	local gameId = global.g_mainPlayer:getCurrentGameId()
	if not gameId and gameId ~= -1 then
		self:initGameType()
	else
		--查找当前gameid的列表 
		local _type = nil
		for _,v in pairs(games_config) do
			if v.id == gameId then
				_type = v.style
			end
		end
		self:initGameList(_type)
	end

	self:initMusic()
end

function HallScene:onMatchJoin()
	local matchId = global.g_mainPlayer:getNeedMatch()
	local rd = global.g_mainPlayer:getRoomData(matchId)
	self:startMatchModule(rd.kindId)
end

function HallScene:checkMatch2Join()
	local matchId = global.g_mainPlayer:getNeedMatch()
	local nowTime = os.time()
	local matchData = global.g_mainPlayer:getMatchData(matchId)
	local timeStart = matchData.startTime.timestamp
	local timeEnd = matchData.endTime.timestamp

	if nowTime > timeStart and nowTime < timeEnd then
		PopUpView.showPopUpView(EnterMatchView, {serverId = matchId, cycle = MATCH_ROOM_CYCLE.ENTER_GAME})
	end
end

-- function startGetUnreadUpdate(self)
-- 	self.getUnreadFlag = true 
-- 	function update(dt)
-- 		if self.getUnreadFlag then
-- 			self:getUnreadState()
-- 		end 
-- 	end 
-- 	self.unreadUpdateHandle = cc.Director:getInstance():getScheduler():scheduleScriptFunc(update, 30, false)
-- end 

-- function stopGetUnreadUpdate(self)
-- 	if self.unreadUpdateHandle then
-- 		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.unreadUpdateHandle)
-- 		self.unreadUpdateHandle = nil
-- 	end 
-- end

function HallScene:getUnreadState()
	local playerId = global.g_mainPlayer:getPlayerId() 
	local url = string.format(privateMessageUserUrl, playerId)
	MultipleDownloader:createDataDownLoad(
		{
			identifier = "PrivateMessageUnread",
			fileUrl = url,
			onDataTaskSuccess = function(dataTask, params)
				local tab = json.decode(params)
				for i = 1, #tab.data do
					if tab.data[i].MeStatus == "2" then -- 2表示未读状态 
						self.countUnread_ = self.countUnread_ + 1
					end
				end

				if self.countUnread_ > 0 then
					self:displaySign(true)
				end
			end,
			onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
				if self.countUnread_ > 0 then
					self:displaySign(true)
				end
			end,
		}
	)
end

function HallScene:displaySign(isVisible)
    self.imgSign:setVisible(isVisible)
end

function HallScene:onPrivateMessag()
    PopUpView.showPopUpView(ui_main_private_message)
    self:displaySign(false)
    -- self.getUnreadFlag = false
end 

function HallScene:onExitPrivateMessaGE()
    -- self.getUnreadFlag = true
end  

function HallScene:checkEmail()
	local actionEmail = cc.Sequence:create(
			{
				cc.DelayTime:create(2),
				cc.CallFunc:create(handler(self, self.requestEmail)),
			}
		)
	self.btnEmail_:runAction(actionEmail)
end

function HallScene:checkRebate()
	self.checkRebate_ = true
	gatesvr.sendInsureInfoQuery(true)
end

function HallScene:check3rdFace()
	if global.g_mainPlayer:isLogin3rdAvailable() then
		local data = global.g_mainPlayer:getLoginData3rd()
		local faceUrl = data.icon
		global.g_mainPlayer:cacheHead3rd(global.g_mainPlayer:getPlayerId(), faceUrl)
		gatesvr.sendSetWxFace(faceUrl)
	end
end

function HallScene:onCustomerHandler()
	-- WarnTips.showTips(
	-- 	{
	-- 		text = "功能暂未开放",
	-- 		style = WarnTips.STYLE_Y,
	-- 	}
	-- )
	require_ex ("fullmain.src.ui.hall.customerService.ui_customer_service_t")
	PopUpView.showPopUpView(ui_customer_service_t)
end

function HallScene:addFrameTexture(frames)
	for k, v in ipairs(frames) do
		self.frameTextures[#self.frameTextures + 1] = v
	end
end

function HallScene:cutline(msg)
	local result=msg:split("\n")
	local result1=""
	for i=1,#result do
		result1=result1..result[i]
	end
	return result1
end

function HallScene:showNotice(lbl)
	lbl:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	lbl:setString("")
	local notice = global.g_noticeData.notice 
	lbl:setPosition(cc.p(0, 24))
	if notice and #notice > 0 then
		local msg = self:cutline(notice[1].content)
		msg = string.gsub(msg, "\n", "")
		msg = string.gsub(msg, "\r", "")

		lbl:setString(msg)
		local arr_action = {}
		arr_action[#arr_action + 1] = cc.DelayTime:create(2)
		arr_action[#arr_action + 1] = cc.CallFunc:create(function() 
		end)
		arr_action[#arr_action + 1] = cc.MoveTo:create(
				(lbl:getContentSize().width + 800) / 80,
				cc.p(-lbl:getContentSize().width, 24))
		arr_action[#arr_action + 1] = cc.DelayTime:create(0.5)
		arr_action[#arr_action + 1] = cc.CallFunc:create(function() 
			lbl:setPosition(cc.p(800, 24))
		end)
		lbl:runAction(cc.RepeatForever:create(cc.Sequence:create(arr_action)))
	end
end

function HallScene:initGameType()
	self.show_type = 0
	self.panel_list:setVisible(false)
	self.nodeGames_ = {}
	self.gamePanel_:removeAllChildren()
	self.panel_type:setVisible(true)
	self.btnExit:loadTextures(BTN_EXIT_RES, BTN_EXIT_RES, BTN_EXIT_RES)
	self.leftbtn:setVisible(false)
	self.rightbtn:setVisible(false)
end

function HallScene:onjingJiChang()
	-- self:initGameList(JING_JI_CHANG)

	self:requestMatchRank()
end

function HallScene:requestMatchRank()
	LoadingView.showTips()

	gatesvr.sendRequestMatchRank()
end

function HallScene:onbuYuChang()
	self:initGameList(BU_YU_CHANG)
end

function HallScene:onxiuXianChang()
	self:initGameList(XIU_XIAN_CHANG)
end

function HallScene:check4Hall()
	local scheduleId
	local function onComplete()
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduleId)

		--获取排行榜
		self.rankFull_:setVisible(true)

		self:startTickMatch()
		self:checkNotice()
		self:checkRebate()
		self:check3rdFace()
		self:checkEmail()
		self:checkAppLogin()
		self:checkDeviceLogin()
		gatesvr.sendChatInfo()
		self:checkOpenAuction()
		self:checkDataBind()
		-- self:scheduleUpdateScoreStart()
		-- self:startGetUnreadUpdate()
	end
	scheduleId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onComplete, 0.1, false)
end

function HallScene:scheduleUpdateScoreStart()
	self:scheduleUpdateScoreStop()

	local function onComplete()
		gatesvr.sendInsureInfoQuery(true)
	end
	self.scheduleScore_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onComplete, 5, false)
end

function HallScene:scheduleUpdateScoreStop()
	if not self.scheduleScore_ then return end

	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleScore_)
	self.scheduleScore_ = nil
end

function HallScene:onExit()
	local textureCache = cc.Director:getInstance():getTextureCache()
	for i,v in ipairs(self.frameTextures) do
		textureCache:removeTextureForKey(v)
	end
end

function HallScene:initMusic()
	local musicVolume = global.g_mainPlayer:getMusicVolume()
	local effectVolume = global.g_mainPlayer:getEffectVolume()

	AudioEngine.playMusic("fullmain/res/music/background.mp3", true)

	AudioEngine.setMusicVolume(musicVolume)
	AudioEngine.setEffectsVolume(effectVolume)
end

function HallScene:checkSpreaderHead()
	local spreaderId = global.g_mainPlayer:getSpreaderId()
	if spreaderId == 0 or not global.g_mainPlayer:isBind3rdPay() then
		self.flashSprite_:setVisible(true)
	else
		self.flashSprite_:setVisible(false)
	end
end

function HallScene:checkSpreader()
	self:checkSpreaderHead()

	local spreaderId = global.g_mainPlayer:getSpreaderId()
	if (spreaderId == 0 or not global.g_mainPlayer:isBind3rdPay()) and global.g_mainPlayer:isNeedPopSpreader() then
		PopUpView.showPopUpView(ui_complete_spreader_t)
	end
end

function HallScene:checkNotice()
	if not HallScene.noticed then
		local scheduleId
		local function onNotice()
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduleId)

			PopUpView.showPopUpView(ui_notice_t)
			HallScene.noticed = true
		end
		scheduleId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onNotice, 0.1, false)
	end
end

function HallScene:checkOpenAuction()
	local isItem1Buyed = global.g_mainPlayer:isItem1Buyed()
	local score = global.g_mainPlayer:getPlayerScore()
	local isOpenAuction = global.g_mainPlayer:isOpenAuction()
	if not isItem1Buyed and score >= ITEM1_COST and not isOpenAuction then
		self.guideAuctionFinger_ = GuideFinger.new()
		self.guideAuctionFinger_:setPosition(cc.p(69, 47))
		self.btnAuction_:addChild(self.guideAuctionFinger_)
	end
end

function HallScene:checkDataBind()
	gatesvr.sendGetUserInfoNew()
end

function HallScene:keyboardBackClicked()
	--返回按钮
	if self.starting_ then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_9809a59127714f15"),
					style = WarnTips.STYLE_YN,
					confirm = function()
							if self.starting_ then
								self:cancelDownload()
							end
							self:keyboardHandleRelease()
						end,
					cancel = function()
							self:keyboardHandleRelease()
						end
				}
			)
	else
		local tipStr = ""
		local score = global.g_mainPlayer:getPlayerScore()
		local rebateTomorrow = global.g_mainPlayer:getRebateTomorrow()
		if score > 1000 then
			tipStr = LocalLanguage:getLanguageString("L_3efcff4dd0345d13")
		elseif rebateTomorrow > 0 then
			tipStr = LocalLanguage:getLanguageString("L_9394710bab6e8b34")
		else
			tipStr = LocalLanguage:getLanguageString("L_40fdbecf186e5e1d")
		end
		
		WarnTips.showTips(
				{
					text = tipStr,
					style = WarnTips.STYLE_YN,
					confirm = function()
							self:keyboardHandleRelease()
							os.exit()
						end,
					cancel = function()
							self:keyboardHandleRelease()
						end
				}
			)
	end
end

function HallScene:initHallLight(root)

	local bg = ccui.Helper:seekWidgetByName(root, "background")

	local spriteAni = cc.Sprite:create()
	spriteAni:setPosition(cc.p(640, 480))
	bg:addChild(spriteAni)

	local animation = cc.Animation:create()
	for i = 1, 18 do
		local frameName = string.format("hallLight%d.png", i)
    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
		animation:addSpriteFrame(frame)
	end
	animation:setDelayPerUnit(0.15)

	local action = cc.RepeatForever:create(cc.Animate:create(animation))
	spriteAni:runAction(action)
	spriteAni:setScale(4)
end

function HallScene:onHead()
	replaceScene(PersonalScene, TRANS_CONST.TRANS_SCALE)
end

function HallScene:startTickMatch()
	self:stopTickMatch()

	self.matchTick_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.onTickMatch), 1, false)
end

function HallScene:onTickMatch()
	local nowTime = os.time()
	local nowDate = os.date("*t")

	local ret = nil
	local hintServer = nil

	for k, v in pairs(global.g_mainPlayer.matchList_) do
		local startTime = os.time(
			{
				year = nowDate.year,
				month = nowDate.month,
				day = nowDate.day,
				hour = v.startTime.hour,
				min = v.startTime.minute,
				sec = v.startTime.second
			}
		)

		local endToday = os.time(
			{
				year = nowDate.year,
				month = nowDate.month,
				day = nowDate.day,
				hour = v.endTime.hour,
				min = v.endTime.minute,
				sec = v.endTime.second
			}
		)

		local endTime = os.time(
			{
				year = v.endTime.year,
				month = v.endTime.month,
				day = v.endTime.day,
				hour = v.endTime.hour,
				min = v.endTime.minute,
				sec = v.endTime.second
			}
		)

		local timeStart = startTime - 30 * 60
		local timeEnd = (endTime > endToday) and endToday or endTime

		if nowTime > timeStart and nowTime < timeEnd then
			ret = true
			
			break
		elseif nowTime > timeEnd then
			hintServer = k

			ret = false
		else
			ret = false
		end
	end

	if hintServer and global.g_mainPlayer:needMatchHinted(hintServer) then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_fa36ffde142787bb"),
					style = WarnTips.STYLE_Y
				}
			)

		global.g_mainPlayer:setMatchHinted(hintServer)
	end

	if ret then
		self:startFlashMatch()
	else
		self:stopFlashMatch()
	end
end

function HallScene:startFlashMatch()
	if self.btnMatch_.flash_ then return end

	self.btnMatch_.flash_ = true
	self.matchFlash_:setVisible(true)
	self.matchFlash_:runAction(cc.RepeatForever:create(cc.Blink:create(0.5,1)))
end

function HallScene:stopFlashMatch()
	if not self.btnMatch_.flash_ then return end

	self.btnMatch_.flash_ = false
	self.matchFlash_:stopAllActions()
	self.matchFlash_:setVisible(false)
end

function HallScene:stopTickMatch()
	if self.matchTick_ then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.matchTick_)
		self.matchTick_ = nil
	end
end

function HallScene:cancelDownload()
	MultipleDownloader:removeFileDownload(self.moduleDownload_)
	self:setProgressVisible(false)
	self.moduleDownload_ = nil
	self.starting_ = false
end

function HallScene:onCancelDownload()
	WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_9809a59127714f15"),
				style = WarnTips.STYLE_YN,
				confirm = function()
						if self.starting_ then
							self:cancelDownload()
						end
					end
			}
		)
end

function HallScene:setProgressVisible(bVal)
	self.panelLoad_:setVisible(bVal)
	self.progressBar_:setPercent(0)
	self.labelProgress_:setString("0%")
end

function HallScene:updateProgress(current, total)
	local rate = current / total
	local percent = math.floor(rate*100)
	self.progressBar_:setPercent(percent)
	self.labelProgress_:setString(percent .. "%")

	local nX = self.startX_ + rate * self.maxWidth_
	self.progressLight_:setPositionX(nX)
end

function HallScene:getPageIndexs(index)
	local maxIndex = #self.listGame_
	local indexL1 = index - 1
	local indexL2 = indexL1 - 1
	local indexL3 = indexL2 - 1

	if index == 1 then
		indexL1 = maxIndex
		indexL2 = indexL1 - 1
		indexL3 = indexL2 - 1
	end

	if indexL1 == 1 then
		indexL2 = maxIndex
		indexL3 = maxIndex - 1
	end

	if indexL3 == 0 then
		indexL3 = maxIndex
	end

	local indexR1 = index + 1
	local indexR2 = indexR1 + 1
	local indexR3 = indexR2 + 1

	if index == maxIndex then
		indexR1 = 1
		indexR2 = indexR1 + 1
		indexR3 = indexR2 + 1
	end

	if indexR1 == maxIndex then
		indexR2 = 1
		indexR3 = 2
	end

	if indexR3 > maxIndex then
		indexR3 = maxIndex
	end

	return 	{
						[-3] = indexL3,
						[-2] = indexL2,
						[-1] = indexL1,
						[0] = index,
						[1] = indexR1,
						[2] = indexR2,
						[3] = indexR3,
					}
end

function HallScene:initGameList(showType)
	self.show_type = 1
	self.btnExit:loadTextures(BTN_BACK_RES, BTN_BACK_RES, BTN_BACK_RES)
	self.panel_type:setVisible(false)
	self.panel_list:setVisible(true)
	

	self.listGame_ = {}
	self.nodeGames_ = {}
	self.gamePanel_:removeAllChildren()
	for _,v in pairs(games_config) do
		if v.style == showType then
			table.insert(self.listGame_, v.id)
		end
	end

	self.wkf_tips:setVisible(table.nums(self.listGame_) == 0)
	
	-- table.sort(self.listGame_, function(a, b)
	-- 		local cfgA = games_config[a]
	-- 		local cfgB = games_config[b]
	-- 		if cfgA.open > cfgB.open then
	-- 			return true
	-- 		elseif cfgA.open < cfgB.open then
	-- 			return false
	-- 		elseif cfgA.sort < cfgB.sort then
	-- 			return true
	-- 		else
	-- 			return false
	-- 		end
	-- 	end)

	local gameId = global.g_mainPlayer:getCurrentGameId()
	if not gameId or gameId==-1 then
		self.currentIndex_ = 1
	else
		self.currentIndex_ = table.indexof(self.listGame_, gameId)
	end

	if self.currentIndex_ == false then
		self.currentIndex_ = 1
	end

	self.leftbtn:setVisible(#self.listGame_ >= 4)
	self.rightbtn:setVisible(#self.listGame_ >= 4)
	if #self.listGame_ < 4 then
		local offsetX_t = {{0}, {-144, 144}, {-288, 0, 288}}
		for i = 1, #self.listGame_ do
			local gameId = self.listGame_[i]

			if gameId then
				--显示游戏
				local ds = math.pow(SCALE_GAP, math.abs(i))
				local item = ui_game_item_t.new(gameId)
				item:setScale(ds)
				item:setTag(i)
				local offset_x = offsetX_t[#self.listGame_]
				item:setPosition(cc.p(565 + offset_x[i], 180))
				self.gamePanel_:addChild(item, 5 - math.abs(i))

				table.insert(self.nodeGames_, item)
			end
		end
		
		return 
	end

	local pageIndexs = self:getPageIndexs(self.currentIndex_)
	for i = -2, 1 do
		local index = pageIndexs[i]
		local gameId = self.listGame_[index]

		if gameId then
			--显示游戏
			local ds = math.pow(SCALE_GAP, math.abs(i))
			local item = ui_game_item_t.new(gameId)
			item:setScale(ds)
			item:setTag(index)
			item:setPosition(cc.p((i + 2) * H_GAP + H_GAP / 2, 180))

			self.gamePanel_:addChild(item, 5 - math.abs(i))

			table.insert(self.nodeGames_, item)
		end
	end

	self:moveGameComplete()
end

function HallScene:moveGameComplete()
	for i = 1, #self.nodeGames_ do
		local nodeGame = self.nodeGames_[i]
		local tag = nodeGame:getTag()
		-- if tag == self.currentIndex_ then
		-- 	nodeGame:setActivity()
		-- else
		-- 	nodeGame:setIdle()
		-- end
		nodeGame:setIdle()
	end
end

function HallScene:getTouchGame(touchX, touchY)
	local np = self.gamePanel_:convertToNodeSpace(cc.p(touchX, touchY))
	if self.nodeGames_ then
		for i = 1, #self.nodeGames_ do
			local nodeGame = self.nodeGames_[i]
			local nodeRect = nodeGame:getTouchRect()

			if cc.rectContainsPoint(nodeRect, np) then
				return nodeGame:getTag()
			end
		end
	end
	
	return nil
end

function HallScene:touchBegan(_touchX, _touchY, _preTouchX, _preTouchY)
	if not self:isCanControl() then
		return false
	end

	self.touchIndex_ = self:getTouchGame(_touchX, _touchY)

	if not self.touchIndex_ then
		return false
	else
		self.touchX_, self.touchY_ = _touchX, _touchY
		self.isWaitDrag_ = true
		self.isDraging_ = false
		return true
	end
end

function HallScene:touchMoved(_touchX, _touchY, _preTouchX, _preTouchY)
	if self.isWaitDrag_ and (math.abs(_touchX - self.touchX_) > 15 or math.abs(_touchY - self.touchY_) > 15) then
		self.isWaitDrag_ = false
		self.isDraging_ = true
	end
end

function HallScene:touchEnded(_touchX, _touchY, _preTouchX, _preTouchY)
	if self.isWaitDrag_ then
		if self.touchIndex_ then
			--判断点击游戏
			local index = self:getTouchGame(_touchX, _touchY)
			if index == self.touchIndex_ then
				--进入游戏流程
				local gameId = self.listGame_[self.touchIndex_]
				local cfg = games_config[gameId]
				if cfg.open == 0 then
					return
				end
				self:startModule(gameId)
			end
		end
	elseif self.isDraging_ then
		if #self.listGame_ < 4 then return false end
		local deltaX = _touchX - self.touchX_
		local distance = math.abs(deltaX)
		if distance > 30 then
			--判断为滑动
			if deltaX > 0 then
				--向左滑动
				self:moveRight()
			else
				--向右滑动
				self:moveLeft()
			end
		end
	end
end

function HallScene:touchCancelled(_touchX, _touchY, _preTouchX, _preTouchY)
	self:touchEnded(_touchX, _touchY, _preTouchX, _preTouchY)
end

function HallScene:moveLeft()
	if not self:isCanControl() then
		return
	end

	self.moving_ = true
	local pageIndexs = self:getPageIndexs(self.currentIndex_)
	local index = pageIndexs[2]
	local dp = 2
	local gameId = self.listGame_[index]
	if gameId then
		local ds = math.pow(SCALE_GAP, math.abs(dp))
		local item = ui_game_item_t.new(gameId)
		item:setScale(ds)
		item:setTag(index)
		item:setPosition(cc.p((dp + 2) * H_GAP + H_GAP / 2, 180))
		self.gamePanel_:addChild(item, 5 - math.abs(dp))

		table.insert(self.nodeGames_, item)
	end

	self.currentIndex_ = pageIndexs[1]
	self:moveGameComplete()

	pageIndexs = self:getPageIndexs(self.currentIndex_)
	local function onComplete()
		local nodeGame = table.remove(self.nodeGames_, 1)
		nodeGame:close()
		self.moving_ = false
	end
	for i = 1, #self.nodeGames_ do
		local item = self.nodeGames_[i]
		local action = cc.Spawn:create(
				{	
					cc.MoveTo:create(0.1, cc.p(item:getPositionX() - H_GAP, 180)),
					cc.ScaleTo:create(0.1, item:getScale()),
				}
			)
		item:runAction(action)
	end

	self.nodeGames_[1]:runAction(cc.CallFunc:create(onComplete))
end

function HallScene:moveRight()
	if not self:isCanControl() then
		return
	end

	self.moving_ = true
	local pageIndexs = self:getPageIndexs(self.currentIndex_)
	local index = pageIndexs[-3]
	local dp = -3
	local gameId = self.listGame_[index]
	if gameId then
		local ds = math.pow(SCALE_GAP, math.abs(dp))
		local item = ui_game_item_t.new(gameId)
		item:setScale(ds)
		item:setTag(index)
		item:setPosition(cc.p(- H_GAP / 2, 180))
		item:setColor(COLOR_DIM)
		self.gamePanel_:addChild(item, 5 - math.abs(dp))

		table.insert(self.nodeGames_, 1, item)
	end

	self.currentIndex_ = pageIndexs[-1]
	self:moveGameComplete()

	local function onComplete()
		local nodeGame = table.remove(self.nodeGames_)
		nodeGame:close()
		self.moving_ = false
	end

	for i = 1, #self.nodeGames_ do
		local item = self.nodeGames_[i]
		local action = cc.Spawn:create(
				{
					cc.MoveTo:create(0.1, cc.p(item:getPositionX() + H_GAP, 180)),
					cc.ScaleTo:create(0.1, item:getScale()),
				}
			)
		if i == #self.nodeGames_ then
			action = cc.Sequence:create(
					{
						action,
						cc.CallFunc:create(onComplete)
					}
				)
		end
		item:runAction(action)
	end
end

function HallScene:isCanControl()
	return not (self.moving_ or self.starting_)
end

function HallScene:startModule(gameId)
	local cfg = games_config[gameId]
	if cfg.open == 0 then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_94ba7085b2060064"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end

	if self.starting_ then return end

	if global.g_mainPlayer:isAppLogin() then
		local ld = global.g_mainPlayer:getAppLoginData()
		WarnTips.showTips(
				{
					text = string.format(LocalLanguage:getLanguageString("L_fdf4005b4b352d80"), ld.serverName),
					style = WarnTips.STYLE_YN,
					confirm = function()
							if self.gameType_ == APP_GAME_TYPE_GATHER then
								gatesvr.sendAppStandUp()
							elseif self.gameType_ == APP_GAME_TYPE_ARCADE then
								gamesvr.sendAppUserStandUp(self.serverId_, self.tableId_, self.chairId_)
							end
							gatesvr.sendInsureInfoQuery(true)

							global.g_mainPlayer:cleanAppLogin()
							self.btnScan_:setVisible(cc.PLATFORM_OS_WINDOWS ~= PLATFROM)
							self.btnLogout_:setVisible(false)
						end
				}
			)
		return
	end

	global.g_game_ext_type = cfg.extType

	local moduleId = cfg.targetId or cfg.id
	local cfgMod = games_config[moduleId]

	self.starting_ = true

	local path = cfgMod.path

	if LocalConfig:getConfigUpdate() then
		local moduleKey = string.format("%sVersion", path)
		self.moduleDownload_ = moduleKey
		local moduleUrl = string.format("%s%s/%s.json", CHECK_URL, path, path)

        MultipleDownloader:createDataDownLoad(
            {
                identifier = self.moduleDownload_,
                fileUrl = moduleUrl,
                onDataTaskSuccess = function(dataTask, params)
                        local dataJson = json.decode(params)
                        local moduleVersion = LocalVersions:getModuleVersion(self.moduleDownload_)
                        if moduleVersion >= dataJson.version then
							self.starting_ = false
							self.moduleDownload_ = nil
							self:openRoomList(moduleId)
                        else
                            local keyStringLocal = tostring(moduleVersion)
                            local keyStringRemote = tostring(dataJson.version)
                            local dataUpdate = dataJson.updates[keyStringLocal] or dataJson.updates[keyStringRemote]

                            local packageUrl = string.format("%s%s/%s", CHECK_URL, path, dataUpdate.package)
                            local storagePath = string.format("%s%d_%s", device.writablePath, os.time(), dataUpdate.package)
                            self.moduleDownload_ = string.format("%s_%s", moduleKey, packageUrl)

                            MultipleDownloader:createFileDownLoad(
                                    {
                                        identifier = self.moduleDownload_,
                                        fileUrl = packageUrl,
                                        storagePath = storagePath,
                                        onFileTaskSuccess = function(dataTask)
                                                fileUtils:uncompressAsyn(dataTask.storagePath, device.writablePath, function(success)
                                                        self.starting_ = false
                                                        self.moduleDownload_ = nil
                                                        self:setProgressVisible(false)

                                                        if success then
                                                            LocalVersions:setModuleVersion(moduleKey, dataJson.version)
                                                            fileUtils:removeFile(dataTask.storagePath)

                                                            self:openRoomList(moduleId)
                                                        else
                                                        	self:startModule(moduleId)
                                                        end
                                                    end)
                                            end,
                                        onTaskProgress = function(dataTask, bytesReceived, totalBytesReceived, totalBytesExpected)
                                                self:updateProgress(totalBytesReceived, totalBytesExpected)
                                            end,
                                        onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
												self.moduleDownload_ = nil
												self.starting_ = false
                                                self:setProgressVisible(false)

                                                WarnTips.showTips(
                                                        {
                                                            text = errorMsg,
                                                            style = WarnTips.STYLE_Y,
                                                            confirm = function()
	                                                            	self:startModule(moduleId)
	                                                            end
                                                        }
                                                    )
                                            end,
                                    }
                                )

                            self:setProgressVisible(true)
                        end
                    end,
                onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
                		self.moduleDownload_ = nil
                		self.starting_ = false

						WarnTips.showTips(
								{
									text = LocalLanguage:getLanguageString("L_bd66abf4b12e5045"),
									style = WarnTips.STYLE_Y
								}
							)
                    end,
            }
        )
	else
		self.moduleDownload_ = nil
		self.starting_ = false

		self:openRoomList(moduleId)
	end
end

function HallScene:startMatchModule(gameId)
	local cfg = games_config[gameId]
	if cfg.open == 0 then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_94ba7085b2060064"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end

	if self.starting_ then return end

	global.g_game_ext_type = cfg.extType

	local moduleId = cfg.targetId or cfg.id
	local cfgMod = games_config[moduleId]

	self.starting_ = true

	local path = cfgMod.path

	if LocalConfig:getConfigUpdate() then
		local moduleKey = string.format("%sVersion", path)
		self.moduleDownload_ = moduleKey
		local moduleUrl = string.format("%s%s/%s.json", CHECK_URL, path, path)

        MultipleDownloader:createDataDownLoad(
            {
                identifier = self.moduleDownload_,
                fileUrl = moduleUrl,
                onDataTaskSuccess = function(dataTask, params)
                        local dataJson = json.decode(params)
                        local moduleVersion = LocalVersions:getModuleVersion(self.moduleDownload_)
                        if moduleVersion >= dataJson.version then
							self.starting_ = false
							self.moduleDownload_ = nil
							self:checkMatch2Join()
                        else
                            local keyStringLocal = tostring(moduleVersion)
                            local keyStringRemote = tostring(dataJson.version)
                            local dataUpdate = dataJson.updates[keyStringLocal] or dataJson.updates[keyStringRemote]

                            local packageUrl = string.format("%s%s/%s", CHECK_URL, path, dataUpdate.package)
                            local storagePath = string.format("%s%d_%s", device.writablePath, os.time(), dataUpdate.package)
                            self.moduleDownload_ = string.format("%s_%s", moduleKey, packageUrl)

                            MultipleDownloader:createFileDownLoad(
                                    {
                                        identifier = self.moduleDownload_,
                                        fileUrl = packageUrl,
                                        storagePath = storagePath,
                                        onFileTaskSuccess = function(dataTask)
                                                fileUtils:uncompressAsyn(dataTask.storagePath, device.writablePath, function(success)
                                                        self.starting_ = false
                                                        self.moduleDownload_ = nil
                                                        self:setProgressVisible(false)

                                                        if success then
                                                            LocalVersions:setModuleVersion(moduleKey, dataJson.version)
                                                            fileUtils:removeFile(dataTask.storagePath)

                                                            self:checkMatch2Join()
                                                        else
                                                        	self:startMatchModule(moduleId)
                                                        end
                                                    end)
                                            end,
                                        onTaskProgress = function(dataTask, bytesReceived, totalBytesReceived, totalBytesExpected)
                                                self:updateProgress(totalBytesReceived, totalBytesExpected)
                                            end,
                                        onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
												self.moduleDownload_ = nil
												self.starting_ = false
                                                self:setProgressVisible(false)

                                                WarnTips.showTips(
                                                        {
                                                            text = errorMsg,
                                                            style = WarnTips.STYLE_Y,
                                                            confirm = function()
		                                                            self:startMatchModule(moduleId)
	                                                            end
                                                        }
                                                    )
                                            end,
                                    }
                                )

                            self:setProgressVisible(true)
                        end
                    end,
                onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
                		self.moduleDownload_ = nil
                		self.starting_ = false

						WarnTips.showTips(
								{
									text = LocalLanguage:getLanguageString("L_bd66abf4b12e5045"),
									style = WarnTips.STYLE_Y
								}
							)
                    end,
            }
        )
	else
		self.moduleDownload_ = nil
		self.starting_ = false

		self:checkMatch2Join()
	end
end

function HallScene:openRoomList(gameId)
	netmng.gsClose()

	local scheduleId
	local function onComplete()
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduleId)

		netmng.setGsNetAddress(GATE_SERV_IP, GATE_SERV_PORT)

		-- if global.g_mainPlayer:isLogin3rdAvailable() then
		-- 	local data = global.g_mainPlayer:getLoginData3rd()
		-- 	local location = global.g_mainPlayer:getLocationCity()
		-- 	gamesvr.sendLoginOtherPlatform(0, gameId, data.userid, data.name, data.name, "", location)
		-- else
		-- 	gamesvr.sendLoginForRoomList(gameId)
		-- end
		gamesvr.sendLoginForRoomList(gameId)
	end
	scheduleId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onComplete, 0.5, false)

	LoadingView.showTips()
end

function HallScene:requestEmail()
	local time = os.time()
	local playerId = global.g_mainPlayer:getPlayerId()
	local str = string.format("keyD60807C36977BD71D4B9375D3DD73815userId%dtimestamp%d", playerId, time)
	local sign = string.upper(cc.utils:getDataMD5Hash(str))
	local url = string.format(mailUrl, playerId, time, 1, 100, 3, sign)

	MultipleDownloader:createDataDownLoad(
		{
			identifier = "Email",
			fileUrl = url,
			onDataTaskSuccess = function(dataTask, params)
				local luaTbl = json.decode(params)
				if luaTbl.code == 100 then
					self.countUnread_ = luaTbl.data.UnRead

					self:getUnreadState()
				end

				local actionEmail = cc.Sequence:create(
						{
							cc.DelayTime:create(30),
							cc.CallFunc:create(handler(self, self.requestEmail)),
						}
					)
				self.btnEmail_:runAction(actionEmail)
			end,
			onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
				local actionEmail = cc.Sequence:create(
						{
							cc.DelayTime:create(30),
							cc.CallFunc:create(handler(self, self.requestEmail)),
						}
					)
				self.btnEmail_:runAction(actionEmail)
			end,
		}
	)
end

function HallScene:NoTFun()
	PopUpView.showPopUpView(ui_notice_t)
end

function HallScene:onMusic(sender, eventType)
	PopUpView.showPopUpView(ui_setting_t)
end

function HallScene:onExitHandler()
	self.waitHandler_ = true

	if self.switchCode_ == HALL_SWITCH_CODE.SWITCH_MATCH then
		self.switchCode_ = HALL_SWITCH_CODE.SWITCH_NORMAL
		self.rankFull_:setVisible(true)
		self.panelMatch_:setVisible(false)
		self:stopMatchCountDown()
	elseif self.show_type == 0 then
		local tipStr = ""
		local score = global.g_mainPlayer:getPlayerScore()
		local rebateTomorrow = global.g_mainPlayer:getRebateTomorrow()
		if score > 1000 then
			tipStr = LocalLanguage:getLanguageString("L_3efcff4dd0345d13")
		elseif rebateTomorrow > 0 then
			tipStr = LocalLanguage:getLanguageString("L_9394710bab6e8b34")
		else
			tipStr = LocalLanguage:getLanguageString("L_40fdbecf186e5e1d")
		end

		WarnTips.showTips(
				{
					text = tipStr,
					style = WarnTips.STYLE_YN,
					confirm = function()
							self:keyboardHandleRelease()
							global.g_mainPlayer:setLoginData3rd(nil)
							
							-- local layer = createObj(login_scene_t)
							-- replaceScene(layer:getCCScene(),layer)
							replaceScene(LoginScene, TRANS_CONST.TRANS_SCALE)
						end,
					cancel = function()
							self:keyboardHandleRelease()
						end
				}
			)
	else
		if self.show_type == 1 then
			--返回按钮
			if self.starting_ then
				WarnTips.showTips(
						{
							text = LocalLanguage:getLanguageString("L_9809a59127714f15"),
							style = WarnTips.STYLE_YN,
							confirm = function()
									if self.starting_ then
										self:cancelDownload()
									end
									self:keyboardHandleRelease()
								end,
							cancel = function()
									self:keyboardHandleRelease()
								end
						}
					)
			else
				self:initGameType()
			end
		end
	end
end

function HallScene:onWechat()
	if global.g_is_wx_login then
		WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_f8d5ddf6355a2dfb"),
				style = WarnTips.STYLE_YN,
				confirm = function()
						if cc.PLATFORM_OS_ANDROID == PLATFROM then
							calljavaMethodV("wechatLogin", {})
						elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
							luaoc.callStaticMethod("AppController", "wechatLogin", {})
						end
					end,
			}
		)
	else
		WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_8774f67723e6fdea"),
				style = WarnTips.STYLE_Y
			}
		)
	end
end

function HallScene:onShangXiaFen()
	local spreaderId = global.g_mainPlayer:getSpreaderId()
	if spreaderId == 0 then
		PopUpView.showPopUpView(ui_complete_spreader_t,
			function()
					gatesvr.sendScoreGet()
				end)
	else
		gatesvr.sendScoreGet()
	end
end

function HallScene:onRefresh()
	gatesvr.sendInsureInfoQuery(true)
end

function HallScene:onMatch()
	self:startModule(0)
end

function HallScene:LefFun()
	self:moveRight()
end

function HallScene:RigFun()
	self:moveLeft()
end

function HallScene:onShopHandler()
	if self.starting_ then
		WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_9809a59127714f15"),
				style = WarnTips.STYLE_YN,
				confirm = function()
						if self.starting_ then
							self:cancelDownload()
						end
					end,
				cancel = function()
					end
			}
		)
		return 
	end

	-- local layer = createObj(ui_shop_t)
	-- replaceScene(layer:getCCScene(),layer)
	replaceScene(ShopScene, TRANS_CONST.TRANS_SCALE)
end

function HallScene:onShare()
	PopUpView.showPopUpView(ShareView, SHARE_CONST)
end

function HallScene:onChatHandler()
	require_ex ("fullmain.src.ui.hall.customerService.ui_customer_chat_t")
	PopUpView.showPopUpView(ui_customer_chat_t)
end

function HallScene:onRechargeHandler()
	if self.starting_ then
		WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_9809a59127714f15"),
				style = WarnTips.STYLE_YN,
				confirm = function()
						if self.starting_ then
							self:cancelDownload()
						end
					end,
				cancel = function()
					end
			}
		)
		return 
	end
	--if PLATFROM == cc.PLATFORM_OS_WINDOWS then
	--	cc.Application:getInstance():openURL(webPayUrl)
	--else
		-- local spreaderId = global.g_mainPlayer:getSpreaderId()
		-- if spreaderId == 0 then
		-- 	PopUpView.showPopUpView(ui_complete_spreader_t,
		-- 		function()
		-- 				local layer = createObj(ui_recharge_t)
		-- 				replaceScene(layer:getCCScene(),layer)
		-- 			end)
		-- else
			-- local layer = createObj(ui_recharge_t)
			-- replaceScene(layer:getCCScene(),layer)
			replaceScene(RechargeScene, TRANS_CONST.TRANS_SCALE)
		-- end
	--end
end

function HallScene:onBankHandler()
	if global.g_mainPlayer:isInsureEnabled() then
		--已开通
		PopUpView.showPopUpView(ui_bank_t, 0, 0)
	else
		--未开通,打开开通界面
		PopUpView.showPopUpView(ui_bank_openUp_t)
	end
end

function HallScene:onLockMachineHandler()
	PopUpView.showPopUpView(ui_lock_machine_t)
end

function HallScene:onAuctionHandler()
	local isItem1Buyed = global.g_mainPlayer:isItem1Buyed()
	local score = global.g_mainPlayer:getPlayerScore()
	local isOpenAuction = global.g_mainPlayer:isOpenAuction()
	if not isItem1Buyed and score >= ITEM1_COST and not isOpenAuction then
		self.guideAuctionFinger_:removeFromParent()
		global.g_mainPlayer:setOpenAuction(true)

		global.g_mainPlayer:pushGuide({GAME_GUIDES.GUIDE_AUCTION_WANT_PUTAWAY})
	end

	replaceScene(AuctionScene, TRANS_CONST.TRANS_SCALE)
end

function HallScene:onEmailHandler()
	PopUpView.showPopUpView(ui_email_t)
end

function HallScene:onScan()
	if cc.PLATFORM_OS_ANDROID == PLATFROM then
		calljavaMethodV("openLoginQRScan", {})
	elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
		luaoc.callStaticMethod("AppController", "openLoginQRScan", {})
	elseif cc.PLATFORM_OS_WINDOWS == PLATFROM then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_ce2731aae66da781"),
					style = WarnTips.STYLE_Y
				}
			)
	end
end

function HallScene:onLogoutAppHandler()
	if self.gameType_ == APP_GAME_TYPE_GATHER then
		gatesvr.sendAppStandUp()
	elseif self.gameType_ == APP_GAME_TYPE_ARCADE then
		gamesvr.sendAppUserStandUp(self.serverId_, self.tableId_, self.chairId_)
	end
	gatesvr.sendInsureInfoQuery(true)

	global.g_mainPlayer:cleanAppLogin()

	self.btnScan_:setVisible(true)
	self.btnLogout_:setVisible(false)
end

function HallScene:onDaySignHandler()
	PopUpView.showPopUpView(ui_daySign_t)
end

function HallScene:onEnterGameFailed()
	WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_a33855abf217266f"),
				style = WarnTips.STYLE_Y
			}
		)
end

function HallScene:onScoreOrderEmpty()
	PopUpView.showPopUpView(ui_applyShangXiaFen_t)
end

function HallScene:onScoreOrderExist(orderId, playerId, account, spreaderId, scoreType, score, msg, time)
	PopUpView.showPopUpView(ui_cancelShangXiaFen_t, orderId, playerId, account, spreaderId, scoreType, score, msg, time)
end

function HallScene:onHallScoreChange()
	self.goodtext_:setString(global.g_mainPlayer:getPlayerScore())

	if self.checkRebate_ then
		local rebateToday = global.g_mainPlayer:getRebateToday()
		if rebateToday > 0 then
			--签到按钮闪烁
			self.btnDaySign_:setOpacity(0)
			self.animateDaySign_:setVisible(true)
		else
			--签到按钮不闪烁
			self.btnDaySign_:setOpacity(255)
			self.animateDaySign_:setVisible(false)
		end

		self.checkRebate_ = nil
	end
end

function HallScene:onWechatSuccess()
	local wechat_data = global.g_mainPlayer:getWechatData()
	gatesvr.sendBindWechat(wechat_data.unionid)
end

function HallScene:onLoginQRScanSuccess(param)
	param = string.gsub(param, "%%2B", "+")
	param = string.gsub(param, "%%2F", "/")
	param = string.gsub(param, "%%3F", "?")
	param = string.gsub(param, "%%23", "#")
	param = string.gsub(param, "%%26", "&")
	param = string.gsub(param, "%%3D", "=")
	param = string.gsub(param, "%%3A", ":")

	local appUrl, rechargeUrl, gameUrl, hallIp, hallPort, serverId, tableId, chairId, coinRate, scoreRate, kindId, gameVer, hallVer, socketId, spreader = string.match(param, "(.+)&&(.+)&(.+)&(.+)&(.+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(.+)&&")

	if tonumber(serverId) == 888 and tonumber(kindId) == 888 then
		self:onVendingMachineQRScanSuccess(param)
	elseif tonumber(serverId) == 501 and tonumber(kindId) == 501 then
		self:onLoginDeviceQRScanSuccess(param)
	else
		self:onLoginGameQRScanSuccess(param)
	end
end

function HallScene:onVendingMachineQRScanSuccess(param)
	local appUrl, rechargeUrl, gameUrl, orderId, orderPrice, serverId, tableId, chairId, coinRate, scoreRate, kindId, gameVer, hallVer, socketId, machineName = string.match(param, "(.+)&&(.+)&(.+)&(.+)&(.+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(.+)&&")
	local content = string.format(LocalLanguage:getLanguageString("L_3371ac2373630249"), orderId, tonumber(orderPrice) * 100, global.g_mainPlayer:getInsureMoney())

	VendingTips.showTips(
			{
				text = content,
				style = VendingTips.STYLE_YN,
				confirm = function()
						local nowTime = os.time()
						local playerId = global.g_mainPlayer:getPlayerId()
						local str = string.format("userid=%d&timestamp=%d&key=HVQSJSL8MC265SQ3ZVV1S4Q9M9ECNADP", playerId, nowTime)
						local sign = string.upper(cc.utils:getDataMD5Hash(str))
						local url = string.format(vendingUrl, playerId, orderId, nowTime, sign)

						LoadingView.showTips()

						MultipleDownloader:createDataDownLoad(
								{
									identifier = "MachineQRScan",
									fileUrl = url,
									onDataTaskSuccess = function(dataTask, params)
											LoadingView.closeTips()

											local luaTbl = json.decode(params)
											WarnTips.showTips(
													{
														text = luaTbl.msg,
														style = WarnTips.STYLE_Y
													}
												)
											gatesvr.sendInsureInfoQuery(true)
										end,
									onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
											LoadingView.closeTips()

											WarnTips.showTips(
													{
														text = errorMsg,
														style = WarnTips.STYLE_Y
													}
												)
										end,
								}
							)
					end
			}
		)
end


function HallScene:onLoginGameQRScanSuccess(param)
	local appUrl, rechargeUrl, gameUrl, hallIp, hallPort, serverId, tableId, chairId, coinRate, scoreRate, kindId, gameVer, hallVer, socketId, spreader = string.match(param, "(.+)&&(.+)&(.+)&(.+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(.+)&&")

	if hallIp ~= GATE_SERV_IP then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_d83fce7fad1734dc"),
					style = WarnTips.STYLE_Y
				}
			)
	else
		LoadingView.showTips()

		self.gameVer_ = tonumber(gameVer)
		self.hallVer_ = tonumber(hallVer)
		self.serverId_ = tonumber(serverId)
		self.kindId_ = tonumber(kindId)
		self.tableId_ = tonumber(tableId)
		self.chairId_ = tonumber(chairId)

		local nSocketId = tonumber(socketId)
		if nSocketId == 0 then
			--街机中登录房间
			netmng.gsClose()

			self.gameType_ = APP_GAME_TYPE_ARCADE

			gatesvr.sendAppGetServer(self.serverId_)
		else
			--合集,发送APP坐下协议
			self.gameType_ = APP_GAME_TYPE_GATHER

			if global.g_mainPlayer:isLogin3rdAvailable() then
				local data = global.g_mainPlayer:getLoginData3rd()
				local location = global.g_mainPlayer:getLocationCity()

				gatesvr.sendAppSitdownWX(self.kindId_, self.hallVer_, nSocketId, data.userid, location)
			else
				gatesvr.sendAppSitdown(self.kindId_, self.hallVer_, nSocketId)
			end
		end
	end
end

function HallScene:onLoginDeviceQRScanSuccess(param)
	local appUrl, rechargeUrl, gameUrl, hallIp, hallPort, serverId, tableId, chairId, coinRate, scoreRate, kindId, gameVer, hallVer, socketId, spreader = string.match(param, "(.+)&&(.+)&(.+)&(.+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(%d+)&(.+)&&")

	if hallIp ~= GATE_SERV_IP then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_d83fce7fad1734dc"),
					style = WarnTips.STYLE_Y
				}
			)
	else
		global.g_mainPlayer:setDeviceLogin(tonumber(socketId), 0)
		gatesvr.sendCoinMBLogin()
	end
end

function HallScene:checkAppLogin()
	if not global.g_mainPlayer:isAppLogin() then
		return
	end

	local data = global.g_mainPlayer:getAppLoginData()
	if data.serverId == 0 then
		--合集中
		self.gameType_ = APP_GAME_TYPE_GATHER

		SwallowView.showSwallowView(ui_qr_login_t, self.gameType_, data.serverId, data.serverName, data.tableId, data.chairId)
		self.btnScan_:setVisible(false)
		self.btnLogout_:setVisible(cc.PLATFORM_OS_WINDOWS ~= PLATFROM)
	else
		--街机中登录房间
		LoadingView.showTips()

		netmng.gsClose()

		self.gameType_ = APP_GAME_TYPE_ARCADE

		self.gameVer_ = util:makeVersion(6, 7, 0, 1)
		self.hallVer_ = util:makeVersion(6, 7, 0, 1)
		self.serverId_ = data.serverId
		self.kindId_ = data.kindId
		self.tableId_ = data.tableId
		self.chairId_ = data.chairId

		gatesvr.sendAppGetServer(self.serverId_)
	end
end

function HallScene:onAppGetServerSuccess(param)
	netmng.setGsNetAddress(param.serverUrl, param.serverPort)

	gamesvr.sendAppLogin(self.hallVer_, self.gameVer_, self.kindId_, param.serverId, self.tableId_, self.chairId_)
end

function HallScene:onAppLoginSuccess(param)
	--登录成功
	global.g_mainPlayer:setAppLoginData(param.serverId, param.serverName, param.tableId, param.chairId, param.kindId)

	SwallowView.showSwallowView(ui_qr_login_t, self.gameType_, param.serverId, param.serverName, param.tableId, param.chairId)

	gamesvr.sendAppMsgToubi(param.serverId, param.tableId, param.chairId, 0)
	self.btnScan_:setVisible(false)
	self.btnLogout_:setVisible(cc.PLATFORM_OS_WINDOWS ~= PLATFROM)
end

function HallScene:onAppSitdownSuccess(serverName)
	--坐下成功
	global.g_mainPlayer:setAppLoginData(self.serverId_, serverName, self.tableId_, self.chairId_, self.kindId_)

	SwallowView.showSwallowView(ui_qr_login_t, self.gameType_, self.serverId_, serverName, self.tableId_, self.chairId_)
	self.btnScan_:setVisible(false)
	self.btnLogout_:setVisible(cc.PLATFORM_OS_WINDOWS ~= PLATFROM)
end

function HallScene:checkDeviceLogin()
	if not global.g_mainPlayer:isDeviceLogin() then
		return
	end

	PopUpView.showPopUpView(ui_mb_toubi_t)
end

function HallScene:onDeviceLoginSuccess()
	PopUpView.showPopUpView(ui_mb_toubi_t)
end

function HallScene:onCustomerHeddotUpdate(status)
	self.customerHeddot:setVisible(status)
end

function HallScene:onRequestUnreadEmail()
	self:requestEmail()
end

function HallScene:on3rdLoginSuccess()
	LoadingView.showTips()

	local data3rd = global.g_mainPlayer:getLoginData3rd()
	gatesvr.sendBindWechat(data3rd.userid)
end

function HallScene:on3rdBindSuccess()
	self:check3rdFace()
end

function HallScene:onCompleteSpreaderSuccess()
	self:checkSpreaderHead()
end

function HallScene:onCheckRebate()
	self:checkRebate()
end

function HallScene:onRequestMatchRankSuccess(params)
	WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_d9755146f6fef7b0"),
				style = WarnTips.STYLE_Y
			}
		)
	
	self.switchCode_ = HALL_SWITCH_CODE.SWITCH_MATCH
	self.rankFull_:setVisible(false)
	self.panelMatch_:setVisible(true)

	for i = 1, 10 do
		local itemRank = self.nodeRanks_[i]
		local dataRank = params[i]

		if dataRank then
			itemRank:setVisible(true)
			itemRank.labelName:setString(dataRank.playerId)
		else
			itemRank:setVisible(false)
		end
	end

	local matchId = global.g_mainPlayer:getNeedMatch()
	if matchId == nil then
		self.btnMatchJoin_:setVisible(false)
		self.labelMatchCountDown_:setString("00:00:00")
		self.labelMatchName_:setString(LocalLanguage:getLanguageString("L_8a6ef524b8883312"))
		self.labelMatchTimeStart_:setString(LocalLanguage:getLanguageString("L_8a6ef524b8883312"))
		self.labelMatchTimeEnd_:setString(LocalLanguage:getLanguageString("L_8a6ef524b8883312"))
		self.labelMatchPrize_:setString(LocalLanguage:getLanguageString("L_8a6ef524b8883312"))
	else
		local nowTime = os.time()
		local matchData = global.g_mainPlayer:getMatchData(matchId)
		local timeStart = matchData.startTime.timestamp
		local timeEnd = matchData.endTime.timestamp
		local dateStart = os.date("*t", timeStart)
		local dateEnd = os.date("*t", timeEnd)

		self.labelMatchName_:setString(matchData.matchName)
		self.labelMatchTimeStart_:setString(string.format("%02d:%02d:%02d", dateStart.hour, dateStart.min, dateStart.sec))
		self.labelMatchTimeEnd_:setString(string.format("%02d:%02d:%02d", dateEnd.hour, dateEnd.min, dateEnd.sec))
		self.labelMatchPrize_:setString(string.format(LocalLanguage:getLanguageString("L_4ac718f682170386"), matchData.rewardCount))
		if nowTime < timeStart then
			self.btnMatchJoin_:setVisible(false)

			local deltaTime = timeStart - nowTime
			self.labelMatchCountDown_:setString(formatTimeString(deltaTime))
			self:startMatchCountDown(matchId, deltaTime)
		elseif nowTime > timeStart and nowTime < timeEnd then
			self.btnMatchJoin_:setVisible(true)
			self.labelMatchCountDown_:setString(LocalLanguage:getLanguageString("L_f01dd5f21244e965"))
		else
			self.btnMatchJoin_:setVisible(false)
			self.labelMatchCountDown_:setString(LocalLanguage:getLanguageString("L_08f097d84dd97636"))
		end
	end
end

function HallScene:startMatchCountDown(matchId, remainTime)
	self:stopMatchCountDown()

	self.matchIdCountDown_ = matchId
	self.matchRemainTime_ = remainTime
	self.matchCountDownTick_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.onMatchCountDown), 1, false)
end

function HallScene:onMatchCountDown()
	if self.matchRemainTime_ < 1 then
		self:stopMatchCountDown()

		local nowTime = os.time()
		local matchData = global.g_mainPlayer:getMatchData(self.matchIdCountDown_)
		local timeStart = matchData.startTime.timestamp
		local timeEnd = matchData.endTime.timestamp
		if nowTime < timeStart then
			self.btnMatchJoin_:setVisible(false)

			local deltaTime = timeStart - nowTime
			self.labelMatchCountDown_:setString(formatTimeString(deltaTime))
			self:startMatchCountDown()
		elseif nowTime > timeStart and nowTime < timeEnd then
			self.btnMatchJoin_:setVisible(true)
			self.labelMatchCountDown_:setString(LocalLanguage:getLanguageString("L_f01dd5f21244e965"))
		else
			self.btnMatchJoin_:setVisible(false)
			self.labelMatchCountDown_:setString(LocalLanguage:getLanguageString("L_08f097d84dd97636"))
		end
	else
		self.matchRemainTime_ = self.matchRemainTime_ - 1
		self.labelMatchCountDown_:setString(formatTimeString(self.matchRemainTime_))
	end
end

function HallScene:stopMatchCountDown()
	if self.matchCountDownTick_ then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.matchCountDownTick_)
		self.matchIdCountDown_ = nil
		self.matchCountDownTick_ = nil
		self.matchRemainTime_ = nil
	end
end

function HallScene:onRequestDataBindSuccess()
	self:checkSpreader()
end

function HallScene:onStartEnterTransition()
	self:check4Hall()

	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAME_SERVER_CONNECT_FAILED, self, self.onEnterGameFailed)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_HALL_SCORE_CHANGE, self, self.onHallScoreChange)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_WECHAT_AUTHORIZATION, self, self.onWechatSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_LOGIN_QRCODE_SCAN_SUCCESS, self, self.onLoginQRScanSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_APP_GET_SEVER_SUCCESS, self, self.onAppGetServerSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_APP_LOGIN_SUCCESS, self, self.onAppLoginSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_APP_SITDOWN_SUCCESS, self, self.onAppSitdownSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_DEVICE_LOGIN, self, self.onDeviceLoginSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_CUSTOMER_HEDDOT_UPDATE, self, self.onCustomerHeddotUpdate)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_EMAIL_UNREAD_UPDATE, self, self.onRequestUnreadEmail)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_EXIT_PRIVATE_MESSAGE, self, self.onExitPrivateMessaGE)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_COMPLETE_SPREADER_SUCCESS, self, self.onCompleteSpreaderSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_CHECK_REBATE, self, self.onCheckRebate)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_REQUEST_MATCH_RANK, self, self.onRequestMatchRankSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GET_DATA_BIND_SUCCESS, self, self.onRequestDataBindSuccess)
end

function HallScene:onStartExitTransition()
	responseEmail = false
	responseMessage = false
	self.btnEmail_:stopAllActions()

	self:stopTickMatch()
	self:stopMatchCountDown()
	self:scheduleUpdateScoreStop()

	if self.moduleDownload_ then
		MultipleDownloader:removeFileDownload(self.moduleDownload_)
	end

	MultipleDownloader:removeFileDownload("PrivateMessageUnread")
	MultipleDownloader:removeFileDownload("Email")
	MultipleDownloader:removeFileDownload("MachineQRScan")

	-- self:stopGetUnreadUpdate()

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAME_SERVER_CONNECT_FAILED, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_HALL_SCORE_CHANGE, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_WECHAT_AUTHORIZATION, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_LOGIN_QRCODE_SCAN_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_APP_GET_SEVER_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_APP_LOGIN_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_APP_SITDOWN_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_DEVICE_LOGIN, self)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_CUSTOMER_HEDDOT_UPDATE, self)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_EMAIL_UNREAD_UPDATE, self)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_EXIT_PRIVATE_MESSAGE, self)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_COMPLETE_SPREADER_SUCCESS, self)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_CHECK_REBATE, self)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_REQUEST_MATCH_RANK, self)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GET_DATA_BIND_SUCCESS, self)
end