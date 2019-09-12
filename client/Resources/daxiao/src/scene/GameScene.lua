GameScene = class("GameScene", LayerBase)

local LIGHT_COUNT = 28
local TAIL_COUNT = 8

local DELTA_POS = 3

local SWITCH_JETTON_BASE = {
	10,
	50,
	100,
	500,
	1000,
	10000
}

local idle=0
local moved=1
local attack=2
local defense=3

local STATUS_WAIT = 0
local STATUS_IDLE = 1
local STATUS_JETTON = 2
local STATUS_RUN = 3

local TOWARD_RIGHT = 1
local TOWARD_LEFT = 2

function GameScene:ctor()
	GameScene.super.ctor(self)
	self.status_ = STATUS_WAIT
	GameScene.gold_ = global.g_mainPlayer:getPlayerScore()
	GameScene.score_ = 0
	local ratio = global.g_mainPlayer:getCurrentRoomBeilv()
	GameScene.score_ = math.floor(GameScene.gold_ * ratio)
	GameScene.gold_ = 0
	self.progressTime_=0
	self.indexValue=1

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("daxiao/res/json/ui_game.json")
	self:addChild(root)

	self.autoBet=false
	self.areaLimitScore=10000
	self.userLimitScore=5000
	self.totalScore=0
	self.alluserTotal={}
	self.alluserTotal={[1]=0,[2]=0,[3]=0}
	self.popList={}
	self.popindex=1
	self.timeAnimate={}
	self.Popidx={}
	self:setPopAnim()
	self.popPosition={}

	self.indexAnim=1
	self.counter=0
	self.jettonResult={}

	self.imageview = ccui.Helper:seekWidgetByName(root, "Image_1")
	self.imageview:setOpacity(1)
	self.imageRun = ccui.Helper:seekWidgetByName(self.imageview, "Image_12")
	self.runActionimage = ccui.Helper:seekWidgetByName(root, "Image_16")

	self.tips = ccui.Helper:seekWidgetByName(self.imageview, "Image_2")

	print("imageview=====================",self.imageview:getPositionY(),self.imageview:getPositionX())

	self.Panel_80 = ccui.Helper:seekWidgetByName(root, "Panel_80")
	self.remainScore_ = ccui.Helper:seekWidgetByName(self.Panel_80, "Label_30")
	self.remainScore_:setString(GameScene.score_)
	self.score_=GameScene.score_

	self.starImg=ccui.Helper:seekWidgetByName(self.Panel_80, "Image_13_star")

	self.platform=ccui.Helper:seekWidgetByName(root, "Panel_45")
	self.platformani=ccui.Helper:seekWidgetByName(root, "Panel_17xx")
	self.platformui=ccui.Helper:seekWidgetByName(root, "Panel_45_0")

	self.panelClone=ccui.Helper:seekWidgetByName(self.platform, "Panel_12_clone")
	self.leftPanel=ccui.Helper:seekWidgetByName(self.platform, "Panel_18_post")
	self.rigthPanel=ccui.Helper:seekWidgetByName(self.platform, "Panel_19_post")

	for i=1,5 do
		local item1={}
		item1.x=self.leftPanel:getPositionX()
		item1.y=self.leftPanel:getPositionY()+self.leftPanel:getContentSize().height*(i-1)
		item1.x2=item1.x-self.leftPanel:getContentSize().width
		self.popPosition[i]=item1

		local item2={}
		item2.x=self.rigthPanel:getPositionX()
		item2.y=self.rigthPanel:getPositionY()+self.rigthPanel:getContentSize().height*(i-1)
		item2.x2=item2.x+self.rigthPanel:getContentSize().width
		self.popPosition[i+5]=item2
	end
	--table.dump(self.popPosition)
	
	self.titleImage = ccui.Helper:seekWidgetByName(self.platform, "Image_12t")
	self.timePanel = ccui.Helper:seekWidgetByName(root, "Panel_134")
	self.timePanel:setVisible(false)

	self.mediumRole = ccui.Helper:seekWidgetByName(self.platform, "Image_31")
	self.mediumRole:setScale(0.35)
	
	self.imageOk = ccui.Helper:seekWidgetByName(root, "Image_111")
	self.centerAnim = ccui.Helper:seekWidgetByName(self.platform, "Image_12ca")
	self.centerAnim2 = ccui.Helper:seekWidgetByName(self.platform, "Image_12_0ca")

	self.leftRole = ccui.Helper:seekWidgetByName(root, "Panel_13_l")
	self.rightRole = ccui.Helper:seekWidgetByName(root, "Panel_14_r")
	self.roleheight = self.leftRole:getPositionY()
	
	self.leftProgress = ccui.Helper:seekWidgetByName(root, "ProgressBar_19")
	self.rightProgress = ccui.Helper:seekWidgetByName(root, "ProgressBar_20")

	self.recodebg = ccui.Helper:seekWidgetByName(root, "Image_385")
	
	self.Panel_80:runAction(cc.Sequence:create(
							cc.Repeat:create(cc.Sequence:create(
								cc.DelayTime:create(0.8),
								cc.CallFunc:create(function()
									ccui.Helper:seekWidgetByName(self.Panel_80, "Image_16"):setVisible(false)
									ccui.Helper:seekWidgetByName(self.Panel_80, "Image_17"):setVisible(false)
								 end),
								cc.DelayTime:create(0.8),
								cc.CallFunc:create(function() 
									ccui.Helper:seekWidgetByName(self.Panel_80, "Image_16"):setVisible(true)
									ccui.Helper:seekWidgetByName(self.Panel_80, "Image_17"):setVisible(true)
								 end)
								), -1)
						))
	-------------------------------------
	self.panel_13 = ccui.Helper:seekWidgetByName(self.imageview, "Panel_13")
	self.panel_13:setVisible(false)

	self.checkbox17_ = ccui.Helper:seekWidgetByName(root,"CheckBox_17")
	self.checkbox17_:addEventListener(handler(self, self.onSelectChangeHandler))
	self.checkbox17_:setSelected(false)

	local btnSetting = ccui.Helper:seekWidgetByName(root, "Image_13click")
	local function onSettingHandler(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
		  	self.panel_13:setVisible(true)
		  	AudioEngine.playEffect("daxiao/res/sound/click.mp3")
		end
	end
	btnSetting:addTouchEventListener(onSettingHandler)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_20")
	local function onCloseHandler(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
		  	self.panel_13:setVisible(false)
		  	AudioEngine.playEffect("daxiao/res/sound/click.mp3")
		end
	end
	btnClose:addTouchEventListener(onCloseHandler)
	-------------------------------------
	local panel_12 = ccui.Helper:seekWidgetByName(root, "Panel_12")
	local soundBtn = ccui.Helper:seekWidgetByName(root, "Button_13")
	local function onSoundBtn(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			AudioEngine.playEffect("daxiao/res/sound/click.mp3")
		  	panel_12:setVisible(true)
		  	self.panel_13:setVisible(false)
		end 
	end 
	soundBtn:addTouchEventListener(onSoundBtn)

	local btnClose1 = ccui.Helper:seekWidgetByName(panel_12, "Button_13")
	local function onCloseHandler1(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
		  	panel_12:setVisible(false)
		  	AudioEngine.playEffect("daxiao/res/sound/click.mp3")
		end
	end
	btnClose1:addTouchEventListener(onCloseHandler1)

	self.sliderEffect_ = ccui.Helper:seekWidgetByName(panel_12, "Slider_24")
	self.sliderEffect_:addEventListener(handler(self, self.onEffectVolume))

	self.sliderSound_ = ccui.Helper:seekWidgetByName(panel_12, "Slider_26")
	self.sliderSound_:addEventListener(handler(self, self.onSoundVolume))
	-------------------------------------------------------
	local panel_16 = ccui.Helper:seekWidgetByName(root, "Panel_16")
	local recordBtn = ccui.Helper:seekWidgetByName(root, "Button_14")
	local function onRecordBtn(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
		  	panel_16:setVisible(true)
		  	self.panel_13:setVisible(false)
		  	self:setListView()
		  	AudioEngine.playEffect("daxiao/res/sound/click.mp3")
		end 
	end 
	recordBtn:addTouchEventListener(onRecordBtn)

	local recordbtn=ccui.Helper:seekWidgetByName(self.platformui, "Button_17")
	local function onRecordHandler(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
		  	if panel_16:isVisible() then
		  		panel_16:setVisible(false)
		  	else
		  		panel_16:setVisible(true)
		  		self:setListView()
		  	end
		  	AudioEngine.playEffect("daxiao/res/sound/click.mp3")
		end
	end
	recordbtn:addTouchEventListener(onRecordHandler)

	self.switchLabel=ccui.Helper:seekWidgetByName(self.platformui, "Label_19")
	

	local switchBtn=ccui.Helper:seekWidgetByName(self.platformui, "Button_18")
	local function onSwitchHandler(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self.indexJettonBase_ = self.indexJettonBase_ + 1
			self.indexJettonBase_ = self.indexJettonBase_ > #SWITCH_JETTON_BASE and 1 or self.indexJettonBase_
			self:refreshJettonBase()
		  	AudioEngine.playEffect("daxiao/res/sound/click.mp3")
		end
	end
	switchBtn:addTouchEventListener(onSwitchHandler)

	local btnClose2 = ccui.Helper:seekWidgetByName(panel_16, "Button_21")
	local function onCloseHandler2(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
		  	panel_16:setVisible(false)
		  	AudioEngine.playEffect("daxiao/res/sound/click.mp3")
		end
	end
	btnClose2:addTouchEventListener(onCloseHandler2)

	self.indexJettonBase_ = 1
	self.labelJettonBase_ = ccui.Helper:seekWidgetByName(self.panel_13, "Label_19")
	self.switchLabel:setString(SWITCH_JETTON_BASE[self.indexJettonBase_])
	self:refreshJettonBase()
	local btnSwitch1 = ccui.Helper:seekWidgetByName(self.panel_13, "Button_16")
	btnSwitch1:setTag(1)
	btnSwitch1:addTouchEventListener(makeClickHandler(self, self.onSwitchJettonBaseHandler))

	local btnSwitch2 = ccui.Helper:seekWidgetByName(self.panel_13, "Button_15")
	btnSwitch2:setTag(2)
	btnSwitch2:addTouchEventListener(makeClickHandler(self, self.onSwitchJettonBaseHandler))

	local btnExit = ccui.Helper:seekWidgetByName(root, "Button_12")
	local function onExitHandler(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			AudioEngine.playEffect("daxiao/res/sound/click.mp3")
			global.g_mainPlayer:setPlayerScore(GameScene.gold_ + math.floor(GameScene.score_/global.g_mainPlayer:getCurrentRoomBeilv()))
			WarnTips.showTips({
					text = LocalLanguage:getLanguageString("L_6ceb2e80d33e115e"),
					confirm = exit_daxiao
				})
		end 
	end
	btnExit:addTouchEventListener(onExitHandler)

	self.rRoleImage = ccui.Helper:seekWidgetByName(self.Panel_80, "Image_14_rr")
	self.lRoleImage = ccui.Helper:seekWidgetByName(self.Panel_80, "Image_15_lr")

	self.tipLabel = ccui.Helper:seekWidgetByName(self.Panel_80, "Label_12_0")
	self.scoreLabel = ccui.Helper:seekWidgetByName(self.Panel_80, "Label_12")
	self.scoreLabel.x=self.scoreLabel:getPositionX()
	self.scoreLabel.y=self.scoreLabel:getPositionY()

	self.startImage = ccui.Helper:seekWidgetByName(self.imageview, "Image_15_logo")
	self.startImage:runAction(cc.FadeOut:create(0.01))
	self:onSetBateRole()

	self.btns_ = {}
	for i=1,3 do
		local baseImg = ccui.Helper:seekWidgetByName(self.platformui, "Image_"..(60+i))
		self.btns_[i] = baseImg
		baseImg.btnAnim = ccui.Helper:seekWidgetByName(self.platformui, "Image_g"..(16+i))
		baseImg.btnAnim:setOpacity(1)
		baseImg.title = ccui.Helper:seekWidgetByName(baseImg, "Image_12")
		baseImg.title:setOpacity(1)
		baseImg.fire = ccui.Helper:seekWidgetByName(self.platformui, "Image_f"..(11+i))
		baseImg.fire:setOpacity(1)
		baseImg.img1 = ccui.Helper:seekWidgetByName(baseImg, "Image_14")
		baseImg.img2 = ccui.Helper:seekWidgetByName(baseImg, "Image_15")
		baseImg.proImg={}
		baseImg.progress={}
		for j=1,4 do
			baseImg.progress[j] = ccui.Helper:seekWidgetByName(baseImg, "ProgressBar_"..(21+j))
			baseImg.progress[j]:setPercent(0)
			
			baseImg.proImg[j] = ccui.Helper:seekWidgetByName(baseImg, "Image_"..(15+j))
			baseImg.proImg[j]:setOpacity(1)
		end
		self.btns_[i].labels = ccui.Helper:seekWidgetByName(baseImg, "Label_24")
		self.btns_[i].labell = ccui.Helper:seekWidgetByName(baseImg, "Label_25")
		local btn = ccui.Helper:seekWidgetByName(self.platformui, "Button_"..(21+i))
		btn:setTag(i)
		btn:addTouchEventListener(makeClickHandler(self, self.onJettonAnimal))
	end

	self.lights_ = {}
	self.history_images_ = {}
	for i = 1, 15 do
		self.history_images_[i] = ccui.Helper:seekWidgetByName(root, "history" .. i)
		self.history_images_[i]:setVisible(false)
	end

	self.listView_ = ccui.Helper:seekWidgetByName(panel_16, "ListView_12")
	self.item=ccui.Helper:seekWidgetByName(panel_16, "Panel_13")
	self.item:setVisible(false)
	self.listView_1 = ccui.Helper:seekWidgetByName(panel_16, "ListView_12_0")
	self.listView_1:setVisible(false)
	self.item1=ccui.Helper:seekWidgetByName(panel_16, "Panel_13_0")
	self.item1:setVisible(false)

	self.indexh=1
	local changeBtn = ccui.Helper:seekWidgetByName(panel_16, "Button_22")
	local function onChangeBtn(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			AudioEngine.playEffect("daxiao/res/sound/click.mp3")
			if self.indexh==1 then
				self.indexh=2
				self.listView_:setVisible(false)
				self.listView_1:setVisible(true)
			else
				self.indexh=1
				self.listView_:setVisible(true)
				self.listView_1:setVisible(false)
			end
		end
	end 
	changeBtn:addTouchEventListener(onChangeBtn)
	
	self.jettonPanel_ = ccui.Helper:seekWidgetByName(root, "Panel_82")
	self.timeLabel = ccui.Helper:seekWidgetByName(self.timePanel, "AtlasLabel_12")
	self.last_jettons_ = {}
	self.recordlist = {}

	self.nusnum = 1 -- 纪录开奖次数
	self.nndd = 1

	self:onStart()
	--初始化返回键
	self:initBackKey()
	self.freeCounter=1
	self.freeHandler_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.onFreeCounter), 1, false)
	AudioEngine.playMusic("daxiao/res/sound/bgm.mp3", true)
end

function GameScene:setPopAnim()
	local nums={[1] = 1,[2] = 2,[3] = 3,[4] = 4,[5] = 5,[6] = 6,[7] = 7,[8] = 8,[9] = 9,[10] = 10}
	for i=1,10 do
		self.timeAnimate[i]=math.random(1,15)/10
		local index=math.random(1,10)
		local num=nums[i]
		nums[i]=nums[index]
		
		nums[index]=num
	end
	self.Popidx=nums
	--table.dump(self.timeAnimate)
	--table.dump(self.Popidx)
end

function GameScene:createButtonAnim( node, bimg, rectTab, time, count) 
	local tab = {}
  	local spriteDog = nil
  	for i=0, count do
  		local str=bimg..i..".png"
  		local textureDog = cc.Director:getInstance():getTextureCache():addImage(str)
    	local frame = cc.SpriteFrame:createWithTexture(textureDog, rectTab)
    	table.insert(tab, i, frame)

   		if i == 0 then
      		spriteDog = cc.Sprite:createWithSpriteFrame(frame)
    	end
  	end

  	local animation = cc.Animation:createWithSpriteFrames(tab, time)
  	local animate = cc.Animate:create(animation)
  	spriteDog:runAction(cc.RepeatForever:create(animate))
  	spriteDog:setPositionX(spriteDog:getContentSize().width/2)
  	spriteDog:setPositionY(spriteDog:getContentSize().height/2)
  	node:addChild(spriteDog)
  	node.ani=spriteDog
end
--复选框
function GameScene:onSelectChangeHandler(sender, eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		self.autoBet=true
		AudioEngine.playEffect("daxiao/res/sound/click.mp3")
	elseif eventType == ccui.CheckBoxEventType.unselected then
		self.autoBet=false
		AudioEngine.playEffect("daxiao/res/sound/click.mp3")
	end
end

function GameScene:onEffectVolume()
	local volume = self.sliderEffect_:getPercent() / 100
	AudioEngine.setEffectsVolume(volume)
end

function GameScene:onSoundVolume()
	local volume = self.sliderSound_:getPercent() / 100
	AudioEngine.setMusicVolume(volume)
end

function GameScene:initBackKey()
    self.back_release_ = true
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(handler(self, self.keyboardReleased), cc.Handler.EVENT_KEYBOARD_RELEASED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function GameScene:keyboardReleased(keycode, event)
    if keycode == 6 then --返回键
    	if self.back_release_ then
        	self.back_release_ = false
        	local function onCancel()
          		self.back_release_ = true
        	end
        	global.g_mainPlayer:setPlayerScore(GameScene.gold_ + math.floor(GameScene.score_/global.g_mainPlayer:getCurrentRoomBeilv()))
        	WarnTips.showTips({
				text = LocalLanguage:getLanguageString("L_6ceb2e80d33e115e"),
				confirm = exit_daxiao,
				cancel = onCancel
			})
      	end
    end
end

function GameScene:onStart()--第一次开始,直接等待
	self:onWait(60)
end

function GameScene:onWait(time)--等待倒计时开始
	self.remainTime_ = time
	self:onStartTimer()
end

function GameScene:onJetton(time)--下注倒计时开始
	self.status_ = STATUS_JETTON
	self.remainTime_ = time
	self.timeLabel:setString(self.remainTime_)
	self:onStartTimer()
end

function GameScene:onLottery(time)--开奖倒计时开始
	self.status_ = STATUS_RUN
	self.remainTime_ = time
end

function GameScene:onStartTimer()
	self:onStopTimer()
	self.timeHandler_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.onTimer), 1, false)
	if self.animateHandler_ then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.animateHandler_)
		self.animateHandler_ = nil
	end
	self.animateHandler_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.onAnimate), 1.5, false)
end

function GameScene:onStopTimer()
	if self.timeHandler_ then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.timeHandler_)
		self.timeHandler_ = nil
	end
end

function GameScene:onTimer()
	self.remainTime_ = self.remainTime_ - 1
	if self.remainTime_ > 0 then
		if self.timePanel:isVisible() then
			AudioEngine.playEffect("daxiao/res/sound/second.mp3")
		end
		self.timeLabel:setString(self.remainTime_)
	else
		self:onStopTimer()
	end
end
--1 大 蓝
--2 小 红
--3 和 绿
local value={
	[1]=1,
	[2]=2,
	[3]=0
}

function GameScene:onJettonAnimal(sender)
	if self.status_ == STATUS_JETTON then
		local animalId = sender:getTag()
		local base = SWITCH_JETTON_BASE[self.indexJettonBase_]

		AudioEngine.playEffect("daxiao/res/sound/click.mp3")

		if base>self.score_ then
			self:Tip(LocalLanguage:getLanguageString("L_e2879698f53e39b0"))
			return
		end

		if self.userLimitScore<=self.totalScore then
			self:Tip(LocalLanguage:getLanguageString("L_bfa76cb6bc5e5729"))
			return
		end

		if self.userLimitScore<=(self.totalScore+base) then
			base=self.userLimitScore-self.totalScore
		end

		gamesvr.sendJetton(value[animalId], base)

		self.freeCounter=0
	else
		self:Tip(LocalLanguage:getLanguageString("L_028a9039e00b758e"))
	end
end

function GameScene:refreshJettonBase()
	local base = SWITCH_JETTON_BASE[self.indexJettonBase_]
	self.switchLabel:setString(base)
	self.labelJettonBase_:setString(base)
end

function GameScene:onSwitchJettonBaseHandler(sender, eventType)
	if sender:getTag()==1 then
		self.indexJettonBase_ = self.indexJettonBase_ + 1
		self.indexJettonBase_ = self.indexJettonBase_ > #SWITCH_JETTON_BASE and #SWITCH_JETTON_BASE or self.indexJettonBase_
	else
		self.indexJettonBase_ = self.indexJettonBase_ - 1
		self.indexJettonBase_ = self.indexJettonBase_ < 1 and 1 or self.indexJettonBase_
	end

	self:refreshJettonBase()
	AudioEngine.playEffect("daxiao/res/sound/click.mp3")
end

function GameScene:setListView()
	self.item:setVisible(true)
	self.listView_:removeAllChildren()
	local tables={}
	local function setdata(tables)
		if #self.recordlist>0 then
			local idx=1
			local flag=self.recordlist[1]
			local count=0
			local tab={}
			for i=1,#self.recordlist do
				local value=self.recordlist[i]
				if count==5 or flag~=value then
					flag=value
					tables[idx]=tab
					idx=idx+1
					count=0
					tab={}
				end
				table.insert(tab,value)
				count=count+1
			end
			if #tab>0 then
				tables[idx]=tab
			end
		end
	end
	setdata(tables)
	for i=1,#tables do
		local itemclone=self.item:clone()
		if i~=1 then 
			local newImg = ccui.Helper:seekWidgetByName(itemclone, "Image_12new")
			newImg:setVisible(false)
		end
		for j=1,5 do
			local img = ccui.Helper:seekWidgetByName(itemclone, "Image_"..13+j)
			if tables[i][j] and tables[i][j]>0 then
				if tables[i][j]==1 then
					img:loadTexture("daxiao/res/game/img_dzjgjl_hong.png")
				elseif tables[i][j]==2 then
					img:loadTexture("daxiao/res/game/img_dzjgjl_lv.png")
				elseif tables[i][j]==3 then
					img:loadTexture("daxiao/res/game/img_dzjgjl_lan.png")
				end
			else
				img:setVisible(false)
			end
		end
		self.listView_:pushBackCustomItem(itemclone)
	end
	self.item:setVisible(false)
	self.item1:setVisible(true)

	self.listView_1:removeAllChildren()
	local num=math.floor(#self.recordlist/12)
	if #self.recordlist%12>0 then num=num+1 end
	local idx=1
	for i=1,num do
		local itemclone=self.item1:clone()
		if i~=1 then 
			local newImg = ccui.Helper:seekWidgetByName(itemclone, "Image_13new")
			newImg:setVisible(false)
		end
		for j=1,12 do
			local img=ccui.Helper:seekWidgetByName(itemclone, "Image_"..13+j)
			if self.recordlist[idx] and self.recordlist[idx]>0 then
				if self.recordlist[idx]==1 then
					img:loadTexture("daxiao/res/game/img_dzjgjl_hong.png")
				elseif self.recordlist[idx]==2 then
					img:loadTexture("daxiao/res/game/img_dzjgjl_lv.png")
				elseif self.recordlist[idx]==3 then
					img:loadTexture("daxiao/res/game/img_dzjgjl_lan.png")
				end
			else
				img:setVisible(false)
			end
			idx=idx+1
		end
		self.listView_1:pushBackCustomItem(itemclone)
	end
	self.item1:setVisible(false)
end

function GameScene:onExchangeScoreSuccessHandler()
	
end

function GameScene:onExchangeGoldSuccessHandler()
	
end

function GameScene:onProgress()
	self.progressTime_ = self.progressTime_ - 10
	self.progressA_ = self.progressA_-math.random(9,12)
    self.progressB_ = self.progressB_-math.random(9,12)
	if self.resultIndex==1 then
		if self.progressTime_>10 then
			self.leftProgress:setPercent(self.progressA_)
		end
		self.rightProgress:setPercent(self.progressB_)
	elseif self.resultIndex==2 then
		if self.progressTime_>10 then
			self.leftProgress:setPercent(self.progressA_)
			self.rightProgress:setPercent(self.progressB_)
		end
	elseif self.resultIndex==3 then
		self.leftProgress:setPercent(self.progressA_)
		if self.progressTime_>10 then
			self.rightProgress:setPercent(self.progressB_)
		end
	end
	if self.progressTime_ <= 0 then
		self.progressTime_=0
		if self.progressHandler_ then
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.progressHandler_)
			self.progressHandler_ = nil
		end
	end
end

function GameScene:onFreeCounter()
	self.freeCounter=self.freeCounter+1
	if self.freeCounter>=60 then
		self.tips:setVisible(true)
		local timeLabel = ccui.Helper:seekWidgetByName(self.tips, "AtlasLabel_3")
		timeLabel:setString(90-self.freeCounter)
		if self.freeCounter>=90 then
			exit_daxiao()
		end
	else
		self.tips:setVisible(false)
	end
end

function GameScene:onAnimate()
	if self.status_ == STATUS_RUN then
		self.counter=self.counter+1
		if self.counter==30 then
			if self.animateHandler_ then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.animateHandler_)
				self.animateHandler_ = nil
			end
		end
	end
	if self.popList[self.popindex] then
		local count=#self.popList-self.popindex+1
		if count>10 then
			count=10
		end
		self.panelClone:setVisible(true)
		for i=1,count do
			local item1=self.panelClone:clone()
			local index=self.Popidx[self.indexAnim]
			
			local item=self.popPosition[index]
			local time=self.timeAnimate[self.indexAnim]
			item1:setPositionX(item.x2)
			item1:setPositionY(item.y)
			item1:runAction(cc.Sequence:create(cc.DelayTime:create(time),cc.MoveTo:create(0.25,cc.p(item.x,item.y)),cc.DelayTime:create(1),cc.MoveTo:create(0.25,cc.p(item.x2,item.y)),cc.RemoveSelf:create()))
			self.platformani:addChild(item1)

			local data=self.popList[self.popindex]
			local img=ccui.Helper:seekWidgetByName(item1, "Image_13")
			local userid=ccui.Helper:seekWidgetByName(item1, "Label_12")
			userid:setString(data.userid)
			local forward=ccui.Helper:seekWidgetByName(item1, "Label_14")
			if data.index==1 then
				forward:setString(LocalLanguage:getLanguageString("L_3f24a912cf731786"))
				forward:setColor(cc.c3b(95,185,255))
				img:loadTexture("daxiao/res/game/img_tk_lan.png")
			elseif data.index==2 then
				forward:setString(LocalLanguage:getLanguageString("L_4f46d3291c41314e"))
				forward:setColor(cc.c3b(255,75,94))
				img:loadTexture("daxiao/res/game/img_tk_hong.png")
			else
				forward:setString(LocalLanguage:getLanguageString("L_6f67e9757094d8e6"))
				forward:setColor(cc.c3b(95,255,140))
				img:loadTexture("daxiao/res/game/img_tk_lv.png")
			end
			local num=ccui.Helper:seekWidgetByName(item1, "Label_16")
			num:setString(data.amount)

			local lable=ccui.Helper:seekWidgetByName(item1, "Label_17")
			lable:setPositionX(num:getPositionX()+num:getContentSize().width)
			forward:setPositionX(lable:getPositionX()+lable:getContentSize().width)

			self.popindex=self.popindex+1
			self.indexAnim=self.indexAnim>=10 and 1 or self.indexAnim+1
		end
		self.panelClone:setVisible(false)
	end
end
--1 大 蓝
--2 小 红
--3 和 绿
function GameScene:onGameStatusIdleHandler(param)
	table.dump(param)
	self.score_=param.userScore
	--self.areaLimitScore=param.areaLimitScore
	self.userLimitScore=param.userMaxScore
	self.scoreLabel:setVisible(false)
	self.titleImage:setVisible(false)
	--self.remainScore_:setString(param.userScore)
	self.mediumRole:loadTexture("daxiao/res/game/P_5/16.png")
	self.mediumRole:setScale(0.35)
	self.mediumRole:setOpacity(255)
	if self.mediumRole.enger then
		self.mediumRole.enger:setVisible(false)
		self.mediumRole.enger:removeFromParent()
		self.mediumRole.enger=nil
		self.mediumRole.enger2:setVisible(false)
		self.mediumRole.enger2:removeFromParent()
		self.mediumRole.enger2=nil
	end

	if self.mediumRole.ani then
		self.mediumRole.ani:setVisible(false)
		self.mediumRole.ani:removeFromParent()
		self.mediumRole.ani=nil
	end
	self:onEndBateAnim()
	if param.gameRecord[1]==0 then
		self.recordlist={}
	end
	if self.jettonResult.jettonTbj then
		if self.jettonResult.jettonTbj[self.resultIndex]>0 then
			self.btns_[self.resultIndex].labels:setString(0)
			function callback()
				self.scoreLabel:setVisible(true)
				self.remainScore_:setString(self.score_)
				self.scoreLabel:runAction(cc.Sequence:create(cc.MoveBy:create(1.5,cc.p(0,200)),cc.DelayTime:create(1.5),cc.CallFunc:create(function()
					self.scoreLabel:setVisible(false)
				end)))
			end
			
			pos = cc.p(self.btns_[self.resultIndex].labels:getPositionX(),self.btns_[self.resultIndex].labels:getPositionY())
			pos = self.btns_[self.resultIndex]:convertToWorldSpace(pos)
			pos = self.Panel_80:convertToNodeSpace(pos)
			self:setStar(10,pos,cc.p(self.starImg:getPositionX(),self.starImg:getPositionY()),1,callback)
			AudioEngine.playEffect("daxiao/res/sound/fly_star.mp3")
			self.scoreLabel:setPositionX(self.scoreLabel.x)
			self.scoreLabel:setPositionY(self.scoreLabel.y)
		else
			if self.resultIndex==2 then
				self.remainScore_:setString(self.score_)
			end
		end
		---self.jettonResult.jettonTbj[self.resultIndex]
		if (self.jettonResult.jettonTbl[self.resultIndex])>0 then
			local label=self.btns_[self.resultIndex].labell
			label:setString(0)
			function callback()
				
			end
			pos = cc.p(label:getPositionX(),label:getPositionY())
			pos = self.btns_[self.resultIndex]:convertToWorldSpace(pos)
			pos = self.Panel_80:convertToNodeSpace(pos)
			local x=-130
			local y=-500
			if self.resultIndex==3 then x=1300 end
			self:setStar(10,pos,cc.p(x,y),1,callback)
			AudioEngine.playEffect("daxiao/res/sound/fly_star.mp3")
			self.scoreLabel:setPositionX(self.scoreLabel.x)
			self.scoreLabel:setPositionY(self.scoreLabel.y)
		end
	else
		if self.resultIndex==2 then
			self.remainScore_:setString(self.score_)
		end
	end

	self.recordlist={}
	for i=1,100 do
		if param.gameRecord[i]==2 then--小 红
			self.recordlist[i]=1
		elseif param.gameRecord[i]==1 then--大 蓝
			self.recordlist[i]=3
		elseif param.gameRecord[i]==3 then--和 绿
			self.recordlist[i]=2
		end
	end
	
	for i=1,15 do
		if self.recordlist[i] and self.recordlist[i]>0 then
			self.history_images_[i]:setVisible(true)
			if self.recordlist[i]==1 then
				self.history_images_[i]:loadTexture("daxiao/res/game/img_jilu_hong.png")
			elseif self.recordlist[i]==2 then
				self.history_images_[i]:loadTexture("daxiao/res/game/img_jilu_lv.png")
			else
				self.history_images_[i]:loadTexture("daxiao/res/game/img_jilu_lan.png")
			end
		else
			self.history_images_[i]:setVisible(false)
		end
	end
end

function GameScene:onGameStatusStartHandler(param)
	self.userLimitScore=param.userScore
	if self.animateHandler_ then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.animateHandler_)
		self.animateHandler_ = nil
	end
	self:onJetton(param.remainTime)
	self.counter=0
	if self.animateHandler_ then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.animateHandler_)
		self.animateHandler_ = nil
	end
	self.animateHandler_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.onAnimate), 0.3, false)
	self.jettonResult={}
	for i=1,3 do
		if self.btns_[i].title.ani then
			self.btns_[i].title.ani:stopAllActions()
			self.btns_[i].title.ani:removeFromParent()
			self.btns_[i].title.ani=nil
		end
		if self.btns_[i].btnAnim.ani then
			self.btns_[i].btnAnim.ani:stopAllActions()
			self.btns_[i].btnAnim.ani:removeFromParent()
			self.btns_[i].btnAnim.ani=nil
		end
		if self.btns_[i].fire.ani then
			self.btns_[i].fire.ani:stopAllActions()
			self.btns_[i].fire.ani:removeFromParent()
			self.btns_[i].fire.ani=nil
		end
		for j=1,4 do
			self.btns_[i].progress[j]:setPercent(0)
			if self.btns_[i].proImg[j].ani then
				self.btns_[i].proImg[j].ani:stopAllActions()
				self.btns_[i].proImg[j].ani:removeFromParent()
				self.btns_[i].proImg[j].ani=nil
			end
		end
	end
	self.timePanel:setVisible(true)
	self.scoreLabel:setVisible(false)
	self.titleImage:setVisible(false)
	if self.reward_light_ then
		self.reward_light_:stopAllActions()
		self.reward_light_:setVisible(false)
	end
	self.mediumRole:loadTexture("daxiao/res/game/P_5/16.png")
	self.mediumRole:setScale(0.35)
	self.mediumRole:setOpacity(255)
	if self.mediumRole.ani then
		self.mediumRole.ani:setVisible(false)
		self.mediumRole.ani:removeFromParent()
		self.mediumRole.ani=nil
	end
	
	self:onSetBateRole()
	local x=self.leftRole:getPositionX()
	local y=self.leftRole:getPositionY()
	local x2=self.rightRole:getPositionX()
	
	self.leftRole:setPositionX(0-x)
	self.rightRole:setPositionX(x2+2*x)
	
	self.leftRole:runAction(cc.JumpTo:create(1, cc.p(x, y), 200, 1))
	self.rightRole:runAction(
		cc.Sequence:create(
			cc.JumpTo:create(1, cc.p(x2, y), 200, 1),
			cc.CallFunc:create(function()
				self:onBeginBateAnim()
			end)
		)
	)
	if self.autoBet then
		if self.totalScore>self.score_ then
			print("=============================飘字")
			self:Tip(LocalLanguage:getLanguageString("L_e2879698f53e39b0"))
			self.checkbox17_:setSelected(false)
			self.autoBet=false
		else
			local pd = global.g_mainPlayer:getRoomPlayer(global.g_mainPlayer.playerId_)
			gamesvr.sendJettonContinue(pd.chairId)
		end
	end

	self.rightRole:setVisible(true)
	self.leftRole:setVisible(true)

	self.totalScore=0
	self.popindex=1
	self.alluserTotal={[1]=0,[2]=0,[3]=0}
	self.popList={}
	self:setPopAnim()

	if self.nodebinkspr then
		self.nodebinkspr:removeFromParent()
		self.nodebinkspr=nil
	end

	self.nusnum = self.nusnum + 1
	if self.nusnum >= 100 then
		local named = "daxiao/res/game/KOFBG0"..self.nndd..".jpg"
		local action1 = cc.FadeOut:create(1)
		local function educk()
			self.imageRun:loadTexture(named)
		end
  		local CallFunc = cc.CallFunc:create(educk)
  		local action1Back = action1:reverse()
  		local seq = cc.Sequence:create(action1,CallFunc,action1Back)
  		self.runActionimage:runAction(seq)
		
		self.nndd = self.nndd + 1
		if self.nndd == 4 then self.nndd = 1 end
		self.nusnum=0
	end

	self.Panel_80:setVisible(true)

	for i=1,#self.btns_ do
		self.btns_[i].labels:setString(0)
		self.btns_[i].labell:setString(0)
	end
	--AudioEngine.playEffect("daxiao/res/sound/birds_muisc_please_bet.mp3")
end

function GameScene:creatboom(node, idx) 
	local tab = {}
  	local spriteDog = nil
  	local rectTab=cc.rect(0,0,512,512)
  	for i=1, 16 do
  		local str="daxiao/res/game/"
  		if idx==1 then
  			str=str.."blue/concert/Blueexplosion_"..i..".png"
  		else
  			str=str.."red/concert/redexplosion_"..i..".png"
  		end
  		local textureDog = cc.Director:getInstance():getTextureCache():addImage(str)
    	local frame = cc.SpriteFrame:createWithTexture(textureDog, rectTab)
    	table.insert(tab, i, frame)

   		if i == 1 then
      		spriteDog = cc.Sprite:createWithSpriteFrame(frame)
    	end
  	end

  	local animation = cc.Animation:createWithSpriteFrames(tab, 0.03)
  	local animate = cc.Animate:create(animation)
  	local function Endcallback()
    	spriteDog:removeFromParent()
  	end

  	local callfun = cc.CallFunc:create(Endcallback)
  	spriteDog:runAction(cc.Sequence:create(animate,callfun))
  	spriteDog:setAnchorPoint(cc.p(0.5,0.5))

  	spriteDog:setPositionX(node.ani:getContentSize().width/2)
	spriteDog:setPositionY(node.ani:getContentSize().height/2)
	node.ani:addChild(spriteDog)
end

function GameScene:creatFightAnimate(node) 
	local tab = {}
  	local spriteDog = nil
  	local rectTab=cc.rect(0,0,720,405)
  	for i=30, 120 do
  		local str="daxiao/res/game/fight/CJB__"..i..".png"
  		local textureDog =cc.Director:getInstance():getTextureCache():addImage(str)
    	local frame = cc.SpriteFrame:createWithTexture(textureDog, rectTab)
    	table.insert(tab, i, frame)

   		if i == 30 then
      		spriteDog = cc.Sprite:createWithSpriteFrame(frame)
    	end
  	end

  	local animation = cc.Animation:createWithSpriteFrames(tab, 0.03)
  	local animate = cc.Animate:create(animation)
  	local function Endcallback()
    	spriteDog:removeFromParent()
  	end

  	local callfun = cc.CallFunc:create(Endcallback)
  	spriteDog:runAction(cc.Sequence:create(animate,callfun))
  	spriteDog:setAnchorPoint(cc.p(0.5,0.5))

  	spriteDog:setPositionX(node:getContentSize().width/2)
  	spriteDog:setPositionY(node:getContentSize().height/2)
  	spriteDog:setScale(2)
  	spriteDog:setRotation(180)
	node.fight=spriteDog
	node:addChild(spriteDog)
end

function GameScene:creatFightAnimate2(node)
	local tab = {}
  	local spriteDog = nil
  	local rectTab=cc.rect(0,0,720,405)
  	for i=30, 119 do
  		local str="daxiao/res/game/fight2/CJB__"..i..".png"
  		local textureDog = cc.Director:getInstance():getTextureCache():addImage(str)
    	local frame = cc.SpriteFrame:createWithTexture(textureDog, rectTab)
    	table.insert(tab, i, frame)

   		if i == 30 then
      		spriteDog = cc.Sprite:createWithSpriteFrame(frame)
    	end
  	end

  	local animation = cc.Animation:createWithSpriteFrames(tab, 0.03)
  	local animate = cc.Animate:create(animation)
  	local function Endcallback()
    	spriteDog:removeFromParent()
  	end

  	local callfun = cc.CallFunc:create(Endcallback)
  	spriteDog:runAction(cc.Sequence:create(animate,callfun))
  	spriteDog:setAnchorPoint(cc.p(0.5,0.5))

  	spriteDog:setPositionX(node:getContentSize().width/2)
  	spriteDog:setPositionY(node:getContentSize().height/2)
  	spriteDog:setScale(2)
	node.fight=spriteDog
	node:addChild(spriteDog)
end

function GameScene:creatEnger(node, idx) 
	local tab = {} 
	local tab1 = {}
  	local spriteDog = nil
  	local spriteDog1 = nil
  	local rectTab=cc.rect(0,0,512,512)	
  	for i=30, 90 do
  		local str="daxiao/res/game/"
  		local str1="daxiao/res/game/"
  		if idx==1 then
  			str=str.."blue/enger1/Continued__"..i..".png"
  			str1=str1.."blue/enger2/Continued2__"..i..".png"
  		elseif idx==2 then
  			str=str.."red/enger1/Continued__"..i..".png"
  			str1=str1.."red/enger2/Continued2__"..i..".png"
  		elseif idx==3 then
  			str=str.."green/enger1/Continued__"..i..".png"
  			str1=str1.."green/enger2/Continued2__"..i..".png"
  		end
  		local textureDog = cc.Director:getInstance():getTextureCache():addImage(str)
    	local frame = cc.SpriteFrame:createWithTexture(textureDog, rectTab)
    	table.insert(tab, i, frame)

		local textureDog1 = cc.Director:getInstance():getTextureCache():addImage(str1)
		local frame1 = cc.SpriteFrame:createWithTexture(textureDog1, rectTab)
		table.insert(tab1, i, frame1)

		if i == 30 then
  			spriteDog = cc.Sprite:createWithSpriteFrame(frame)
  			spriteDog1 = cc.Sprite:createWithSpriteFrame(frame1)
		end
  	end

  	local animation = cc.Animation:createWithSpriteFrames(tab, 0.1)
  	local animate = cc.Animate:create(animation)

  	local animation1 = cc.Animation:createWithSpriteFrames(tab1, 0.1)
  	local animate1 = cc.Animate:create(animation1)
  	local function Endcallback()
    	spriteDog:removeFromParent()
  	end

  	--local callfun = cc.CallFunc:create(Endcallback)
  	spriteDog:runAction(cc.RepeatForever:create(animate))
  	spriteDog:setAnchorPoint(cc.p(0.5,0.5))
  	--spriteDog:setOpacity(1)
  	spriteDog1:runAction(cc.RepeatForever:create(animate1))
  	spriteDog1:setAnchorPoint(cc.p(0.5,0.5))
  	--spriteDog1:setOpacity(1)

  	spriteDog:setPositionX(node.ani:getContentSize().width/2)
  	spriteDog:setPositionY(node.ani:getContentSize().height/2)
  	spriteDog1:setPositionX(node.ani:getContentSize().width/2)
  	spriteDog1:setPositionY(node.ani:getContentSize().height/2)
  	if idx==3 then
		spriteDog:setScale(3)
		spriteDog1:setScale(3)
	else
		spriteDog:setScale(0.6)
		spriteDog1:setScale(0.6)
	end
	node.ani.enger=spriteDog
	node.ani.enger2=spriteDog1
	if idx==3 then
		node.ani:addChild(spriteDog,100,100)
		node.ani:addChild(spriteDog1,-10,100)
	else
		node.ani:addChild(spriteDog)
		node.ani:addChild(spriteDog1,-10,100)
	end
end

function GameScene:GameOver(node) 
	local tab = {}
  	local spriteDog = nil
  	local rectTab=cc.rect(0,0,1280,720)
  	for i=1, 30 do
  		local str="daxiao/res/game/gameover/KO_"..i..".png"
  		local textureDog = cc.Director:getInstance():getTextureCache():addImage(str)
    	local frame = cc.SpriteFrame:createWithTexture(textureDog, rectTab)
    	table.insert(tab, i, frame)

   		if i == 1 then
      		spriteDog = cc.Sprite:createWithSpriteFrame(frame)
    	end
  	end

  	local animation = cc.Animation:createWithSpriteFrames(tab, 0.03)
  	local animate = cc.Animate:create(animation)
  	local function Endcallback()
    	spriteDog:removeFromParent()
  	end

  	local callfun = cc.CallFunc:create(Endcallback)
  	spriteDog:runAction(cc.Sequence:create(animate,callfun))
  	spriteDog:setAnchorPoint(cc.p(0.5,0.5))

  	spriteDog:setPositionX(node:getContentSize().width/2)
	spriteDog:setPositionY(node:getContentSize().height/2)
	node:addChild(spriteDog)
end

function GameScene:resultRoleAnim(node,idx)
	local tab = {}
  	local spriteDog = nil
  	local rectTab=cc.rect(0,0,572,927)
  	local str="daxiao/res/game/P_5/"
  	local count=6
  	if idx==1 then
  		str=str.."l/"
  	elseif idx==2 then
  		count=9
  		str=str.."c/0"
  	else
  		str=str.."r/"
  	end
  	for i=1, count do
  		local textureDog = nil
  		if idx==2 then
  			textureDog = cc.Director:getInstance():getTextureCache():addImage(str..i..".png")
  		else
  			textureDog = cc.Director:getInstance():getTextureCache():addImage(str..(i+9)..".png")
  		end
  		
    	local frame = cc.SpriteFrame:createWithTexture(textureDog, rectTab)
    	table.insert(tab, i, frame)

   		if i == 1 then
      		spriteDog = cc.Sprite:createWithSpriteFrame(frame)
    	end
  	end

  	local animation = cc.Animation:createWithSpriteFrames(tab, 0.2)  
  	local animate = cc.Animate:create(animation)
  	local function Endcallback()
    	
  	end

  	local callfun = cc.CallFunc:create(Endcallback)
  	spriteDog:runAction(cc.RepeatForever:create(animate))
  	spriteDog:setAnchorPoint(cc.p(0.5,0.5))

  	spriteDog:setPositionX(node:getContentSize().width/2)
	spriteDog:setPositionY(node:getContentSize().height/2)
	node.ani=spriteDog
	node:addChild(spriteDog)
end

local roleBox={
	[1] = cc.rect(0,0,182,205),
	[2] = cc.rect(0,0,261,213),
	[3] = cc.rect(0,0,213,211),
	[4] = cc.rect(0,0,194,196),
	[5] = cc.rect(0,0,182,205),
	[6] = cc.rect(0,0,261,213),
	[7] = cc.rect(0,0,213,211)
}

function GameScene:onShock()
	if self.isShock then return end
	self.isShock=true
	local x=635
	local y=475
	local tableAction={}
	for i=1,20 do
		tableAction[i]=cc.MoveTo:create(0.05,cc.p(x+math.random(0,10),y+math.random(0,10)))
	end
	tableAction[21]=cc.MoveTo:create(0.05,cc.p(x+5,y+5))
	local seq=cc.Sequence:create(
			tableAction[1],
			tableAction[2],
			tableAction[3],
			tableAction[4],
			tableAction[5],
			tableAction[6],
			tableAction[7],
			tableAction[8],
			tableAction[9],
			tableAction[10],
			tableAction[11],
			tableAction[12],
			tableAction[13],
			tableAction[14],
			tableAction[15],
			tableAction[16],
			tableAction[17],
			tableAction[18],
			tableAction[19],
			tableAction[20],
			tableAction[21]
			)
	local rep=cc.Repeat:create(seq,3)
	self.imageRun:runAction(rep)
end

function GameScene:onGameStatusEndHandler(param)
	self.isShock=false
	self.progressTime_=0
	table.dump(param)
	local total=param.card1+param.card2

	AudioEngine.playEffect("daxiao/res/sound/start_fight.mp3")

	self.scoreLabel:setString("+"..param.lUserScore)
	self.scoreLabel.value=param.lUserScore
	if total<7 then--小 红
		self.resultIndex=1
	elseif total==7 then--和 绿
		self.resultIndex=2
	elseif total>7 then--大 蓝
		self.resultIndex=3
	end
	print(total.."============================="..self.resultIndex)

	self:onEndBateAnim()
	self:creatSpRoleNormal(self.leftRole,roleBox[self.leftRole.idx],self.leftRole.idx)
	self:creatSpRoleNormal(self.rightRole,roleBox[self.rightRole.idx],self.rightRole.idx)
	self.leftRole.status=idle
	self.rightRole.status=idle
	self.timePanel:setVisible(false)
	self.startImage:setVisible(true)
	self.startImage:loadTexture("daxiao/res/game/img_fight.png")
	self:onLottery(param.remainTime)
	local pos=nil
	local seq=cc.Sequence:create(
		cc.FadeIn:create(0.6),
		cc.DelayTime:create(0.8),
		cc.FadeOut:create(0.6),
		cc.CallFunc:create(function()
				self.resultfinish1=true
				self.resultfinish2=true
				self:creatboom(self.leftRole,2)
				self:creatboom(self.rightRole,1)
			end),
		cc.DelayTime:create(0.35),
		cc.CallFunc:create(function()
			self:onAnimTimer()
			end),
		cc.DelayTime:create(0.2),
		cc.CallFunc:create(function()
			self:onShock()
			--AudioEngine.playEffect("daxiao/res/sound/fighting.mp3")
			self:creatFightAnimate(self.centerAnim)
			self:creatFightAnimate2(self.centerAnim2)
	    	local seq2=cc.Sequence:create(
	    		cc.DelayTime:create(2.5),
	    		cc.CallFunc:create(function()
	    			self:GameOver(self.imageOk)
	    			if self.rightRole.ani.enger then
	    				self.rightRole.ani.enger:stopAllActions()
	    				self.rightRole.ani.enger:removeFromParent()
	    				self.rightRole.ani.enger=nil
	    				self.rightRole.ani.enger2:stopAllActions()
	    				self.rightRole.ani.enger2:removeFromParent()
	    				self.rightRole.ani.enger2=nil
	    			end
	    			if self.leftRole.ani.enger then
	    				self.leftRole.ani.enger:stopAllActions()
	    				self.leftRole.ani.enger:removeFromParent()
	    				self.leftRole.ani.enger=nil
	    				self.leftRole.ani.enger2:stopAllActions()
	    				self.leftRole.ani.enger2:removeFromParent()
	    				self.leftRole.ani.enger2=nil
	    			end
	    			if self.centerAnim.enger then
	    				self.centerAnim.enger:stopAllActions()
	    				self.centerAnim.enger:removeFromParent()
	    				self.centerAnim.ani.enger=nil
	    				self.centerAnim.enger2:stopAllActions()
	    				self.centerAnim.enger2:removeFromParent()
	    				self.centerAnim.ani.enger2=nil
	    			end
	    		end))
	    	self.imageOk:runAction(seq2)
	    	
	    	if self.progressTime_==0 then
	    		self.progressTime_ = 100
	    		self.progressA_ = 100
	    		self.progressB_ = 100
	    		self.progressHandler_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.onProgress), 0.35, false)
	    	end
		end),
		cc.DelayTime:create(3),
		cc.CallFunc:create(function()
				self.startImage:loadTexture("daxiao/res/game/img_KO.png")
				if self.resultIndex==1 then
					self:onSuffer(self.rightRole)
					self.progressB_=0
					self.rightProgress:setPercent(self.progressB_)
				elseif self.resultIndex==2 then
					self:onSuffer(self.rightRole)
					self:onSuffer(self.leftRole)
					self.progressB_=0
					self.rightProgress:setPercent(self.progressB_)
					self.progressA_=0
					self.leftProgress:setPercent(self.progressA_)
				else
					self:onSuffer(self.leftRole)
					self.progressA_=0
					self.leftProgress:setPercent(self.progressA_)
				end
				self.progressTime_=0
			end),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			if self.resultIndex==1 then
				self:creatSpRoleNormal(self.leftRole,roleBox[self.leftRole.idx],self.leftRole.idx)
			elseif self.resultIndex==2 then
				--self:creatSpRoleNormal(self.leftRole,roleBox[self.leftRole.idx],self.leftRole.idx)
				--self:creatSpRoleNormal(self.rightRole,roleBox[self.rightRole.idx],self.rightRole.idx)
			else
				self:creatSpRoleNormal(self.rightRole,roleBox[self.rightRole.idx],self.rightRole.idx)
			end
		end),
		cc.DelayTime:create(1),
		cc.FadeOut:create(0.6),
		cc.CallFunc:create(function() 
			AudioEngine.playEffect("daxiao/res/sound/ending.mp3")
			if self.resultIndex==1 then
				AudioEngine.playEffect("daxiao/res/sound/notpeace.mp3")
				self.titleImage:setVisible(true)
				self.titleImage:loadTexture("daxiao/res/game/img_winner.png")
				self.mediumRole:loadTexture("daxiao/res/game/P_5/l/15.png")
				self.mediumRole:setScale(0.35)
				self.mediumRole:setOpacity(1)
				self:resultRoleAnim(self.mediumRole,1)
				self:creatSpRoleNormal(self.leftRole,roleBox[self.leftRole.idx],self.leftRole.idx)
				if self.jettonResult.jettonTbl and self.jettonResult.jettonTbl[1] and self.jettonResult.jettonTbl[1]>0 then
					self:creatNumberEnger(self.btns_[1].img1,1)
				end
				if self.jettonResult.jettonTbj and self.jettonResult.jettonTbj[1] and self.jettonResult.jettonTbj[1]>0 then
					self:creatNumberEnger(self.btns_[1].img2,1)
				end
				if self.jettonResult.jettonTbl and self.jettonResult.jettonTbl[2] and self.jettonResult.jettonTbl[2]>0 then
					self:creatNumberEnger(self.btns_[2].img1,2)
				end
				if self.jettonResult.jettonTbj and self.jettonResult.jettonTbj[2] and self.jettonResult.jettonTbj[2]>0 then
					self:creatNumberEnger(self.btns_[2].img2,2)
				end
				if self.jettonResult.jettonTbl and self.jettonResult.jettonTbl[3] and self.jettonResult.jettonTbl[3]>0 then
					self:creatNumberEnger(self.btns_[3].img2,2)
				end
				if self.jettonResult.jettonTbj and self.jettonResult.jettonTbj[3] and self.jettonResult.jettonTbj[3]>0 then
					self:creatNumberEnger(self.btns_[3].img1,2)
				end
				self.btns_[2].labels:setString(0)
				self.btns_[2].labell:setString(0)
				self.btns_[3].labels:setString(0)
				self.btns_[3].labell:setString(0)
			elseif self.resultIndex==2 then
				AudioEngine.playEffect("daxiao/res/sound/pace.mp3")
				self.titleImage:setVisible(true)
				self.titleImage:loadTexture("daxiao/res/game/img_gogfall.png")
				self.mediumRole:loadTexture("daxiao/res/game/P_5/c/03.png")
				self.mediumRole:setScale(0.35)
				self.mediumRole:setOpacity(1)
				self:resultRoleAnim(self.mediumRole,2)
				--self:creatSpRoleNormal(self.leftRole,roleBox[self.leftRole.idx],self.leftRole.idx)
				--self:creatSpRoleNormal(self.rightRole,roleBox[self.rightRole.idx],self.rightRole.idx)
				if self.jettonResult.jettonTbl and self.jettonResult.jettonTbl[1] and self.jettonResult.jettonTbl[1]>0 then
					self:creatNumberEnger(self.btns_[1].img1,2)
				end
				if self.jettonResult.jettonTbj and self.jettonResult.jettonTbj[1] and self.jettonResult.jettonTbj[1]>0 then
					self:creatNumberEnger(self.btns_[1].img2,2)
				end
				if self.jettonResult.jettonTbl and self.jettonResult.jettonTbl[2] and self.jettonResult.jettonTbl[2]>0 then
					self:creatNumberEnger(self.btns_[2].img1,1)
				end
				if self.jettonResult.jettonTbj and self.jettonResult.jettonTbj[2] and self.jettonResult.jettonTbj[2]>0 then
					self:creatNumberEnger(self.btns_[2].img2,1)
				end
				if self.jettonResult.jettonTbl and self.jettonResult.jettonTbl[3] and self.jettonResult.jettonTbl[3]>0 then
					self:creatNumberEnger(self.btns_[3].img2,2)
				end
				if self.jettonResult.jettonTbj and self.jettonResult.jettonTbj[3] and self.jettonResult.jettonTbj[3]>0 then
					self:creatNumberEnger(self.btns_[3].img1,2)
				end
				self.btns_[1].labels:setString(0)
				self.btns_[1].labell:setString(0)
				self.btns_[3].labels:setString(0)
				self.btns_[3].labell:setString(0)
			else
				AudioEngine.playEffect("daxiao/res/sound/notpeace.mp3")
				self.titleImage:setVisible(true)
				self.titleImage:loadTexture("daxiao/res/game/img_winner2.png")
				self.mediumRole:loadTexture("daxiao/res/game/P_5/r/15.png")
				self.mediumRole:setScale(0.35)
				self.mediumRole:setOpacity(1)
				self:resultRoleAnim(self.mediumRole,3)
				self:creatSpRoleNormal(self.rightRole,roleBox[self.rightRole.idx],self.rightRole.idx)
				if self.jettonResult.jettonTbl and self.jettonResult.jettonTbl[1] and self.jettonResult.jettonTbl[1]>0 then
					self:creatNumberEnger(self.btns_[1].img1,2)
				end
				if self.jettonResult.jettonTbj and self.jettonResult.jettonTbj[1] and self.jettonResult.jettonTbj[1]>0 then
					self:creatNumberEnger(self.btns_[1].img2,2)
				end
				if self.jettonResult.jettonTbl and self.jettonResult.jettonTbl[2] and self.jettonResult.jettonTbl[2]>0 then
					self:creatNumberEnger(self.btns_[2].img1,2)
				end
				if self.jettonResult.jettonTbj and self.jettonResult.jettonTbj[2] and self.jettonResult.jettonTbj[2]>0 then
					self:creatNumberEnger(self.btns_[2].img2,2)
				end
				if self.jettonResult.jettonTbl and self.jettonResult.jettonTbl[3] and self.jettonResult.jettonTbl[3]>0 then
					self:creatNumberEnger(self.btns_[3].img2,1)
				end
				if self.jettonResult.jettonTbj and self.jettonResult.jettonTbj[3] and self.jettonResult.jettonTbj[3]>0 then
					self:creatNumberEnger(self.btns_[3].img1,1)
				end
				self.btns_[1].labels:setString(0)
				self.btns_[1].labell:setString(0)
				self.btns_[2].labels:setString(0)
				self.btns_[2].labell:setString(0)
			end
			local index=self.resultIndex
			if self.jettonResult.jettonTbj then
				local mul= self.resultIndex==2 and 6 or 2
				mul= self.resultIndex==3 and 1.95 or mul
				self.btns_[index].labels:setString(self.jettonResult.jettonTbj[index]*mul)
				self.btns_[index].labell:setString(self.jettonResult.jettonTbl[index]*mul)
			end
			end))
	self.startImage:runAction(seq)
end

local str1={
	[1]="red",
	[2]="green",
	[3]="blue"
}

local str2={
	[1]="hong",
	[2]="lv",
	[3]=LocalLanguage:getLanguageString("L_17291ce93ee52e50")
}
--1 大 蓝--0大 1小 2和
--2 小 红
--3 和 绿
local values={
	[1]=2,
	[2]=3,
	[3]=1
}

function GameScene:onGamePlaceJettonResult(param)
	--table.dump(param)
	local score=self.score_
	self.totalScore=0
	local itemData={}
	self.jettonResult.jettonTbj={}
	self.jettonResult.jettonTbl={}
	for i=1,#self.btns_ do
		self.jettonResult.jettonTbj[i]=param.jettonTbj[values[i]]
		self.jettonResult.jettonTbl[i]=param.jettonTbl[values[i]]

		self.btns_[i].labels:setString(param.jettonTbj[values[i]])
		score=score-param.jettonTbj[values[i]]
		if param.jettonTbl[values[i]]>self.alluserTotal[values[i]] then
			itemData.index=values[i]
			itemData.amount=param.jettonTbl[values[i]]-self.alluserTotal[values[i]]
		end
		self.alluserTotal[values[i]]=param.jettonTbl[values[i]]
		self.totalScore=self.totalScore+param.jettonTbj[values[i]]
		self.btns_[i].labell:setString(param.jettonTbl[values[i]])

		local limit = self.areaLimitScore/4
		if param.jettonTbl[values[i]]<4*limit then
			if param.jettonTbl[values[i]]>=limit then
				self.btns_[i].progress[1]:setPercent(100)
				if self.btns_[i].proImg[1].ani==nil then
					self:createButtonAnim(self.btns_[i].proImg[1],"daxiao/res/game/"..str1[i].."/anim2/img_nengliangt_"..str2[i].."3_",cc.rect(0,0,77,42),0.2,5)
				end
			else
				self.btns_[i].progress[1]:setPercent(param.jettonTbl[values[i]]/limit*100)
			end
			if param.jettonTbl[values[i]]>=2*limit then
				self.btns_[i].progress[2]:setPercent(100)
				if self.btns_[i].proImg[2].ani==nil then
					self:createButtonAnim(self.btns_[i].proImg[2],"daxiao/res/game/"..str1[i].."/anim2/img_nengliangt_"..str2[i].."3_",cc.rect(0,0,77,42),0.2,5)
				end
			else
				self.btns_[i].progress[2]:setPercent((param.jettonTbl[values[i]]-limit)/limit*100)
			end
			if param.jettonTbl[values[i]]>=3*limit then
				self.btns_[i].progress[3]:setPercent(100)
				if self.btns_[i].proImg[3].ani==nil then
					self:createButtonAnim(self.btns_[i].proImg[3],"daxiao/res/game/"..str1[i].."/anim2/img_nengliangt_"..str2[i].."3_",cc.rect(0,0,77,42),0.2,5)
				end
			else
				self.btns_[i].progress[3]:setPercent((param.jettonTbl[values[i]]-limit*2)/limit*100)
			end
		end
		if param.jettonTbl[values[i]]>=4*limit then
			if self.btns_[i].proImg[4].ani==nil then
				self:createButtonAnim(self.btns_[i].title,"daxiao/res/game/"..str1[i].."/font/bg_"..str2[i].."_zi_",cc.rect(0,0,67,92),0.1,9)
				self:createButtonAnim(self.btns_[i].btnAnim,"daxiao/res/game/"..str1[i].."/button/btn_yafen_"..str2[i].."_",cc.rect(0,0,76,76),0.2,10)
				local str = "daxiao/res/game/fire/image"
				if i==2 then
					str = "daxiao/res/game/fire/green/image"
				end
				if i==3 then
					str = "daxiao/res/game/fire/blue/image"
				end
				self:createButtonAnim(self.btns_[i].fire,str,cc.rect(0,0,114,124),0.1,9)
				if i==1 then
					self:creatEnger(self.leftRole,2)
				elseif i==2 then
					local item={}
					item.ani=self.mediumRole
					self:creatEnger(item,3)
				elseif i==3 then
					self:creatEnger(self.rightRole,1)
				end
				for j=1,4 do
					if self.btns_[i].proImg[j].ani then
						self.btns_[i].proImg[j].ani:stopAllActions()
						self.btns_[i].proImg[j].ani:removeFromParent()
						self.btns_[i].proImg[j].ani=nil
					end
					self:createButtonAnim(self.btns_[i].proImg[j],"daxiao/res/game/"..str1[i].."/anim/img_nengliangt_"..str2[i].."3_",cc.rect(0,0,77,42),0.2,9)
					self.btns_[i].progress[j]:setPercent(100)
				end
				AudioEngine.playEffect("daxiao/res/sound/enger.mp3")
			end
		else
			self.btns_[i].progress[4]:setPercent((param.jettonTbl[values[i]]-limit*3)/limit*100)
		end
	end
	AudioEngine.playEffect("daxiao/res/sound/coin.mp3")
	itemData.userId=param.userId
	table.insert(self.popList,itemData)
	self.remainScore_:setString(score)
end

function GameScene:onClearJettonResult(param)
	
end

function GameScene:onContinueJettonResult(param)
	
end

local role_src_path=
{
	[1]="daxiao/res/game/p1/P1A_0_01.png",
	[2]="daxiao/res/game/p2/P2A_0_01.png",
	[3]="daxiao/res/game/p3/P3A_0_01.png",
	[4]="daxiao/res/game/p4/P4A_0_01.png",
	[5]="daxiao/res/game/p5/P5A_0_01.png",
	[6]="daxiao/res/game/p6/P6A_0_01.png",
	[7]="daxiao/res/game/p7/P7A_0_01.png"
}

function GameScene:creatSpRoleAction( node, bimg, rectTab, times, count, idx, flag) 
	local tab = {}  
	local textureDog = nil
	local frame = nil
  	for i=1, count do  
  		local str=bimg..i..".png"
  		textureDog =cc.Director:getInstance():getTextureCache():addImage(str)
    	frame = cc.SpriteFrame:createWithTexture(textureDog, rectTab)  
    	table.insert(tab, i, frame) 
  	end  
  	local animation = cc.Animation:createWithSpriteFrames(tab, times)  
  	local animate = cc.Animate:create(animation)

  	tab = {} 
  	str=role_src_path[idx]
  	textureDog =cc.Director:getInstance():getTextureCache():addImage(str)
    frame = cc.SpriteFrame:createWithTexture(textureDog, rectTab)  
    table.insert(tab, 1, frame) 
  	
  	animation = cc.Animation:createWithSpriteFrames(tab, 0.05)  
  	local animate1 = cc.Animate:create(animation)

  	local seq=nil
	if flag then
		seq=cc.Sequence:create(
  			animate,
  			cc.DelayTime:create(0.5),						
			cc.CallFunc:create(function()
				node.status=idle
			end)
		)
	else
		seq=cc.Sequence:create(
  			animate,
  			animate1,
  			cc.DelayTime:create(0.5),						
			cc.CallFunc:create(function()
				node.status=idle
			end)
		)
	end
  	node.ani:runAction(seq)
end

function GameScene:creatSpRoleNormal( node, rectTab, idx)
	local tab = {}
  	local str=role_src_path[idx]
  	local textureDog =cc.Director:getInstance():getTextureCache():addImage(str)
    local frame = cc.SpriteFrame:createWithTexture(textureDog, rectTab)
    table.insert(tab, 1, frame)
  	local animation = cc.Animation:createWithSpriteFrames(tab, 0.2)
  	local animate = cc.Animate:create(animation)
  	node.ani:stopAllActions()
  	node.ani:runAction(animate)
end

local role_die_path=
{
	[1]="daxiao/res/game/p1/P1A_4_01.png",
	[2]="daxiao/res/game/p2/P2A_4_01.png",
	[3]="daxiao/res/game/p3/P3A_4_01.png",
	[4]="daxiao/res/game/p4/P4A_0_01.png",
	[5]="daxiao/res/game/p5/P5A_4_01.png",
	[6]="daxiao/res/game/p6/P6A_4_01.png",
	[7]="daxiao/res/game/p7/P7A_4_01.png"
}

function GameScene:creatSpRoleDie( node, rectTab, idx) 
	local tab = {}
  	local str = role_die_path[idx]
  	local textureDog = cc.Director:getInstance():getTextureCache():addImage(str)
    local frame = cc.SpriteFrame:createWithTexture(textureDog, rectTab)
    table.insert(tab, 1, frame)
  	local animation = cc.Animation:createWithSpriteFrames(tab, 0.2)  
  	local animate = cc.Animate:create(animation)
  	node.ani:runAction(animate)
end

function GameScene:creatRoleSprite(rectTab,idx)
	local tab = {}
	local textureDog = cc.Director:getInstance():getTextureCache():addImage(role_src_path[idx])
	local frame = cc.SpriteFrame:createWithTexture(textureDog, rectTab)
	local spriteDog = cc.Sprite:createWithSpriteFrame(frame)
	spriteDog.status = idle
  	return spriteDog
end

function GameScene:onSetBateRole()
	print("===================onSetBateRole")
	self.leftValue=100
	self.rightValue=100
	self.leftProgress:setPercent(self.leftValue)
	self.rightProgress:setPercent(self.rightValue)
	local lidx=math.random(1,3)
	local ridx=math.random(5,7)
	print("================role====================ridx:"..ridx.." lidx:"..lidx)
	self.leftRole.idx=lidx
	self.rightRole.idx=ridx
	self.rRoleImage:loadTexture("daxiao/res/game/"..lidx..".png")
	self.lRoleImage:loadTexture("daxiao/res/game/"..ridx..".png")

	self.lbulletIdx=0
	self.lbulletTable={}
	self.rbulletIdx=0
	self.rbulletTable={}
	-------------------------------------------------------------
	if self.leftRole.ani then
		self.leftRole.ani:stopAllActions()
		self.leftRole.ani:removeFromParent()
	end
	self.leftRole.ani=nil
	self.leftRole:removeAllChildren()

	local lr = self:creatRoleSprite(roleBox[lidx],lidx)
	lr:setPositionX(self.leftRole:getContentSize().width/2)
 	lr:setPositionY(self.leftRole:getContentSize().height/2)
	self.leftRole:addChild(lr)
	self.leftRole.ani=lr
	self.leftRole.status=idle
	--self.leftRole:setScale(1.7)
	self.leftRole.Toward=TOWARD_RIGHT
	
	self.leftRole:setPositionX(295)
	self.leftRole:setPositionY(self.roleheight)
	-------------------------------------------------------------
	if self.rightRole.ani then
		self.rightRole.ani:stopAllActions()
		self.rightRole.ani:removeFromParent()
	end
	self.rightRole.ani=nil
	self.rightRole:removeAllChildren()
	local rr = self:creatRoleSprite(roleBox[ridx],ridx)
	rr:setPositionX(self.rightRole:getContentSize().width/2)
 	rr:setPositionY(self.rightRole:getContentSize().height/2)
	self.rightRole:addChild(rr)
	self.rightRole.ani=rr
	rr:setFlippedX(true)
	self.rightRole.status=idle
	--self.rightRole:setScale(1.7)
	self.rightRole.Toward=TOWARD_LEFT

	self.rightRole:setPositionX(985)
	self.rightRole:setPositionY(self.roleheight)
end

function GameScene:onBeginBateAnim()
	print("===================onBeginBateAnim")
	if self.timeAnimHandler_ then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.timeAnimHandler_)
		self.timeAnimHandler_ = nil
	end
	if self.status_ == STATUS_JETTON then
		self.timeAnimHandler_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.onPreAnimTimer), 0.05, false)
	end
end

local anim_num={
	[1] = 3,[2] = 2,[3] = 3,[4] = 3,[5] = 3,[6] = 2,[7] = 3
}

local anim_frame_num={
	[1] = {[1] = 3,[2] = 2,[3] = 4},
	[2] = {[1] = 2,[2] = 2},
	[3] = {[1] = 2,[2] = 1,[3] = 2},
	[4] = {[1] = 2,[2] = 2,[3] = 2},
	[5] = {[1] = 3,[2] = 2,[3] = 4},
	[6] = {[1] = 2,[2] = 2},
	[7] = {[1] = 2,[2] = 1,[3] = 2}
}

local anim_frame_time={
	[1] = {[1] = 0.2,[2] = 0.2,[3] = 0.2},
	[2] = {[1] = 0.2,[2] = 0.2},
	[3] = {[1] = 0.2,[2] = 1.3,[3] = 0.4},
	[4] = {[1] = 0.2,[2] = 0.2,[3] = 0.2},
	[5] = {[1] = 0.2,[2] = 0.2,[3] = 0.2},
	[6] = {[1] = 0.2,[2] = 0.2},
	[7] = {[1] = 0.2,[2] = 1.3,[3] = 0.4}
}

local anim_frame_eff={
	[1] = {[1] = 0,[2] = 1,[3] = 0},
	[2] = {[1] = 0,[2] = 0},
	[3] = {[1] = 0,[2] = 0,[3] = 1},
	[4] = {[1] = 0,[2] = 0,[3] = 0},
	[5] = {[1] = 0,[2] = 1,[3] = 0},
	[6] = {[1] = 0,[2] = 0},
	[7] = {[1] = 0,[2] = 0,[3] = 1}
}

local anim_frame_status={
	[1] = {[1] = attack,[2] = attack,[3] = attack},
	[2] = {[1] = attack,[2] = attack},
	[3] = {[1] = attack,[2] = defense,[3] = attack},
	[4] = {[1] = attack,[2] = attack,[3] = attack},
	[5] = {[1] = attack,[2] = attack,[3] = attack}
}

function GameScene:onPreAnimTimer()--判断受击动画
	if(self.leftRole.status==idle) then
		self.leftRole.status=1
		local lidx=self.leftRole.idx
		local index=math.random(1,anim_num[lidx])
		local str="daxiao/res/game/p"..lidx.."/P"..lidx.."A_"..index.."_0"
		self:creatSpRoleAction(self.leftRole,str,roleBox[lidx],anim_frame_time[lidx][index],anim_frame_num[lidx][index],lidx,false)
	end

	if(self.rightRole.status==idle) then
		self.rightRole.status=1
		local ridx=self.rightRole.idx
		local index=math.random(1,anim_num[ridx])
		local str="daxiao/res/game/p"..ridx.."/P"..ridx.."A_"..index.."_0"
		self:creatSpRoleAction(self.rightRole,str,roleBox[ridx],anim_frame_time[ridx][index],anim_frame_num[ridx][index],ridx,false)
	end
end

function GameScene:onAnimTimer()--分离方法
	self.leftRole.status=1
	local lidx=self.leftRole.idx
	local index=2
	if lidx==3 then
		index=1
	end
	local str="daxiao/res/game/p"..lidx.."/P"..lidx.."A_"..index.."_0"
	self:creatSpRoleAction(self.leftRole,str,roleBox[lidx],anim_frame_time[lidx][index],anim_frame_num[lidx][index],lidx,true)
	
	self.rightRole.status=1
	local ridx=self.rightRole.idx
	local index=2
	if ridx==7 then
		index=1
	end
	local str="daxiao/res/game/p"..ridx.."/P"..ridx.."A_"..index.."_0"
	self:creatSpRoleAction(self.rightRole,str,roleBox[ridx],anim_frame_time[ridx][index],anim_frame_num[ridx][index],ridx,true)
end

function GameScene:onSuffer(role)
	print("====================onSuffer")
	role:stopAllActions()
	role.ani:stopAllActions()
	self:creatSpRoleDie(role,roleBox[role.idx],role.idx)
end

function GameScene:onEndBateAnim(isRemove)
	if self.timeAnimHandler_ then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.timeAnimHandler_)
		self.timeAnimHandler_ = nil
	end
	if self.lbulletIdx>0 then
		for i=0,(self.lbulletIdx-1) do
			if self.lbulletTable[i] then
				self.lbulletTable[i]:stopAllActions()
				self.lbulletTable[i]:removeFromParent()
				self.lbulletTable[i]=nil
			end
		end
	end
	if self.rbulletIdx>0 then
		for i=0,(self.rbulletIdx-1) do
			if self.rbulletTable[i] then
				self.rbulletTable[i]:stopAllActions()
				self.rbulletTable[i]:removeFromParent()
				self.rbulletTable[i]=nil
			end
		end
	end

	if isRemove then
		self.leftRole:stopAllActions()
		self.leftRole.ani:stopAllActions()
		self.leftRole.ani:removeFromParent()
		self.leftRole.ani=nil
			
		self.rightRole:stopAllActions()
		self.rightRole.ani:stopAllActions()
		self.rightRole.ani:removeFromParent()
		self.rightRole.ani=nil
	else
		self.leftRole:stopAllActions()
		self.leftRole.ani:stopAllActions()
			
		self.rightRole:stopAllActions()
		self.rightRole.ani:stopAllActions()
	end
end

function GameScene:onRemoveBateAnim()
	if self.timeAnimHandler_ then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.timeAnimHandler_)
		self.timeAnimHandler_ = nil
	end
end

function GameScene:onEndEnterTransition()
	global.g_gameDispatcher:addMessageListener(GAME_EXCHANGE_SCORE_SUCCESS, self, self.onExchangeScoreSuccessHandler)
	global.g_gameDispatcher:addMessageListener(GAME_EXCHANGE_GOLD_SUCCESS, self, self.onExchangeGoldSuccessHandler)

	global.g_gameDispatcher:addMessageListener(GAME_EVENT_STATUS_IDLE, self, self.onGameStatusIdleHandler)
	global.g_gameDispatcher:addMessageListener(GAME_EVENT_STATUS_START, self, self.onGameStatusStartHandler)
	global.g_gameDispatcher:addMessageListener(GAME_EVENT_STATUS_END, self, self.onGameStatusEndHandler)

	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAMEPLACEJETTONRESULT, self, self.onGamePlaceJettonResult)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_CLEARJETTONRESULT, self, self.onClearJettonResult)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_CONTINUEJETTONRESULT, self, self.onContinueJettonResult)
end

function GameScene:onStartExitTransition()
	self:onStopTimer()
	self:onRemoveBateAnim()
	if self.animateHandler_ then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.animateHandler_)
		self.animateHandler_ = nil
	end
	if self.progressHandler_ then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.progressHandler_)
		self.progressHandler_ = nil
	end
	if self.freeHandler_ then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.freeHandler_)
		self.freeHandler_ = nil
	end

	global.g_gameDispatcher:removeMessageListener(GAME_EXCHANGE_SCORE_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_EXCHANGE_GOLD_SUCCESS, self)

	global.g_gameDispatcher:removeMessageListener(GAME_EVENT_STATUS_IDLE, self)
	global.g_gameDispatcher:removeMessageListener(GAME_EVENT_STATUS_START, self)
	global.g_gameDispatcher:removeMessageListener(GAME_EVENT_STATUS_END, self)

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAMEPLACEJETTONRESULT, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_CLEARJETTONRESULT, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_CONTINUEJETTONRESULT, self)
end

function GameScene:Tip(str)
	local msg=self.tipLabel:clone()
	msg:setVisible(true)
	msg:setString(str)
	local viewsize = cc.Director:getInstance():getWinSize()
	msg:setPositionX(viewsize.width/2)
	msg:setPositionY(viewsize.height/2)
	msg:runAction(cc.Sequence:create(cc.MoveBy:create(0.3,cc.p(0,100)),cc.DelayTime:create(0.5),cc.RemoveSelf:create()))
	self:addChild(msg,1001,1001)
end
--tnBg:convertToNodeSpace(pos)
--hand:convertToWorldSpace(cc.p(px, py))
function GameScene:setStar(num,startPoint,endPoint,time,func)
	for i=1,num do
		local star=self.starImg:clone()
		star:setPositionX(startPoint.x)
		star:setPositionY(startPoint.y)
		local delayAction=cc.DelayTime:create(0.1*i)
		local moveTo=cc.MoveTo:create(time,cc.p(endPoint.x,endPoint.y))
		local removeSelf=cc.RemoveSelf:create()
		local sequence=cc.Sequence:create(delayAction,moveTo,removeSelf)
		if num==i then
			sequence=cc.Sequence:create(delayAction,moveTo,removeSelf,cc.CallFunc:create(func))
		end
		star:runAction(sequence)
		self.Panel_80:addChild(star,1001,1001)
	end
end

function GameScene:creatNumberEnger(node, idx) 
	local tab = {} 
  	local spriteDog = nil
  	local rectTab=cc.rect(0,0,103,100)	
  	for i=1, 9 do
  		local str="daxiao/res/game/"
  		if idx==1 then
  			str=str.."1/"..i..".png"
  		elseif idx==2 then
  			str=str.."2/"..i..".png"
  		end
  		local textureDog = cc.Director:getInstance():getTextureCache():addImage(str)
    	local frame = cc.SpriteFrame:createWithTexture(textureDog, rectTab)
    	table.insert(tab, i, frame)

   		if i == 1 then
      		spriteDog = cc.Sprite:createWithSpriteFrame(frame)
    	end
  	end

  	local animation = cc.Animation:createWithSpriteFrames(tab, 0.1)
  	local animate = cc.Animate:create(animation)
  	local function Endcallback()
    	spriteDog:removeFromParent()
  	end

  	local callfun = cc.CallFunc:create(Endcallback)
  	spriteDog:runAction(
  		cc.Sequence:create(
  			animate,
  			callfun
  			)
  		)
  	spriteDog:setAnchorPoint(cc.p(0.5,0.5))

  	spriteDog:setPositionX(node:getContentSize().width/2)
  	spriteDog:setPositionY(node:getContentSize().height/2)
  	
	node.enger=spriteDog
	node:addChild(spriteDog)
end

