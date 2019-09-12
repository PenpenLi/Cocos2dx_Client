GameScene = class("GameScene", LayerBase)

local winSize = cc.Director:getInstance():getWinSize()

local STATUS_IDLE   = 1
local STATUS_JETTON = 2
local STATUS_PLAY   = 3

local player_zhanji  = 0

local banker_name     = nil
local banker_zhanji   = 0
local banker_playtime = 0
local banker_score    = 0

local banker_limit_score = 0
local me_limit_score     = 0

local user_list       = {}
local bnaker_list     = {}

local record_msg      = {}              --存储输赢
local record_type     = {}              --存储自己有没有下注标识
local record_jetton   = {east = 0,south = 0,west = 0,north = 0}

function GameScene:ctor()

  self.keypadHanlder_ = {
      [6] = self.keyboardBackClicked,
  }
	GameScene.super.ctor(self)
	--获取房间类型
	local roomtype = global.g_mainPlayer:getRoomType(global.g_mainPlayer:getCurrentRoom())
	--获取金币数,赋值给全局变量GameScene.gold_
	GameScene.gold_    = global.g_mainPlayer:getPlayerScore()
	--玩家ID
	GameScene.playerId_= global.g_mainPlayer:getPlayerId()
	--玩家姓名
	GameScene.name_    = global.g_mainPlayer:getPlayerName()
	--玩家座位
	local pd = global.g_mainPlayer:getRoomPlayer(GameScene.playerId_)
	GameScene.chairId_ = pd.chairId
	--tableId
	GameScene.tableId_ = pd.tableId
	-- GameScene.gold_  = 200000000
	--初始化全局分数为0
	GameScene.score_ = math.modf(GameScene.gold_ * global.g_mainPlayer:getCurrentRoomBeilv())
	gamesvr.sendUpScore(GameScene.score_)
	-- GameScene.score_  = 20000000 
	self:loadBG()
end

function GameScene:keyboardBackClicked()
	-- global.g_mainPlayer:setPlayerScore(GameScene.gold_ + math.floor(GameScene.score_*global.g_mainPlayer:getCurrentRoomBeilv()))
	WarnTips.showTips(
			{
					-- text = localizable.exit_game_tips,
					-- confirm = exit_feiqinzoushou,
				text    = LocalLanguage:getLanguageString("L_f2d2ddd962dc86fb"),
				style   = WarnTips.STYLE_YN,
				confirm = function()
						self:keyboardHandleRelease()
						exit_bairenniuniu()
					end,
				cancel  = function()
						self:keyboardHandleRelease()
					end
			}
		)
end

--添加背景
function GameScene:loadBG()
	--导入游戏背景的cocoStudio项目ui_game.json
	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("bairenniuniu/res/json/ui_game.json")
	root:setClippingEnabled(true)
	self:addChild(root)
	--获取信息表的label,并进行声明,备用
	self.left_banker_name_    = ccui.Helper:seekWidgetByName(root,"left_banker_name")
	self.left_banker_result_  = ccui.Helper:seekWidgetByName(root,"left_banker_result")
	self.left_banker_num_     = ccui.Helper:seekWidgetByName(root,"left_banker_num")
	self.left_banker_score_   = ccui.Helper:seekWidgetByName(root,"left_banker_score")
	self.right_player_name_   = ccui.Helper:seekWidgetByName(root,"right_player_name")
	self.right_player_result_ = ccui.Helper:seekWidgetByName(root,"right_player_result")
	self.right_player_score_  = ccui.Helper:seekWidgetByName(root,"right_player_score")


	self.right_player_name_  :setString(GameScene.name_)
	self.right_player_result_:setString(player_zhanji)
	self.right_player_score_ :setString(GameScene.score_)


	--获取定时器的信息,并进行声明,备用
	self.time_back_  = ccui.Helper:seekWidgetByName(root,"time_back")
	self.time_label_ = ccui.Helper:seekWidgetByName(root,"time_label")
	self.kaipai_     = ccui.Helper:seekWidgetByName(root,"kaipai")
	self.kongxian_   = ccui.Helper:seekWidgetByName(root,"kongxian")
	self.xiazhu_     = ccui.Helper:seekWidgetByName(root,"xiazhu")
	self.kaipai_  :setVisible(false)
	self.kongxian_:setVisible(false)
	self.xiazhu_  :setVisible(false)

	--菜单按钮,投币,结算,设置，退出
	self.menu_root_     = ccui.Helper:seekWidgetByName(root,"Panel_menu")
	-- self.menu_toubi_    = ccui.Helper:seekWidgetByName(root,"btn_toubi")
	-- self.toubi_image_   = ccui.Helper:seekWidgetByName(root,"btn_bg1")
	-- self.menu_jiesuan_  = ccui.Helper:seekWidgetByName(root,"btn_jiesuan")
	-- self.jiesuan_image_ = ccui.Helper:seekWidgetByName(root,"btn_bg2")
	self.menu_set_      = ccui.Helper:seekWidgetByName(root,"btn_set")
	self.set_image_     = ccui.Helper:seekWidgetByName(root,"btn_bg3")
	self.menu_exit_     = ccui.Helper:seekWidgetByName(root,"btn_exit")
	self.exit_image_    = ccui.Helper:seekWidgetByName(root,"btn_bg4")
	self.btn_left_      = ccui.Helper:seekWidgetByName(root,"btn_left")
	self.down_fire_     = ccui.Helper:seekWidgetByName(root,"down_fire")
	self.up_fire_       = ccui.Helper:seekWidgetByName(root,"up_fire")

	self.btn_left_    :addTouchEventListener(makeClickHandler(self,self.onBtnLeftClick))
	-- self.menu_toubi_  :addTouchEventListener(handler(self,self.onBtnTouBi))
	-- self.menu_jiesuan_:addTouchEventListener(handler(self,self.onBtnJieSuan))
	self.menu_set_    :addTouchEventListener(handler(self,self.onBtnSet))
	self.menu_exit_   :addTouchEventListener(handler(self,self.onBtnExit))
	self.down_fire_:setVisible(false)
	self.up_fire_  :setVisible(false)
	-- self.menu_root:setVisible(false)

	--获取东,南,西,北
	self.bg_east_     = ccui.Helper:seekWidgetByName(root,"bg_east")
	self.bg_south_    = ccui.Helper:seekWidgetByName(root,"bg_south")
	self.bg_west_     = ccui.Helper:seekWidgetByName(root,"bg_west")
	self.bg_north_    = ccui.Helper:seekWidgetByName(root,"bg_north")
	--将要用到,点击东南西北下注。
	self.bg_east_ :addTouchEventListener(makeClickHandler(self, self.onEastJetton))
	self.bg_south_:addTouchEventListener(makeClickHandler(self, self.onSouthJetton))
	self.bg_west_ :addTouchEventListener(makeClickHandler(self, self.onWestJetton))
	self.bg_north_:addTouchEventListener(makeClickHandler(self, self.onNorthJetton))

	--东南西北是否获胜标志
	self.east_win_    = ccui.Helper:seekWidgetByName(root,"east_win")
	self.south_win_   = ccui.Helper:seekWidgetByName(root,"south_win")
	self.west_win_    = ccui.Helper:seekWidgetByName(root,"west_win")
	self.north_win_   = ccui.Helper:seekWidgetByName(root,"north_win")
	self.east_win_ :setVisible(false)
	self.south_win_:setVisible(false)
	self.west_win_ :setVisible(false)
	self.north_win_:setVisible(false)

	--牛几显示标记
	self.banker_niu_   = ccui.Helper:seekWidgetByName(root,"banker_niu")
	self.east_niu_     = ccui.Helper:seekWidgetByName(root,"east_niu")
	self.south_niu_    = ccui.Helper:seekWidgetByName(root,"south_niu")
	self.west_niu_     = ccui.Helper:seekWidgetByName(root,"west_niu")
	self.north_niu_    = ccui.Helper:seekWidgetByName(root,"north_niu")
	self.banker_niu_:setVisible(false)
	self.east_niu_  :setVisible(false)
	self.south_niu_ :setVisible(false)
	self.west_niu_  :setVisible(false)
	self.north_niu_ :setVisible(false)

	--下注的几个图标
	self.jetton_root_  = ccui.Helper:seekWidgetByName(root,"Panel_Jetton")
	self.btn_jetton1_  = ccui.Helper:seekWidgetByName(root,"btn_jetton1")
	self.btn_jetton1_0 = ccui.Helper:seekWidgetByName(root,"btn_jetton1_0")
	self.btn_jetton2_  = ccui.Helper:seekWidgetByName(root,"btn_jetton2")
	self.btn_jetton2_0 = ccui.Helper:seekWidgetByName(root,"btn_jetton2_0")
	self.btn_jetton3_  = ccui.Helper:seekWidgetByName(root,"btn_jetton3")
	self.btn_jetton3_0 = ccui.Helper:seekWidgetByName(root,"btn_jetton3_0")
	self.btn_jetton4_  = ccui.Helper:seekWidgetByName(root,"btn_jetton4")
	self.btn_jetton4_0 = ccui.Helper:seekWidgetByName(root,"btn_jetton4_0")
	self.btn_jetton5_  = ccui.Helper:seekWidgetByName(root,"btn_jetton5")
	self.btn_jetton5_0 = ccui.Helper:seekWidgetByName(root,"btn_jetton5_0")
	self.btn_jetton6_  = ccui.Helper:seekWidgetByName(root,"btn_jetton6")
	self.btn_jetton6_0 = ccui.Helper:seekWidgetByName(root,"btn_jetton6_0")
	self.btn_jetton7_  = ccui.Helper:seekWidgetByName(root,"btn_jetton7")
	self.btn_jetton7_0 = ccui.Helper:seekWidgetByName(root,"btn_jetton7_0")

	self.btn_jetton1_:setSelected(true)
	self.jetton_root_:setVisible(false)
	self.btn_jetton1_:addEventListener(handler(self,self.onBtnJettonHandler))
	self.btn_jetton2_:addEventListener(handler(self,self.onBtnJettonHandler))
	self.btn_jetton3_:addEventListener(handler(self,self.onBtnJettonHandler))
	self.btn_jetton4_:addEventListener(handler(self,self.onBtnJettonHandler))
	self.btn_jetton5_:addEventListener(handler(self,self.onBtnJettonHandler))
	self.btn_jetton6_:addEventListener(handler(self,self.onBtnJettonHandler))
	self.btn_jetton7_:addEventListener(handler(self,self.onBtnJettonHandler))

	-- self.area1_lab_ = cc.LabelTTF:create("Hello World", "Arial", 30)
	-- self.bg_east_   :addChild(self.area1_lab_,2,100)
	-- self.area1_lab_ :setPosition(cc.p(self.bg_east_:getContentSize().width/2,self.bg_east_:getContentSize().height/2))
	--下注倍数默认值
	self.jetton_ratio_  = 100
	--选中复选框,默认选项
	self.selectedJettonBox_  = self.btn_jetton1_
	-- self:refreshCurrentScore()
	-- self.btn_jetton10:setBright(false)
	-- self.btn_jetton10:setEnabled(false)
	self.count_num_1_  = ccui.Helper:seekWidgetByName(root,"count_num_1")
	self.count_num_2_  = ccui.Helper:seekWidgetByName(root,"count_num_2")
	self.count_num_3_  = ccui.Helper:seekWidgetByName(root,"count_num_3")
	self.count_num_4_  = ccui.Helper:seekWidgetByName(root,"count_num_4")
	self.myjetton_num_1_ = ccui.Helper:seekWidgetByName(root,"myjetton_num_1")
	self.myjetton_num_2_ = ccui.Helper:seekWidgetByName(root,"myjetton_num_2")
	self.myjetton_num_3_ = ccui.Helper:seekWidgetByName(root,"myjetton_num_3")
	self.myjetton_num_4_ = ccui.Helper:seekWidgetByName(root,"myjetton_num_4")
	self.count_text_1_ = 0
	self.count_text_2_ = 0
	self.count_text_3_ = 0
	self.count_text_4_ = 0
	self.myjetton_text_1_ = 0
	self.myjetton_text_2_ = 0
	self.myjetton_text_3_ = 0
	self.myjetton_text_4_ = 0
	self.text_countscore_ = 0               --区域总下注
	self.myjetton_countscore_ = 0			--玩家总下注

	--信息板
	self.winmsg_root_  = ccs.GUIReader:getInstance():widgetFromJsonFile("bairenniuniu/res/json/ui_winmsg.json")
	self.myscore_lab_  = ccui.Helper:seekWidgetByName(self.winmsg_root_ ,"myscore_lab")
	self.myreturn_lab_ = ccui.Helper:seekWidgetByName(self.winmsg_root_ ,"myretrurn_lab")
	self.banker_lab_   = ccui.Helper:seekWidgetByName(self.winmsg_root_ ,"banker_lab")

	self:addChild(self.winmsg_root_,1,10001)
	self.winmsg_root_:setPosition(cc.p(winSize.width/2,winSize.height*0.6))
	self.winmsg_root_:setVisible(false)

	-- self:applyBanker()
	self.btn_applaybanker_ = ccui.Helper:seekWidgetByName(root,"btn_applaybanker")
	self.btn_quitapply_    = ccui.Helper:seekWidgetByName(root,"btn_quitapply")
	self.btn_downbanker_   = ccui.Helper:seekWidgetByName(root,"btn_downbanker")
	self.btn_applaybanker_ :addTouchEventListener(makeClickHandler(self,self.applyBanker))
	self.btn_quitapply_   :addTouchEventListener(makeClickHandler(self,self.quitApplyBanker))
	self.btn_downbanker_   :addTouchEventListener(makeClickHandler(self,self.downApplyBnaker))

	--申请上庄列表
	self.applybanker_root_ = ccs.GUIReader:getInstance():widgetFromJsonFile("bairenniuniu/res/json/ui_applybanker.json")
	self.apply_list_       = ccui.Helper:seekWidgetByName(self.applybanker_root_ ,"apply_list")
	self.btn_applybanker_  = ccui.Helper:seekWidgetByName(self.applybanker_root_,"btn_applybanker")
	self.btn_applyclose_   = ccui.Helper:seekWidgetByName(self.applybanker_root_,"btn_applyclose")
	self.applymsg_lab_     = ccui.Helper:seekWidgetByName(self.applybanker_root_,"applymsg_lab")
	-- self.btn_quitbanker_   = ccui.Helper:seekWidgetByName(self.applybanker_root_,"btn_quitbanker")
	self:addChild(self.applybanker_root_,2,10002)
	self.applybanker_root_:setPosition(cc.p(winSize.width/2,winSize.height*0.6))
	self.applybanker_root_:setVisible(false)
	self.btn_applybanker_ :addTouchEventListener(makeClickHandler(self,self.btnApplyBanker))
	self.btn_applyclose_  :addTouchEventListener(makeClickHandler(self,self.btnApplyClose))

	--游戏记录
	self.btn_record_       = ccui.Helper:seekWidgetByName(root,"btn_record")
	self.btn_record_:addTouchEventListener(makeClickHandler(self,self.btnGameRecord))

	self.recordMsg_root_   = ccs.GUIReader:getInstance():widgetFromJsonFile("bairenniuniu/res/json/ui_record.json")
	self.record_list_      = ccui.Helper:seekWidgetByName(self.recordMsg_root_,"record_list")
	self.btn_recordclose_  = ccui.Helper:seekWidgetByName(self.recordMsg_root_,"btn_recordclose")
	self:addChild(self.recordMsg_root_,3,10003)
	self.recordMsg_root_:setVisible(false)
	-- self.recordMsg_root_:setPosition(cc.p(winSize.width/2,winSize.height/2))

	self.btn_recordclose_:addTouchEventListener(makeClickHandler(self,self.btnrecordclose))
	self:createCloseListener()

	--帮助说明
	self.btn_help_ = ccui.Helper:seekWidgetByName(root,"btn_help")
	self.btn_help_:addTouchEventListener(makeClickHandler(self,self.btnHelpClick))

	--播放背景音乐
	AudioEngine.playMusic("bairenniuniu/res/sound/BACK_GROUND.wav", true)
end

------------------------------游戏说明----------------------------

function GameScene:btnHelpClick()
	PopUpView.showPopUpView(HelpView)
end
------------------------------------------------------------------



----------------------------游戏历史记录--------------------------
function GameScene:btnGameRecord()
	self.recordMsg_root_:setVisible(true)
	self:addRecordlistItem()
end
function GameScene:btnrecordclose()
	self.recordMsg_root_:setVisible(false)
end
function GameScene:createCloseListener()
	--单点触控
		local function onTouchBegan(touch, event)
			local cur = touch:getLocation()
			local pre = touch:getPreviousLocation()
			return self:touchBegan(cur.x, cur.y, pre.x, pre.y)
		end

		local function onTouchMoved(touch, event)
			local cur = touch:getLocation()
			local pre = touch:getPreviousLocation()
			self:touchMoved(cur.x, cur.y, pre.x, pre.y)
		end

		local function onTouchEnded(touch, event)
			local cur = touch:getLocation()
			local pre = touch:getPreviousLocation()
			self:touchEnded(cur.x, cur.y, pre.x, pre.y)
			self.recordMsg_root_:setVisible(false)
		end

		local function onTouchCancelled(touch, event)
			local cur = touch:getLocation()
			local pre = touch:getPreviousLocation()
			self:touchCancelled(cur.x, cur.y, pre.x, pre.y)
		end

		self.listener_ = cc.EventListenerTouchOneByOne:create()
		-- self.listener_:setSwallowTouches(true)
		self.listener_:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
		self.listener_:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
		self.listener_:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
		self.listener_:registerScriptHandler(onTouchCancelled,cc.Handler.EVENT_TOUCH_CANCELLED )
		-- eventDispatcher = self.recordMsg_root_:getEventDispatcher()
		self.recordMsg_root_:getEventDispatcher():addEventListenerWithSceneGraphPriority(self.listener_, self.recordMsg_root_)
end

function GameScene:touchBegan(_touchX, _touchY, _preTouchX, _preTouchY)
    return true
end

function GameScene:touchMoved(_touchX, _touchY, _preTouchX, _preTouchY)

end

function GameScene:touchEnded(_touchX, _touchY, _preTouchX, _preTouchY)

end

function GameScene:touchCancelled(_touchX, _touchY, _preTouchX, _preTouchY)
	
end

function GameScene:removeCloseListener()
	if self.listener_ then
		self.recordMsg_root_:getEventDispatcher():removeEventListener(self.listener_)
		self.listener_ = nil
	end
end
function GameScene:addRecordlistItem()
	if self.record_list_ then
		self.record_list_:removeAllChildren()
	end
	if record_msg then 
		for k,v in ipairs(record_msg) do
			local recordbg_east_  = cc.Sprite:create("bairenniuniu/res/game/hundredbeef_history_adapter_1.png")
			local recordbg_south_ = cc.Sprite:create("bairenniuniu/res/game/hundredbeef_history_adapter_1.png")
			local recordbg_west_  = cc.Sprite:create("bairenniuniu/res/game/hundredbeef_history_adapter_1.png")
			local recordbg_north_ = cc.Sprite:create("bairenniuniu/res/game/hundredbeef_history_adapter_1.png")
			local list_item = ccui.Layout:create()
			list_item:setContentSize(recordbg_east_:getContentSize())
			list_item:addChild(recordbg_east_)
			list_item:addChild(recordbg_south_)
			list_item:addChild(recordbg_west_)
			list_item:addChild(recordbg_north_)
			if v.east  == -1 then
				local texture =  cc.Director:getInstance():getTextureCache():addImage("bairenniuniu/res/game/hundredbeef_history_adapter_2.png") 
				recordbg_east_:setTexture(texture)
				-- recordbg_east_:loadTexture("bairenniuniu/res/game/hundredbeef_history_adapter_2.png")
			end
			if v.south == -1 then
				local texture =  cc.Director:getInstance():getTextureCache():addImage("bairenniuniu/res/game/hundredbeef_history_adapter_2.png") 
				recordbg_south_:setTexture(texture)
				-- recordbg_south_:loadTexture("bairenniuniu/res/game/hundredbeef_history_adapter_2.png")
			end
			if v.west == -1 then
				local texture =  cc.Director:getInstance():getTextureCache():addImage("bairenniuniu/res/game/hundredbeef_history_adapter_2.png") 
				recordbg_west_:setTexture(texture)
				-- recordbg_west_:loadTexture("bairenniuniu/res/game/hundredbeef_history_adapter_2.png")
			end
			if v.north == -1 then
				local texture =  cc.Director:getInstance():getTextureCache():addImage("bairenniuniu/res/game/hundredbeef_history_adapter_2.png") 
				recordbg_north_:setTexture(texture)
				-- recordbg_north_:loadTexture("bairenniuniu/res/game/hundredbeef_history_adapter_2.png")
			end



			if record_type[k].east  == 1 then
				if v.east  == -1 then
					local texture =  cc.Director:getInstance():getTextureCache():addImage("bairenniuniu/res/game/hundredbeef_history_adapter_4.png") 
					recordbg_east_:setTexture(texture)
				-- recordbg_east_:loadTexture("bairenniuniu/res/game/hundredbeef_history_adapter_2.png")
				else
					local texture =  cc.Director:getInstance():getTextureCache():addImage("bairenniuniu/res/game/hundredbeef_history_adapter_3.png") 
					recordbg_east_:setTexture(texture)
				end
			end
			if record_type[k].south == 1 then
				if v.south  == -1 then
					local texture =  cc.Director:getInstance():getTextureCache():addImage("bairenniuniu/res/game/hundredbeef_history_adapter_4.png") 
					recordbg_south_:setTexture(texture)
				-- recordbg_east_:loadTexture("bairenniuniu/res/game/hundredbeef_history_adapter_2.png")
				else
					local texture =  cc.Director:getInstance():getTextureCache():addImage("bairenniuniu/res/game/hundredbeef_history_adapter_3.png") 
					recordbg_south_:setTexture(texture)
				end
			end
			if record_type[k].west  == 1 then
				if v.west  == -1 then
					local texture =  cc.Director:getInstance():getTextureCache():addImage("bairenniuniu/res/game/hundredbeef_history_adapter_4.png") 
					recordbg_west_:setTexture(texture)
				-- recordbg_east_:loadTexture("bairenniuniu/res/game/hundredbeef_history_adapter_2.png")
				else
					local texture =  cc.Director:getInstance():getTextureCache():addImage("bairenniuniu/res/game/hundredbeef_history_adapter_3.png") 
					recordbg_west_:setTexture(texture)
				end
			end
			if record_type[k].north == 1 then
				if v.north  == -1 then
					local texture =  cc.Director:getInstance():getTextureCache():addImage("bairenniuniu/res/game/hundredbeef_history_adapter_4.png") 
					recordbg_north_:setTexture(texture)
				-- recordbg_east_:loadTexture("bairenniuniu/res/game/hundredbeef_history_adapter_2.png")
				else
					local texture =  cc.Director:getInstance():getTextureCache():addImage("bairenniuniu/res/game/hundredbeef_history_adapter_3.png") 
					recordbg_north_:setTexture(texture)
				end
			end

			recordbg_east_ :setPosition(cc.p(-110,0))
			recordbg_south_:setPosition(cc.p(-50,0))
			recordbg_west_ :setPosition(cc.p(10,0))
			recordbg_north_:setPosition(cc.p(70,0))
			self.record_list_:insertCustomItem(list_item,0)
		end
	end
	if record_type then
		for k,v in ipairs(record_type) do
			print(v.east,v.south,v.west,v.north)
		end
	end
end
------------------------------------------------------------------


-----------------------------上庄---------------------------------
function GameScene:applyBanker()
	self:addListItem()
	self.applybanker_root_:setVisible(true)
	-- 创建模型
	-- local default_button = ccui.Button:create(cocosui/backtotoppressed.png, cocosui/backtotopnormal.png)
	-- default_button:setName(Title Button) 
	-- local sprite_bg = cc.Sprite:create("bairenniuniu/res/game/line_01.png")
	-- -- 创建默认item
	-- local default_itme = ccui.Layout:create()
	-- default_itme:setTouchEnabled(true)
	-- default_itme:setContentSize(200,50)
	-- sprite_bg:setPosition(cc.p(default_itme:getContentSize().width/2.0,default_itme:getContentSize().height / 2.0))
	-- default_itme:addChild(sprite_bg)
	-- -- self.apply_list_ :addChild(default_itme) 
	-- -- 设置模型
	-- self.apply_list_ :setItemModel(default_itme)
	-- for i=1,5 do 
	-- 	self.apply_list_:pushBackDefaultItem()    --加载5个默认模板
 	-- end
end
	--向服务器发送上庄请求
function GameScene:btnApplyBanker()
	print("申请上庄")
	if GameScene.score_ >= self.banker_limit_ then
		gamesvr.sendApplyBanker()
		self.applybanker_root_:setVisible(false)
	else
		-- TextTipsUtils:showTips(LocalLanguage:getLanguageString("L_be2bc3fd40d53dab"))
		self.applybanker_root_:setVisible(false)
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_be2bc3fd40d53dab"),
					style = WarnTips.STYLE_Y
				})
	end
end
	--向服务器发送下庄请求
function GameScene:quitApplyBanker()
	gamesvr.sendChangeBanker()
end
function GameScene:downApplyBnaker()
	gamesvr.sendChangeBanker()
end

function GameScene:btnApplyClose()
	print("关闭上庄")
	self.applybanker_root_:setVisible(false)
end

--添加列表项
function GameScene:addListItem()
	if self.apply_list_ then
		self.apply_list_:removeAllChildren()
	end
	print("开始添加列表项bnaker_list=",#bnaker_list)
	if #bnaker_list == 0 then
		local Label1 = cc.LabelTTF:create("", "arial", 20)
		Label1:setAnchorPoint(cc.p(0.5, 0.5))
		Label1:setString(LocalLanguage:getLanguageString("L_e4c8473b9fe5fad8"))
		Label1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)

		local list_item = ccui.Layout:create()
		list_item:setContentSize(Label1:getContentSize())
		-- list_item:setPosition(cc.p(list_item:getContentSize().width / 2.0, list_item:getContentSize().height / 2.0))
		-- sprite_bg:setPosition(cc.p(list_item:getContentSize().width / 2.0,-list_item:getContentSize().height / 2.0))
		-- sprite_bg:setScaleX(0.5)
		-- list_item:addChild(sprite_bg)
		list_item:addChild(Label1)
		Label1:setPosition(cc.p(list_item:getContentSize().width/2.0,0))
		self.apply_list_:insertCustomItem(list_item,0)
	else
		for k,v in ipairs(bnaker_list) do
			local Label1 = cc.LabelTTF:create("", "arial", 20)
			Label1:setAnchorPoint(cc.p(0.5, 0.5))
			Label1:setString(v.apply_name.."      "..v.apply_score)
			Label1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
			local sprite_bg = cc.Sprite:create("bairenniuniu/res/game/line_01.png")

			local list_item = ccui.Layout:create()
			list_item:setContentSize(Label1:getContentSize())
			sprite_bg:setPosition(cc.p(list_item:getContentSize().width / 2.0,-list_item:getContentSize().height / 2.0))
			sprite_bg:setScaleX(0.5)
			list_item:addChild(sprite_bg)
			list_item:addChild(Label1)
			Label1:setPosition(cc.p(list_item:getContentSize().width/2.0,0))
			self.apply_list_:insertCustomItem(list_item,0)
		end
	end
end
------------------------------------------------------------------


--------------------------投币,设置部分---------------------------
	-- self.menu_toubi_  :addTouchEventListener(handler(self,self.onBtnTouBi))
	-- self.menu_jiesuan_:addTouchEventListener(handler(self,self.onBtnJieSuan))
	-- self.menu_set_    :addTouchEventListener(handler(self,self.onBtnSet))
	-- self.menu_exit_   :addTouchEventListener(handler(self,self.onBtnExit))
local showMenu = true
function GameScene:onBtnLeftClick()
	print("左侧按钮")
	if showMenu == true then
		local fire_down = cc.MoveBy:create(0.5,cc.p(0,-100))
		local fire_up   = cc.MoveBy:create(0.5,cc.p(0,100))

		local move_to   = cc.MoveBy:create(0.2,cc.p(100,0))
		local seqAction = cc.Sequence:create(
			move_to,
			cc.CallFunc:create(function()
				self.btn_left_ :loadTextureNormal("bairenniuniu/res/game/out_btn.png")
			end))
		self.menu_root_:runAction(seqAction)


		local down_fireSeq = cc.Sequence:create(
				fire_down,
				cc.CallFunc:create(function()
				self.down_fire_:setVisible(false)
				end),
				fire_down:reverse()
				)
		local up_fireSeq   = cc.Sequence:create(
				fire_up,
				cc.CallFunc:create(function()
				self.up_fire_:setVisible(false)
				end),
				fire_up:reverse()
				)
		self.down_fire_:setVisible(true)
		self.up_fire_  :setVisible(true)
		self.down_fire_:runAction(down_fireSeq)
		self.up_fire_  :runAction(up_fireSeq)
		showMenu = false
	else
		self.down_fire_:setVisible(false)
		self.up_fire_  :setVisible(false)

		local move_to   = cc.MoveBy:create(0.2,cc.p(-100,0))
		local seqAction = cc.Sequence:create(
			move_to,
			cc.CallFunc:create(function()
				self.btn_left_ :loadTextureNormal("bairenniuniu/res/game/int_btn.png")
			end))
		self.menu_root_:runAction(seqAction)

		showMenu = true
	end
	-- self.menu_root_:setVisible(false)
end
function GameScene:onBtnTouBi(sender,eventType)
	if eventType == ccui.TouchEventType.ended then
		self.toubi_image_:setVisible(false)
		PopUpView.showPopUpView(ToubiView)
	elseif eventType == ccui.TouchEventType.moved then
		self.toubi_image_:setVisible(false)
	elseif eventType == ccui.TouchEventType.began then
		self.toubi_image_:setVisible(true)
	end
end
function GameScene:onBtnJieSuan(sender,eventType)
	if eventType == ccui.TouchEventType.ended then
		self.jiesuan_image_:setVisible(false)
		if self.SettleBool_ == true then
			PopUpView.showPopUpView(SettleView)
		else
			WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_2b3b627e09bdf969"),
					style = WarnTips.STYLE_Y
				})
		end
	elseif eventType == ccui.TouchEventType.moved then
		self.jiesuan_image_:setVisible(false)
	elseif eventType == ccui.TouchEventType.began then
		self.jiesuan_image_:setVisible(true)
	end
end
function GameScene:onBtnSet(sender,eventType)
	if eventType == ccui.TouchEventType.ended then
		self.set_image_:setVisible(false)
		PopUpView.showPopUpView(SettingView)
	elseif eventType == ccui.TouchEventType.moved then
		self.set_image_:setVisible(false)
	elseif eventType == ccui.TouchEventType.began then
		self.set_image_:setVisible(true)
	end
end
function GameScene:onBtnExit(sender,eventType)
	if eventType == ccui.TouchEventType.ended then
		-- global.g_mainPlayer:setPlayerScore(GameScene.gold_ + math.floor(GameScene.score_*global.g_mainPlayer:getCurrentRoomBeilv()))
		self.exit_image_:setVisible(false)
		WarnTips.showTips({
						text    = LocalLanguage:getLanguageString("L_6ceb2e80d33e115e"),
						confirm = exit_bairenniuniu,
					})
	elseif eventType == ccui.TouchEventType.moved then
		self.exit_image_:setVisible(false)
	elseif eventType == ccui.TouchEventType.began then
		self.exit_image_:setVisible(true)
	end
end
-----------------------------------------------------------------



---------------------------时间显示部分---------------------------
--计时器空闲状态
function GameScene:Clock_onIdle(time)
	self.retainTime_ = time
	self:onStartTimer()
	self.status_ 	 = STATUS_IDLE

	self.kaipai_  :setVisible(false)
	self.kongxian_:setVisible(true)
	self.xiazhu_  :setVisible(false)
end
--计时器开始下注状态
function GameScene:Clock_onJetton(time)
	self.retainTime_ = time
	self:onStartTimer()
	self.status_     = STATUS_JETTON

	self.kaipai_  :setVisible(false)
	self.kongxian_:setVisible(false)
	self.xiazhu_  :setVisible(true)
end
--计时器开牌状态
function GameScene:Clock_onPlay(time)
	self.retainTime_ = time
	self:onStartTimer()

	self.status_ 	 = STATUS_PLAY

	self.kaipai_  :setVisible(true)
	self.kongxian_:setVisible(false)
	self.xiazhu_  :setVisible(false)
	-- cardID = 8
	-- --开始时间
	-- self:StartCard(cardID)
end
--开始计时
function GameScene:onStartTimer()
	self:onStopTimer()
	self.time_label_:setString(self.retainTime_)
	self.timeHandler_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.onTimer), 1, false)
end
--停止上次计时器调用
function GameScene:onStopTimer()
	if self.timeHandler_ then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.timeHandler_)
		self.timeHandler_ = nil
	end
end
--倒计时
function GameScene:onTimer()
	self.retainTime_ = self.retainTime_ - 1
	if self.retainTime_ > 0 then
		self.time_label_:setString(self.retainTime_)
		self.time_label_:setString(self.retainTime_)
	else
		self.time_label_:setString(self.retainTime_)
		self.time_label_:setString(self.retainTime_)
	end
	--警告声音
	if self.JettonBool_ and self.JettonBool_==true then
		if self.retainTime_ > 0  and self.retainTime_ < 4 then
			AudioEngine.playEffect("bairenniuniu/res/sound/TIME_WARIMG.wav")
		end
	end
end
-------------------------时间模块结束------------------------------


---------------------------下注模块--------------------------------
local JettonSpr = {}

--判断显示那几个可以选择的下注筹码按钮
function GameScene:switchJettonShow()
	print("switchJettonShow--GameScene.score_ = ",GameScene.score_)
	banker_limit_score = banker_score*self.endGameMul_/100
	print("庄家限制下注分数:",banker_limit_score)

	if banker_name == LocalLanguage:getLanguageString("L_45a3acaf08fe01c8") then
		if self.areamaxscore_>=10000000 and (GameScene.score_/10 - self.myjetton_countscore_) >= 10000000 and self.my_maxscore_ - self.myjetton_countscore_ >= 10000000 then
			self.btn_jetton7_0:setVisible(false)
			self.btn_jetton7_ :setVisible(true)
			self.btn_jetton6_0:setVisible(false)
			self.btn_jetton6_ :setVisible(true)
			self.btn_jetton5_0:setVisible(false)
			self.btn_jetton5_ :setVisible(true)
			self.btn_jetton4_0:setVisible(false)
			self.btn_jetton4_ :setVisible(true)
			self.btn_jetton4_0:setVisible(false)
			self.btn_jetton4_ :setVisible(true)
			self.btn_jetton3_0:setVisible(false)
			self.btn_jetton3_ :setVisible(true)
			self.btn_jetton2_0:setVisible(false)
			self.btn_jetton2_ :setVisible(true)
			self.btn_jetton1_0:setVisible(false)
			self.btn_jetton1_ :setVisible(true)
		elseif self.areamaxscore_>=5000000 and (GameScene.score_/10 - self.myjetton_countscore_) >= 5000000 and self.my_maxscore_ - self.myjetton_countscore_ >= 5000000 then
			self.btn_jetton7_0:setVisible(true)
			self.btn_jetton7_ :setVisible(false)
			self.btn_jetton6_0:setVisible(false)
			self.btn_jetton6_ :setVisible(true)
			self.btn_jetton5_0:setVisible(false)
			self.btn_jetton5_ :setVisible(true)
			self.btn_jetton4_0:setVisible(false)
			self.btn_jetton4_ :setVisible(true)
			self.btn_jetton4_0:setVisible(false)
			self.btn_jetton4_ :setVisible(true)
			self.btn_jetton3_0:setVisible(false)
			self.btn_jetton3_ :setVisible(true)
			self.btn_jetton2_0:setVisible(false)
			self.btn_jetton2_ :setVisible(true)
			self.btn_jetton1_0:setVisible(false)
			self.btn_jetton1_ :setVisible(true)
			if self.selectedJettonBox_ == self.btn_jetton7_ then
				if self.btn_jetton7_:isVisible() == false then
					self.selectedJettonBox_:setSelected(false)
					self.btn_jetton6_:setSelected(true)
					self.selectedJettonBox_ = self.btn_jetton6_
					self:switchJettonRatio(self.selectedJettonBox_:getName())
				end
			end
		elseif self.areamaxscore_>=1000000 and (GameScene.score_/10 - self.myjetton_countscore_) >= 1000000 and self.my_maxscore_ - self.myjetton_countscore_ >= 1000000 then
			self.btn_jetton7_0:setVisible(true)
			self.btn_jetton7_ :setVisible(false)
			self.btn_jetton6_0:setVisible(true)
			self.btn_jetton6_ :setVisible(false)
			self.btn_jetton5_0:setVisible(false)
			self.btn_jetton5_ :setVisible(true)
			self.btn_jetton4_0:setVisible(false)
			self.btn_jetton4_ :setVisible(true)
			self.btn_jetton4_0:setVisible(false)
			self.btn_jetton4_ :setVisible(true)
			self.btn_jetton3_0:setVisible(false)
			self.btn_jetton3_ :setVisible(true)
			self.btn_jetton2_0:setVisible(false)
			self.btn_jetton2_ :setVisible(true)
			self.btn_jetton1_0:setVisible(false)
			self.btn_jetton1_ :setVisible(true)
			if self.selectedJettonBox_ == self.btn_jetton6_ or self.selectedJettonBox_ == self.btn_jetton7_ then
				if self.btn_jetton6_:isVisible() == false then
					self.selectedJettonBox_:setSelected(false)
					self.btn_jetton5_:setSelected(true)
					self.selectedJettonBox_ = self.btn_jetton5_
					self:switchJettonRatio(self.selectedJettonBox_:getName())
				end
			end
		elseif self.areamaxscore_>=100000 and (GameScene.score_/10 - self.myjetton_countscore_) >= 100000 and self.my_maxscore_ - self.myjetton_countscore_ >= 100000 then
			self.btn_jetton7_0:setVisible(true)
			self.btn_jetton7_ :setVisible(false)
			self.btn_jetton6_0:setVisible(true)
			self.btn_jetton6_ :setVisible(false)
			self.btn_jetton5_0:setVisible(true)
			self.btn_jetton5_ :setVisible(false)
			self.btn_jetton4_0:setVisible(false)
			self.btn_jetton4_ :setVisible(true)
			self.btn_jetton3_0:setVisible(false)
			self.btn_jetton3_ :setVisible(true)
			self.btn_jetton2_0:setVisible(false)
			self.btn_jetton2_ :setVisible(true)
			self.btn_jetton1_0:setVisible(false)
			self.btn_jetton1_ :setVisible(true)
			if self.selectedJettonBox_ == self.btn_jetton5_ or self.selectedJettonBox_ == self.btn_jetton6_ or self.selectedJettonBox_ == self.btn_jetton7_  then
				if self.btn_jetton5_:isVisible() == false then
					self.selectedJettonBox_:setSelected(false)
					self.btn_jetton4_:setSelected(true)
					self.selectedJettonBox_ = self.btn_jetton4_
					self:switchJettonRatio(self.selectedJettonBox_:getName())
				end
			end
		elseif self.areamaxscore_>=10000 and (GameScene.score_/10 - self.myjetton_countscore_) >= 10000 and self.my_maxscore_ - self.myjetton_countscore_ >= 10000 then
			self.btn_jetton7_0:setVisible(true)
			self.btn_jetton7_ :setVisible(false)
			self.btn_jetton6_0:setVisible(true)
			self.btn_jetton6_ :setVisible(false)
			self.btn_jetton5_0:setVisible(true)
			self.btn_jetton5_ :setVisible(false)
			self.btn_jetton4_0:setVisible(true)
			self.btn_jetton4_ :setVisible(false)
			self.btn_jetton3_0:setVisible(false)
			self.btn_jetton3_ :setVisible(true)
			self.btn_jetton2_0:setVisible(false)
			self.btn_jetton2_ :setVisible(true)
			self.btn_jetton1_0:setVisible(false)
			self.btn_jetton1_ :setVisible(true)
			if self.selectedJettonBox_ == self.btn_jetton4_ or self.selectedJettonBox_ == self.btn_jetton5_ or self.selectedJettonBox_ == self.btn_jetton6_ or self.selectedJettonBox_ == self.btn_jetton7_ then
				if self.btn_jetton4_:isVisible() == false then
					self.selectedJettonBox_:setSelected(false)
					self.btn_jetton3_:setSelected(true)
					self.selectedJettonBox_ = self.btn_jetton3_
					self:switchJettonRatio(self.selectedJettonBox_:getName())
				end
			end
		elseif self.areamaxscore_>=1000 and (GameScene.score_/10 - self.myjetton_countscore_) >= 1000 and self.my_maxscore_ - self.myjetton_countscore_ >= 1000 then
			self.btn_jetton7_0:setVisible(true)
			self.btn_jetton7_ :setVisible(false)
			self.btn_jetton6_0:setVisible(true)
			self.btn_jetton6_ :setVisible(false)
			self.btn_jetton5_0:setVisible(true)
			self.btn_jetton5_ :setVisible(false)
			self.btn_jetton4_0:setVisible(true)
			self.btn_jetton4_ :setVisible(false)
			self.btn_jetton3_0:setVisible(true)
			self.btn_jetton3_ :setVisible(false)
			self.btn_jetton2_0:setVisible(false)
			self.btn_jetton2_ :setVisible(true)
			self.btn_jetton1_0:setVisible(false)
			self.btn_jetton1_ :setVisible(true)
			if self.selectedJettonBox_ == self.btn_jetton3_ or self.selectedJettonBox_ == self.btn_jetton4_ or self.selectedJettonBox_ == self.btn_jetton5_ or self.selectedJettonBox_ == self.btn_jetton6_ or self.selectedJettonBox_ == self.btn_jetton7_  then
				if self.btn_jetton3_:isVisible() == false then
					self.selectedJettonBox_:setSelected(false)
					self.btn_jetton2_:setSelected(true)
					self.selectedJettonBox_ = self.btn_jetton2_
					self:switchJettonRatio(self.selectedJettonBox_:getName())
				end
			end
		elseif self.areamaxscore_>=100 and (GameScene.score_/10 - self.myjetton_countscore_) >= 100 and self.my_maxscore_ - self.myjetton_countscore_ >= 100 then
			self.btn_jetton7_0:setVisible(true)
			self.btn_jetton7_ :setVisible(false)
			self.btn_jetton6_0:setVisible(true)
			self.btn_jetton6_ :setVisible(false)
			self.btn_jetton5_0:setVisible(true)
			self.btn_jetton5_ :setVisible(false)
			self.btn_jetton4_0:setVisible(true)
			self.btn_jetton4_ :setVisible(false)
			self.btn_jetton3_0:setVisible(true)
			self.btn_jetton3_ :setVisible(false)
			self.btn_jetton2_0:setVisible(true)
			self.btn_jetton2_ :setVisible(false)
			self.btn_jetton1_0:setVisible(false)
			self.btn_jetton1_ :setVisible(true)
			if self.selectedJettonBox_ == self.btn_jetton2_ or self.selectedJettonBox_ == self.btn_jetton3_ or self.selectedJettonBox_ == self.btn_jetton4_ or self.selectedJettonBox_ == self.btn_jetton5_ or self.selectedJettonBox_ == self.btn_jetton6_ or self.selectedJettonBox_ == self.btn_jetton7_  then
				if self.btn_jetton2_:isVisible() == false then
					self.selectedJettonBox_:setSelected(false)
					self.btn_jetton1_:setSelected(true)
					self.selectedJettonBox_ = self.btn_jetton1_
					self:switchJettonRatio(self.selectedJettonBox_:getName())
				end
			end
		elseif self.areamaxscore_>=0 and (GameScene.score_/10 - self.myjetton_countscore_) >= 0 and self.my_maxscore_ - self.myjetton_countscore_ >= 0 then
			self.btn_jetton7_0:setVisible(true)
			self.btn_jetton7_ :setVisible(false)
			self.btn_jetton6_0:setVisible(true)
			self.btn_jetton6_ :setVisible(false)
			self.btn_jetton5_0:setVisible(true)
			self.btn_jetton5_ :setVisible(false)
			self.btn_jetton4_0:setVisible(true)
			self.btn_jetton4_ :setVisible(false)
			self.btn_jetton3_0:setVisible(true)
			self.btn_jetton3_ :setVisible(false)
			self.btn_jetton2_0:setVisible(true)
			self.btn_jetton2_ :setVisible(false)
			self.btn_jetton1_0:setVisible(true)
			self.btn_jetton1_ :setVisible(false)
			-- WarnTips.showTips(
			-- 		{
			-- 			text = "已是玩家下注最大值",
			-- 			style = WarnTips.STYLE_Y
			-- 		})
			self.JettonBool_ = false
		end
	else
		if self.areamaxscore_>=10000000 and (GameScene.score_/10 - self.myjetton_countscore_) >= 10000000 and self.my_maxscore_ - self.myjetton_countscore_ >= 10000000 and banker_limit_score/10 - self.text_countscore_ >= 10000000 then
			self.btn_jetton7_0:setVisible(false)
			self.btn_jetton7_ :setVisible(true)
			self.btn_jetton6_0:setVisible(false)
			self.btn_jetton6_ :setVisible(true)
			self.btn_jetton5_0:setVisible(false)
			self.btn_jetton5_ :setVisible(true)
			self.btn_jetton4_0:setVisible(false)
			self.btn_jetton4_ :setVisible(true)
			self.btn_jetton4_0:setVisible(false)
			self.btn_jetton4_ :setVisible(true)
			self.btn_jetton3_0:setVisible(false)
			self.btn_jetton3_ :setVisible(true)
			self.btn_jetton2_0:setVisible(false)
			self.btn_jetton2_ :setVisible(true)
			self.btn_jetton1_0:setVisible(false)
			self.btn_jetton1_ :setVisible(true)
		elseif self.areamaxscore_>=5000000 and (GameScene.score_/10 - self.myjetton_countscore_) >= 5000000 and self.my_maxscore_ - self.myjetton_countscore_ >= 5000000 and banker_limit_score/10 - self.text_countscore_ >= 5000000 then
			self.btn_jetton7_0:setVisible(true)
			self.btn_jetton7_ :setVisible(false)
			self.btn_jetton6_0:setVisible(false)
			self.btn_jetton6_ :setVisible(true)
			self.btn_jetton5_0:setVisible(false)
			self.btn_jetton5_ :setVisible(true)
			self.btn_jetton4_0:setVisible(false)
			self.btn_jetton4_ :setVisible(true)
			self.btn_jetton4_0:setVisible(false)
			self.btn_jetton4_ :setVisible(true)
			self.btn_jetton3_0:setVisible(false)
			self.btn_jetton3_ :setVisible(true)
			self.btn_jetton2_0:setVisible(false)
			self.btn_jetton2_ :setVisible(true)
			self.btn_jetton1_0:setVisible(false)
			self.btn_jetton1_ :setVisible(true)
			if self.selectedJettonBox_ == self.btn_jetton7_ then
				if self.btn_jetton7_:isVisible() == false then
					self.selectedJettonBox_:setSelected(false)
					self.btn_jetton6_:setSelected(true)
					self.selectedJettonBox_ = self.btn_jetton6_
					self:switchJettonRatio(self.selectedJettonBox_:getName())
				end
			end
		elseif self.areamaxscore_>=1000000 and (GameScene.score_/10 - self.myjetton_countscore_) >= 1000000 and self.my_maxscore_ - self.myjetton_countscore_ >= 1000000 and banker_limit_score/10 - self.text_countscore_ >= 1000000 then
			self.btn_jetton7_0:setVisible(true)
			self.btn_jetton7_ :setVisible(false)
			self.btn_jetton6_0:setVisible(true)
			self.btn_jetton6_ :setVisible(false)
			self.btn_jetton5_0:setVisible(false)
			self.btn_jetton5_ :setVisible(true)
			self.btn_jetton4_0:setVisible(false)
			self.btn_jetton4_ :setVisible(true)
			self.btn_jetton4_0:setVisible(false)
			self.btn_jetton4_ :setVisible(true)
			self.btn_jetton3_0:setVisible(false)
			self.btn_jetton3_ :setVisible(true)
			self.btn_jetton2_0:setVisible(false)
			self.btn_jetton2_ :setVisible(true)
			self.btn_jetton1_0:setVisible(false)
			self.btn_jetton1_ :setVisible(true)
			if self.selectedJettonBox_ == self.btn_jetton6_ or self.selectedJettonBox_ == self.btn_jetton7_ then
				if self.btn_jetton6_:isVisible() == false then
					self.selectedJettonBox_:setSelected(false)
					self.btn_jetton5_:setSelected(true)
					self.selectedJettonBox_ = self.btn_jetton5_
					self:switchJettonRatio(self.selectedJettonBox_:getName())
				end
			end
		elseif self.areamaxscore_>=100000 and (GameScene.score_/10 - self.myjetton_countscore_) >= 100000 and self.my_maxscore_ - self.myjetton_countscore_ >= 100000 and banker_limit_score/10 - self.text_countscore_ >= 100000 then
			self.btn_jetton7_0:setVisible(true)
			self.btn_jetton7_ :setVisible(false)
			self.btn_jetton6_0:setVisible(true)
			self.btn_jetton6_ :setVisible(false)
			self.btn_jetton5_0:setVisible(true)
			self.btn_jetton5_ :setVisible(false)
			self.btn_jetton4_0:setVisible(false)
			self.btn_jetton4_ :setVisible(true)
			self.btn_jetton3_0:setVisible(false)
			self.btn_jetton3_ :setVisible(true)
			self.btn_jetton2_0:setVisible(false)
			self.btn_jetton2_ :setVisible(true)
			self.btn_jetton1_0:setVisible(false)
			self.btn_jetton1_ :setVisible(true)
			if self.selectedJettonBox_ == self.btn_jetton5_ or self.selectedJettonBox_ == self.btn_jetton6_ or self.selectedJettonBox_ == self.btn_jetton7_ then
				if self.btn_jetton5_:isVisible() == false then
					self.selectedJettonBox_:setSelected(false)
					self.btn_jetton4_:setSelected(true)
					self.selectedJettonBox_ = self.btn_jetton4_
					self:switchJettonRatio(self.selectedJettonBox_:getName())
				end
			end
		elseif self.areamaxscore_>=10000 and (GameScene.score_/10 - self.myjetton_countscore_) >= 10000 and self.my_maxscore_ - self.myjetton_countscore_ >= 10000 and banker_limit_score/10 - self.text_countscore_ >= 10000 then
			self.btn_jetton7_0:setVisible(true)
			self.btn_jetton7_ :setVisible(false)
			self.btn_jetton6_0:setVisible(true)
			self.btn_jetton6_ :setVisible(false)
			self.btn_jetton5_0:setVisible(true)
			self.btn_jetton5_ :setVisible(false)
			self.btn_jetton4_0:setVisible(true)
			self.btn_jetton4_ :setVisible(false)
			self.btn_jetton3_0:setVisible(false)
			self.btn_jetton3_ :setVisible(true)
			self.btn_jetton2_0:setVisible(false)
			self.btn_jetton2_ :setVisible(true)
			self.btn_jetton1_0:setVisible(false)
			self.btn_jetton1_ :setVisible(true)
			if self.selectedJettonBox_ == self.btn_jetton4_ or self.selectedJettonBox_ == self.btn_jetton5_ or self.selectedJettonBox_ == self.btn_jetton6_ or self.selectedJettonBox_ == self.btn_jetton7_  then
				if self.btn_jetton4_:isVisible() == false then
					self.selectedJettonBox_:setSelected(false)
					self.btn_jetton3_:setSelected(true)
					self.selectedJettonBox_ = self.btn_jetton3_
					self:switchJettonRatio(self.selectedJettonBox_:getName())
				end
			end
		elseif self.areamaxscore_>=1000 and (GameScene.score_/10 - self.myjetton_countscore_) >= 1000 and self.my_maxscore_ - self.myjetton_countscore_ >= 1000 and banker_limit_score/10 - self.text_countscore_ >= 1000 then
			self.btn_jetton7_0:setVisible(true)
			self.btn_jetton7_ :setVisible(false)
			self.btn_jetton6_0:setVisible(true)
			self.btn_jetton6_ :setVisible(false)
			self.btn_jetton5_0:setVisible(true)
			self.btn_jetton5_ :setVisible(false)
			self.btn_jetton4_0:setVisible(true)
			self.btn_jetton4_ :setVisible(false)
			self.btn_jetton3_0:setVisible(true)
			self.btn_jetton3_ :setVisible(false)
			self.btn_jetton2_0:setVisible(false)
			self.btn_jetton2_ :setVisible(true)
			self.btn_jetton1_0:setVisible(false)
			self.btn_jetton1_ :setVisible(true)
			if self.selectedJettonBox_ == self.btn_jetton3_ or self.selectedJettonBox_ == self.btn_jetton4_ or self.selectedJettonBox_ == self.btn_jetton5_ or self.selectedJettonBox_ == self.btn_jetton6_ or self.selectedJettonBox_ == self.btn_jetton7_  then
				if self.btn_jetton3_:isVisible() == false then
					self.selectedJettonBox_:setSelected(false)
					self.btn_jetton2_:setSelected(true)
					self.selectedJettonBox_ = self.btn_jetton2_
					self:switchJettonRatio(self.selectedJettonBox_:getName())
				end
			end
		elseif self.areamaxscore_>=100 and (GameScene.score_/10 - self.myjetton_countscore_) >= 100 and self.my_maxscore_ - self.myjetton_countscore_ >= 100 and banker_limit_score/10 - self.text_countscore_ >= 100 then
			self.btn_jetton7_0:setVisible(true)
			self.btn_jetton7_ :setVisible(false)
			self.btn_jetton6_0:setVisible(true)
			self.btn_jetton6_ :setVisible(false)
			self.btn_jetton5_0:setVisible(true)
			self.btn_jetton5_ :setVisible(false)
			self.btn_jetton4_0:setVisible(true)
			self.btn_jetton4_ :setVisible(false)
			self.btn_jetton3_0:setVisible(true)
			self.btn_jetton3_ :setVisible(false)
			self.btn_jetton2_0:setVisible(true)
			self.btn_jetton2_ :setVisible(false)
			self.btn_jetton1_0:setVisible(false)
			self.btn_jetton1_ :setVisible(true)
			if self.selectedJettonBox_ == self.btn_jetton2_ or self.selectedJettonBox_ == self.btn_jetton3_ or self.selectedJettonBox_ == self.btn_jetton4_ or self.selectedJettonBox_ == self.btn_jetton5_ or self.selectedJettonBox_ == self.btn_jetton6_ or self.selectedJettonBox_ == self.btn_jetton7_ then
				if self.btn_jetton2_:isVisible() == false then
					self.selectedJettonBox_:setSelected(false)
					self.btn_jetton1_:setSelected(true)
					self.selectedJettonBox_ = self.btn_jetton1_
					self:switchJettonRatio(self.selectedJettonBox_:getName())
				end
			end
		elseif self.areamaxscore_>=0 and (GameScene.score_/10 - self.myjetton_countscore_) >= 0 and self.my_maxscore_ - self.myjetton_countscore_ >= 0 then
			self.btn_jetton7_0:setVisible(true)
			self.btn_jetton7_ :setVisible(false)
			self.btn_jetton6_0:setVisible(true)
			self.btn_jetton6_ :setVisible(false)
			self.btn_jetton5_0:setVisible(true)
			self.btn_jetton5_ :setVisible(false)
			self.btn_jetton4_0:setVisible(true)
			self.btn_jetton4_ :setVisible(false)
			self.btn_jetton3_0:setVisible(true)
			self.btn_jetton3_ :setVisible(false)
			self.btn_jetton2_0:setVisible(true)
			self.btn_jetton2_ :setVisible(false)
			self.btn_jetton1_0:setVisible(true)
			self.btn_jetton1_ :setVisible(false)
			-- WarnTips.showTips(
			-- 		{
			-- 			text = "已是玩家下注最大值",
			-- 			style = WarnTips.STYLE_Y
			-- 		})
			self.JettonBool_ = false
		end
	end
end
--下注筹码全黑
function GameScene:allhideJetton()
		self.btn_jetton7_0:setVisible(true)
		self.btn_jetton7_ :setVisible(false)
		self.btn_jetton6_0:setVisible(true)
		self.btn_jetton6_ :setVisible(false)
		self.btn_jetton5_0:setVisible(true)
		self.btn_jetton5_ :setVisible(false)
		self.btn_jetton4_0:setVisible(true)
		self.btn_jetton4_ :setVisible(false)
		self.btn_jetton3_0:setVisible(true)
		self.btn_jetton3_ :setVisible(false)
		self.btn_jetton2_0:setVisible(true)
		self.btn_jetton2_ :setVisible(false)
		self.btn_jetton1_0:setVisible(true)
		self.btn_jetton1_ :setVisible(false)
		self.JettonBool_ = false
end

function GameScene:onBtnJettonHandler(sender,eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		if self.selectedJettonBox_ ~= sender then
			self.selectedJettonBox_ :setSelected(false)
			self.selectedJettonBox_ = sender
		end
	elseif eventType == ccui.CheckBoxEventType.unselected then
		sender:setSelected(true)
	end
	self:switchJettonRatio(self.selectedJettonBox_:getName())
end
--切换倍数
function GameScene:switchJettonRatio(name)
	if name == "btn_jetton1" then
		self.jetton_ratio_ = 100	
	elseif name == "btn_jetton2" then
		self.jetton_ratio_ = 1000
		-- GameScene.score_ = GameScene.score_ - self.jetton_ratio_
	elseif name == "btn_jetton3" then
		self.jetton_ratio_ = 10000
		-- GameScene.score_ = GameScene.score_ - self.jetton_ratio_
	elseif name == "btn_jetton4" then
		self.jetton_ratio_ = 100000
		-- GameScene.score_ = GameScene.score_ - self.jetton_ratio_
	elseif name == "btn_jetton5" then
		self.jetton_ratio_ = 1000000
		-- GameScene.score_ = GameScene.score_ - self.jetton_ratio_
	elseif name == "btn_jetton6" then
		self.jetton_ratio_ = 5000000
		-- GameScene.score_ = GameScene.score_ - self.jetton_ratio_
	elseif name == "btn_jetton7" then
		self.jetton_ratio_ = 10000000
		-- GameScene.score_ = GameScene.score_ - self.jetton_ratio_
	end
	print("self.jetton_ratio_ =",self.jetton_ratio_)
	self:switchJettonShow()
end
--下注到东
function GameScene:onEastJetton()
	if self.JettonBool_ == true then
		if (GameScene.score_/10 - self.myjetton_countscore_) >= self.jetton_ratio_ then
			if self.count_text_1_ <= self.areamaxscore_  and self.myjetton_countscore_ <= self.my_maxscore_ then
				print("当前倍数",self.jetton_ratio_)
				local animalId = 1
				local base     = self.jetton_ratio_
				-- GameScene.score_ = GameScene.score_ - self.jetton_ratio_
				self:switchJettonShow()
				gamesvr.sendPlaceJetton(animalId, base)	
			else
				WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_8b6b63b9cb38e943"),
					style = WarnTips.STYLE_Y
				})
			end
		else
			WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_1bbdbbd2dc4180d2"),
					style = WarnTips.STYLE_Y
				})
		end
	end
	print("下注到东")
end
--下注到南
function GameScene:onSouthJetton()
	if self.JettonBool_ == true then
		if (GameScene.score_/10 - self.myjetton_countscore_) >= self.jetton_ratio_ then
			if self.count_text_2_ <= self.areamaxscore_ and self.myjetton_countscore_ <= self.my_maxscore_ then
				print("当前倍数",self.jetton_ratio_)
				local animalId = 2
				local base     = self.jetton_ratio_
				-- GameScene.score_ = GameScene.score_ - self.jetton_ratio_
				self:switchJettonShow()
				gamesvr.sendPlaceJetton(animalId, base)	
			else
				WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_8b6b63b9cb38e943"),
					style = WarnTips.STYLE_Y
				})
			end
		else 
			WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_1bbdbbd2dc4180d2"),
					style = WarnTips.STYLE_Y
				})
		end
	end
	print("下注到南")
end
--下注到西
function GameScene:onWestJetton()
	if self.JettonBool_ == true then
		if (GameScene.score_/10 - self.myjetton_countscore_) >= self.jetton_ratio_ then
			if self.count_text_3_ <= self.areamaxscore_ and self.myjetton_countscore_ <= self.my_maxscore_ then
				print("当前倍数",self.jetton_ratio_)
				local animalId = 3
				local base     = self.jetton_ratio_
				-- GameScene.score_ = GameScene.score_ - self.jetton_ratio_
				self:switchJettonShow()
				gamesvr.sendPlaceJetton(animalId, base)	
			else
				WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_8b6b63b9cb38e943"),
					style = WarnTips.STYLE_Y
				})
			end
		else
			WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_1bbdbbd2dc4180d2"),
					style = WarnTips.STYLE_Y
				})
		end
	end
	print("下注到西")
end
--下注到北
function GameScene:onNorthJetton()
	if self.JettonBool_ == true then
		if (GameScene.score_/10 - self.myjetton_countscore_) >= self.jetton_ratio_ then
			if self.count_text_4_ <= self.areamaxscore_ and self.myjetton_countscore_ <= self.my_maxscore_ then
				print("当前倍数4",self.jetton_ratio_)
				local animalId = 4
				local base     = self.jetton_ratio_
				-- GameScene.score_ = GameScene.score_ - self.jetton_ratio_
				self:switchJettonShow()
				gamesvr.sendPlaceJetton(animalId, base)	
			else
				WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_8b6b63b9cb38e943"),
					style = WarnTips.STYLE_Y
				})
			end
		else
			WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_1bbdbbd2dc4180d2"),
					style = WarnTips.STYLE_Y
				})
		end
	end
	print("下注到北")
end

--创建押注筹码
function GameScene:createJetton(chairId,areaId,jetton_ratio)
	if areaId == 1 then
		if GameScene.chairId_ == chairId then
			self.myjetton_text_1_ = self.myjetton_text_1_ + jetton_ratio
			self.myjetton_num_1_:setString(self.myjetton_text_1_)
			self.myjetton_num_1_:setVisible(true)
			self:refreshJettonNum()
		end
		self.jettonSpr = cc.Sprite:create("bairenniuniu/res/jetton/jettom_view_"..jetton_ratio..".png")
		self.jettonSpr:setPosition(cc.p(math.random(40,150),math.random(35,130)))
		self.bg_east_:addChild(self.jettonSpr)
		table.insert(JettonSpr,self.jettonSpr)

		self.count_text_1_ = self.count_text_1_ + jetton_ratio
		self.count_num_1_:setString(self.count_text_1_)
		self.count_num_1_:setVisible(true)
	elseif areaId == 2 then
		if GameScene.chairId_ == chairId then
			self.myjetton_text_2_ = self.myjetton_text_2_ + jetton_ratio
			self.myjetton_num_2_:setString(self.myjetton_text_2_)
			self.myjetton_num_2_:setVisible(true)
			self:refreshJettonNum()
		end
		self.jettonSpr = cc.Sprite:create("bairenniuniu/res/jetton/jettom_view_"..jetton_ratio..".png")
		self.jettonSpr:setPosition(cc.p(math.random(40,150),math.random(35,130)))
		self.bg_south_:addChild(self.jettonSpr)
		table.insert(JettonSpr,self.jettonSpr)

		self.count_text_2_ = self.count_text_2_ + jetton_ratio
		self.count_num_2_:setString(self.count_text_2_)
		self.count_num_2_:setVisible(true)
	elseif areaId == 3 then
		if GameScene.chairId_ == chairId then
			self.myjetton_text_3_ = self.myjetton_text_3_ + jetton_ratio
			self.myjetton_num_3_:setString(self.myjetton_text_3_)
			self.myjetton_num_3_:setVisible(true)
			self:refreshJettonNum()
		end
		self.jettonSpr = cc.Sprite:create("bairenniuniu/res/jetton/jettom_view_"..jetton_ratio..".png")
		self.jettonSpr:setPosition(cc.p(math.random(40,150),math.random(35,130)))
		self.bg_west_:addChild(self.jettonSpr)
		table.insert(JettonSpr,self.jettonSpr)

		self.count_text_3_ = self.count_text_3_ + jetton_ratio
		self.count_num_3_:setString(self.count_text_3_)
		self.count_num_3_:setVisible(true)
	elseif areaId == 4 then
		if GameScene.chairId_ == chairId then
			self.myjetton_text_4_ = self.myjetton_text_4_ + jetton_ratio
			self.myjetton_num_4_:setString(self.myjetton_text_4_)
			self.myjetton_num_4_:setVisible(true)
			self:refreshJettonNum()
		end
		self.jettonSpr = cc.Sprite:create("bairenniuniu/res/jetton/jettom_view_"..jetton_ratio..".png")
		self.jettonSpr:setPosition(cc.p(math.random(40,150),math.random(35,130)))
		self.bg_north_:addChild(self.jettonSpr)
		table.insert(JettonSpr,self.jettonSpr)

		self.count_text_4_ = self.count_text_4_ + jetton_ratio
		self.count_num_4_:setString(self.count_text_4_)
		self.count_num_4_:setVisible(true)
	end

	--判断是否超出庄家最大赔损范围
	self.text_countscore_ = self.count_text_1_ + self.count_text_2_ + self.count_text_3_ + self.count_text_4_
	if	banker_name ~= LocalLanguage:getLanguageString("L_45a3acaf08fe01c8") then
		--庄家承受范围
		if self.text_countscore_ >= banker_limit_score /10 then
			-- WarnTips.showTips(
			-- {
			-- 	text = "已经是所有闲家最大押注范围了！",
			-- 	style = WarnTips.STYLE_Y
			-- })
			self:allhideJetton()
		end				
	end

end
--刷新当前自己当前押注总分数
function GameScene:refreshJettonNum()
	self.myjetton_countscore_ = self.myjetton_text_1_ + self.myjetton_text_2_ + self.myjetton_text_3_ + self.myjetton_text_4_
	self:switchJettonShow()
	self.right_player_score_:setString(GameScene.score_ - self.myjetton_countscore_)
	-- self.left_banker_score_ :setString(GameScene.score_)
	print("我押注的总分数.....",self.myjetton_countscore_)
end

--下注筹码显示
function GameScene:showJetton()
	self.jetton_root_:setVisible(true)
end
function GameScene:hideJetton()
	self.jetton_root_:setVisible(false)	
end

---------------------------结束--------------------------------


-------------------------玩家输赢面板--------------------------
local win_bankscore    = 0
local win_myscore      = 0
local win_returnscocre = 0
function GameScene:winPlayerMsg()
	self.myscore_lab_  :setString(win_myscore)
	self.myreturn_lab_ :setString(win_returnscocre)
	self.banker_lab_   :setString(win_bankscore)
	self.winmsg_root_  :setVisible(true)
	self.right_player_score_:setString(GameScene.score_)
	if player_zhanji >0 then
		self.right_player_result_:setString(player_zhanji)
	else
		self.right_player_result_:setString(0)
	end
	--更新庄家信息
	self.left_banker_result_ :setString(banker_zhanji)
	
	if banker_name == LocalLanguage:getLanguageString("L_45a3acaf08fe01c8") then
		self.left_banker_score_	 :setString(0)
	else
		self.left_banker_score_	 :setString(banker_score)
	end
	

	if win_myscore > 0 then
		AudioEngine.playEffect("bairenniuniu/res/sound/END_WIN.wav")
	elseif  win_myscore < 0 then
		AudioEngine.playEffect("bairenniuniu/res/sound/END_LOST.wav")
	end
end
---------------------------------------------------------------




----------------------------cards时部分-------------------------
local cards   = {}
cards = {10,2,3,4,5,
		 13,11,7,4,10,
		 7,16,14,18,22,
		 9,20,24,26,28,
		 6,8,39,40,46
		}

local cardSpr      = {}
--用于创建好的牌,转换按筛子发牌的顺序(1-5第一家，2-10第二家)
local paiCard     = {}
--用于转换成1-30按(1,6,11,16,21,发牌第一圈儿)
local fapaiCardSpr = {}
local fapaiNum = 1	

--开牌动作计时器,计算次数
local card_num  = 0
--开牌骰子，从那家开始拿牌(默认庄家)
local cardID    = 0
--从服务器信息转换过来的25张牌的数值
local cardsReal = {}

local Result_Cards = {}           --获取类型时,临时保存每组的数值
local test_type    = {}			  --获取类型返回的类型存储表,一共5组,5个值
local sort_cards   = {}           --获取类型返回的第一张和第三张确定的牌值
local showcardSpr  = {}           --亮牌时,有序的牌的table
local win_player   = {}           --获胜玩家

--亮牌牛牛的最终位置
local niuniuSpr    = {}
--亮牌输赢的标志
local winplayerSpr = {}
--开牌时显示的第一张牌,确定开牌位置
function GameScene:StartCard(cardID)
	self.cardSpr_ = cc.Sprite:create("bairenniuniu/res/cards/GAME_CARD_0"..string.format("%02d",cardID-1)..".png")
	self.cardSpr_:setPosition(cc.p(winSize.width/2,winSize.height/2+50))
	self:addChild(self.cardSpr_)

	card_num = 0
	--创建一个自定义的时间监听器
	self.cardHandler_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.onCardTimer), 0.3, false)


    ---------------------测试牌的类型----------------------
	local test_NumBome    = {1,14,27,40,2}    --x x x x 2
	local test_NumBone2   = {2,1,14,27,40}    --2 x x x x
	local test_NUmBoneW   = {53,54,3,16,2}    --w w x x 2
	local test_NUmBoneW2  = {53,54,2,14,1}    --w w 2 x x
	local test_NUmBoneW1  = {53,3,16,29,1}    --w x x x 2
	local test_NUmBoneW1_2= {53,1,3,16,29}    --w 2 x x x
	local test_NUmNiuKing = {53,11,12,13,26}  --w J Q K K
	local test_NUmNiuYin  = {53,10,12,13,26}  --w J Q K K
	local test_NUmNiuDW   = {54,53,12,1,2}    --w w J 2 2
	local test_NUmNiuXW   = {53,10,12,1,2}    --w w J 2 2
	local test_NUmNiuXW_1 = {53,1,9,2,3}      --w 10(1+9)
	local test_NUmNiuXW_2 = {53,11,4,2,3}     --w 10(1+9)
	local test_NUmXW_1    = {53,5,9,1,10}     --w 10(1+9)

	local test_NUmNiuNiu_1= {10,11,8,1,14}    --J Q 10(8+1+1)
	local test_NUmNiu_5   = {10,11,8,2,5}    --J  Q 10(8+2)

	local test_NUmNiuNiuW = {53,4,8,2,5}    --w  Q 10(8+2)
	local test_NUmW_6     = {53,4,7,2,5}    --w  Q 10(8+2)

	local test_NUmNiu_8   = {10,3,8,2,5}     --J  x 10(8+2)
	--修改部分
	-- local test_NUmNiu_3   = {24,23,21,32,16}     --J  x 10(8+2)
	-- local test_NUmNiu_3   = {11,35,20,19,1}     --J  x 10(8+2)
	-- local test_NUmNiu_3   = {54,33,48,47,29}     --J  x 10(8+2)
	-- local result_Num      = {}
	-- local test_type_Bone  = self:getCardType(test_NumBome,result_Num)
	-- local test_type_Bone2 = self:getCardType(test_NumBone2,result_Num)
	-- local test_NUmBoneW   = self:getCardType(test_NUmBoneW,result_Num)
	-- local test_NUmBoneW2  = self:getCardType(test_NUmBoneW2,result_Num)
	-- local test_NUmBoneW1  = self:getCardType(test_NUmBoneW1,result_Num)
	-- local test_NUmBoneW1_2= self:getCardType(test_NUmBoneW1_2,result_Num)
	-- local test_NUmNiuKing = self:getCardType(test_NUmNiuKing,result_Num)
	-- local test_NUmNiuYin  = self:getCardType(test_NUmNiuYin,result_Num)
	-- local test_NUmNiuDW   = self:getCardType(test_NUmNiuDW,result_Num)
	-- local test_NUmNiuXW   = self:getCardType(test_NUmNiuXW,result_Num)
	-- local test_NUmNiuXW_1 = self:getCardType(test_NUmNiuXW_1,result_Num)
	-- local test_NUmNiuXW_2 = self:getCardType(test_NUmNiuXW_2,result_Num)
	-- local test_NUmXW_1    = self:getCardType(test_NUmXW_1,result_Num)
	-- local test_NUmNiuNiu_1= self:getCardType(test_NUmNiuNiu_1,result_Num)
	-- local test_NUmNiu_5   = self:getCardType(test_NUmNiu_5,result_Num)
	-- local test_NUmNiuNiuW = self:getCardType(test_NUmNiuNiuW,result_Num)
	-- local test_NUmW_6     = self:getCardType(test_NUmW_6,result_Num)
	-- local test_NUmNiu_8   = self:getCardType(test_NUmNiu_8,result_Num)
	-- local test_NUmNiu_3   = self:getCardType(test_NUmNiu_3,result_Num)

	-- print("确定类型是:",test_type_Bone)
	-- print("确定类型是:",test_type_Bone2)
	-- print("确定类型是:",test_NUmBoneW)
	-- print("确定类型是:",test_NUmBoneW2)
	-- print("确定类型是:",test_NUmBoneW1)
	-- print("确定类型是:",test_NUmBoneW1_2)
	-- print("确定类型是:",test_NUmNiuKing)
	-- print("确定类型是:",test_NUmNiuYin)
	-- print("确定类型是:",test_NUmNiuDW)
	-- print("确定类型是:",test_NUmNiuXW)
	-- print("确定类型是:",test_NUmNiuXW_1)
	-- print("确定类型是:",test_NUmNiuXW_2)
	-- print("确定类型是:",test_NUmXW_1)
	-- print("确定类型是:",test_NUmNiuNiu_1)
	-- print("确定类型是:",test_NUmNiu_3)

	-- for k=1,5 do
	-- 	print("确定类型牌值是:",result_Num[k])
	-- end
end

--开牌的计时器
function GameScene:onCardTimer()
	card_num = card_num + 1
	if card_num == 3 then
		self.cardSpr_:setVisible(false)
		self:removeChild(self.cardSpr_)
	elseif card_num == 47 then
		self:onStopCardTimer()
		card_num = 0
	elseif fapaiNum >=26 then
		 if card_num == 30 then
		 	self:setFaPaiPos()
		 elseif card_num == 34 then
		 	fapaiNum = fapaiNum+1
		 	self:setFaPaiPos()
		 elseif card_num == 38 then
		 	fapaiNum = fapaiNum+1
		 	self:setFaPaiPos()
		 elseif card_num == 42 then
		 	fapaiNum = fapaiNum+1
		 	self:setFaPaiPos()
		 elseif card_num == 46 then
		 	fapaiNum = fapaiNum+1
		 	self:setFaPaiPos()
		 else
		 	return true
		 end
	elseif card_num > 3 then
		self:setFaPaiPos()
		fapaiCardSpr[fapaiNum]:setVisible(true)
		fapaiNum = fapaiNum+1
		AudioEngine.playEffect("bairenniuniu/res/sound/OUT_CARD.wav")
	end
	print(card_num)
end

--停止开牌计时器
function GameScene:onStopCardTimer()
	print("停止开牌计时器")
	if self.cardHandler_ then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.cardHandler_)
		self.cardHandler_ = nil
	end

	control_Num = 1
end

--创建将要显示的牌
function GameScene:CreateCards(cards)
	local i = 1
	for k,v in pairs(cards) do
		self.cardSpr = cc.Sprite:create("bairenniuniu/res/cards/GAME_CARD_0"..string.format("%02d",v-1)..".png")
		self.cardSpr:setPosition(cc.p(100+i*20,winSize.height/2))
		self.cardSpr:setVisible(false)
		self:addChild(self.cardSpr)
		table.insert(cardSpr,self.cardSpr)

		i = i + 1
		if k%5 == 3 then
			self.cardSpr = cc.Sprite:create("bairenniuniu/res/cards/GAME_CARD_056.png")
			self.cardSpr:setPosition(cc.p(100+i*20,winSize.height/2))
			self.cardSpr:setVisible(false)
			self:addChild(self.cardSpr)
			table.insert(cardSpr,self.cardSpr)

			i = i + 1
		end
	end
	--创建手视图
	--设置发牌table
	self:paiCards()
	--设置庄，东南西北,发第一圈牌的位置
	self:defCardPos()
	for m = 1,5 do
		self.handSpr = cc.Sprite:create("bairenniuniu/res/cards/HAND.png")
		self.handSpr:setVisible(false)
		self:addChild(self.handSpr)
		table.insert(fapaiCardSpr,self.handSpr)
	end
	--创建亮牌时要现显示的牌
	self:create_showCard()
end
--设置发牌的table,paiCardSpr
function GameScene:paiCards()
	--庄-东-南-西-北
	local card_value = self:getNewCardValue(cardID)
	if card_value%5 == 0 then
		for i=1,#cardSpr do
			table.insert(paiCard,cardSpr[i])
		end
	elseif card_value%5 == 1 then
		for i=1,#cardSpr do
			if (i+6) > 30 then
				table.insert(paiCard,cardSpr[i-24])
			else
				table.insert(paiCard,cardSpr[6+i])
			end
		end
	elseif card_value%5 == 2 then
		for i=1,#cardSpr do
			if (i+12) > 30 then
				table.insert(paiCard,cardSpr[i-18])
			else
				table.insert(paiCard,cardSpr[12+i])
			end
		end
	elseif card_value%5 == 3 then
		for i=1,#cardSpr do
			if (i+18) > 30 then
				table.insert(paiCard,cardSpr[i-12])
			else
				table.insert(paiCard,cardSpr[18+i])
			end
		end	
	elseif card_value%5 == 4 then
		for i=1,#cardSpr do
			if (i+24) > 30 then
				table.insert(paiCard,cardSpr[i-6])
			else
				table.insert(paiCard,cardSpr[24+i])
			end
		end	
	end

	--将cardSpr表中的数据,转化为发牌顺序赋值给fapaiCardSpr
	for n=1,7 do
		for m=1,30 do
			if m%6 == n then
			table.insert(fapaiCardSpr,paiCard[m])
			end
			if n == 7 then
				if m%6 == 0 then
					table.insert(fapaiCardSpr,paiCard[m])
				end
			end
		end
	end
end
--开始发牌,以及位置
function GameScene:setFaPaiPos()
    if fapaiNum/5 > 1 then
		if (fapaiNum/5) <= 2 then
			fapaiCardSpr[fapaiNum]  :setPosition(cc.p(fapaiCardSpr[fapaiNum-5]:getPosition()))
			fapaiCardSpr[fapaiNum-5]:setPositionX(fapaiCardSpr[fapaiNum-5]:getPositionX()-20)
			-- print("fapaiNum/5:"..fapaiNum/5)
		end
	end	
	if fapaiNum/5 > 2 then
		if (fapaiNum/5) <= 3 then
			fapaiCardSpr[fapaiNum]:setPosition(cc.p(fapaiCardSpr[fapaiNum-5]:getPosition()))
			fapaiCardSpr[fapaiNum]:setPositionX(fapaiCardSpr[fapaiNum-5]:getPositionX()+20)
			-- print("fapaiNum/5:"..fapaiNum/5)
		end
	end	
	if fapaiNum/5 > 3 then
		if (fapaiNum/5) <= 4 then
			fapaiCardSpr[fapaiNum]:setPosition(cc.p(fapaiCardSpr[fapaiNum-10]:getPosition()))
			fapaiCardSpr[fapaiNum]:setPositionY(fapaiCardSpr[fapaiNum-10]:getPositionY()-30)
			-- print("fapaiNum/5:"..fapaiNum/5)
		end
	end	
	if fapaiNum/5 > 4 then
		if (fapaiNum/5) <= 5 then
			fapaiCardSpr[fapaiNum]:setPosition(cc.p(fapaiCardSpr[fapaiNum-5]:getPosition()))
			fapaiCardSpr[fapaiNum]:setPositionX(fapaiCardSpr[fapaiNum-5]:getPositionX()+20)
			-- print("fapaiNum/5:"..fapaiNum/5)
		end
	end
	if fapaiNum/5 > 5 then
		if (fapaiNum/5) <= 6 then
			-- print("fapaiNum/5:"..fapaiNum/5)
			local moveAction = cc.MoveBy:create(0.3,cc.p(50,0))
			local rmoveAction= moveAction:reverse() 
			local sequenceA  = cc.Sequence:create(
												cc.Spawn:create(moveAction,
												cc.CallFunc:create(function()
													fapaiCardSpr[fapaiNum]:setPosition(cc.p(fapaiCardSpr[fapaiNum-10]:getPosition()))
													fapaiCardSpr[fapaiNum-5]:setLocalZOrder(fapaiCardSpr[fapaiNum]:getLocalZOrder() +1)
													fapaiCardSpr[fapaiNum]:setVisible(true)
													fapaiCardSpr[fapaiNum-10]:setVisible(false)	
												end)),
												rmoveAction,
												cc.CallFunc:create(function()
													fapaiCardSpr[fapaiNum+5]:setVisible(false)
													self:startShowCard()                              --调用,作为牛牛牌展示的接口
												end))
			fapaiCardSpr[fapaiNum+5]:setPosition(cc.p(fapaiCardSpr[fapaiNum-10]:getPositionX()-45,fapaiCardSpr[fapaiNum-10]:getPositionY()-10))
			fapaiCardSpr[fapaiNum+5]:setVisible(true)
			fapaiCardSpr[fapaiNum-5]:runAction(sequenceA)
		end
	end					
end
--发牌的基准位置
function GameScene:defCardPos()
	if fapaiCardSpr == nil then
		return true
	end
	local card_value = self:getNewCardValue(cardID)
	if card_value%5 == 0 then
		fapaiCardSpr[1]:setPosition(cc.p(winSize.width/2,winSize.height/2+200))
		fapaiCardSpr[2]:setPosition(cc.p(winSize.width*0.3-20,winSize.height/2-50))
		fapaiCardSpr[3]:setPosition(cc.p(winSize.width*0.4+30,winSize.height/2-50))
		fapaiCardSpr[4]:setPosition(cc.p(winSize.width*0.6-30,winSize.height/2-50))
		fapaiCardSpr[5]:setPosition(cc.p(winSize.width*0.7+30,winSize.height/2-50))
	elseif card_value%5 == 1 then
		fapaiCardSpr[5]:setPosition(cc.p(winSize.width/2,winSize.height/2+200))
		fapaiCardSpr[1]:setPosition(cc.p(winSize.width*0.3-20,winSize.height/2-50))
		fapaiCardSpr[2]:setPosition(cc.p(winSize.width*0.4+30,winSize.height/2-50))
		fapaiCardSpr[3]:setPosition(cc.p(winSize.width*0.6-30,winSize.height/2-50))
		fapaiCardSpr[4]:setPosition(cc.p(winSize.width*0.7+30,winSize.height/2-50))
	elseif card_value%5 == 2 then
		fapaiCardSpr[4]:setPosition(cc.p(winSize.width/2,winSize.height/2+200))
		fapaiCardSpr[5]:setPosition(cc.p(winSize.width*0.3-20,winSize.height/2-50))
		fapaiCardSpr[1]:setPosition(cc.p(winSize.width*0.4+30,winSize.height/2-50))
		fapaiCardSpr[2]:setPosition(cc.p(winSize.width*0.6-30,winSize.height/2-50))
		fapaiCardSpr[3]:setPosition(cc.p(winSize.width*0.7+30,winSize.height/2-50))
	elseif card_value%5 == 3 then
		fapaiCardSpr[3]:setPosition(cc.p(winSize.width/2,winSize.height/2+200))
		fapaiCardSpr[4]:setPosition(cc.p(winSize.width*0.3-20,winSize.height/2-50))
		fapaiCardSpr[5]:setPosition(cc.p(winSize.width*0.4+30,winSize.height/2-50))
		fapaiCardSpr[1]:setPosition(cc.p(winSize.width*0.6-30,winSize.height/2-50))
		fapaiCardSpr[2]:setPosition(cc.p(winSize.width*0.7+30,winSize.height/2-50))
	elseif card_value%5 == 4 then
		fapaiCardSpr[2]:setPosition(cc.p(winSize.width/2,winSize.height/2+200))
		fapaiCardSpr[3]:setPosition(cc.p(winSize.width*0.3-20,winSize.height/2-50))
		fapaiCardSpr[4]:setPosition(cc.p(winSize.width*0.4+30,winSize.height/2-50))
		fapaiCardSpr[5]:setPosition(cc.p(winSize.width*0.6-30,winSize.height/2-50))
		fapaiCardSpr[1]:setPosition(cc.p(winSize.width*0.7+30,winSize.height/2-50))
	end
end

local control_Num = 1
function GameScene:startShowCard()
	
	local cardID_value = self:getNewCardValue(cardID)
	if cardID_value%5 == 0 then
		for i=1,5 do
			showcardSpr[5*(control_Num-1)+i]:setVisible(true)
		end
	elseif cardID_value%5 == 1 then
		for i=1,5 do
			if control_Num == 5 then
				showcardSpr[i]:setVisible(true)
			else
				showcardSpr[5+5*(control_Num-1)+i]:setVisible(true)
			end
		end
	elseif cardID_value%5 == 2 then
		for i=1,5 do
			if control_Num >= 4 then
				showcardSpr[5*(control_Num-4)+i]:setVisible(true)
			else
				showcardSpr[10+5*(control_Num-1)+i]:setVisible(true)
			end
		end
	elseif cardID_value%5 == 3 then
		for i=1,5 do
			if control_Num >= 3 then
				showcardSpr[5*(control_Num-3)+i]:setVisible(true)
			else
				showcardSpr[15+5*(control_Num-1)+i]:setVisible(true)
			end
		end
	elseif cardID_value%5 == 4 then
		for i=1,5 do
			if control_Num >= 2 then
				showcardSpr[5*(control_Num-2)+i]:setVisible(true)
			else
				showcardSpr[20+5*(control_Num-1)+i]:setVisible(true)
			end
		end
	end
	for i=1,6 do
		fapaiCardSpr[control_Num+5*(i-1)]:setVisible(false)
	end
	control_Num = control_Num + 1
	if control_Num == 6 then
		control_Num = 1
		self:end_showCard()      --显示牛牛
		AudioEngine.playEffect("bairenniuniu/res/sound/END_DRAW.wav")
	end
	print("调用了 哈哈！")
end

function GameScene:create_showCard()
	for k,v in ipairs(sort_cards) do
		self.cardSpr = cc.Sprite:create("bairenniuniu/res/cards/GAME_CARD_0"..string.format("%02d",v-1)..".png")
		self.cardSpr:setPosition(cc.p(100+k*20,winSize.height/2+150))
		self.cardSpr:setVisible(false)
		self:addChild(self.cardSpr)
		table.insert(showcardSpr,self.cardSpr)
	end
	-- print("sort_cards = ",#sort_cards)
	-- print("showcardSpr = ",#showcardSpr)

	self:def_showCard()
end

--设置亮牌初始的位置
function GameScene:def_showCard()
	showcardSpr[1] :setPosition(cc.p(winSize.width/2-30,winSize.height/2+200))
	showcardSpr[6] :setPosition(cc.p(winSize.width*0.3-50,winSize.height/2-50))
	showcardSpr[11]:setPosition(cc.p(winSize.width*0.4,winSize.height/2-50))
	showcardSpr[16]:setPosition(cc.p(winSize.width*0.6-60,winSize.height/2-50))
	showcardSpr[21]:setPosition(cc.p(winSize.width*0.7,winSize.height/2-50))
	--庄
	showcardSpr[2] :setPosition(cc.p(winSize.width/2-30+20,winSize.height/2+200))
	showcardSpr[3] :setPosition(cc.p(winSize.width/2-30+20,winSize.height/2+200-30))
	showcardSpr[4] :setPosition(cc.p(winSize.width/2-30+40,winSize.height/2+200-30))
	showcardSpr[5] :setPosition(cc.p(winSize.width/2-30+60,winSize.height/2+200-30))
	--东
	showcardSpr[7] :setPosition(cc.p(winSize.width*0.3-50+20,winSize.height/2-50))
	showcardSpr[8] :setPosition(cc.p(winSize.width*0.3-50+20,winSize.height/2-50-30))
	showcardSpr[9] :setPosition(cc.p(winSize.width*0.3-50+40,winSize.height/2-50-30))
	showcardSpr[10]:setPosition(cc.p(winSize.width*0.3-50+60,winSize.height/2-50-30))
	--南
	showcardSpr[12]:setPosition(cc.p(winSize.width*0.4+20,winSize.height/2-50))
	showcardSpr[13]:setPosition(cc.p(winSize.width*0.4+20,winSize.height/2-50-30))
	showcardSpr[14]:setPosition(cc.p(winSize.width*0.4+40,winSize.height/2-50-30))
	showcardSpr[15]:setPosition(cc.p(winSize.width*0.4+60,winSize.height/2-50-30))
	--西
	showcardSpr[17]:setPosition(cc.p(winSize.width*0.6-60+20,winSize.height/2-50))
	showcardSpr[18]:setPosition(cc.p(winSize.width*0.6-60+20,winSize.height/2-50-30))
	showcardSpr[19]:setPosition(cc.p(winSize.width*0.6-60+40,winSize.height/2-50-30))
	showcardSpr[20]:setPosition(cc.p(winSize.width*0.6-60+60,winSize.height/2-50-30))
	--北
	showcardSpr[22]:setPosition(cc.p(winSize.width*0.7+20,winSize.height/2-50))
	showcardSpr[23]:setPosition(cc.p(winSize.width*0.7+20,winSize.height/2-50-30))
	showcardSpr[24]:setPosition(cc.p(winSize.width*0.7+40,winSize.height/2-50-30))
	showcardSpr[25]:setPosition(cc.p(winSize.width*0.7+60,winSize.height/2-50-30))
end

function GameScene:end_showCard()
	for i=1,#test_type do
		if test_type[i] == 1 then
			for j=3,5 do
				showcardSpr[(i-1)*5+j]:setPosition(cc.p(showcardSpr[(i-1)*5+2]:getPositionX()+20*(j-2),showcardSpr[(i-1)*5+2]:getPositionY()))
			end
		end
	end
	for k,v in ipairs(test_type) do
		if k == 1 then
			self.banker_niu_:loadTexture("bairenniuniu/res/cards/CARDTYPE_0"..string.format("%02d",v)..".png")
			self.banker_niu_:setVisible(true)
		elseif k==2 then
			self.east_niu_:loadTexture("bairenniuniu/res/cards/CARDTYPE_0"..string.format("%02d",v)..".png")
			self.east_niu_:setVisible(true)
		elseif k==3 then
			self.south_niu_:loadTexture("bairenniuniu/res/cards/CARDTYPE_0"..string.format("%02d",v)..".png")
			self.south_niu_:setVisible(true)
		elseif k==4 then
			self.west_niu_:loadTexture("bairenniuniu/res/cards/CARDTYPE_0"..string.format("%02d",v)..".png")
			self.west_niu_:setVisible(true)
		elseif k==5 then
			self.north_niu_:loadTexture("bairenniuniu/res/cards/CARDTYPE_0"..string.format("%02d",v)..".png")
			self.north_niu_:setVisible(true)		
		end
	end



	local win_record = {}
	for k,v in ipairs(win_player) do
		if k==1 then
			if v == 1 then
				self.east_win_:loadTexture("bairenniuniu/res/win/win.png")
			else
				self.east_win_:loadTexture("bairenniuniu/res/win/lost.png")
			end
			self.east_win_:setVisible(true)
			win_record.east = v
		elseif k==2 then
			if v == 1 then
				self.south_win_:loadTexture("bairenniuniu/res/win/win.png")
			else
				self.south_win_:loadTexture("bairenniuniu/res/win/lost.png")
			end
			self.south_win_:setVisible(true)
			win_record.south = v
		elseif k==3 then
			if v == 1 then
				self.west_win_:loadTexture("bairenniuniu/res/win/win.png")
			else
				self.west_win_:loadTexture("bairenniuniu/res/win/lost.png")
			end
			self.west_win_:setVisible(true)
			win_record.west = v
		elseif k==4 then
			if v == 1 then
				self.north_win_:loadTexture("bairenniuniu/res/win/win.png")
			else
				self.north_win_:loadTexture("bairenniuniu/res/win/lost.png")
			end
			self.north_win_:setVisible(true)
			win_record.north = v
		end
	end

	--游戏记录
	table.insert(record_msg,win_record)
	table.insert(record_type,record_jetton)
	--更新游戏记录
	self:addRecordlistItem()
	-- self:btnGameRecord()
	self:winPlayerMsg()
end

function GameScene:remove_cards()
	if #fapaiCardSpr>0 then
		for i=1,#fapaiCardSpr do
			fapaiCardSpr[i]:setVisible(false)
			self:removeChild(fapaiCardSpr[i])
		end
	end
	fapaiCardSpr = {}
	cardSpr = {}
	if #paiCard>0 then
		paiCard = {}
	end
	fapaiNum     = 1
	card_num     = 0
	cardID       = 0
    cardsReal    = {}
    Result_Cards = {}
    test_type    = {}
    sort_cards   = {}
    if #showcardSpr >0 then
    	for i=1,#showcardSpr do
			showcardSpr[i]:setVisible(false)
			self:removeChild(showcardSpr[i])
		end
    end
    showcardSpr = {}
    --胜利标志
    self.east_win_ :setVisible(false)
	self.south_win_:setVisible(false)
	self.west_win_ :setVisible(false)
	self.north_win_:setVisible(false)
	--牛牛标志
	self.banker_niu_:setVisible(false)
	self.east_niu_  :setVisible(false)
	self.south_niu_ :setVisible(false)
	self.west_niu_  :setVisible(false)
	self.north_niu_ :setVisible(false)
	--玩家信息板
	self.winmsg_root_:setVisible(false)

	--东南西北下注筹码显示模块
	if #JettonSpr >0 then
		for i=1,#JettonSpr do
			JettonSpr[i]:setVisible(false)
			self:removeChild(JettonSpr[i])
		end
	end
	JettonSpr = {}

	self.count_text_1_ = 0
	self.count_text_2_ = 0
	self.count_text_3_ = 0
	self.count_text_4_ = 0
	self.myjetton_text_1_ = 0
	self.myjetton_text_2_ = 0
	self.myjetton_text_3_ = 0
	self.myjetton_text_4_ = 0
	self.count_num_1_:setString(0)
	self.count_num_2_:setString(0)
	self.count_num_3_:setString(0)
	self.count_num_4_:setString(0)
	self.count_num_1_:setVisible(false)
	self.count_num_2_:setVisible(false)
	self.count_num_3_:setVisible(false)
	self.count_num_4_:setVisible(false)
	self.myjetton_num_1_:setString(0)
	self.myjetton_num_2_:setString(0)
	self.myjetton_num_3_:setString(0)
	self.myjetton_num_4_:setString(0)
	self.myjetton_num_1_:setVisible(false)
	self.myjetton_num_2_:setVisible(false)
	self.myjetton_num_3_:setVisible(false)
	self.myjetton_num_4_:setVisible(false)
	self.myjetton_countscore_ = 0
	self.text_countscore_ = 0
-- local Result_Cards = {}           --获取类型时,临时保存每组的数值
-- local test_cards   = {}           --获取类型时要用到的临时数据表(5个值一组)
-- local test_type    = {}			  --获取类型返回的类型存储表,一共5组,5个值
-- local sort_cards   = {}           --获取类型返回的第一张和第三张确定的牌值
-- local showcardSpr  = {}           --亮牌时,有序的牌的table
end



---------------------------以上是card部分---------------------

----------------------------逻辑类模块------------------------
local cardsData = {
				   1 ,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13,
				   17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
				   33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 
				   49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
				   65, 66
				  }
local cardsDefault = {
					  1 ,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13,
					  14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,
					  27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
					  40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52,
					  53, 54
					}
local	CT_POINT			= 1
local	CT_SPECIAL_NIU1		= 2
local	CT_SPECIAL_NIU2		= 3
local	CT_SPECIAL_NIU3		= 4
local	CT_SPECIAL_NIU4		= 5
local	CT_SPECIAL_NIU5		= 6
local 	CT_SPECIAL_NIU6		= 7
local	CT_SPECIAL_NIU7		= 8
local 	CT_SPECIAL_NIU8		= 9
local 	CT_SPECIAL_NIU9		= 10
local 	CT_SPECIAL_NIUNIU	= 11
local	CT_SPECIAL_NIUNIUXW	= 11
local	CT_SPECIAL_NIUNIUDW	= 11
local	CT_SPECIAL_NIUYING	= 12  --金牛 JQK大小王组成的5张牌
local	CT_SPECIAL_NIUKING	= 13  --银牛 JQK大小王占4张牌
local	CT_SPECIAL_BOMEBOME	= 14  --炸弹 四张一样的牌				
--将服务器发过来的cardsValue转化为这里需要的数值,并返回一个牌值的table
function GameScene:getCardData(cardsData,cardsNum)
	local cards = {}
	for k,v in pairs(cardsNum) do
		for m,n in pairs(cardsData) do
			if v == n then
				table.insert(cards,m)
			end
		end
	end
	return cards
end

--获取牌的花色(1-54)
--[[
	1 -13 方块A-K 代号:1
	14-26 梅花A-K 代号:2
	27-39 红桃A-K 代号:3
	40-52 黑桃A-K 代号:4
	53-54 小-大王 代号:5
--]]
function GameScene:getCardColor(cards_Num)
	if cards_Num <= 13 then
		return 1
	elseif cards_Num <= 26 then
		return 2
	elseif cards_Num <= 39 then
		return 3
	elseif cards_Num <= 52 then
		return 4
	else
		return 5
	end
end
--获取牌值的大小(A-K)
function GameScene:getCardValue(cards_Num)
	local cards_Value = cards_Num % 13
	if cards_Value == 0 then 
		return 13
	else
		return cards_Value
	end
end
--获取逻辑牌值的大小用于游戏比较大小(J,Q,K=10，小，大王=11)
function GameScene:getLogicCardValue(cards_Num)
	local cValue = self:getCardValue(cards_Num)
	--获取花色
	local cColor = self:getCardColor(cards_Num)

	if cValue > 10 then
		cValue = 10;
	elseif cColor==5 then
		cValue = 11;
	end
	return cValue;
end
--用于排序和判断5张牌的组合类型(牛几牛几)
function GameScene:getNewCardValue(cards_Num)
	local cardValue = self:getCardValue(cards_Num)
	local cardColor = self:getCardColor(cards_Num)
	if cardColor == 5 then
		cardValue = cardValue + 13 + 2         --(值是16,17)
	end
	return cardValue
end
--对扑克数据进行一下排序(5个一组)
function GameScene:sortCard(cards)
	local cbCards = {}
	for k = 1,#cards do
		cbCards[k] = self:getNewCardValue(cards[k])
		-- print("排序前获取的值cbCards",k,"=",cbCards[k])
	end
	local sSorted = true;
	local cbcards_num = 0;
	for j = 1,#cards-1 do
		for i = 1,#cards-j do
			-- print("排序前获取的值cbCards",cbCards[i],cbCards[i+1])
			if cbCards[i] < cbCards[i+1] then
				cbcards_num = cards[i]
				cards[i]    = cards[i+1]
				cards[i+1]  = cbcards_num

				cbcards_num = cbCards[i]
				cbCards[i]  = cbCards[i+1]
				cbCards[i+1]= cbcards_num
			elseif cbCards[i] == cbCards[i+1] then
				if cards[i] < cards[i+1] then
					cbcards_num = cards[i]
					cards[i]    = cards[i+1]
					cards[i+1]  = cbcards_num

					cbcards_num = cbCards[i]
					cbCards[i]  = cbCards[i+1]
					cbCards[i+1]= cbcards_num
				end
			end 
		end
	end
	-- for i = 1,#cards do
	-- 	print("排序完成输出排序后的值:cbCards[",i,"]=",cbCards[i])
	-- 	print("排序完成输出排序后的值:cards[",i,"]=",cards[i])
	-- end	
end

--返回牛牛类型
function GameScene:RetType(type_Num)
	type_Num = type_Num%10
	if type_Num == 0 then
		return CT_SPECIAL_NIUNIU
	elseif  type_Num == 1 then
		return CT_SPECIAL_NIU1
	elseif  type_Num == 2 then
		return CT_SPECIAL_NIU2
	elseif  type_Num == 3 then
		return CT_SPECIAL_NIU3
	elseif  type_Num == 4 then
		return CT_SPECIAL_NIU4
	elseif  type_Num == 5 then
		return CT_SPECIAL_NIU5
	elseif  type_Num == 6 then
		return CT_SPECIAL_NIU6
	elseif  type_Num == 7 then
		return CT_SPECIAL_NIU7
	elseif  type_Num == 8 then
		return CT_SPECIAL_NIU8
	elseif  type_Num == 9 then
		return CT_SPECIAL_NIU9
	else
		return CT_POINT
	end
end	

function GameScene:getCardType(cards,showcards)
	--对传进来的table进行一次排序(由大到小)
	self:sortCard(cards)

	--特殊类型CT_SPECIAL_BOMEBOME(炸弹)
	if self:getNewCardValue(cards[1]) == self:getNewCardValue(cards[4]) then
		for i=1,#cards do
			showcards[i] = cards[i]
		end
		return CT_SPECIAL_BOMEBOME
	elseif self:getNewCardValue(cards[2]) == self:getNewCardValue(cards[5]) then
		for i=1,#cards do
			showcards[i] = cards[i]
		end
		return CT_SPECIAL_BOMEBOME
	end
	--有大小王的炸弹类型
	if self:getCardColor(cards[1]) == 5 and self:getCardColor(cards[2]) == 5 then
		if self:getNewCardValue(cards[3]) == self:getNewCardValue(cards[4]) then
			showcards[1] = cards[3]
			showcards[2] = cards[4]
			showcards[3] = cards[1]
			showcards[4] = cards[2]
			showcards[5] = cards[5]
			return CT_SPECIAL_BOMEBOME
		elseif self:getNewCardValue(cards[4]) == self:getNewCardValue(cards[5]) then
			showcards[1] = cards[3]
			showcards[2] = cards[5]
			showcards[3] = cards[1]
			showcards[4] = cards[2]
			showcards[5] = cards[4]			
			return CT_SPECIAL_BOMEBOME
		end
	end
	--只有一张王的炸弹类型
	if self:getCardColor(cards[1]) == 5 then
		if self:getNewCardValue(cards[2]) == self:getNewCardValue(cards[4]) then
			showcards[1] = cards[1]
			showcards[2] = cards[5]
			showcards[3] = cards[2]
			showcards[4] = cards[3]
			showcards[5] = cards[4]
			return CT_SPECIAL_BOMEBOME
		elseif self:getNewCardValue(cards[3]) == self:getNewCardValue(cards[5]) then
			showcards[1] = cards[1]
			showcards[2] = cards[2]
			showcards[3] = cards[3]
			showcards[4] = cards[4]
			showcards[5] = cards[5]
			return CT_SPECIAL_BOMEBOME
		end
	end


	--CT_SPECIAL_NIUKING金牛和CT_SPECIAL_NIUYING银牛
	local isTrue = true
	local iValue = 0

	for i=1,#cards do
		if self:getLogicCardValue(cards[i]) ~= 10 and self:getLogicCardValue(cards[i]) ~= 11 then
			isTrue = false
			break
		elseif self:getNewCardValue(cards[i]) == 10 then
			iValue = iValue + 1
		end
	end
	if isTrue then
		for i=1,#cards do
			showcards[i] = cards[i]
		end
		if iValue == 0 then
			return CT_SPECIAL_NIUKING
		elseif iValue == 1 then
			return CT_SPECIAL_NIUYING
		end
	end

	--存在大小王的牛牛
	local iGetTenCount = 0
	for i=1,#cards do
		if self:getLogicCardValue(cards[i]) == 10 or self:getLogicCardValue(cards[i]) == 11 then
			iGetTenCount = iGetTenCount + 1
		end
	end
	if iGetTenCount >= 3 then
		if self:getCardColor(cards[1]) == 5 and self:getCardColor(cards[2]) == 5 then
			showcards[1] = cards[2]
			showcards[2] = cards[3]
			showcards[3] = cards[1]
			showcards[4] = cards[4]
			showcards[5] = cards[5]
			return CT_SPECIAL_NIUNIUDW
		elseif self:getCardColor(cards[1]) == 5 then
			--大小王和最小的组合成牛
			showcards[1] = cards[2]
			showcards[2] = cards[3]
			showcards[3] = cards[1]
			showcards[4] = cards[4]
			showcards[5] = cards[5]
			if cards[1] == 54 then
				return CT_SPECIAL_NIUNIUDW
			else
				return CT_SPECIAL_NIUNIUXW
			end
		else
			showcards[1] = cards[4]
			showcards[2] = cards[5]
			showcards[3] = cards[1]
			showcards[4] = cards[2]
			showcards[5] = cards[3]
			return self:RetType(self:getLogicCardValue(cards[4])+self:getLogicCardValue(cards[5]))	
		end
	end

	--存在两张逻辑值是10的牌，或者一张王牌
	if iGetTenCount == 2 or self:getCardColor(cards[1]) == 5 then
		-- print("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
		if self:getCardColor(cards[1]) == 5 and self:getCardColor(cards[2]) == 5 then
			showcards[1] = cards[2]
			showcards[2] = cards[3]
			showcards[3] = cards[1]
			showcards[4] = cards[4]
			showcards[5] = cards[5]
			return CT_SPECIAL_NIUNIUDW
		elseif self:getCardColor(cards[1]) == 5 then
			-- print("www111111111111111111111111111")
			--如果有一张王,其他任意三张组合为10则是牛牛
			for i=2,#cards do
				for j=2,#cards do
					if j ~= i then
						for k=2,#cards do
							if k~=i and k~=j then
								if (self:getLogicCardValue(cards[i])+self:getLogicCardValue(cards[j])+self:getLogicCardValue(cards[k]))%10 == 0 then
									local otherC = 0
									for y=2,#cards do
										if y~=i and y~=k and y~=j then
											otherC = y
										end
									end
									showcards[1] = cards[1]
									showcards[2] = cards[otherC]
									showcards[3] = cards[i]
									showcards[4] = cards[j]
									showcards[5] = cards[k]
									if cards[1] == 54 then
										return CT_SPECIAL_NIUNIUDW
									else
										return CT_SPECIAL_NIUNIUXW
									end									
								end
							end
						end
					end
				end
			end
			--如果有一张王 其他任意三张组合不为0 则取两张点数最大的组合
			-- print("000000000000000000000000000000000000")
			local bigNum        = 0
			local cardNum_Other = {}
			for i = 2,#cards do
				for j = 2,#cards do
					if i~=j then
						local bcLogicNum = (self:getLogicCardValue(cards[i])+self:getLogicCardValue(cards[j]))%10
						if bcLogicNum == 0 then
							bcLogicNum = 10
						end
						if bcLogicNum > bigNum then
							bigNum = bcLogicNum
							if i > j then
								cardNum_Other[3] = cards[j]
								cardNum_Other[4] = cards[i]
							else
								cardNum_Other[3] = cards[i]
								cardNum_Other[4] = cards[j]
							end
							local other_Num = 1
							for y=2,#cards do
								if y~=i and y~=j then
									cardNum_Other[other_Num] = cards[y]
									other_Num = other_Num + 1
								end
							end
						end
					end
				end
			end
			if bigNum == 10 then
				showcards[1] = cardNum_Other[3]
				showcards[2] = cardNum_Other[4]
				showcards[3] = cards[1]
				showcards[4] = cardNum_Other[1]
				showcards[5] = cardNum_Other[2]
				if cards[1] == 54 then
					return CT_SPECIAL_NIUNIUDW
				else
					return CT_SPECIAL_NIUNIUXW
				end									
			else
				showcards[1] = cardNum_Other[3]
				showcards[2] = cardNum_Other[4]
				showcards[3] = cards[1]
				showcards[4] = cardNum_Other[1]
				showcards[5] = cardNum_Other[2]
				return self:RetType(self:getLogicCardValue(cardNum_Other[3])+self:getLogicCardValue(cardNum_Other[4])) 	
			end
		--没有王的情况,其他三张相加为10的倍数
		elseif (self:getLogicCardValue(cards[3]) + self:getLogicCardValue(cards[4]) + self:getLogicCardValue(cards[5]))%10 == 0 then
			for i=1,#cards do
				showcards[i] = cards[i]
			end
			return CT_SPECIAL_NIUNIU
		--没有王的情况,两张相加等于10的情况(有牛的情况)
		else
			-- print("1111111111111111111111111111111111111")
			local iBigValue = 0
			local iSingleA  = {}
			for m=3,#cards do
				for n=3,#cards do
					if m~=n then
						if (self:getLogicCardValue(cards[m])+self:getLogicCardValue(cards[n]))%10 == 0 then
							-- print("2222222222222222222222222222222222222222222")
							for y=3,#cards do
								if y~=m and y~=n then
									iSingleA[1] = cards[y]
								end
							end
							if iBigValue <= self:getLogicCardValue(iSingleA[1])%10 then
								iBigValue = self:getLogicCardValue(iSingleA[1])%10
								if m < n then
									showcards[1] = cards[2]
									showcards[2] = iSingleA[1]
									showcards[3] = cards[1]
									showcards[4] = cards[m]
									showcards[5] = cards[n]
								else
									showcards[1] = cards[2]
									showcards[2] = iSingleA[1]
									showcards[3] = cards[1]
									showcards[4] = cards[n]
									showcards[5] = cards[m]
								end
								if iBigValue == 0 then
									return CT_SPECIAL_NIUNIU
								else
									return self:RetType(iBigValue)
								end	 
							end
						end
					end
				end
			end
		end
		iGetTenCount = 1
	end
	if iGetTenCount == 1 then
		if self:getCardColor(cards[1]) == 5 then
			--如果有一张王 其他任意三张组合不为10 则取两张点数最大的组合
			-- print("4444444444444444444444444444")
			local bigNum        = 0
			local cardNum_Other = {}
			for i = 2,#cards do
				for j = 2,#cards do
					if i~=j then
						local bcLogicNum = (self:getLogicCardValue(cards[i])+self:getLogicCardValue(cards[j]))%10
						if bcLogicNum == 0 then
							bcLogicNum = 10
						end
						if bcLogicNum > bigNum then
							bigNum = bcLogicNum
							if i > j then
								cardNum_Other[3] = cards[j]
								cardNum_Other[4] = cards[i]
							else
								cardNum_Other[3] = cards[i]
								cardNum_Other[4] = cards[j]
							end
							local other_Num = 1
							for y=2,#cards do
								if y~=i and y~=j then
									cardNum_Other[other_Num] = cards[y]
									other_Num = other_Num + 1
								end
							end
						end
					end
				end
			end
			if bigNum == 10 then
				showcards[1] = cardNum_Other[3]
				showcards[2] = cardNum_Other[4]
				showcards[3] = cards[1]
				showcards[4] = cardNum_Other[1]
				showcards[5] = cardNum_Other[2]
				if cards[1] == 54 then
					return CT_SPECIAL_NIUNIUDW
				else
					return CT_SPECIAL_NIUNIUXW
				end
			else
				showcards[1] = cardNum_Other[3]
				showcards[2] = cardNum_Other[4]
				showcards[3] = cards[1]
				showcards[4] = cardNum_Other[1]
				showcards[5] = cardNum_Other[2]
				return self:RetType(self:getLogicCardValue(cardNum_Other[3])+self:getLogicCardValue(cardNum_Other[4])) 	
			end	
		end
		--没有王的情况,取4张中任两张组合为10 然后求另外两张的组合看是否是组合中最大
		local iBigValue = 0
		local iSingleA  = {}
		for m=2,#cards do
			for n=2,#cards do
				if m~=n then
					if (self:getLogicCardValue(cards[m])+self:getLogicCardValue(cards[n]))%10 == 0 then
						local num_index = 0
						for y=2,#cards do
							if y~=m and y~=n then
								iSingleA[num_index] = cards[y]
								num_index = num_index + 1
							end
						end
						if iBigValue <= (self:getLogicCardValue(iSingleA[0])+self:getLogicCardValue(iSingleA[1]))%10 then
							iBigValue = (self:getLogicCardValue(iSingleA[0])+self:getLogicCardValue(iSingleA[1]))%10
							if m < n then
								showcards[1] = iSingleA[0]
								showcards[2] = iSingleA[1]
								showcards[3] = cards[1]
								showcards[4] = cards[m]
								showcards[5] = cards[n]
							else
								showcards[1] = iSingleA[0]
								showcards[2] = iSingleA[1]
								showcards[3] = cards[1]
								showcards[4] = cards[n]
								showcards[5] = cards[m]
							end
							if iBigValue == 0 then
								return CT_SPECIAL_NIUNIU
							end	 
						end
					end
				end
			end
		end
			if iBigValue~=0 then
				return self:RetType(iBigValue)
			else
				--组合不成功
				iGetTenCount = 0
			end
	end
	--没有一张是10,或者逻辑值是10的情况
	if iGetTenCount == 0 then
		--取3张看是否有10的倍数的
		-- print("3333333333333333333333333333333333333")
		local iBigValue = 0
		local iSingleA  = {}
		for m=1,#cards do
			for n=1,#cards do
				if n~=m then
					for w=1,#cards do
						if w~=m and w~=n then
							local valueCount = self:getLogicCardValue(cards[m])+self:getLogicCardValue(cards[n])+self:getLogicCardValue(cards[w])
							if valueCount%10 == 0 then
								local num_index = 1
								for y=1,#cards do
									if y~=m and y~=n and y~=w then
										iSingleA[num_index] = cards[y]
										num_index = num_index + 1
									end
								end
								if iBigValue <= (self:getLogicCardValue(iSingleA[1])+self:getLogicCardValue(iSingleA[2]))%10 then
									iBigValue = (self:getLogicCardValue(iSingleA[1])+self:getLogicCardValue(iSingleA[2]))%10
									showcards[1] = iSingleA[1]
									showcards[2] = iSingleA[2]
									showcards[3] = cards[n]
									showcards[4] = cards[m]
									showcards[5] = cards[w]
									if iBigValue == 0 then
										return CT_SPECIAL_NIUNIU
									end
								end
							end
						end
					end
				end
			end
		end
			if iBigValue~=0 then
				return self:RetType(iBigValue)
			end
	end
	-- for i=1,#cards do
	-- 	-- print("showcards",i,"=",showcards[i]
	-- 	showcards[i] = cards[i]
	-- 	print("showcards",i,"=",showcards[i])
	-- end
	showcards[1] = cards[4]
	showcards[2] = cards[5]
	showcards[3] = cards[1]
	showcards[4] = cards[2]
	showcards[5] = cards[3]
	return CT_POINT
end

--返回玩家输赢
function GameScene:getWinPlayer(bankerCards,playerCards)
	--获取牌值类型
	local result_table = {} --getCardType返回的有序table,这里没啥用
	-- for i=1,#bankerCards do
	-- 	print("bankerCards=",bankerCards[i],"playerCards=",playerCards[i])
	-- end
	if #bankerCards == 0 or #playerCards == 0 then
		return 0
	end

	local banker_type = self:getCardType(bankerCards,result_table)
	local player_type = self:getCardType(playerCards,result_table)
	if banker_type ~= player_type then
		if player_type > banker_type then
			return 1
		else
			return -1
		end
	end

	--排序扑克
	self:sortCard(bankerCards)
	self:sortCard(playerCards)
	local bankerValue = self:getNewCardValue(bankerCards[1])
	local playerValue = self:getNewCardValue(playerCards[1])
	local bankerColor = self:getCardColor(bankerCards[1])
	local bankerColor = self:getCardColor(playerCards[1])
	--特殊牌型判断
	if CT_POINT~=banker_type and banker_type == player_type then
		if bankerValue < playerValue then
			return 1
		elseif bankerValue == playerValue then
			if bankerValue < playerValue then
				return 1
			else
				return -1
			end
		else
			return -1
		end
	end
	--没牛情况的判断
	if bankerValue < playerValue then
		return 1
	elseif bankerValue == playerValue then
		if bankerValue < playerValue then
			return 1
		else
			return -1
		end
	else
		return -1
	end
end
----------------------------结束------------------------------



--更新分数
function GameScene:onExchangeScoreSuccessHandler()
	self:switchJettonShow()
	self.right_player_score_:setString(GameScene.score_)
end

--空闲状态
function GameScene:onGameStatusIdleHandler(remainTime)
	--下注开关
	self.JettonBool_ = false
	--结算开关
	self.SettleBool_ = true

	self:remove_cards()

	self:Clock_onIdle(remainTime)
	record_jetton   = {east = 0,south = 0,west = 0,north = 0}
end
--游戏状态
function GameScene:onGameStatusStartHandler(remainTime,score,bankerScore)
	-- 下注开关
	self.JettonBool_ = true
	--结算开关
	self.SettleBool_ = false
	--刷新下注筹码的显示
	self:switchJettonShow()
	self:Clock_onJetton(remainTime)
	self:showJetton()
	if GameScene.name_ == banker_name then
		self:allhideJetton()
	end
	--刷新最大玩家最大限制
	self.my_maxscore_  = score/10			--个人最大限制
	banker_score = bankerScore
	AudioEngine.playEffect("bairenniuniu/res/sound/GAME_START.wav")
end
--发牌状态
function GameScene:onGameStatusEndHandler(cards,remainTime,bFirstCard,myScore,returnScore,bankerScore, bankerTotalScore, bankerTime)
	print("remainTime=",remainTime,"bFirstCard=",bFirstCard)

	--赢分面板
	win_bankscore    = bankerScore
	win_myscore      = myScore
	win_returnscocre = returnScore
	--将自己的分数,重新赋值
	GameScene.score_ = GameScene.score_ + myScore
	--战绩
	player_zhanji    = player_zhanji + myScore
	-- GameScene.score_ = GameScene.score_ + win_returnscocre
	--坐庄次数
	banker_playtime  = bankerTime
	self.left_banker_num_:setString(banker_playtime)
	--更新庄家信息
	banker_score = banker_score + win_bankscore
	if bankerTotalScore >= 0 then
		banker_zhanji = bankerTotalScore
	else
		banker_zhanji = 0
	end

	--下注开关
	self.JettonBool_ = false
	--结算开关
	self.SettleBool_ = false

	for m,n in pairs(cardsData) do
		if bFirstCard == n then
			cardID = m
			print("cardID",cardID)
		end
	end
	--隐藏下注状态
	self:hideJetton()
  	--开始时间
	self:Clock_onPlay(remainTime)
	self:StartCard(cardID)
	--把服务器的牌值,转化为本地需要的牌值
	cardsReal = self:getCardData(cardsData,cards)
	-- for k,v in pairs(cards) do
	-- 	print("传入过来发牌的cards:",k,"=",v,"......")
	-- 	print("改变后的牌值:cardsReal",k,"=",cardsReal[k])
	-- 	print("花色:",self:getCardColor(cardsReal[k]))
	-- 	print("牌值:",self:getCardValue(cardsReal[k]))
	-- 	print("逻辑值:",self:getLogicCardValue(cardsReal[k]))
	-- end

	local test_cards  = {}           --获取类型时要用到的临时数据表(5个值一组)
	local test_banker = {}			 --比较输赢时,用于存储庄家的数据
	local test_player = {}			 --比较输赢时,用于临时存储其他玩家的数据
	for i=1,5 do
		test_banker[i] = cardsReal[i]
		for j=1,5 do
			test_cards[j]  = cardsReal[5*(i-1)+j]
			-- print("测试值是:",test_cards[j])
		end
		test_type[i] = self:getCardType(test_cards,Result_Cards)
		-- print("测试类型是:",test_type[i])
		for m =1,5 do
			-- print("获取类型后的值:",Result_Cards[m])
			sort_cards[5*(i-1)+m] = Result_Cards[m]
			-- print("sort_cards[",(5*(i-1)+m),"]=",sort_cards[5*(i-1)+m])
		end
	end

	--存储赢家信息,这里主要用于显示赢家的标志
	for m=1,4 do
		for n=1,5 do
			test_player[n] = cardsReal[5*m+n]
		end
		win_player[m] = self:getWinPlayer(test_banker,test_player)
		-- print("玩家",m,"的输赢返回值:",win_player[m])
	end
	--创建将要发布的牌
	self:CreateCards(cardsReal)

	-- local test_type = self:getCardType(test_cards,Result_Cards)
	-- print("测试类型是:",test_type)
	-- for i=1,#Result_Cards do
	-- 	print("获取类型后的值:",Result_Cards[i])
	-- end

	-- local test_Num = {}
	-- for k=1,5 do
	-- 	table.insert(test_Num,cardsReal[k])
	-- 	print("测试排序前赋值:",test_Num[k])
	-- 	print("测试排序cardsReal:",cardsReal[k])
	-- end
	-- self:sortCard(test_Num)
	-- for k=1,5 do
	-- 	print("测试排序是否成功:",test_Num[k])
	-- 	print("测试排序cardsReal:",cardsReal[k])
	-- end
end

--第一次进入场景时调用
function GameScene:onGameStatusGameSceneFree(endGameMul,remainTime,userScore,bankerUser,bankerTime,bankerWinScore,bankerScore,enableSysBanker,applyBankerCondition,areaLimitScore)
	print("空闲状态传进来的值",remainTime,userScore,bankerUser,bankerTime,bankerWinScore,bankerScore,enableSysBanker,applyBankerCondition,areaLimitScore)
	self.my_maxscore_  = userScore/10			--个人最大限制
	self.areamaxscore_ = areaLimitScore         --区域最大限制
	self.banker_limit_ = applyBankerCondition   --申请坐庄的条件

	self.endGameMul_   = endGameMul             --闲家总下注百分比
	print("我要调用监听空闲状态！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！")

	--显示庄家昵称,分数等信息
	if bankerUser ~= -1 then
		GameScene.bankerId_= global.g_mainPlayer:getTableChairUser(GameScene.tableId_,bankerUser)
		print("庄家Id:.................",GameScene.bankerId_)
			--玩家座位
		local banker_ = global.g_mainPlayer:getRoomPlayer(GameScene.bankerId_)
		banker_name = banker_.name
		print("庄家姓名:.................",banker_name)
		self.left_banker_name_:setString(banker_name)
	else
		banker_name = LocalLanguage:getLanguageString("L_45a3acaf08fe01c8")
		self.left_banker_name_:setString(banker_name)
	end
	--系统坐庄
	banker_playtime = bankerTime
	banker_score    = bankerScore

	if bankerWinScore > 0 then
		banker_zhanji = bankerWinScore
	else
		banker_zhanji = 0
	end
	self.left_banker_result_ :setString(banker_zhanji)
	self.left_banker_num_    :setString(banker_playtime)
	self.left_banker_score_  :setString(banker_score)


	--下注开关
	self.JettonBool_ = false
	--结算开关
	self.SettleBool_ = true

	--空闲状态计时器
	self:Clock_onIdle(remainTime)
	--弹出投币框
	-- PopUpView.showPopUpView(ToubiView)

end
function GameScene:onGameStatusGameScenePlay(endGameMul,banker, bankerTime,bankerWinScore,bankerScore,enableSysBanker,endBankerScore,endUserScore,endUserReturnScore,allJettons,userJettons,cards,status,score,applyBankerCondition,areaLimitScore,remainTime,gamestatus)
	print("游戏状态传进来的值",score,applyBankerCondition,areaLimitScore,remainTime,gamestatus)
	self.my_maxscore_  = score/10			    --个人最大限制
	self.areamaxscore_ = areaLimitScore     	--区域最大限制
	self.banker_limit_ = applyBankerCondition   --申请坐庄的条件

	self.endGameMul_   = endGameMul             --闲家总下注百分比

	local jettonratio = {10000000,5000000,1000000,100000,10000,1000,100}
	--显示庄家昵称,分数等信息
	if banker ~= -1 then
		GameScene.bankerId_= global.g_mainPlayer:getTableChairUser(GameScene.tableId_,banker)
		print("庄家桌",GameScene.tableId_)
		print("庄家Id:.................",GameScene.bankerId_)
			--玩家座位
		local banker_ = global.g_mainPlayer:getRoomPlayer(GameScene.bankerId_)
		banker_name = banker_.name
		print("庄家姓名:.................",banker_name)
		self.left_banker_name_:setString(banker_name)
	else
		banker_name = LocalLanguage:getLanguageString("L_45a3acaf08fe01c8")
		self.left_banker_name_:setString(banker_name)
	end
	--系统坐庄
	banker_playtime = bankerTime
	banker_score    = bankerScore

	if bankerWinScore > 0 then
		banker_zhanji = bankerWinScore
	else
		banker_zhanji = 0
	end
	self.left_banker_result_ :setString(banker_zhanji)
	self.left_banker_num_    :setString(bankerTime)
	self.left_banker_score_  :setString(bankerScore)

	--赢分面板
	win_bankscore    = endBankerScore
	win_myscore      = endUserScore
	win_returnscocre = endUserReturnScore

	if status == 100 then
		-- 下注开关
		self.JettonBool_ = true
		--结算开关
		self.SettleBool_ = false
		self:switchJettonShow()
		self:Clock_onJetton(remainTime)

		if GameScene.name_ == banker_name then
			return
		else
			self:showJetton()
		end

		for k,v in ipairs(allJettons) do
			print("allJettons[",k,"]==",v)
		end
		for k,v in ipairs(allJettons) do
			print("allJettons[",k,"]==",v)
			for m,n in ipairs(jettonratio) do
				print("jettonratio[",m,"]=",n)
				if allJettons[k]/n >= 1 then
					repeat
						self:createJetton(GameScene.chairId,k-1,n)
						allJettons[k]=allJettons[k]-n
					until allJettons[k]/n <1
				end
			end
		end
		-- for k,v in ipairs(userJettons) do
		-- 	print("userJettons[",k,"]==",v)
		-- 	for m,n in ipairs(jettonratio) do
		-- 		print("jettonratio[",m,"]=",n)
		-- 		if userJettons[k]/n >= 1 then
		-- 			repeat
		-- 				self:createJetton(GameScene.chairId,k-1,n)
		-- 				userJettons[k]=userJettons[k]-n
		-- 			until userJettons[k]/n <1
		-- 		end
		-- 	end
		-- end
	elseif status == 101 then
		for k,v in ipairs(allJettons) do
			print("allJettons[",k,"]==",v)
			for m,n in ipairs(jettonratio) do
				print("jettonratio[",m,"]=",n)
				if allJettons[k]/n >= 1 then
					repeat
						self:createJetton(GameScene.chairId,k-1,n)
						allJettons[k]=allJettons[k]-n
					until allJettons[k]/n <1
				end
			end
		end
		for k,v in ipairs(userJettons) do
			print("userJettons[",k,"]==",v)
		end
		-- for k,v in ipairs(userJettons) do
		-- 	print("userJettons[",k,"]==",v)
		-- 	for m,n in ipairs(jettonratio) do
		-- 		print("jettonratio[",m,"]=",n)
		-- 		if userJettons[k]/n >= 1 then
		-- 			repeat
		-- 				self:createJetton(GameScene.chairId,k-1,n)
		-- 				userJettons[k]=userJettons[k]-n
		-- 			until userJettons[k]/n <1
		-- 		else
		-- 			return
		-- 		end
		-- 	end
		-- end
		for k,v in ipairs(cards) do
			print("cards[",k,"]==",v)
		end

		--隐藏下注状态
		self:hideJetton()
	  	--开始时间
		self:Clock_onPlay(remainTime)
		-- self:StartCard(cardID)
		--把服务器的牌值,转化为本地需要的牌值
		cardsReal = self:getCardData(cardsData,cards)
		for k,v in pairs(cardsReal) do
			print("cardsReal[",k,"]==",v)
		end
		-- for k,v in pairs(cards) do
		-- 	print("传入过来发牌的cards:",k,"=",v,"......")
		-- 	print("改变后的牌值:cardsReal",k,"=",cardsReal[k])
		-- 	print("花色:",self:getCardColor(cardsReal[k]))
		-- 	print("牌值:",self:getCardValue(cardsReal[k]))
		-- 	print("逻辑值:",self:getLogicCardValue(cardsReal[k]))
		-- end

		local test_cards  = {}           --获取类型时要用到的临时数据表(5个值一组)
		local test_banker = {}			 --比较输赢时,用于存储庄家的数据
		local test_player = {}			 --比较输赢时,用于临时存储其他玩家的数据
		for i=1,5 do
			test_banker[i] = cardsReal[i]
			for j=1,5 do
				test_cards[j]  = cardsReal[5*(i-1)+j]
				-- print("测试值是:",test_cards[j])
			end
			test_type[i] = self:getCardType(test_cards,Result_Cards)
			-- print("测试类型是:",test_type[i])
			for m =1,5 do
				-- print("获取类型后的值:",Result_Cards[m])
				sort_cards[5*(i-1)+m] = Result_Cards[m]
				print("sort_cards[",(5*(i-1)+m),"]=",sort_cards[5*(i-1)+m])
			end
		end

		--存储赢家信息,这里主要用于显示赢家的标志
		for m=1,4 do
			for n=1,5 do
				test_player[n] = cardsReal[5*m+n]
			end
			win_player[m] = self:getWinPlayer(test_banker,test_player)
			-- print("玩家",m,"的输赢返回值:",win_player[m])
		end
			--创建亮牌时要现显示的牌
		self:create_showCard()
		-- self:CreateCards(cardsReal)
		self:end_showCard()      --显示牛牛
		for i=1,#showcardSpr do
			showcardSpr[i]:setVisible(true)
		end

	end
	-- PopUpView.showPopUpView(ToubiView)
	-- PopUpView.showPopUpView(HelpView)
end

--申请上庄
function GameScene:onGameStatusGameApplyBanker(applyUser)
	local bankerMsg = {}
	-- local applybankerId= global.g_mainPlayer:getTableChairUser(GameScene.tableId_,applyUser)
	-- --玩家座位
	-- local banker_ = global.g_mainPlayer:getRoomPlayer(applybankerId)
	-- local apply_name 	= banker_.name
	-- local apply_score   = banker_.score*global.g_mainPlayer:getCurrentRoomBeilv()	
	--备用以防万一
	local applybankerId = nil
	local apply_name  = nil
	local apply_score = nil
	if GameScene.chairId_ == applyUser then
		applybankerId = GameScene.playerId_
		apply_name    = GameScene.name_
		apply_score   = GameScene.score_
	elseif #user_list ~= 0 then
		for k,v in ipairs(user_list) do
			print("user_list[",k,"]=",v.userId,v.chairId,v.score,v.nickname)
			if v.chairId == applyUser then
				applybankerId = v.userId
				apply_name    = v.nickname
				apply_score   = v.score
			end
		end
	else
		applybankerId = global.g_mainPlayer:getTableChairUser(GameScene.tableId_,applyUser)
		banker_       = global.g_mainPlayer:getRoomPlayer(applybankerId)
		apply_name 	  = banker_.name
		apply_score   = math.modf(banker_.score * global.g_mainPlayer:getCurrentRoomBeilv())
	end

	
	-- print("申请庄家Id:.................",applybankerId)
	-- print("申请庄家姓名:.................",apply_name)
	-- print("申请庄家分数:.................",apply_score)
	bankerMsg["apply_Id"]   = applybankerId
	bankerMsg["apply_name"] = apply_name
	bankerMsg["apply_score"]= apply_score
	table.insert(bnaker_list,bankerMsg)
	for k,v in ipairs(bnaker_list) do
		print("bnaker_list[",k,"]=",v.apply_Id,v.apply_name,v.apply_score)
	end
	-- self:applyBanker()
	self:addListItem()

	if GameScene.playerId_ == applybankerId then
		self.btn_applaybanker_:setVisible(false)
		self.btn_downbanker_  :setVisible(false)
		self.btn_quitapply_   :setVisible(true)
	end
end
--申请下庄
function GameScene:onGameStatusGameQuitBanker(applyUser)
	print("申请下庄......",applyUser)
	-- local applybankerId= global.g_mainPlayer:getTableChairUser(GameScene.tableId_,applyUser)

	local applybankerId = nil
	-- --备用以防万一
	-- for k,v in ipairs(user_list) do
	-- 	print("user_list[",k,"]=",v.userId,v.chairId,v.score,v.nickname)
	-- 	if v.chairId == applyUser then
	-- 		applybankerId = v.userId
	-- 	end
	-- end
	if GameScene.chairId_ == applyUser then
		applybankerId = GameScene.playerId_
	elseif #user_list ~= 0 then
		for k,v in ipairs(user_list) do
			print("user_list[",k,"]=",v.userId,v.chairId,v.score,v.nickname)
			if v.chairId == applyUser then
				applybankerId = v.userId
			end
		end
	else
		applybankerId = global.g_mainPlayer:getTableChairUser(GameScene.tableId_,applyUser)
	end


	print(GameScene.tableId_,applybankerId,GameScene.playerId_)
	for k,v in ipairs(bnaker_list) do
		if applybankerId == v.apply_Id then
			table.remove(bnaker_list,k)
		end
	end
	--如果数组数据清除完了,数组赋值为nil
	if #bnaker_list == 1 and bnaker_list[1].apply_score == nil then
		bnaker_list = nil
	end
	print(".......",GameScene.playerId_,applybankerId)
	--显示上庄按钮
	if GameScene.playerId_ == applybankerId then
		self.btn_applaybanker_:setVisible(true)
		self.btn_downbanker_  :setVisible(false)
		self.btn_quitapply_   :setVisible(false)
	end
	self:addListItem()
end
--切换庄家
function GameScene:onGameStatusGameChangeBanker(bankerUser,bankerScore)
	print("游戏切换庄家,bankerUser,bankerScore",bankerUser,bankerScore)
	--更新申请庄家列表
	-- local applybankerId = global.g_mainPlayer:getTableChairUser(GameScene.tableId_,bankerUser)
	--备用以防万一
	local applybankerId = nil
	-- for k,v in ipairs(user_list) do
	-- 	print("user_list[",k,"]=",v.userId,v.chairId,v.score,v.nickname)
	-- 	if v.chairId == bankerUser then
	-- 		applybankerId = v.userId
	-- 	end
	-- end
	if GameScene.chairId_ == bankerUser then
		applybankerId = GameScene.playerId_
	elseif #user_list ~= 0 then
		for k,v in ipairs(user_list) do
			print("user_list[",k,"]=",v.userId,v.chairId,v.score,v.nickname)
			if v.chairId == bankerUser then
				applybankerId = v.userId
			end
		end
	else
		applybankerId = global.g_mainPlayer:getTableChairUser(GameScene.tableId_,bankerUser)
	end

	for k,v in ipairs(bnaker_list) do
		if applybankerId == v.apply_Id then
			table.remove(bnaker_list,k)
		end
	end
	--如果数组数据清除完了,数组赋值为nil
	if #bnaker_list == 1 and bnaker_list[1].apply_score == nil then
		bnaker_list = nil
	end

	for k,v in ipairs(bnaker_list) do
		print("bnaker_list[",k,"]=",v.apply_Id,v.apply_name,v.apply_score)
	end
	self:addListItem()
	if bankerUser ~= -1 then
		-- GameScene.bankerId_= global.g_mainPlayer:getTableChairUser(GameScene.tableId_,bankerUser)
		
		--玩家座位
		-- local banker_ = global.g_mainPlayer:getRoomPlayer(GameScene.bankerId_)
		-- banker_name = banker_.name
		local banker_   = nil
		local bankerId_ = nil
		--备用以防万一
		-- for k,v in ipairs(user_list) do
		-- 	print("user_list[",k,"]=",v.userId,v.chairId,v.score,v.nickname)
		-- 	if v.chairId == bankerUser then
		-- 		banker_name = v.nickname
		-- 		bankerId_   = v.userId
		-- 	end
		-- end	

		if GameScene.chairId_ == bankerUser then
			bankerId_    = GameScene.playerId_
			banker_name  = GameScene.name_
		elseif #user_list ~= 0 then
			for k,v in ipairs(user_list) do
				print("user_list[",k,"]=",v.userId,v.chairId,v.score,v.nickname)
				if v.chairId == bankerUser then
					banker_name = v.nickname
					bankerId_   = v.userId
				end
			end
		else
			--玩家座位
			local banker_ = global.g_mainPlayer:getRoomPlayer(applybankerId)
			banker_name   = v.nickname
			bankerId_     = applybankerId
		end

		print("庄家Id:.................",bankerId_)
		print("庄家姓名:.................",banker_name)
		
		banker_zhanji  	= 0
		banker_playtime = 0
		banker_score 	= bankerScore
		--显示上庄按钮
		if GameScene.playerId_ == bankerId_ then
			self.btn_applaybanker_:setVisible(false)
			self.btn_downbanker_  :setVisible(true)
			self.btn_quitapply_   :setVisible(false)
			self.left_banker_score_  :setString(banker_score)
		else
			self.btn_applaybanker_:setVisible(true)
			self.btn_downbanker_  :setVisible(false)
			self.btn_quitapply_   :setVisible(false)
			self.left_banker_score_  :setString(banker_score)
		end

		self.left_banker_name_	 :setString(banker_name)
		self.left_banker_result_ :setString(banker_zhanji)
		self.left_banker_num_    :setString(banker_playtime)
	else
		banker_name = LocalLanguage:getLanguageString("L_45a3acaf08fe01c8")
		print("庄家姓名:.................",banker_name)
		banker_zhanji  	= 0
		banker_playtime = 0
		banker_score 	= bankerScore
		self.left_banker_name_   :setString(banker_name)
		self.left_banker_result_ :setString(banker_zhanji)
		self.left_banker_num_    :setString(banker_playtime)
		self.left_banker_score_  :setString(banker_score)

		self.btn_applaybanker_:setVisible(true)
		self.btn_downbanker_  :setVisible(false)
		self.btn_quitapply_   :setVisible(false)
	end
end


--玩家列表
function GameScene:onGameStatusGameUpdateUserList(userId,chairId,score,nickname)
	local userMsg = {}
	print("玩家列表更新",userId,chairId,score,nickname)
	userMsg["userId"]   = userId
	userMsg["chairId"]  = chairId
	userMsg["score"]    = score
	userMsg["nickname"] = nickname
	local insertbool    = true
	-- print("..............",userMsg.userId,userMsg.chairId,userMsg.score,userMsg.nickname)
	for k,v in ipairs(user_list) do
		if v.userId == userMsg.userId then
			--更新玩家分数
			v.score = userMsg.score
			insertbool = false
		end
	end

	if insertbool == true then
		table.insert(user_list,userMsg)
	end
	for k,v in ipairs(user_list) do
		print("user_list[",k,"]=",v.userId,v.chairId,v.score,v.nickname)
	end
end
--玩家进入
function GameScene:onGameStatusGameUserEnter(userId,chairId,score,nickname)
	local userMsg = {}
	print("玩家进入",userId,chairId,score,nickname)
	userMsg["userId"]   = userId
	userMsg["chairId"]  = chairId
	userMsg["score"]    = score
	userMsg["nickname"] = nickname
	local insertbool    = true
	-- print("..............",userMsg.userId,userMsg.chairId,userMsg.score,userMsg.nickname)

	for k,v in ipairs(user_list) do
		if v.userId  == userMsg.userId then
			insertbool = false
		end
	end
	if insertbool == true then
		table.insert(user_list,userMsg)
	end

	for k,v in ipairs(user_list) do
		print("user_list[",k,"]=",v.userId,v.chairId,v.score,v.nickname)
	end
end
--玩家退出
function GameScene:onGameStatusGameUserQuit(userId,chairId,score,nickname)
	local userMsg = {}
	print("玩家退出",userId,chairId,score,nickname)
	userMsg["userId"]   = userId
	userMsg["chairId"]  = chairId
	userMsg["score"]    = score
	userMsg["nickname"] = nickname
	-- print("..............",userMsg.userId,userMsg.chairId,userMsg.score,userMsg.nickname)
	if #user_list ~= 0 then
		for k,v in ipairs(user_list) do
			if v.userId  == userMsg.userId then
				table.remove(user_list,k)
			end
		end
	end
	for k,v in ipairs(user_list) do
		print("user_list[",k,"]=",v.userId,v.chairId,v.score,v.nickname)
	end

	--如果有申请上庄的玩家退出
	--更新申请庄家列表
	for k,v in ipairs(bnaker_list) do
		if userId == v.apply_Id then
			table.remove(bnaker_list,k)
		end
	end
	for k,v in ipairs(bnaker_list) do
		print("bnaker_list[",k,"]=",v.apply_Id,v.apply_name,v.apply_score)
	end

end




--拆码
local JETTON_BASE = {
	100,
	1000,
	10000,
	100000,
	1000000,
	5000000,
	10000000,
}
function GameScene:splitJetton(jettonratio)
	local t = {}

	for i = 1, #JETTON_BASE do
		local front = JETTON_BASE[i-1] or 1
		local base = JETTON_BASE[i]
		if base == jettonratio then
			table.insert(t, base)
			jettonratio = jettonratio - base
			break
		elseif base > jettonratio then
			local div = math.floor(jettonratio/front)
			local valueSub = div * front
			for i = 1, div do
				table.insert(t, front)
			end
			jettonratio = jettonratio - valueSub
			
			break
		end
	end

	if jettonratio > 0 then
		local ret = self:splitJetton(jettonratio)
		for i = 1, #ret do
			table.insert(t, ret[i])
		end
	end

	return t
end




--下注
function GameScene:onGamePlaceJettonResult(chairId, jettonArea, jettonScore)
	print("玩家下注..............",chairId,jettonArea,jettonScore)
	local scoretable = self:splitJetton(jettonScore)
	for k,v in ipairs(scoretable) do
		self:createJetton(chairId,jettonArea,v)
		print(v)
	end

	if GameScene.chairId_ == chairId then
		if jettonArea == 1 then
			record_jetton.east  = 1
		elseif jettonArea == 2 then
			record_jetton.south = 1
		elseif jettonArea == 3 then
			record_jetton.west  = 1
		elseif jettonArea == 4 then
			record_jetton.north = 1
		end
	end

	AudioEngine.playEffect("bairenniuniu/res/sound/ADD_GOLD.wav")
end




--结算金币成功
function GameScene:onExchangeGoldSuccessHandler()
	print("结算金币成功")
	self:onExchangeScoreSuccessHandler()
end

function GameScene:onEndEnterTransition()
	print("添加监听111111")
	global.g_gameDispatcher:addMessageListener(GAME_EXCHANGE_SCORE_SUCCESS, self, self.onExchangeScoreSuccessHandler)
	global.g_gameDispatcher:addMessageListener(GAME_EXCHANGE_GOLD_SUCCESS, self, self.onExchangeGoldSuccessHandler)

	global.g_gameDispatcher:addMessageListener(GAME_EVENT_STATUS_IDLE, self, self.onGameStatusIdleHandler)
	global.g_gameDispatcher:addMessageListener(GAME_EVENT_STATUS_START, self, self.onGameStatusStartHandler)
	global.g_gameDispatcher:addMessageListener(GAME_EVENT_STATUS_END, self, self.onGameStatusEndHandler)

	global.g_gameDispatcher:addMessageListener(GAME_EVENT_GAMESCENE_FREE, self, self.onGameStatusGameSceneFree)
	global.g_gameDispatcher:addMessageListener(GAME_EVENT_GAMESCENE_PLAY, self, self.onGameStatusGameScenePlay)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAMEAPPLYBANKER, self, self.onGameStatusGameApplyBanker)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAMEQUITBANKER, self, self.onGameStatusGameQuitBanker)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAMEChANGEBANKER, self, self.onGameStatusGameChangeBanker)

	--玩家列表,进入与退出
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_UPDATEUSERNAMELIST, self, self.onGameStatusGameUpdateUserList)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAMEUSERENTER, self, self.onGameStatusGameUserEnter)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAMEUSERQUIT, self, self.onGameStatusGameUserQuit)

	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAMEPLACEJETTONRESULT, self, self.onGamePlaceJettonResult)
	-- global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_CLEARJETTONRESULT, self, self.onClearJettonResult)
	-- global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_CONTINUEJETTONRESULT, self, self.onContinueJettonResult)
end

function GameScene:onStartExitTransition()
	print("删除监听")

	self:onStopTimer()
	self:onStopCardTimer()
	self:remove_cards()
	self:removeCloseListener()

	global.g_gameDispatcher:removeMessageListener(GAME_EXCHANGE_SCORE_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_EXCHANGE_GOLD_SUCCESS, self)

	global.g_gameDispatcher:removeMessageListener(GAME_EVENT_STATUS_IDLE, self)
	global.g_gameDispatcher:removeMessageListener(GAME_EVENT_STATUS_START, self)
	global.g_gameDispatcher:removeMessageListener(GAME_EVENT_STATUS_END, self)

	global.g_gameDispatcher:removeMessageListener(GAME_EVENT_GAMESCENE_FREE, self)
	global.g_gameDispatcher:removeMessageListener(GAME_EVENT_GAMESCENE_PLAY, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAMEAPPLYBANKER, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAMEQUITBANKER, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAMEChANGEBANKER, self)

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_UPDATEUSERNAMELIST, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAMEUSERENTER, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAMEUSERQUIT, self)

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAMEPLACEJETTONRESULT, self)
	-- global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_CLEARJETTONRESULT, self)
	-- global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_CONTINUEJETTONRESULT, self)
end