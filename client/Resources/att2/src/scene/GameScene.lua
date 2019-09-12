--以中下划线命名的变量为场景节点，以驼峰明明法的变量为函数名
GameScene = class("GameScene", LayerBase)

--构造方法
function GameScene:ctor()
    GameScene.super.ctor(self) --调用父类
    print("GameScene:ctor()--------------------------------------------------------------------------------");

    self:loadData(); --加载数据信息
    self:loadResources(); --加载资源
    self:loadAnimation(); --加载动画
    self:addListener() --添加事件
    self:init(); --数据初始化
end

--销毁方法，退出场景的时候调用
--需要主动调用
function GameScene:destroy()
    if self.schedulerList ~= nil and #self.schedulerList > 0 then
        for i = 1, #self.schedulerList do
            if self.schedulerList[i] ~= nil then
                Scheduler:stop(self.schedulerList[i]);
            end
        end
    end

    self:saveData();
end

--保存数据
function GameScene:saveData()
end

--加载数据
function GameScene:loadData()
    self.schedulerList = {} --定时器列表
    self.isExplain = false
end

--加载资源
function GameScene:loadResources()
    local root = ccs.GUIReader:getInstance():widgetFromJsonFile("att2/res/json/ui_game.json")
    self:addChild(root)

    self.pannelDeskCards = ccui.Helper:seekWidgetByName(root, "Panel_poker")
    self.panelLogo = ccui.Helper:seekWidgetByName(root, "Panel_title")
    self.information = ccui.Helper:seekWidgetByName(root, "Panel_information") --文本动画

    --皮子区分数
    self.rewards = {}
    self.rewardsRed = {}
    for i = 1, 4 do
        -- ccui.Helper:seekWidgetByName(root, "AtlasLabel_score_red_" .. i):setString(DeskData.rewards[i]);
        -- ccui.Helper:seekWidgetByName(root, "AtlasLabel_score_yellow_" .. i):setString(DeskData.rewards[i]);
        ccui.Helper:seekWidgetByName(root, "AtlasLabel_score_yellow_" .. i):setVisible(true);
        table.insert(self.rewards, ccui.Helper:seekWidgetByName(root, "AtlasLabel_score_yellow_" .. i))
        ccui.Helper:seekWidgetByName(root, "AtlasLabel_score_red_" .. i):setVisible(false);
        table.insert(self.rewardsRed, ccui.Helper:seekWidgetByName(root, "AtlasLabel_score_red_" .. i))
    end

    --背景
    self.explainPanel = ccui.Helper:seekWidgetByName(root, "Panel_game_explain")--说明

    --按钮
    self.btnExit = ccui.Helper:seekWidgetByName(root, "Button_quit") --退出按钮
    self.btnStartMusic = ccui.Helper:seekWidgetByName(root, "Button_sound_close") --开启声音
    self.btnStopMusic = ccui.Helper:seekWidgetByName(root, "Button_sound_open") --关闭声音

    self.btnStart = ccui.Helper:seekWidgetByName(root, "Button_start") --点击开始按钮
    self.btnStart:setBright(false)
    self.btnStart:setTouchEnabled(false)
    -- self.btnRecord = ccui.Helper:seekWidgetByName(root, "Button_record")
    -- self.btnExitRecord = ccui.Helper:seekWidgetByName(root, "Button_return")
    self.btnAuto = ccui.Helper:seekWidgetByName(root, "Button_automatic")
    self.btnManually = ccui.Helper:seekWidgetByName(root, "Button_manually") --手动按钮
    self.btnUp = ccui.Helper:seekWidgetByName(root, "Button_goFraction") --上分
    self.btnDown = ccui.Helper:seekWidgetByName(root, "Button_downFraction") --下分
    self.btnBet = ccui.Helper:seekWidgetByName(root, "Button_bottomPour") --下注按钮
    self.btnExplain = ccui.Helper:seekWidgetByName(root, "Button_explain") --说明按钮
    self.btnScore = ccui.Helper:seekWidgetByName(root, "Button_score")    --得分
    self.btnCompare = ccui.Helper:seekWidgetByName(root, "Button_compare")   --比倍

    --非按钮
    self.lblBet = ccui.Helper:seekWidgetByName(root, "AtlasLabel_score_bet") --bet节点
    self.panelRecord = ccui.Helper:seekWidgetByName(root, "Panel_record_one") --历史记录面板
    self.specialAward = ccui.Helper:seekWidgetByName(root, "Panel_special_award") --历史记录面板

    

    --分数功能
    --初级，中级，高级分数数组
    self.winCardTypeScoreList = {}
    self.winCardTypeRedScoreList = {}
    self.winCardTypeTitleList = {}
    --把分数添加到上面
    for j = 1, 3 do
        self.winCardTypeScoreList[j] = {}
        self.winCardTypeRedScoreList[j] = {}
        for i = 1, 10 do
            local lblScore = nil
            lblScore = ccui.Helper:seekWidgetByName(root, "AtlasLabel_score_" .. j .. "_" .. i)
            table.insert(self.winCardTypeScoreList[j], lblScore)
            lblScore = ccui.Helper:seekWidgetByName(root, "AtlasLabel_red_score_" .. j .. "_" .. i)
            table.insert(self.winCardTypeRedScoreList[j], lblScore)
        end
    end

    for i = 1, 10 do
        local cardTypeTitle = ccui.Helper:seekWidgetByName(root, "Image_type_" .. i)
        table.insert(self.winCardTypeTitleList, cardTypeTitle)
    end
    self.lblCredit = ccui.Helper:seekWidgetByName(root, "AtlasLabel_score_credit")


    --自动
    if DeskData.automatic == true then
        self:autoAction(1)
    end
	

	  --【退出】返回键
    local function onKeyReleased(keyCode, event)
        if keyCode == cc.KeyCode.KEY_BACK then
				  WarnTips.showTips({
					text = LocalLanguage:getLanguageString("L_6ceb2e80d33e115e"),
					-- confirm = exit_att2,
					confirm = function()
						if self.logoTimer ~= nil then
							SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.logoTimer)
						end
						if self.textTimer ~= nil then
							SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.textTimer)
						end
						if self.autoTimer ~= nil then
							SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.autoTimer)
						end
						exit_att2()
					end,
				})
     
        elseif keyCode == cc.KeyCode.KEY_MENU  then
			print("backbackback..wwwwww........")
            if DeskData.automatic == true then
                self:autoAction()
            end
        end
    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )

    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.btnExit)
	
end

--加载动画
function GameScene:loadAnimation()
    --logo动画
    local animation = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o" } --背景星星动画用的数组
    self.animation_number = 0
    self.atlasLabel_animation_1 = self.panelLogo:getChildByName("BitmapLabel_animation_1")
    self.atlasLabel_animation_2 = self.panelLogo:getChildByName("BitmapLabel_animation_2")
    self.atlasLabel_animation_3 = self.panelLogo:getChildByName("BitmapLabel_animation_3")
    local function callbackLogoTimer()
        if self.atlasLabel_animation_1 then
            self.atlasLabel_animation_1:setString(animation[self.animation_number])
        end
        if self.atlasLabel_animation_2 then
            self.atlasLabel_animation_2:setString(animation[self.animation_number])
        end
        if self.atlasLabel_animation_3 then
            self.atlasLabel_animation_3:setString(animation[self.animation_number])
        end
        if self.animation_number and self.animation_number < 15 then
            self.animation_number = self.animation_number + 1
        elseif self.animation_number and self.animation_number > 13 then
            self.animation_number = 0
        end
    end

    self.logoTimer = SchedulerUtil.start(cc.Director:getInstance():getScheduler(), callbackLogoTimer, 0.1, false);

    --文本动画
    self.isShowGameTis = true
    self.textFrequency = 0
    local function callbackTextTimer()
        
        if self.stateText and self.stateText < 6 then
            self.information:getChildByName("Image_push_start"):setVisible(false)
            self.information:getChildByName("Image_lose"):setVisible(false)
            self.information:getChildByName("Image_bet"):setVisible(false)
            self.information:getChildByName("Image_push_hold"):setVisible(false)
            self.information:getChildByName("Image_take_score"):setVisible(false)
        end
        if self.information then
            self.imgGameTis = self.information:getChildByName("Image_lose")
            if self.stateText == 1 then
                self.imgGameTis = self.information:getChildByName("Image_bet")
            elseif self.stateText == 2 then
                self.imgGameTis = self.information:getChildByName("Image_push_start")
            elseif self.stateText == 3 then
                self.imgGameTis = self.information:getChildByName("Image_push_hold")
            elseif self.stateText == 4 then
                self.imgGameTis = self.information:getChildByName("Image_lose")
            elseif self.stateText == 5 then
                self.imgGameTis = self.information:getChildByName("Image_take_score")
            end
        end

        if self.stateText and self.stateText < 6 then
            if self.isShowGameTis == true then
                if self.stateText == 5 or self.stateText == 4 then
                    self.textFrequency = self.textFrequency + 1
                end
                self.imgGameTis:setVisible(true)
                self.isShowGameTis = false
            elseif self.isShowGameTis == false then
                self.imgGameTis:setVisible(false)
                self.isShowGameTis = true
                if self.textFrequency == 1 and self.stateText == 4 then
                    self.textFrequency = 0
                    self.stateText = 10
                end
                -- if self.textFrequency == 1 and self.stateText == 5 then
                --     self.textFrequency = 0
                --     self.stateText = 7
                -- elseif self.textFrequency == 1 and self.stateText == 4 then
                --     self.textFrequency = 0
                --     self.stateText = 1
                -- end
            end
        end
    end

    self.textTimer = SchedulerUtil.start(cc.Director:getInstance():getScheduler(), callbackTextTimer, 0.5, false);
end



--添加事件
function GameScene:addListener()
    --侧边面板
    self.btnExit:addTouchEventListener(makeClickHandler(self, self.exitAction)) --退出游戏
    self.btnStartMusic:addTouchEventListener(makeClickHandler(self, self.stopMusicAction))
    self.btnStopMusic:addTouchEventListener(makeClickHandler(self, self.startMusicAction))

    --主面板
    -- self.btnRecord:addTouchEventListener(makeClickHandler(self, self.checkRecordAction))
    self.btnAuto:addTouchEventListener(makeClickHandler(self, self.autoAction))
    self.btnManually:addTouchEventListener(makeClickHandler(self, self.autoAction))
    self.btnBet:addTouchEventListener(makeClickHandler(self, self.betAction))
    self.btnStart:addTouchEventListener(makeClickHandler(self, self.startAction))
    self.btnExplain:addTouchEventListener(makeClickHandler(self, self.gameExplain))
    self.btnScore:addTouchEventListener(makeClickHandler(self, self.gameScore))
    self.btnCompare:addTouchEventListener(makeClickHandler(self, self.gameCompare))

    --其他按钮
    -- self.btnExitRecord:addTouchEventListener(makeClickHandler(self, self.exitRecordAction))
end

--初始化方法
function GameScene:init()
    print("初始化函数执行")

    self.stateText = 1 --状态文本

    self.lblCredit:setString(DeskData.credit)
    if DeskData.credit < 100 then
        DeskData.bet = 0
    end
    self.lblBet:setString(DeskData.bet)

    self:changeGameStatus(DeskData.GAME_STATUS_WAIT_BET);

    --初始化皮子区
    local rewardNumber = { 5000, 2000, 500, 200 }
    for i = 1, 4 do
        self.rewards[i]:setString(rewardNumber[i]);
        self.rewardsRed[i]:setString(rewardNumber[i]);
    end

    if MusicUtil.isPlayMusic == false then
        self.btnStartMusic:setVisible(false)
        self.btnStopMusic:setVisible(true)
    elseif MusicUtil.isPlayMusic == true then
        self.btnStartMusic:setVisible(true)
        self.btnStopMusic:setVisible(false)
    end

    -- self.btnStart:setVisible(true)
    -- self.btnScore:setVisible(false)
end

function GameScene:changeGameStatus(_gameStatus)
    if _gameStatus == nil then
        DeskData.gameStatus = DeskData.gameStatus + 1;
    else
        DeskData.gameStatus = _gameStatus;
    end

    if DeskData.gameStatus == DeskData.GAME_STATUS_WAIT_BET then --等待下注
        self.btnBet:setBright(true)
        self.btnBet:setTouchEnabled(true)
        self.btnCompare:setBright(false)
        self.btnCompare:setTouchEnabled(false)
        self.btnScore:setBright(false)
        self.btnScore:setTouchEnabled(false)
        self.btnStart:setVisible(true)
        self.btnScore:setVisible(false)

        if DeskData.isOldBet == true then
            self:betAction()
        else
            self.panelLogo:setVisible(true)
            self.pannelDeskCards:setVisible(false)
            self.btnAuto:setBright(true)
            self.btnAuto:setTouchEnabled(true)
            self.btnStart:setBright(false)
            self.btnStart:setTouchEnabled(false)
        end
        

        --数据修正
        if DeskData.credit < 100 and DeskData.bet == 0  then --判断是否可以下注
            self.btnAuto:setBright(false)
            self.btnAuto:setTouchEnabled(false)
            self.btnBet:setBright(false)
            self.btnBet:setTouchEnabled(false)
            self.btnStart:setBright(false)
            self.btnStart:setBright(false)
            if DeskData.automatic == true then
                self:autoAction()
            end
        end

    elseif DeskData.gameStatus == DeskData.GAME_STATUS_WAIT_START then --等待开始
        self.stateText = 2
        self.panelLogo:setVisible(false)
        self.pannelDeskCards:setVisible(true)
        self.btnStart:setBright(true)
        self.btnStart:setTouchEnabled(true)
    elseif DeskData.gameStatus == DeskData.GAME_STATUS_WAIT_DISCARD_FIRST then --等待第一次发牌
        self.btnStart:setBright(false)
        self.btnStart:setTouchEnabled(false)
        self.btnBet:setBright(false)
        self.btnBet:setTouchEnabled(false)
        DeskData.isBet = true
        DeskData.isOldBet = true --用于自动
        DeskData.oldBet = DeskData.bet

        if self.logoTimer ~= nil then
            SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.logoTimer)
        end
        self.stateText = 3
    elseif DeskData.gameStatus == DeskData.GAME_STATUS_WAIT_CHANGE then --等待换牌
        self.btnStart:setBright(true)
        self.btnStart:setTouchEnabled(true)
    elseif DeskData.gameStatus == DeskData.GAME_STATUS_WAIT_DISCARD_SECOND then --等待第二次发牌
        self.btnStart:setBright(false)
        self.btnStart:setTouchEnabled(false)
    elseif DeskData.gameStatus == DeskData.GAME_STATUS_WAIT_RESULT then--等待胜利结果
        self.btnStart:setBright(false)
        self.btnStart:setTouchEnabled(false)
        self.btnStart:setVisible(false)
        self.btnScore:setBright(true)
        self.btnScore:setTouchEnabled(true)
        self.btnCompare:setBright(true)
        self.btnCompare:setTouchEnabled(true)
        self.btnScore:setVisible(true)
    end

    if DeskData.automatic == true then
        self.btnBet:setBright(false)
        self.btnBet:setTouchEnabled(false)
        self.btnStart:setBright(false)
        self.btnStart:setTouchEnabled(false)
        self.btnCompare:setBright(false)
        self.btnCompare:setTouchEnabled(false)
        self.btnScore:setBright(false)
        self.btnScore:setTouchEnabled(false)
    end

    print(DeskData:getGameStatusDescribe())
end

--点击【退出】按钮操作
function GameScene:exitAction(sender, eventType)
    print("点击【退出】按钮")
    if eventType == ccui.TouchEventType.ended then
        WarnTips.showTips({
            text = LocalLanguage:getLanguageString("L_6ceb2e80d33e115e"),
            -- confirm = exit_att2,
            confirm = function()
                if self.logoTimer ~= nil then
                    SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.logoTimer)
                    self.logoTimer = nil
                end
                if self.textTimer ~= nil then
                    SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.textTimer)
                    self.textTimer = nil
                end
                if self.autoTimer ~= nil then
                    SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.autoTimer)
                    self.autoTimer = nil
                end
                if self.takeScoreTimer ~= nil then
                    SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.takeScoreTimer)
                    self.takeScoreTimer = nil
                end
                if self.winTime ~= nil then
                    SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.winTime)
                    self.winTime = nil
                end
                if self.ChangeCardTimer ~= nil then
                    SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.ChangeCardTimer)
                    self.ChangeCardTimer = nil
                end
                exit_att2()
            end,
        })
    elseif eventType == ccui.TouchEventType.moved then
    elseif eventType == ccui.TouchEventType.began then
    end
end

function GameScene:stopMusicAction()
    self.btnStartMusic:setVisible(false);
    self.btnStopMusic:setVisible(true);
    MusicUtil.stopAll();
    global.g_musicopen=0;
end

function GameScene:startMusicAction()
    self.btnStartMusic:setVisible(true);
    self.btnStopMusic:setVisible(false);
    MusicUtil.startAll();
    global.g_musicopen=1;
end

--点击【记录】按钮操作
function GameScene:checkRecordAction()
    self.panelRecord:setVisible(true)
end

--历史记录面板点击【返回】按钮操作
function GameScene:exitRecordAction()
    self.panelRecord:setVisible(false)
end

function GameScene:autoAction(isAutomatic)
    if self.autoTimer ~= nil then
        SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.autoTimer)
    end
    if DeskData.automatic == true then
        self.btnManually:setVisible(false)
        self.btnAuto:setVisible(true)
    else
        self.btnManually:setVisible(true)
        self.btnAuto:setVisible(false)
    end
    local isRunning=false
    local function callbackAutoTimer()
        if DeskData.automatic == true then
            if isRunning==false then
                if DeskData.gameStatus == DeskData.GAME_STATUS_WAIT_BET then--等待下注状态
                    isRunning = true;
                    if DeskData.isOldBet == false then
                        self:betAction()
                    end
                    isRunning=false;
                elseif DeskData.gameStatus == DeskData.GAME_STATUS_WAIT_START or DeskData.gameStatus == DeskData.GAME_STATUS_WAIT_CHANGE then
                    --等待开始状态或者等待换牌状态
                    isRunning=true;
                    self:startAction()
                    isRunning=false;
                elseif DeskData.gameStatus == DeskData.GAME_STATUS_WAIT_RESULT then
                    --等待选择结果
                    isRunning=true;
                    self:gameScore()--得分
                    isRunning=false;
                end
            end
        end
    end

    if isAutomatic ~= 1 then
        if DeskData.automatic == true then
            DeskData.automatic = false
            if DeskData.gameStatus == DeskData.GAME_STATUS_WAIT_BET then --开始状态
                self.btnBet:setBright(true)
                self.btnBet:setTouchEnabled(true)
                self.btnStart:setBright(false)
                self.btnStart:setTouchEnabled(false)
                if DeskData.isBet == true or DeskData.isOldBet == true then
                    self.btnBet:setBright(true)
                    self.btnBet:setTouchEnabled(true)
                    DeskData.gameStatus = DeskData.GAME_STATUS_WAIT_START
                end
            elseif DeskData.gameStatus == DeskData.GAME_STATUS_WAIT_START or DeskData.gameStatus == DeskData.GAME_STATUS_WAIT_CHANGE then
                --出牌和发牌状态
                self.btnBet:setBright(false)
                self.btnBet:setTouchEnabled(false)
                self.btnStart:setBright(true)
                self.btnStart:setTouchEnabled(true)
                if DeskData.isBet == true or DeskData.isOldBet == true then
                    if DeskData.gameStatus == DeskData.GAME_STATUS_WAIT_START then
                        --出牌状态
                        self.btnBet:setBright(true)
                        self.btnBet:setTouchEnabled(true)
                    end
                end
            elseif DeskData.gameStatus == DeskData.GAME_STATUS_WAIT_RESULT then
                --等待结果
                self.btnBet:setBright(false)
                self.btnBet:setTouchEnabled(false)
                self.btnStart:setBright(false)
                self.btnStart:setTouchEnabled(false)
                self.btnStart:setVisible(false)
                self.btnCompare:setBright(true)
                self.btnCompare:setTouchEnabled(true)
                self.btnScore:setVisible(true)
                self.btnScore:setTouchEnabled(true)
                self.btnScore:setVisible(true)
            end
        else
            self.btnBet:setBright(false)
            self.btnBet:setTouchEnabled(false)
            self.btnStart:setBright(false)
            self.btnStart:setTouchEnabled(false)
            self.btnCompare:setBright(true)
            self.btnCompare:setTouchEnabled(true)
            self.btnScore:setTouchEnabled(true)
            self.btnScore:setVisible(true)
            self.btnCompare:setBright(false)
            self.btnCompare:setTouchEnabled(false)
            self.autoTimer = SchedulerUtil.start(cc.Director:getInstance():getScheduler(), callbackAutoTimer, 2, false);
            DeskData.automatic = true
        end
    else
        self.btnBet:setBright(false)
        self.btnBet:setTouchEnabled(false)
        self.btnStart:setBright(false)
        self.btnStart:setTouchEnabled(false)
    end
end

--游戏说明
function GameScene:gameExplain()
    self.isExplain = true
    self.explainPanel:setVisible(true)
    local returnExplain = self.explainPanel:getChildByName("Button_explain_return")
    local function returnFunction()
        self.isExplain = false
        self.explainPanel:setVisible(false)
    end
    returnExplain:addTouchEventListener(returnFunction) 
end

--显示奖励提示
function GameScene:displayBonusBoardGrade()
    local lowLevelList = { 1, 2, 3, 4, 6, 8, 40, 100, 150, 300 }
    local midLevelList = { 1, 2, 3, 5, 7, 10, 50, 120, 200, 400 }
    local highLevelList = { 1, 2, 3, 6, 8, 12, 60, 140, 250, 500 }

    for i = 1, 10 do
        self.winCardTypeScoreList[DeskData.winRank][i]:setVisible(false)
        self.winCardTypeRedScoreList[DeskData.winRank][i]:setVisible(true)

        for j = 1, 3 do
            if j == 1 then
                self.winCardTypeScoreList[j][i]:setString(highLevelList[i] * DeskData.bet)
                self.winCardTypeRedScoreList[j][i]:setString(highLevelList[i] * DeskData.bet)
            elseif j == 2 then
                self.winCardTypeScoreList[j][i]:setString(midLevelList[i] * DeskData.bet)
                self.winCardTypeRedScoreList[j][i]:setString(midLevelList[i] * DeskData.bet)
            elseif j == 3 then
                self.winCardTypeScoreList[j][i]:setString(lowLevelList[i] * DeskData.bet)
                self.winCardTypeRedScoreList[j][i]:setString(lowLevelList[i] * DeskData.bet)
            end
        end
    end
end
--奖励观看区（动画，获胜）
function GameScene:bonusBoardWin()
    for i = 1, 10 do
        for j = 1, 3 do
            if j == DeskData.winRank and i == DeskData.deskCardsType then
                local pizifen = 0
                if i==10 then
                    pizifen=DeskData.score5K
                elseif i==9 then
                    pizifen=DeskData.scoreRS
                elseif i==8 then 
                    pizifen=DeskData.scoreSF
                elseif i==7 then
                    pizifen=DeskData.score4K
                end
                DeskData.bet = self.winCardTypeScoreList[j][i]:getString()+pizifen;
            else
                self.winCardTypeScoreList[j][i]:setString(0)
                self.winCardTypeRedScoreList[j][i]:setString(0)
            end
        end
    end

    for i = 1, 4 do
        self.specialAward:getChildByName("AtlasLabel_score_yellow_" .. i):setVisible(false);
        self.specialAward:getChildByName("AtlasLabel_score_red_" .. i):setVisible(true);
    end

    local typeAnimation = 1
    local winCardTypeTitle = self.winCardTypeTitleList[DeskData.deskCardsType]
    local function callbackWintime()
        if winCardTypeTitle and typeAnimation == 1 then
            winCardTypeTitle:setVisible(true)
            typeAnimation = 2
        elseif winCardTypeTitle and typeAnimation == 2 then
            winCardTypeTitle:setVisible(false)
            typeAnimation = 1
        end
    end

    self.winTime = SchedulerUtil.start(cc.Director:getInstance():getScheduler(), callbackWintime, 0.4, false);
end
--奖励观看区（动画，结束）
function GameScene:bonusBoardInit()
    for i = 1, 10 do
        for j = 1, 3 do
            self.winCardTypeScoreList[j][i]:setVisible(true)
            self.winCardTypeRedScoreList[j][i]:setVisible(false)
            self.winCardTypeScoreList[j][i]:setString(0)
            self.winCardTypeRedScoreList[j][i]:setString(0)
        end
    end

    if self.winTime ~= nil and DeskData.deskCardsType ~= 0 then
        SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.winTime)
        self.winCardTypeTitleList[DeskData.deskCardsType]:setVisible(false)
    end

    for i = 1, 4 do
        self.specialAward:getChildByName("AtlasLabel_score_yellow_" .. i):setVisible(true);
        self.specialAward:getChildByName("AtlasLabel_score_red_" .. i):setVisible(false);
    end
end

--下注操作
function GameScene:betAction()
    self:changeGameStatus(DeskData.GAME_STATUS_WAIT_START)
    MusicUtil.jetton()
    DeskData.nextBet();
    self.lblCredit:setString(DeskData.credit)
    self.lblBet:setString(DeskData.bet)
end

--点击【开始】按钮操作
function GameScene:startAction()
    print("点击【开始】按钮")

    if DeskData.gameStatus == DeskData.GAME_STATUS_WAIT_START then
        self:discard();
    else
        self:switchCards();
    end
end

--第一次发牌
function GameScene:discard()
    self:changeGameStatus()
    --发送发牌牌消息到服务器
    gamesvr.sendStartDeal(DeskData.bet)
end

--发牌动画
function GameScene:discardCardsAnimation()
    --初始化皮子区
    local rewardNumber = { DeskData.score5K, DeskData.scoreRS, DeskData.scoreSF, DeskData.score4K }
    for i = 1, 4 do
        self.rewards[i]:setString(rewardNumber[i]);
        self.rewardsRed[i]:setString(rewardNumber[i]);
    end

    self.lblCredit:setString(DeskData.credit)

    --重新计算nodeDeskCards和nodeHoldLabels节点
    self.nodeDeskCards = {}
    self.nodeHoldLabels = {}
    self:cardClick()

    local k = 1
    local function callbackIssueTimer()
        self.cardFace = self.pannelDeskCards:getChildByName('Card_Target_' .. k)
        self.cardBack = self.pannelDeskCards:getChildByName(DeskData.deskCards[k])
        AnimationUtil.handCardsAnimation(self.pannelDeskCards, self.cardFace, self.cardBack)
        k = k + 1
        if k > 5 then
            SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.IssueTimer)
            if self.imgGameTis ~= nil then
                self.imgGameTis:setVisible(false)
            end
            for i = 1, 5 do
                if (DeskData.holdCards[i] == true) then
                    self.nodeHoldLabels[i]:setVisible(true)
                end
            end
            --改变游戏状态
            self:changeGameStatus();
        end
    end

    self.IssueTimer = SchedulerUtil.start(cc.Director:getInstance():getScheduler(), callbackIssueTimer, 0.15, false);
end

function GameScene:playMusic(index)
    if index == 1 then
        MusicUtil.keepCard1()
    elseif index == 2 then
        MusicUtil.keepCard2()
    elseif index == 3 then
        MusicUtil.keepCard3()
    elseif index == 4 then
        MusicUtil.keepCard4()
    elseif index == 5 then
        MusicUtil.keepCard5()
    end
end

function GameScene:cardClick()
    for i = 1, 5 do
        self.cardNode = self.pannelDeskCards:getChildByName(DeskData.deskCards[i])
        table.insert(self.nodeDeskCards, self.cardNode)
        table.insert(self.nodeHoldLabels, self.cardNode:getChildByName("hold"))
    end

    --hold的点击事件
    for i = 1, #self.nodeDeskCards do
        self.nodeDeskCards[i]:addTouchEventListener(makeClickHandler(self, function() --点击手牌
            DeskData.holdCards[i] = not DeskData.holdCards[i];
            self.nodeHoldLabels[i]:setVisible(DeskData.holdCards[i]);
            self:playMusic(i)
        end))
        self.nodeHoldLabels[i]:addTouchEventListener(makeClickHandler(self, function() --点击hold节点
            DeskData.holdCards[i] = not DeskData.holdCards[i];
            self.nodeHoldLabels[i]:setVisible(DeskData.holdCards[i]);
            self:playMusic(i)
        end))
    end
end

function GameScene:cancelClick()
    for i = 1, #self.nodeDeskCards do
        self.nodeDeskCards[i]:addTouchEventListener(makeClickHandler(self, function()
        end)) --点击手牌
        self.nodeHoldLabels[i]:addTouchEventListener(makeClickHandler(self, function()
        end)) --点击hold节点
    end
end

--换牌动画
function GameScene:switchCardsAnimation()
    --显示中奖或者失败动画
    print("DeskData.deskCardsType=", DeskData.deskCardsType);

    --初始化皮子区
    local rewardNumber = { DeskData.score5K, DeskData.scoreRS, DeskData.scoreSF, DeskData.score4K }
    for i = 1, 4 do
        self.rewards[i]:setString(rewardNumber[i]);
        self.rewardsRed[i]:setString(rewardNumber[i]);
    end

    if DeskData.deskCardsType ~= 0 then
        self:bonusBoardWin()
    end
    for i = 1, 5 do
        if (DeskData.holdCards[i] == false) then
            self.pannelDeskCards:getChildByName(DeskData.deskCards[i]):setVisible(false)
            self.pannelDeskCards:getChildByName('Card_Target_' .. i):setVisible(true)
        end
    end

    for i = 1, 5 do
        self.cardNode = self.pannelDeskCards:getChildByName(DeskData.newDeskCards[i])
        self.nodeHoldLabels[i] = self.cardNode:getChildByName("hold")
    end

    for i = 1, 5 do
        if (DeskData.winHoldCards[i] == true) then
            self.nodeHoldLabels[i]:setVisible(true)
        else
            self.nodeHoldLabels[i]:setVisible(false)
        end
    end

    local number = 1
    self.isTurnCards = false
    local function callbackChangeCardTimer()
        self.isTurnCards = false
        for i = 1, 5 do
            if self.isTurnCards == false then
                if DeskData.holdCards[number] ~= true then
                    if number < 6 then
                        self.cardFace = self.pannelDeskCards:getChildByName('Card_Target_' .. number)
                        self.cardBack = self.pannelDeskCards:getChildByName(DeskData.newDeskCards[number])
                        AnimationUtil.handCardsAnimation(self.pannelDeskCards, self.cardFace, self.cardBack)
                    end
                    number = number + 1
                    self.isTurnCards = true
                else
                    number = number + 1
                end
            end
            if number > 6 then
                if DeskData.deskCardsType == 0 then
                    MusicUtil.noCard()
                    for i = 1, 10 do
                        for j = 1, 3 do
                            self.winCardTypeScoreList[j][i]:setString(0)
                            self.winCardTypeRedScoreList[j][i]:setString(0)
                        end
                    end
                else
                    MusicUtil.haveCard()

                    --判断具体是哪种类型
                    if DeskData.deskCardsType == 10 then
                        MusicUtil.joinGame();
                        MusicUtil.win5k()
                    elseif DeskData.deskCardsType == 9 then
                        MusicUtil.joinGame();
                        MusicUtil.winRS()
                    elseif DeskData.deskCardsType == 8 then
                        MusicUtil.joinGame();
                        MusicUtil.winSF()
                    elseif DeskData.deskCardsType == 7 then
                        MusicUtil.joinGame();
                        MusicUtil.win4k()
                    end
                end

                if DeskData.deskCardsType ~= 0 then
                    -- self.stateText = 5
                else
                    self.stateText = 4
                end

                SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.ChangeCardTimer) --停止动画
                --改变游戏状态
                -- self:changeGameStatus();
            end
        end
    end

    self.ChangeCardTimer = SchedulerUtil.start(cc.Director:getInstance():getScheduler(), callbackChangeCardTimer, 0.1, false);

    if self.imgGameTis ~= nil then
        self.imgGameTis:setVisible(false)
    end

    local function callback()
        if DeskData.deskCardsType == 0 then
            self:bonusBoardInit()
            for i = 1, 5 do
                self.pannelDeskCards:getChildByName('Card_Target_' .. i):setVisible(true)
                self.pannelDeskCards:getChildByName(DeskData.deskCards[i]):setVisible(false)
                self.pannelDeskCards:getChildByName(DeskData.newDeskCards[i]):setVisible(false)
                self.pannelDeskCards:getChildByName(DeskData.deskCards[i]):getChildByName("hold"):setVisible(false)
                self.pannelDeskCards:getChildByName(DeskData.newDeskCards[i]):getChildByName("hold"):setVisible(false)
                self.nodeHoldLabels[i]:setVisible(false)
            end

            --保存分数
            DeskData.bet = 0; --分数清零
            global.g_mainPlayer:setPlayerScore(DeskData.credit + DeskData.bet);

            SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.endTime)
            DeskData.getScore();
            self:init()
        elseif DeskData.deskCardsType ~= 0 then
            --改变游戏状态
            self:changeGameStatus()
            SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.endTime)
        end
    end

    self.endTime = SchedulerUtil.start(cc.Director:getInstance():getScheduler(), callback, 3, false);
end


function GameScene:gameScore()
    self.stateText = 5
    self.btnScore:setBright(false)
    self.btnScore:setTouchEnabled(false)
    self.btnCompare:setBright(false)
    self.btnCompare:setTouchEnabled(false)
    local function callTakeScoreTimer()
        if self.takeScoreTimer ~= null then
            SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.takeScoreTimer)
        end
        self:bonusBoardInit();

        for i = 1, 5 do
            self.pannelDeskCards:getChildByName('Card_Target_' .. i):setVisible(true)
            self.pannelDeskCards:getChildByName(DeskData.deskCards[i]):setVisible(false)
            self.pannelDeskCards:getChildByName(DeskData.newDeskCards[i]):setVisible(false)
            self.pannelDeskCards:getChildByName(DeskData.deskCards[i]):getChildByName("hold"):setVisible(false)
            self.pannelDeskCards:getChildByName(DeskData.newDeskCards[i]):getChildByName("hold"):setVisible(false)
            self.nodeHoldLabels[i]:setVisible(false)
        end

        --获取分数
        DeskData.getScore();

        self:init()
    end

    self.takeScoreTimer = SchedulerUtil.start(cc.Director:getInstance():getScheduler(), callTakeScoreTimer, 1.5, false);
end

function GameScene:gameCompare()
    self:bonusBoardInit();
    self.btnScore:setBright(false)
    self.btnScore:setTouchEnabled(false)
    self.btnCompare:setBright(false)
    self.btnCompare:setTouchEnabled(false)

    --停止所有动画
    if self.endTime ~= nil then
        SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.endTime)
        self.endTime = nil
    end
    -- if self.logoTimer ~= nil then

    -- end
    SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.logoTimer)
    if self.textTimer ~= nil then
        SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.textTimer)
        self.textTimer = nil
    end
    if self.autoTimer ~= nil then
        SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.autoTimer)
        self.autoTimer = nil
    end

            
    --进入比牌场景
    -- local scene = CompareScene.new()
    -- cc.Director:getInstance():replaceScene(scene)
    replaceScene(CompareScene, TRANS_CONST.TRANS_SCALE)
end


--换牌，第二次点【开始】按钮
function GameScene:switchCards()
    self:changeGameStatus();
    self:cancelClick();
    --发送换牌消息到服务器
    gamesvr.sendSwitchCard(DeskData.deskCards, DeskData.holdCards)
end

function GameScene:onEndEnterTransition()
    print("GameScene:onEndEnterTransition()--------------------------------------------------------------------------------");

    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAME_SCENE_RESULT, self, self.onGameSceneResult)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_DEAL_CARD_RESULT, self, self.onDealCardResult)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SWITCH_CARD_RESULT, self, self.onSwitchCardResult)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAME_FRAME_RESULT, self, self.onGameFrameResult)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAME_END_RESULT, self, self.onGameEndResult)
end

function GameScene:onStartExitTransition()
    print("GameScene:onStartExitTransition()--------------------------------------------------------------------------------");
    self:onStopTimer()

    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAME_SCENE_RESULT, self)
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_DEAL_CARD_RESULT, self)
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SWITCH_CARD_RESULT, self)
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAME_FRAME_RESULT, self)
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAME_END_RESULT, self)
end

--进入游戏返回结果
function GameScene:onGameSceneResult(param)
    print("onGameSceneResult-------------------------------------------------");
    --初始化分数
    DeskData.init(param.currentScore, param.exchangeScale);

    self:init(); --数据初始化
end

--发牌返回结果
function GameScene:onDealCardResult(param)
    print("onGameDealCardResult:");
    MusicUtil.dealCard() --播放发牌音乐
    PokerCard.computeDealCard(param); --计算发牌的相关值

    self:displayBonusBoardGrade(); --显示奖励提示
    self:discardCardsAnimation(); --执行发牌动画
end

--换牌返回结果
function GameScene:onSwitchCardResult(param)
    print("GameScene:onSwitchCardResult ---------------------------------------------------------------------")

    PokerCard.computeSwitchCard(param); --计算换牌的相关值

    self:switchCardsAnimation();
end

function GameScene:onGameEndResult(param)
    print("GameScene:onGameEndResult ---------------------------------------------------------------------")
end

function GameScene:onGameFrameResult(param)
    print("GameScene:onGameFrameResult ---------------------------------------------------------------------")
end

--启动定时器
function GameScene:onTimer()
    print("GameScene:onTimer ---------------------------------------------------------------------")
end

--关闭定时器
function GameScene:onStopTimer()
    print("GameScene:onStopTimer ---------------------------------------------------------------------")
    if self.logoTimer ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.logoTimer)
        self.logoTimer = nil
    end
    if self.textTimer ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.textTimer)
        self.textTimer = nil
    end
    if self.autoTimer ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.autoTimer)
        self.autoTimer = nil
    end
    if self.takeScoreTimer ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.takeScoreTimer)
        self.takeScoreTimer = nil
    end
    if self.winTime ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.winTime)
        self.winTime = nil
    end
    if self.ChangeCardTimer ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.ChangeCardTimer)
        self.ChangeCardTimer = nil
    end
end