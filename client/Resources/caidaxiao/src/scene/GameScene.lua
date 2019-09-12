GameScene = class("GameScene", LayerBase)

local line_define = 
{
	{6, 7, 8, 9, 10},
	{1, 2, 3, 4, 5},
	{11, 12, 13, 14, 15},
	{1, 7, 13, 9, 5},
	{11, 7, 3, 9, 15},
	{1, 2, 8, 4, 5},
	{11, 12, 8, 14, 15},
	{6, 12, 13, 14, 10},
	{6, 2, 3, 4, 10}
}

local col_define = 
{
	{1, 6, 11},
	{2, 7, 12},
	{3, 8, 13},
	{4, 9, 14},
	{5, 10, 15}
}

local bet_table =
{
	[0] = {[5] = 2000, [15] = 5000},
	[1] = {[3] = 50, [4] = 200, [5] = 1000, [15] = 2500},
	[2] = {[3] = 20, [4] = 80, [5] = 400, [15] = 1000},
	[3] = {[3] = 15, [4] = 40, [5] = 200, [15] = 500},
	[4] = {[3] = 10, [4] = 30, [5] = 160, [15] = 400},
	[5] = {[3] = 7, [4] = 20, [5] = 100, [15] = 250},
	[6] = {[3] = 5, [4] = 15, [5] = 60, [15] = 150},
	[7] = {[3] = 3, [4] = 10, [5] = 40, [15] = 100},
	[8] = {[3] = 2, [4] = 5, [5] = 20, [15] = 50},
}

local animate_frame_count = {[0] = 54, [1] = 49, [2] = 47, [3] = 35, [4] = 35, [5] = 54, [6] = 30, [7] = 44, [8] = 42}


function GameScene:ctor(gameScene)
	GameScene.super.ctor(self)

	gamesvr.sendGameOption()
	gamesvr.sendUserReady() --游戏准备

	self:enableNodeEvents()

	self.gameScene_ = gameScene

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("caidaxiao/res/json/ui_bibei.json")
	root:setClippingEnabled(true)
	self:addChild(root)

	self.image_drop_ = {}
	for i=1,10 do
		self.image_drop_[i] = ccui.Helper:seekWidgetByName(root, "Drop_" .. i)
		self.image_drop_[i]:setVisible(false);
	end

	self.image_boss_ = {}
	for i=0,4 do
		local image = ccui.Helper:seekWidgetByName(root, "Image_Boss_" .. i)

		self.image_boss_[i] = cc.Sprite:createWithSpriteFrameName(string.format("BiBei/Boss/%d/0.png", i))
		local contentsize = self.image_boss_[i]:getContentSize()
		self.image_boss_[i]:setPosition(cc.p(contentsize.width/2, contentsize.height/2))
		self.image_boss_[i]:setVisible(false)
		image:addChild(self.image_boss_[i])
		image:setVisible(true)
		image:setOpacity(0)
	end

	local left = ccui.Helper:seekWidgetByName(root, "Image_Left")
	self.image_left_ = cc.Sprite:createWithSpriteFrameName("BiBei/Left/3/aa0.png")
	local contentsize = self.image_left_:getContentSize()
	self.image_left_:setPosition(cc.p(contentsize.width/2, contentsize.height/2))
	left:addChild(self.image_left_)
	left:setOpacity(0)

	local right = ccui.Helper:seekWidgetByName(root, "Image_Right")
	self.image_right_ = cc.Sprite:createWithSpriteFrameName("BiBei/Right/0/0.png")
	local contentsize = self.image_right_:getContentSize()
	self.image_right_:setPosition(cc.p(contentsize.width/2, contentsize.height/2))
	right:addChild(self.image_right_)
	right:setOpacity(0)

	self.dice1_ = ccui.Helper:seekWidgetByName(root, "Image_Dice1")
	self.dice2_ = ccui.Helper:seekWidgetByName(root, "Image_Dice2")

	self.blink_ = ccui.Helper:seekWidgetByName(root, "Image_Blink")
	self.arrow_ = ccui.Helper:seekWidgetByName(root, "Image_Arrow")
	self.arrow_:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveBy:create(0.5, cc.p(0, -30)), cc.MoveBy:create(0.5, cc.p(0, 30)))))
	


	self.btn_maihe_ = ccui.Helper:seekWidgetByName(root, "Button_Maihe")
	self.btn_maihe_:addTouchEventListener(makeClickHandler(self, self.onMaihe))
	self.btn_maihe_:setEnabled(false)
	self.btn_maihe_:setBright(false)

	self.btn_maida_ = ccui.Helper:seekWidgetByName(root, "Button_Maida")
	self.btn_maida_:addTouchEventListener(makeClickHandler(self, self.onMaida))	
	self.btn_maida_:setEnabled(false)
	self.btn_maida_:setBright(false)

	self.btn_maixiao_ = ccui.Helper:seekWidgetByName(root, "Button_Maixiao")
	self.btn_maixiao_:addTouchEventListener(makeClickHandler(self, self.onMaixiao))
	self.btn_maixiao_:setEnabled(false)
	self.btn_maixiao_:setBright(false)

	--路单
	self.btn_beilvbiao_ = ccui.Helper:seekWidgetByName(root, "Button_Beilvbiao")
	self.btn_beilvbiao_:addTouchEventListener(makeClickHandler(self, self.onBeilvbiao))
	self.btn_beilvbiao_:setVisible(true);

	--说明
	self.btn_shuoming = ccui.Helper:seekWidgetByName(root, "Button_ShuoMing")
	self.btn_shuoming:addTouchEventListener(makeClickHandler(self, self.onShuoMing))
	
	--设置
	self.btn_setting_ = ccui.Helper:seekWidgetByName(root, "Button_Setting")
	self.btn_setting_:addTouchEventListener(makeClickHandler(self, self.onSetting))
	--返回
	self.btn_return_ = ccui.Helper:seekWidgetByName(root, "Button_Return")
	self.btn_return_:addTouchEventListener(makeClickHandler(self, self.onReturn))
	--人数
	self.btn_player = ccui.Helper:seekWidgetByName(root,"Button_player")
	self.btn_player:addTouchEventListener(makeClickHandler(self, self.onPlayer))

	--其他人下注 飞元宝动画
	self.other_jetton = ccui.Helper:seekWidgetByName(root,"other_jetton")

	self.lab_line = ccui.Helper:seekWidgetByName(root,"lab_line")
	local playerList = global.g_mainPlayer:getRoomAllPlayer();
	local index = 0;
	for key,value in pairs(playerList) do
    	index = index+1
	end
	self.lab_line:setString(index);


	self.qiehuans = {} -- 分数档次
	self.checks = {} --分数档次选中 默认选中第一个
	self.jettonNums = {}
	for i=1,4 do
		self.qiehuans[i] = ccui.Helper:seekWidgetByName(root, "qiehuan_" .. (i-1))
		self.qiehuans[i]:setTag(i)--设置这个item1的tag 
		self.qiehuans[i]:addTouchEventListener(makeClickHandler(self, self.onQieHuanJetton))
		self.jettonNums[i] = ccui.Helper:seekWidgetByName(root, "jettonNum"..i) --单次下注分数
		self.checks[i] =  ccui.Helper:seekWidgetByName(root, "check"..i)
		self.checks[i]:setVisible(false);
	end

	self.xuya = ccui.Helper:seekWidgetByName(root, "xuya");
	self.xuya:addTouchEventListener(makeClickHandler(self, self.onXuYa))
	self.xuya:setVisible(true);
	self.xuyaquxiao = ccui.Helper:seekWidgetByName(root, "xuyaquxiao");
	self.xuyaquxiao:addTouchEventListener(makeClickHandler(self, self.onXuYaQuXiao))
	self.xuyaquxiao:setVisible(false);


	--文字
	self.remainScore_ = ccui.Helper:seekWidgetByName(root, "AtlasLabel_Credit")
	-- self.totalBet_ = ccui.Helper:seekWidgetByName(root, "AtlasLabel_TotalBet")

	--银子
	self.yinzi_xiao_ = ccui.Helper:seekWidgetByName(root, "Image_Yinzi_Xiao")
	self.yinzi_he_ = ccui.Helper:seekWidgetByName(root, "Image_Yinzi_He")
	self.yinzi_da_ = ccui.Helper:seekWidgetByName(root, "Image_Yinzi_Da")

	--得分
	self.big_defen_ = ccui.Helper:seekWidgetByName(root, "Image_Defen")
	self.label_win_ = ccui.Helper:seekWidgetByName(root, "AtlasLabel_Win")
	self.label_lose_ = ccui.Helper:seekWidgetByName(root, "AtlasLabel_Lose")
	self.Image_Win = ccui.Helper:seekWidgetByName(root, "Image_Win")
	

	self.lab_qu = ccui.Helper:seekWidgetByName(root, "lab_qu")
	self.lab_ge = ccui.Helper:seekWidgetByName(root, "lab_ge")

	self.anim_pic = ccui.Helper:seekWidgetByName(root,"anim_pic");
	self.status_pic = ccui.Helper:seekWidgetByName(root,"status");
	self.anim_pic:setVisible(false);


	self.quall_score = {} -- 0. 1 .2 大小和
	for i=1,3 do
		self.quall_score[i] = ccui.Helper:seekWidgetByName(root, "quall" .. (i-1))
	end
	self.qumy_score = {} -- 0. 1 .2 大小和
	for i=1,3 do
		self.qumy_score[i] = ccui.Helper:seekWidgetByName(root, "qumy" .. (i-1))
	end
	self.gameStatus = ccui.Helper:seekWidgetByName(root, "gameStatus")
	self.statusTime = ccui.Helper:seekWidgetByName(root, "statusTime")
	self.ImageShiZhong = ccui.Helper:seekWidgetByName(root, "Image_29")
	self.ImageShiZhong:setVisible(false)

	self:initAnimation()


	--用户分数
	GameScene.gold_ = global.g_mainPlayer:getPlayerScore()
	GameScene.score_ = 0
	local ratio = global.g_mainPlayer:getCurrentRoomBeilv()
	GameScene.score_ = math.floor(GameScene.gold_ * ratio)

	local userid = global.g_mainPlayer:getPlayerId();
	local user =global.g_mainPlayer:getRoomPlayer(userid);
	GameScene.chairId_ = user.chairId
	print("当前用户椅子id:",GameScene.chairId_ )

	self.jettonScore_ = 0 -- 下注分数 (默认100) 1000  10000 100000

	for i=1,4 do
		self.jettonNums[i]:setString(self.jettonScore_);
	end

	self.isJetton = false ;--用户当前局是否下注
	self.lastScore = 0; --上一局押注的分数
	self:Show()

end

function GameScene:onShuoMing( )
	PopUpView.showPopUpView(ShuoMingView)
end

function GameScene:onSetting( )
	PopUpView.showPopUpView(ui_setting_t)
end

function GameScene:onReturn( )
	global.g_mainPlayer:setPlayerScore(GameScene.gold_ + math.floor(GameScene.score_/global.g_mainPlayer:getCurrentRoomBeilv()))
	WarnTips.showTips({
			text = LocalLanguage:getLanguageString("L_6ceb2e80d33e115e"),
			confirm = function ( ... )
				self:onStopTimer();
				self:onStopScore();
				exit_caidaxiao();
			end,
		})
end

--显示房间人数
function GameScene:onPlayer(  )
	-- body
	PopUpView.showPopUpView(RoomPlayerView);
end

--显示路单
function GameScene:onBeilvbiao( )
	-- self.beilvImage_:setVisible(not self.beilvImage_:isVisible())
	-- PopUpView.showPopUpView(LuDanView);
	gamesvr.sendRecord();
end

function GameScene:onXuYa( ... )
	-- body
	if self.isJetton then 
		self.isZiDongXuYa = true;
		self.xuya:setVisible(false)
		self.xuyaquxiao:setVisible(true)
	else
		WarnTips.showTips(
					{
						text = LocalLanguage:getLanguageString("L_cac99364334fd755"),
						style = WarnTips.STYLE_Y
					}	
				)
	end
	
end

function GameScene:onXuYaQuXiao( ... )
	-- body
	self.isZiDongXuYa = false;
	self.xuya:setVisible(true)
	self.xuyaquxiao:setVisible(false)
end

--切换下注分数
function GameScene:onQieHuanJetton( tag )
	--下注分数 (默认100)  1000  10000 100000
	if self.jettonList_==nil then
		return;
	end
	for i=1,4 do
		self.checks[i]:setVisible(false);
	end
	self.jettonScore_ = self.jettonList_[tag:getTag()];
	self.checks[tag:getTag()]:setVisible(true);
	print("标示符",tag:getTag(),self.jettonScore_)
end

function GameScene:crSmallCoin(m,point1,point2,roat)
  for i = 1,m do 
    local coin = Coin.new()                    
    coin:setPosition(point1.x+(i-m/2)*60*math.sin(roat),point1.y+(i-m/2)*60*math.cos(roat))
    self:addChild(coin,5)
    local moveto1 = cc.MoveTo:create(1,point2)
    local scato = cc.ScaleTo:create(1,0.3)
    local function Endcallback()
      coin:removeFromParent()
    end
    local swap = cc.Spawn:create(moveto1,scato)
    local funcall = cc.CallFunc:create(Endcallback)
    local seq = cc.Sequence:create(swap,funcall)
    coin:runAction(seq)
  end 
end

function GameScene:refreshRemainScore()
	print("跟新分数:",GameScene.score_)
	self.remainScore_:setString(GameScene.score_)
	local myUser = global.g_mainPlayer:getRoomPlayer(global.g_mainPlayer:getPlayerId())
	-- table.dump(myUser);
	global.g_mainPlayer:updateRoomUserData(myUser.playerId, GameScene.score_, myUser.winCount, myUser.lostCount, myUser.drawCount, myUser.fleeCount, myUser.exp)
end

function GameScene:initAnimation()
	local spritechache = cc.SpriteFrameCache:getInstance()
	--BOSS
	--摇奖
	local animation = cc.Animation:create()
	for i = 0, 24 do
		animation:addSpriteFrame(spritechache:getSpriteFrame(string.format("BiBei/Boss/0/%d.png", i)))
	end
	animation:setDelayPerUnit(0.15)
	animation:setRestoreOriginalFrame(true)
	cc.AnimationCache:getInstance():addAnimation(animation, "boss0")

	--开奖
	animation = cc.Animation:create()
	for i = 0, 13 do
		animation:addSpriteFrame(spritechache:getSpriteFrame(string.format("BiBei/Boss/1/%d.png", i)))
	end
	animation:setDelayPerUnit(0.15)
	animation:setRestoreOriginalFrame(true)
	cc.AnimationCache:getInstance():addAnimation(animation, "boss1")

	--玩家输了
	animation = cc.Animation:create()
	for i = 0, 14 do
		animation:addSpriteFrame(spritechache:getSpriteFrame(string.format("BiBei/Boss/2/%d.png", i)))
	end
	animation:setDelayPerUnit(0.15)
	animation:setRestoreOriginalFrame(true)
	cc.AnimationCache:getInstance():addAnimation(animation, "boss2")

	--等待开奖
	animation = cc.Animation:create()
	for i = 0, 7 do
		animation:addSpriteFrame(spritechache:getSpriteFrame(string.format("BiBei/Boss/3/%d.png", i)))
	end
	animation:setDelayPerUnit(0.15)
	animation:setRestoreOriginalFrame(true)
	cc.AnimationCache:getInstance():addAnimation(animation, "boss3")

	--玩家赢了
	animation = cc.Animation:create()
	for i = 0, 25 do
		animation:addSpriteFrame(spritechache:getSpriteFrame(string.format("BiBei/Boss/4/%d.png", i)))
	end
	animation:setDelayPerUnit(0.15)
	animation:setRestoreOriginalFrame(true)
	cc.AnimationCache:getInstance():addAnimation(animation, "boss4")

	--左边瘦子
	--摇奖
	animation = cc.Animation:create()
	for i = 0, 28 do
		animation:addSpriteFrame(spritechache:getSpriteFrame(string.format("BiBei/Left/0/aa%d.png", i)))
	end
	animation:setDelayPerUnit(0.15)
	animation:setRestoreOriginalFrame(true)
	cc.AnimationCache:getInstance():addAnimation(animation, "left0")

	--玩家赢了
	animation = cc.Animation:create()
	for i = 0, 30 do
		animation:addSpriteFrame(spritechache:getSpriteFrame(string.format("BiBei/Left/1/aa%d.png", i)))
	end
	animation:setDelayPerUnit(0.15)
	animation:setRestoreOriginalFrame(true)
	cc.AnimationCache:getInstance():addAnimation(animation, "left1")

	--玩家输了
	animation = cc.Animation:create()
	for i = 0, 30 do
		animation:addSpriteFrame(spritechache:getSpriteFrame(string.format("BiBei/Left/2/aa%d.png", i)))
	end
	animation:setDelayPerUnit(0.15)
	animation:setRestoreOriginalFrame(true)
	cc.AnimationCache:getInstance():addAnimation(animation, "left2")

	--等待开奖
	animation = cc.Animation:create()
	for i = 0, 26 do
		animation:addSpriteFrame(spritechache:getSpriteFrame(string.format("BiBei/Left/3/aa%d.png", i)))
	end
	animation:setDelayPerUnit(0.15)
	animation:setRestoreOriginalFrame(true)
	cc.AnimationCache:getInstance():addAnimation(animation, "left3")

	--右边胖子
	--摇奖
	animation = cc.Animation:create()
	for i = 0, 28 do
		animation:addSpriteFrame(spritechache:getSpriteFrame(string.format("BiBei/Right/0/%d.png", i)))
	end
	animation:setDelayPerUnit(0.15)
	animation:setRestoreOriginalFrame(true)
	cc.AnimationCache:getInstance():addAnimation(animation, "right0")

	--玩家赢了
	animation = cc.Animation:create()
	for i = 0, 16 do
		animation:addSpriteFrame(spritechache:getSpriteFrame(string.format("BiBei/Right/1/%d.png", i)))
	end
	animation:setDelayPerUnit(0.15)
	animation:setRestoreOriginalFrame(true)
	cc.AnimationCache:getInstance():addAnimation(animation, "right1")

	--玩家输了
	animation = cc.Animation:create()
	for i = 0, 24 do
		animation:addSpriteFrame(spritechache:getSpriteFrame(string.format("BiBei/Right/2/%d.png", i)))
	end
	animation:setDelayPerUnit(0.15)
	animation:setRestoreOriginalFrame(true)
	cc.AnimationCache:getInstance():addAnimation(animation, "right2")

	--等待开奖
	animation = cc.Animation:create()
	for i = 0, 20 do
		animation:addSpriteFrame(spritechache:getSpriteFrame(string.format("BiBei/Right/3/%d.png", i)))
	end
	animation:setDelayPerUnit(0.15)
	animation:setRestoreOriginalFrame(true)
	cc.AnimationCache:getInstance():addAnimation(animation, "right3")
end

function GameScene:unInitAnimation()
	for i=0,4 do
		cc.AnimationCache:getInstance():removeAnimation("boss" .. i)
	end
	for i=0,3 do
		cc.AnimationCache:getInstance():removeAnimation("left" .. i)
	end
	for i=0,3 do
		cc.AnimationCache:getInstance():removeAnimation("right" .. i)
	end
end

--正式可下注
function GameScene:blinkBibei()
	local action = cc.RepeatForever:create(cc.Sequence:create(
			cc.CallFunc:create(function() self.blink_:setOpacity(0) end),
			cc.DelayTime:create(0.5),
			cc.CallFunc:create(function() self.blink_:setOpacity(255) end),
			cc.DelayTime:create(0.5)
			))
	self.blink_:setVisible(true)
	-- self.arrow_:setVisible(true)--去掉箭头
	self.blink_:runAction(action)
	if self.isZiDongXuYa  then --开启自动续押, 个人分数大于续押分数
		print("用户上一局下注分数",self.lastScore)
		if GameScene.score_ >= self.lastScore then
			gamesvr.sendContineJetton();
			self.lastScore = 0;
		else 
				WarnTips.showTips(
					{
						text = LocalLanguage:getLanguageString("L_e133c4f4e1f15e15"),
						style = WarnTips.STYLE_Y
					}	
				)
				self.isZiDongXuYa = false;
				self.xuya:setVisible(true)
				self.xuyaquxiao:setVisible(false)
				self.lastScore = 0;
		end
		
	end
	
end

--胖子动作  瘦子动作 boss动作
function GameScene:Show()
	self:setVisible(true)


	self:refreshRemainScore()


	--瘦子动作
	self.image_left_:stopAllActions()
	self.image_left_:runAction(cc.RepeatForever:create(cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("left3"))))
	--胖子动作
	self.image_right_:stopAllActions()
	self.image_right_:runAction(cc.RepeatForever:create(cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("right3"))))

	for i=0,4 do
		self.image_boss_[i]:setVisible(false)
		self.image_boss_[i]:stopAllActions()
	end
	--BOSS动作
	self.image_boss_[3]:setVisible(true)
	self.image_boss_[3]:runAction(cc.RepeatForever:create(cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("boss3"))))

	self.big_defen_:stopAllActions()
	self.big_defen_:setVisible(false)

	self.yinzi_xiao_:loadTexture("caidaxiao/res/game/BiBei/Other/yinzi2.png")
	self.yinzi_xiao_:setVisible(false)
	self.yinzi_he_:loadTexture("caidaxiao/res/game/BiBei/Other/yinzi2.png")
	self.yinzi_he_:setVisible(false)
	self.yinzi_da_:loadTexture("caidaxiao/res/game/BiBei/Other/yinzi2.png")
	self.yinzi_da_:setVisible(false)


end

function GameScene:Hide()
	SoundManager.PlaySound(17)

	self.btn_maida_:removeAllChildren()
	self.btn_maixiao_:removeAllChildren() 
	self.btn_maihe_:removeAllChildren()

	self.image_left_:stopAllActions()
	self.image_right_:stopAllActions()
	for i=0,4 do
		self.image_boss_[i]:stopAllActions()
		self.image_boss_[i]:setVisible(false)
	end
	--瘦子动作
	self.image_left_:stopAllActions()
	self.image_left_:runAction(cc.RepeatForever:create(cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("left3"))))
	--胖子动作
	self.image_right_:stopAllActions()
	self.image_right_:runAction(cc.RepeatForever:create(cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("right3"))))

	self.image_boss_[3]:setVisible(true);
	self.image_boss_[3]:runAction(cc.RepeatForever:create(cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("boss3"))))
	self.dice1_:setVisible(false)
	self.dice2_:setVisible(false)

	self.yinzi_xiao_:loadTexture("caidaxiao/res/game/BiBei/Other/yinzi2.png")
	self.yinzi_xiao_:setVisible(false)
	self.yinzi_he_:loadTexture("caidaxiao/res/game/BiBei/Other/yinzi2.png")
	self.yinzi_he_:setVisible(false)
	self.yinzi_da_:loadTexture("caidaxiao/res/game/BiBei/Other/yinzi2.png")
	self.yinzi_da_:setVisible(false)

end

function GameScene:onExit()
	self:unInitAnimation()
end



function GameScene:onMaihe()
	if self.jettonScore_ > self.lUserMaxScore then --当前用户下注失败
		WarnTips.showTips(
		{
			text = LocalLanguage:getLanguageString("L_016fee87a06af238"),
			style = WarnTips.STYLE_Y
		}
		)
	else
		gamesvr.sendAddScore(2, self.jettonScore_)
	end
end

function GameScene:onMaida()
	if self.jettonScore_ > self.lUserMaxScore then --当前用户下注失败
		WarnTips.showTips(
		{
			text = LocalLanguage:getLanguageString("L_718b6163a04592fd"),
			style = WarnTips.STYLE_Y
		}
		)
	else
		gamesvr.sendAddScore(0, self.jettonScore_)
	end
	

end

function GameScene:onMaixiao()
	if self.jettonScore_ > self.lUserMaxScore then --当前用户下注失败
		WarnTips.showTips(
		{
			text = LocalLanguage:getLanguageString("L_016fee87a06af238"),
			style = WarnTips.STYLE_Y
		}
		)
	else
		gamesvr.sendAddScore(1, self.jettonScore_)
	end
	

end


function GameScene:onGameEndStatus( param )
	print("游戏结束-----=======------")
	

	self.blink_:stopAllActions()
	self.blink_:setVisible(false)
	self.arrow_:setVisible(false)

	self:onGameEnd(param)
	self.gameStatus:setVisible(false)
	self.statusTime:setVisible(false)
	self.ImageShiZhong:setVisible(false);

	self.status_pic:loadTexture("caidaxiao/res/game/BiBei/ainmpic/jsxz.png") --结束下注
	self.anim_pic:setPosition(0,360)
	self.anim_pic:setVisible(true)
	local action = cc.Sequence:create(
						cc.MoveTo:create(1,cc.p(550,360)),
						cc.DelayTime:create(0.3),
						cc.CallFunc:create(function() 
								self.status_pic:loadTexture("caidaxiao/res/game/BiBei/ainmpic/jsxz2.png") --结束下注
						end),
						cc.DelayTime:create(0.3),
						cc.CallFunc:create(function() 
								self.anim_pic:setVisible(false)
								self:onBibeiStart(param)
						end) 
					)
	self.anim_pic:stopAllActions();
	self.anim_pic:runAction(action)
end


function GameScene:onBibeiStart(param)
	for i=0,4 do
		self.image_boss_[i]:setVisible(false)
		self.image_boss_[i]:stopAllActions()
	end


	self.image_boss_[3]:setVisible(false)

	self.image_boss_[3]:stopAllActions()
	self.image_boss_[1]:setVisible(true)

	print("得分", param.WinScore)
	--显示两个骰子大小
	self.defen_ = param.WinScore
	self.dice1_:loadTexture("caidaxiao/res/game/BiBei/Other/dice" .. param.S1 .. ".png")
	self.dice2_:loadTexture("caidaxiao/res/game/BiBei/Other/dice" .. param.S2 .. ".png")

	if param.WinScore>0 then 
		--实现分数动态＋
		self:onStartTimerScore(param.WinScore,param.cbTimeLeave);
	end
	

	local boss_action1 = cc.Sequence:create(
				cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("boss1")),
				cc.CallFunc:create(function() 
						self.image_boss_[1]:setVisible(false)

						if param.WinScore > 0 then
							self.image_boss_[4]:setVisible(true)

							local boss_action4 = cc.Sequence:create(
							cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("boss4")),
							cc.CallFunc:create(function() 
									self.image_boss_[4]:setVisible(false)
									self.image_boss_[3]:setVisible(true)
									self.image_boss_[3]:runAction(cc.RepeatForever:create(cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("boss3"))))
									self:Hide()
									self.gameStatus:setVisible(true)
									self.statusTime:setVisible(true)
									self.ImageShiZhong:setVisible(true);

									self.Image_Win:loadTexture("caidaxiao/res/font/win.png")
									self.Image_Win:setVisible(true);
									self.big_defen_:setVisible(true)

									self.label_win_:setString(param.WinScore)
									self.label_lose_:setVisible(false);
									self.label_win_:setVisible(true)

									local title_action = cc.RepeatForever:create(cc.Sequence:create(
										cc.CallFunc:create(function() 
											self.big_defen_:setOpacity(255)
											self.big_defen_:loadTexture("caidaxiao/res/game/other/defen.png")
											end),
										cc.DelayTime:create(0.5),
										cc.CallFunc:create(function() 
											self.big_defen_:setOpacity(0)
											end),
										cc.DelayTime:create(0.5),
										cc.CallFunc:create(function() 
											self.big_defen_:setOpacity(255)
											self.big_defen_:loadTexture("caidaxiao/res/game/other/defen.png")
											end),
										cc.DelayTime:create(0.5),
										cc.CallFunc:create(function() 
											self.big_defen_:setOpacity(0)
											end),
										cc.DelayTime:create(0.5)
										))
									self.big_defen_:runAction(title_action)
								end) 
							)
							self.image_boss_[4]:runAction(boss_action4)

							--瘦子动作
							local left_action1 = cc.Sequence:create(
										cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("left1")),
										cc.CallFunc:create(function() 
												self.image_left_:runAction(cc.RepeatForever:create(cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("left3"))))
											end) 
										)
							self.image_left_:stopAllActions()
							self.image_left_:runAction(left_action1)

							--胖子动作
							local right_action1 = cc.Sequence:create(
										cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("right1")),
										cc.CallFunc:create(function() 
												self.image_right_:runAction(cc.RepeatForever:create(cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("right3"))))
											end) 
										)
							self.image_right_:stopAllActions()
							self.image_right_:runAction(right_action1);

						elseif param.WinScore== 0 then 							
							self.image_boss_[2]:setVisible(true)

							local boss_action2 = cc.Sequence:create(
							cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("boss2")),
							cc.CallFunc:create(function()
									self.gameStatus:setVisible(true);
									self.statusTime:setVisible(true);
									self.ImageShiZhong:setVisible(true); 

									self.Image_Win:loadTexture("caidaxiao/res/font/LOSE.png")
									self.Image_Win:setVisible(false);
									
									
									self.label_win_:setVisible(false)
									self.label_lose_:setVisible(false)
									self.label_lose_:setString(param.WinScore)

									local title_action = cc.RepeatForever:create(cc.Sequence:create(
										cc.CallFunc:create(function() 
											self.big_defen_:setOpacity(255)
											self.big_defen_:loadTexture("caidaxiao/res/font/LOSE.png")
											end),
										cc.DelayTime:create(0.5),
										cc.CallFunc:create(function() 
											self.big_defen_:setOpacity(0)
											end),
										cc.DelayTime:create(0.5),
										cc.CallFunc:create(function() 
											self.big_defen_:setOpacity(255)
											self.big_defen_:loadTexture("caidaxiao/res/font/LOSE.png")
											end),
										cc.DelayTime:create(0.5),
										cc.CallFunc:create(function() 
											self.big_defen_:setOpacity(0)
											end),
										cc.DelayTime:create(0.5)
										))
									if self.isJetton then
										self.big_defen_:runAction(title_action)
										self.big_defen_:setVisible(true)
									end
									

									self:Hide()
								end) 
							)
							self.image_boss_[2]:runAction(boss_action2)

							self.image_left_:stopAllActions()
							self.image_left_:runAction(cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("left2")))
							self.image_right_:stopAllActions()
							self.image_right_:runAction(cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("right2")))
						end
					end)
				)
	self.image_boss_[1]:runAction(boss_action1)

	--显示骰子
	self.dice1_:runAction(cc.Sequence:create(
		cc.DelayTime:create(0.75), 
		cc.CallFunc:create(function()
			SoundManager.PlaySound(100+param.S1+param.S2)
			self.dice1_:setVisible(true)
			self.dice2_:setVisible(true)
		 end),
		cc.DelayTime:create(2),
		cc.CallFunc:create(function()
					if param.WinScore > 0 then
						SoundManager.PlaySound(114)
					else
						SoundManager.PlaySound(113)
					end
				 end)		
	))

	--隐藏骰子
	if param.WinScore > 0 then
		self.dice2_:runAction(cc.Sequence:create(
			cc.DelayTime:create(35*0.15), 
			cc.CallFunc:create(function()
				self.dice1_:setVisible(false)
				self.dice2_:setVisible(false)
			 end)
		))
	end
end

function GameScene:yao( param )
	-- body
		local boss_action3 = cc.Sequence:create(
		cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("boss3")),
		cc.CallFunc:create(function (  )
				SoundManager.PlaySound(24)
				local action0 = cc.Sequence:create(
				cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("boss0")),
				cc.CallFunc:create(function() 
						SoundManager.PlaySound(23)
						self:yaonBack(param)
					end) 
				)

				self.image_boss_[3]:setVisible(false)
				self.image_boss_[0]:setVisible(true)
				self.image_boss_[0]:runAction(action0)

				--瘦子动作
				local left_action0 = cc.Sequence:create(
							cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("left0")),
							cc.CallFunc:create(function() 
									self.image_left_:runAction(cc.RepeatForever:create(cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("left3"))))
								end) 
							)
				self.image_left_:stopAllActions()
				self.image_left_:runAction(left_action0)

				--胖子动作
				local right_action0 = cc.Sequence:create(
							cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("right0")),
							cc.CallFunc:create(function() 
									self.image_right_:runAction(cc.RepeatForever:create(cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("right3"))))
								end) 
							)
				self.image_right_:stopAllActions()
				self.image_right_:runAction(right_action0)
		end) 
		)
	self.image_boss_[3]:stopAllActions()
	self.image_boss_[3]:runAction(boss_action3);
end

function GameScene:yaonBack(param) 

	self.image_boss_[3]:stopAllActions()
	self.image_boss_[0]:setVisible(false)
	self.image_boss_[3]:setVisible(true)
	self.image_boss_[3]:runAction(cc.RepeatForever:create(cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("boss3"))))

	self.status_pic:loadTexture("caidaxiao/res/game/BiBei/ainmpic/ksxz1.png") --开始下注
	self.anim_pic:setPosition(-700,360)
	self.anim_pic:setVisible(true)
	local action = cc.Sequence:create(
						cc.MoveTo:create(1,cc.p(550,360)),
						cc.DelayTime:create(0.3),
						cc.CallFunc:create(function() 
								self.status_pic:loadTexture("caidaxiao/res/game/BiBei/ainmpic/ksxz2.png") --开始下注
						end),
						cc.DelayTime:create(0.3),
						cc.CallFunc:create(function() 
								self.anim_pic:setVisible(false)
								self.gameStatus:loadTexture("caidaxiao/res/game/BiBei/Other/xiazhushijian.png")
								self.gameStatus:setVisible(true)
								self.statusTime:setVisible(true)
								self.ImageShiZhong:setVisible(true);
	                            --可下注
								self.btn_maihe_:setBright(true)
								self.btn_maihe_:setEnabled(true)
								self.btn_maida_:setBright(true)
								self.btn_maida_:setEnabled(true)
								self.btn_maixiao_:setBright(true)
								self.btn_maixiao_:setEnabled(true)
						
								self:blinkBibei()
						end) 
					)
	self.anim_pic:stopAllActions();
	self.anim_pic:runAction(action)
end

function GameScene:onUserRoom()
	local playerList = global.g_mainPlayer:getRoomAllPlayer();
	local index = 0;
	for key,value in pairs(playerList) do
    	index = index+1
	end
	self.lab_line:setString(index);
end

function GameScene:onEndEnterTransition()
	SoundManager.PlaySound(17)

	global.g_gameDispatcher:addMessageListener(GAME_EXCHANGE_SCORE_SUCCESS, self, self.onExchangeScoreSuccessHandler)
	global.g_gameDispatcher:addMessageListener(GAME_EXCHANGE_GOLD_SUCCESS, self, self.onExchangeGoldSuccessHandler)


	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAMEFREE, self, self.onGameFree) --空闲状态
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAMEPLAY, self, self.onGamePlay) --正在游戏
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAMESTART, self, self.onGameStart) --开始游戏


	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GETSCORE, self, self.onGetScore) --下注结果
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BIBEIDATAM, self, self.onBibeiData) --下注失败
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BIBEISTART, self, self.onGameEndStatus) --比倍结果(游戏结束)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAMERECORD, self, self.onRecord) --游戏路单

	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAMEJETTONLIST, self, self.onJettonList) --游戏下注数切换

	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_COME, self, self.onUserRoom) --用户进入房间
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_LEAVE, self, self.onUserRoom) -- 用户离开房间

end


function GameScene:onStartExitTransition()
	self:onStopTimer()
	self:onStopScore()
	self:unInitAnimation()

	--卸载
	for i=0,5 do
		local plist = string.format("caidaxiao/res/game/BiBei/pvr/BiBei%d.plist", i)
		cc.SpriteFrameCache:getInstance():releasePlist(plist)
	end

	for i=0,3 do
		local plist = string.format("caidaxiao/res/game/type/pvr/type%d.plist", i)
		cc.SpriteFrameCache:getInstance():releasePlist(plist)
	end

	global.g_gameDispatcher:removeMessageListener(GAME_EXCHANGE_SCORE_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_EXCHANGE_GOLD_SUCCESS, self)



	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAMEFREE, self) --空闲状态
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAMEPLAY, self) --正在游戏
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAMESTART, self) --开始游戏
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GETSCORE, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BIBEIDATAM, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BIBEISTART, self)

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAMERECORD, self) --游戏路单
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAMEJETTONLIST, self) --游戏下注数切换

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_COME, self) --用户进入房间
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_LEAVE, self) -- 用户离开房间
end

--刷新分数
function GameScene:onExchangeScoreSuccessHandler()
	-- self:refreshRemainScore()
end

--刷新分数
function GameScene:onExchangeGoldSuccessHandler()
	-- self:refreshRemainScore()
end

function GameScene:onJettonList( param )
	-- body
	self.jettonList_ = param.jettonList;
	self.jettonScore_ = self.jettonList_[1]; --默认选中第一个
	self.checks[1]:setVisible(true);
	for i=1,4 do
		self.jettonNums[i]:setString(self.jettonList_[i]);
	end
end

function GameScene:onGameFree( param )
	self.btn_maida_:removeAllChildren()
	self.btn_maixiao_:removeAllChildren() 
	self.btn_maihe_:removeAllChildren()

	self.lab_qu:setString(param.lAreaLimitScore)
	self.lab_ge:setString(param.lUserMaxScore)

	self:Show();
	self.gameStatus:setVisible(true)
	self.statusTime:setVisible(true)
	self.ImageShiZhong:setVisible(true);
	GameScene.score_ = param.m_UserScore;
	-- body
	self.gameStatus:loadTexture("caidaxiao/res/game/BiBei/Other/kongxianshijian.png");
	self.ImageShiZhong:setVisible(true);
	self.lUserMaxScore = param.lUserMaxScore --区域最大下注数
	self.remainTime_ = param.cbTimeLeave
	self:onStartTimer()
	self.btn_maihe_:setBright(false)
	self.btn_maihe_:setEnabled(false)
	self.btn_maida_:setBright(false)
	self.btn_maida_:setEnabled(false)
	self.btn_maixiao_:setBright(false)
	self.btn_maixiao_:setEnabled(false)

	--隐藏赢分布局
	self.big_defen_:stopAllActions()
	self.big_defen_:setVisible(false)

	for i=1,3 do
		self.quall_score[i]:setString(0);
	end

	for i=1,3 do
		self.qumy_score[i]:setString(0);
	end
	--游戏记录
	for i=1,10 do
		self.image_drop_[i]:setVisible(true);
		if param.m_GameRecord[i] == 1 then
			self.image_drop_[i]:loadTexture("caidaxiao/res/game/BiBei/Other/da.png")
		elseif param.m_GameRecord[i] == 2 then
			self.image_drop_[i]:loadTexture("caidaxiao/res/game/BiBei/Other/xiao.png")
		elseif param.m_GameRecord[i] == 3  then
			self.image_drop_[i]:loadTexture("caidaxiao/res/game/BiBei/Other/he.png")
		else
			self.image_drop_[i]:setVisible(false);
		end
	end
	self:onStopScore();
	self:refreshRemainScore();
end

function GameScene:onGamePlay( param )
	print("状态值=====",param.cbGameStatus);
	self.lab_qu:setString(param.lAreaLimitScore)
	self.lab_ge:setString(param.lUserMaxScore)
	
	-- body
	if param.cbGameStatus == 100 then --游戏开始 可下注
		self:onGameStart(param);
		self:initYuanBao(param);
	elseif param.cbGameStatus == 0 then--空闲  等待
		self:onGameFree(param)
	elseif param.cbGameStatus == 101 then--游戏结束  等待
		self.lUserMaxScore = param.lUserMaxScore --区域最大下注数
		self.gameStatus:setVisible(true)
		self.statusTime:setVisible(true)
		self.ImageShiZhong:setVisible(true);
		self:onGameEnd(param)
	end

	for i=1,3 do
		self.quall_score[i]:setString(param.lAreaInAllScore[i]);
	end

	local score = 0
	for i=1,3 do
		score = score + param.lUserInAllScore[i];
		self.qumy_score[i]:setString(param.lUserInAllScore[i]);
	end

	--游戏记录
	for i=1,10 do
		self.image_drop_[i]:setVisible(true);
		if param.m_GameRecord[i] == 1 then
			self.image_drop_[i]:loadTexture("caidaxiao/res/game/BiBei/Other/da.png")
		elseif param.m_GameRecord[i] == 2 then
			self.image_drop_[i]:loadTexture("caidaxiao/res/game/BiBei/Other/xiao.png")
		elseif param.m_GameRecord[i] == 3  then
			self.image_drop_[i]:loadTexture("caidaxiao/res/game/BiBei/Other/he.png")
		else
			self.image_drop_[i]:setVisible(false);
		end
	end
end
function GameScene:initYuanBao(param)


	for i=1,3 do
		self.quall_score[i]:setString(param.lAreaInAllScore[i]);
		local yuanbao = nil
		if param.lAreaInAllScore[i] >= 5000 then
			yuanbao = cc.Sprite:create("caidaxiao/res/game/BiBei/Other/yinzi3.png")

		elseif param.lAreaInAllScore[i] >= 1000 and param.lAreaInAllScore[i] < 5000 then
			yuanbao = cc.Sprite:create("caidaxiao/res/game/BiBei/Other/yinzi1.png")
		elseif param.lAreaInAllScore[i] >= 500 and param.lAreaInAllScore[i] < 1000 then
			yuanbao = cc.Sprite:create("caidaxiao/res/game/BiBei/Other/yinzi2.png")
		elseif param.lAreaInAllScore[i]>0 then 	
			yuanbao = cc.Sprite:create("caidaxiao/res/game/BiBei/Other/1.png")
		end

		if yuanbao then
			local quDtW = 130
			local quDtH = 60
    		local numW = math.random(-60, 60)
    		local numH = math.random(-50, 40)
			yuanbao:setScale(0.5)
			yuanbao:setPosition(quDtW+numW,quDtH+numH)
			if i == 1 then --大
				self.btn_maida_:addChild(yuanbao)
			elseif i == 2 then --小
				self.btn_maixiao_:addChild(yuanbao) 
			elseif i == 3 then --和
				self.btn_maihe_:addChild(yuanbao)	
			end	
		end

		

	end	

end

--游戏开始 可下注
function GameScene:onGameStart(param )
	self.isJetton = false -- 新的一局开始,用户下注初始化
	

	self.gameStatus:loadTexture("caidaxiao/res/game/BiBei/Other/youxikaishi.png")
	self.gameStatus:setVisible(false)
	self.statusTime:setVisible(false)
	self.ImageShiZhong:setVisible(false);
	print("游戏剩余时间:",param.cbTimeLeave)
	if param.cbTimeLeave >=17 then
		self.status_pic:loadTexture("caidaxiao/res/game/BiBei/ainmpic/ksys1.png") --开始摇骰
		self.anim_pic:setPosition(-700,360)
		self.anim_pic:setVisible(true)
		local action = cc.Sequence:create(
						cc.MoveTo:create(1,cc.p(550,360)),
						cc.DelayTime:create(0.3),
						cc.CallFunc:create(function() 
								self.status_pic:loadTexture("caidaxiao/res/game/BiBei/ainmpic/ksys2.png") --开始摇骰
						end),
						cc.DelayTime:create(0.3),
						cc.CallFunc:create(function() 
								self.anim_pic:setVisible(false)
								self:yao(param);
						end) 
					)
		self.anim_pic:stopAllActions();
		self.anim_pic:runAction(action)
	else
		self:yaonBack(param) 
	end
	
	self.lUserMaxScore = param.lUserMaxScore --区域最大下注数
	self.remainTime_ = param.cbTimeLeave
	self:onStartTimer()
end

function GameScene:onGameEnd( param )

	-- body
	self.gameStatus:loadTexture("caidaxiao/res/game/BiBei/Other/youxijiesu.png")
	self.remainTime_ = param.cbTimeLeave
	self:onStartTimer()

	self.btn_maihe_:setBright(false)
	self.btn_maihe_:setEnabled(false)
	self.btn_maida_:setBright(false)
	self.btn_maida_:setEnabled(false)
	self.btn_maixiao_:setBright(false)
	self.btn_maixiao_:setEnabled(false)


end

--下注成功
function GameScene:onGetScore( param )
	local yuanbao = nil
	if param.lJettonScore >= self.jettonList_[4] then
		yuanbao = cc.Sprite:create("caidaxiao/res/game/BiBei/Other/yinzi3.png")

	elseif param.lJettonScore >= self.jettonList_[3] and param.lJettonScore < self.jettonList_[4] then
		yuanbao = cc.Sprite:create("caidaxiao/res/game/BiBei/Other/yinzi1.png")
	elseif param.lJettonScore >= self.jettonList_[2] and param.lJettonScore < self.jettonList_[3] then
		yuanbao = cc.Sprite:create("caidaxiao/res/game/BiBei/Other/yinzi2.png")
	else	
		yuanbao = cc.Sprite:create("caidaxiao/res/game/BiBei/Other/1.png")
	end

	for i=1,3 do
		self.quall_score[i]:setString(param.lAreaInAllScore[i]);
	end	
	
	local quDtW = 130
	local quDtH = 60
    local numW = math.random(-60, 60)
    local numH = math.random(-50, 40)
	yuanbao:setScale(0.5)
	yuanbao:setPosition(quDtW+numW,quDtH+numH)
	print(quDtW+numW,quDtH+numH)
	if param.wChairID == GameScene.chairId_ then --自己下注
		print("自己下注")
		self.isJetton = true; -- 当前用户下注了
		self.lastScore = self.lastScore + param.lJettonScore;

		local score = 0
		for i=1,3 do
			score = score + param.lUserInAllScore[i];
			self.qumy_score[i]:setString(param.lUserInAllScore[i]);
		end
		GameScene.score_ = GameScene.score_ - param.lJettonScore;
		self:refreshRemainScore();
		if param.cbJettonArea == 0 then --大
			self.btn_maida_:addChild(yuanbao)
		elseif param.cbJettonArea == 1 then --小
			self.btn_maixiao_:addChild(yuanbao) 
		elseif param.cbJettonArea == 2 then --和
			self.btn_maihe_:addChild(yuanbao)	
		end	

	else  --其他人下注 筹码移动
		print("其他人下注")
		--大(180,415) 和(495,415),小(808,415)
		local x = quDtW+numW;
		local y = quDtH+numH;
		if param.cbJettonArea == 0 then --大
			yuanbao:setPosition(180+130,415)
			self.btn_maida_:addChild(yuanbao)
		elseif param.cbJettonArea == 1 then --小
			yuanbao:setPosition(808+130,415)
			self.btn_maixiao_:addChild(yuanbao) 
		elseif param.cbJettonArea == 2 then --和
			yuanbao:setPosition(495+130,415)
			self.btn_maihe_:addChild(yuanbao)	
		end	
		local action = cc.Sequence:create(
								cc.MoveTo:create(1,cc.p(x,y)),
								cc.CallFunc:create(function() 
												-- for i=1,3 do
												-- 	self.quall_score[i]:setString(param.lAreaInAllScore[i]);
												-- end
											end)
								)

		yuanbao:runAction(action)
	end
end


--下注失败
function GameScene:onBibeiData( param)
	-- body

	if param.wPlaceUser == GameScene.chairId_ then --当前用户下注失败
		WarnTips.showTips(
		{
			text = LocalLanguage:getLanguageString("L_343ae168b2b36d9a"),
			style = WarnTips.STYLE_Y
		}
		)
	end
	
end


function GameScene:onRecord( param )
	-- body
	print("游戏路单")
	PopUpView.showPopUpView(LuDanView,param.m_GameRecord);
end

--倒计时
function GameScene:onStartTimer()
	self:onStopTimer()

	self.statusTime:setColor(COLOR_WHITE)

	self.statusTime:setString(self.remainTime_)
	self.timeHandler_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.onTimer), 1, false)
end

function GameScene:onTimer()
	self.remainTime_ = self.remainTime_ - 1
	if self.remainTime_ > 0 then
		self.statusTime:setString(self.remainTime_)
	else
		-- AudioEngine.stopMusic()
		self:onStopTimer()
	end

	if self.status_ == STATUS_JETTON and self.remainTime_ <= 5 then
		self.statusTime:setColor(COLOR_RED)
		-- AudioEngine.playEffect("feiqinzoushou/res/sound/birds_muisc_time_count.mp3")
	end

end

function GameScene:onStopTimer()
	if self.timeHandler_ then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.timeHandler_)
		self.timeHandler_ = nil
	end
end

function GameScene:onStartTimerScore( score ,time)
	self:onStopScore();
	local dt = time/score
	if dt < 0 then
		dt = 0-dt
	end
	print("倒计时时间",dt)
	self.remainTimeScore_ = score
	self.timeHandlerScore_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.onTimerScore), dt, false)
end
function GameScene:onTimerScore( ... )
	if self.remainTimeScore_ == 0 then
		self:onStopScore()
	else 
		local score = self.remainScore_:getString()
		self.remainScore_:setString(score+1);
	end

	self.remainTimeScore_ = self.remainTimeScore_ - 1	
end

function GameScene:onStopScore()
	if self.timeHandlerScore_ then --停止分数倒计时
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.timeHandlerScore_)
		self.timeHandlerScore_ = nil
	end
end

