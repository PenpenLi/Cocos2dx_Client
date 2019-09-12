CompareScene = class("CompareScene", LayerBase)

function CompareScene:ctor()
    CompareScene.super.ctor(self)

    self:loadData(); --加载数据信息
    self:loadResources(); --加载资源
    self:loadAnimation(); --加载动画
    self:addListener() --添加事件
    self:init(); --数据初始化
end

function CompareScene:loadData()
    -- MusicUtil.isPlayMusic=true;
    self.schedulerList = {};
    self.isExplain = false
end

function CompareScene:loadResources()
    local root = ccs.GUIReader:getInstance():widgetFromJsonFile("att2/res/json/ui_compare.json")
    root:setClippingEnabled(true)
    self:addChild(root)

    --背景
    self.explainPanel = ccui.Helper:seekWidgetByName(root, "Panel_game_explain")--说明

    --按钮
    self.btnStartMusic = ccui.Helper:seekWidgetByName(root, "Button_sound_close") --开启声音
    self.btnStopMusic = ccui.Helper:seekWidgetByName(root, "Button_sound_open") --关闭声音
    self.btnExit = ccui.Helper:seekWidgetByName(root, "Button_quit") --退出按钮
    self.btnScore = ccui.Helper:seekWidgetByName(root, "Button_card_score") --得分按钮
    self.btnCompare = ccui.Helper:seekWidgetByName(root, "Button_card_compare") --比倍按钮
    self.btnBig = ccui.Helper:seekWidgetByName(root, "Button_card_big")
    self.btnSmall = ccui.Helper:seekWidgetByName(root, "Button_card_small")
    self.btnAuto = ccui.Helper:seekWidgetByName(root, "Button_automatic") --自动按钮
    self.btnExplain = ccui.Helper:seekWidgetByName(root, "Button_explain") --说明按钮

    --非按钮
    self.lblBet = ccui.Helper:seekWidgetByName(root, "AtlasLabel_score_bet")
    self.lblCredit = ccui.Helper:seekWidgetByName(root, "AtlasLabel_score_credit")

    --比倍动画
    self.panelMultiple = ccui.Helper:seekWidgetByName(root, "Panel_multiple")

    --翻牌
    self.pannelDeskCards = ccui.Helper:seekWidgetByName(root, "Panel_poker")
    self.poker_61 = self.pannelDeskCards:getChildByName("Card_Target_1")
    self.poker_62 = self.pannelDeskCards:getChildByName("Card_Target_2")
    self.poker_63 = self.pannelDeskCards:getChildByName("Card_Target_3")
    self.poker_64 = self.pannelDeskCards:getChildByName("Card_Target_4")
    self.poker_65 = self.pannelDeskCards:getChildByName("Card_Target_5")
    self.poker_66 = self.pannelDeskCards:getChildByName("Card_Target_6")
    self.poker_61:setLocalZOrder(1)
    self.poker_62:setLocalZOrder(2)
    self.poker_63:setLocalZOrder(3)
    self.poker_64:setLocalZOrder(4)
    self.poker_65:setLocalZOrder(5)
    self.poker_66:setLocalZOrder(6)

    self.information = ccui.Helper:seekWidgetByName(root, "Panel_information")
end

function CompareScene:loadAnimation()
    --比倍动画
    self:compareAnimation()
    self:textTypeAnimation()

    if DeskData.automatic == true then
        self:autoAction(1)
    end
end

function CompareScene:addListener()
    --得分
    self.btnScore:addTouchEventListener(makeClickHandler(self, self.scoreAction))
    --比倍
    self.btnCompare:addTouchEventListener(makeClickHandler(self, self.compareAction))
    --比大小
    self.btnBig:addTouchEventListener(makeClickHandler(self, self.bigAction)) --比大功能
    self.btnSmall:addTouchEventListener(makeClickHandler(self, self.smallAction)) --比小功能
    --音效
    self.btnStartMusic:addTouchEventListener(makeClickHandler(self, self.stopMusicAction))
    self.btnStopMusic:addTouchEventListener(makeClickHandler(self, self.startMusicAction))
    --退出
    self.btnExit:addTouchEventListener(makeClickHandler(self, self.exitAction))
    --自动
    self.btnAuto:addTouchEventListener(makeClickHandler(self, self.autoAction))
    --说明
    self.btnExplain:addTouchEventListener(makeClickHandler(self, self.gameExplain))

    --【退出】返回键
    local function onKeyReleased(keyCode, event)
        if keyCode == cc.KeyCode.KEY_BACK then
            if  self.isExplain == true then
                self.isExplain = false
                self.explainPanel:setVisible(false)
            else
                self:exitAction()
            end
            
        elseif keyCode == cc.KeyCode.KEY_MENU  then
            if DeskData.automatic == true then
                self:autoAction()
            end
        end
    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )

    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

--初始化函数
function CompareScene:init()
    print("初始化函数");
    self.scheduler = cc.Director:getInstance():getScheduler()
    DeskData.initCompare(); --初始化比倍
    self.lblCredit:setString(DeskData.credit)
    self.lblBet:setString(DeskData.bet)
    self.pokerValue = 0
    self.value = 1
    self.stateText = 4 --状态文本
    self.card = "" --牌
    self.oldCard = {}
    print(DeskData.gameCompareStatus)
    -- print("音乐："..MusicUtil.isPlayMusic)
    if MusicUtil.isPlayMusic == false then
        self.btnStartMusic:setVisible(false)
        self.btnStopMusic:setVisible(true)
    elseif MusicUtil.isPlayMusic == true then
        self.btnStartMusic:setVisible(true)
        self.btnStopMusic:setVisible(false)
    end
    self.btnCompare:setBright(true)
    self.btnCompare:setTouchEnabled(true)
    self:changeGameCompareStatus(DeskData.GAME_COMPARE_WAIT_BET);
end

function CompareScene:changeGameCompareStatus(_gameCompareStatus)
    if _gameCompareStatus == nil then
        DeskData.gameCompareStatus = DeskData.gameCompareStatus + 1;
    else
        DeskData.gameCompareStatus = _gameCompareStatus;
    end

    if DeskData.gameCompareStatus == DeskData.GAME_COMPARE_WAIT_BET then --等待比倍
        self.btnBig:setBright(false)
        self.btnBig:setTouchEnabled(false)
        self.btnSmall:setBright(false)
        self.btnSmall:setTouchEnabled(false)
        if DeskData.compareNum<5 then
            self.btnCompare:setBright(true)
            self.btnCompare:setTouchEnabled(true)
            self.btnScore:setBright(true)
            self.btnScore:setTouchEnabled(true)
        end
    elseif DeskData.gameCompareStatus == DeskData.GAME_COMPARE_WAIT_SELECT_SIZE then --等待选大小
        self.btnBig:setBright(true)
        self.btnBig:setTouchEnabled(true)
        self.btnSmall:setBright(true)
        self.btnSmall:setTouchEnabled(true)
        self.btnCompare:setBright(false)
        self.btnCompare:setTouchEnabled(false)
        self.btnScore:setBright(true)
        self.btnScore:setTouchEnabled(true)
    elseif DeskData.gameCompareStatus == DeskData.GAME_COMPARE_WAIT_DISCARD_SELECT_SIZE then --等待比大小
        self.btnBig:setBright(false)
        self.btnBig:setTouchEnabled(false)
        self.btnSmall:setBright(false)
        self.btnSmall:setTouchEnabled(false)
        self.btnCompare:setBright(false)
        self.btnCompare:setTouchEnabled(false)
        self.btnScore:setBright(false)
        self.btnScore:setTouchEnabled(false)
    end

    if DeskData.automatic == true then
        self.btnBig:setBright(false)
        self.btnBig:setTouchEnabled(false)
        self.btnSmall:setBright(false)
        self.btnSmall:setTouchEnabled(false)
        self.btnCompare:setBright(false)
        self.btnCompare:setTouchEnabled(false)
        self.btnScore:setBright(false)
        self.btnScore:setTouchEnabled(false)
    end

    print(DeskData:getGameCompareDescribe())
end

--音效	
function CompareScene:stopMusicAction()
    self.btnStartMusic:setVisible(false)
    self.btnStopMusic:setVisible(true)
    MusicUtil.stopAll();
end

function CompareScene:startMusicAction()
    self.btnStartMusic:setVisible(true)
    self.btnStopMusic:setVisible(false)
    MusicUtil.startAll();
end

function CompareScene:autoAction(isAutomatic)
    local function callbackAutoTimer()
        if DeskData.automatic == true then
            if DeskData.gameCompareStatus == 0 then
                self:compareAction()
            elseif DeskData.gameCompareStatus == 1 then
                math.randomseed(tostring(os.time()):reverse():sub(1, 7))
                local k = math.random(1,11)
                if k > 0 and k < 6 then
                    self:bigAction()
                elseif k > 5 and k < 11 then
                    self:smallAction()
                end
                -- self:scoreAction()
            end
        end
    end

    if isAutomatic ~= 1 then
        if DeskData.automatic == true then
            DeskData.automatic = false
            SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.autoTimer)
            if DeskData.gameCompareStatus == 0 then
                self.btnCompare:setBright(true)
                self.btnCompare:setTouchEnabled(true)
                self.btnScore:setBright(true)
                self.btnScore:setTouchEnabled(true)
            elseif DeskData.gameCompareStatus == 1 then
                self.btnBig:setBright(true)
                self.btnBig:setTouchEnabled(true)
                self.btnSmall:setBright(true)
                self.btnSmall:setTouchEnabled(true)
            end
        else
            self.btnCompare:setBright(false)
            self.btnCompare:setTouchEnabled(false)
            self.btnScore:setBright(false)
            self.btnScore:setTouchEnabled(false)
            self.btnBig:setBright(false)
            self.btnBig:setTouchEnabled(false)
            self.btnSmall:setBright(false)
            self.btnSmall:setTouchEnabled(false)
            self.autoTimer = SchedulerUtil.start(cc.Director:getInstance():getScheduler(), callbackAutoTimer, 1, false);
            DeskData.automatic = true
        end
    else
        self.btnCompare:setBright(false)
        self.btnCompare:setTouchEnabled(false)
        self.btnScore:setBright(false)
        self.btnScore:setTouchEnabled(false)
        self.autoTimer = SchedulerUtil.start(cc.Director:getInstance():getScheduler(), callbackAutoTimer, 1, false);
    end
end

--退出
function CompareScene:exitAction(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        WarnTips.showTips({
            text = LocalLanguage:getLanguageString("L_6ceb2e80d33e115e"),
            -- confirm = exit_att2,
            confirm = function()
                if self.textTimer ~= nil then
                    SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.textTimer)
                end
                if self.compareTimer ~= nil then
                    SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.compareTimer)
                end
                if self.autoTimer ~= nil then
                    SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.autoTimer)
                end
                if self.takeScoreTimer ~= null then
                    SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.takeScoreTimer)
                end
                exit_att2()
            end,
        })
    elseif eventType == ccui.TouchEventType.moved then
    elseif eventType == ccui.TouchEventType.began then
    end
end

--比倍动画
function CompareScene:compareAnimation()
    self.arrow_animation = {}
    self.display_animation = {}
    self.score_red_animation = {}
    self.score_ash_animation = {}
    for i = 1, 6 do
        local arrow = self.panelMultiple:getChildByName("Image_arrow_1_" .. i)
        table.insert(self.arrow_animation, arrow)
        local display = self.panelMultiple:getChildByName("Image_display_1_" .. i)
        table.insert(self.display_animation, display)
        local scoreRed = self.panelMultiple:getChildByName("AtlasLabel_score_red_" .. i)
        table.insert(self.score_red_animation, scoreRed)
        local scoreAsh_ = self.panelMultiple:getChildByName("AtlasLabel_score_ash_" .. i)
        table.insert(self.score_ash_animation, scoreAsh_)
    end


    --上半部分倍数闪与不闪动画定时器
    local function callbackcompareTimer()
        local compareIndex=DeskData.compareNum+1;
        if compareIndex<7 then
            if self.value == 1 then
                self.arrow_animation[compareIndex]:setVisible(true)
                self.display_animation[compareIndex]:setVisible(false)
                self.score_red_animation[compareIndex]:setVisible(true)
                self.score_ash_animation[compareIndex]:setVisible(false)
                self.value = 2
            elseif self.value == 2 then
                self.arrow_animation[compareIndex]:setVisible(false)
                self.display_animation[compareIndex]:setVisible(true)
                self.value = 1
            end
        end
    end

    self.compareTimer = SchedulerUtil.start(cc.Director:getInstance():getScheduler(), callbackcompareTimer, 0.5, false);
end

--文本动画
function CompareScene:textTypeAnimation()
    self.text = nil
    self.textFrequency = 0
    self.textAnimation = 1
    local function callbackTextTimer()
        if self.information then
            self.information:getChildByName("Image_big"):setVisible(false)
            self.information:getChildByName("Image_small"):setVisible(false)
            self.information:getChildByName("Image_get_score_or_oouble"):setVisible(false)
            self.information:getChildByName("Image_lose"):setVisible(false)
            self.information:getChildByName("Image_take_score"):setVisible(false)
        end
        if self.stateText then
            if self.stateText == 1 then
                self.text = self.information:getChildByName("Image_big")
            elseif self.stateText == 2 then
                self.text = self.information:getChildByName("Image_small")
            elseif self.stateText == 3 then
                self.text = self.information:getChildByName("Image_lose")
            elseif self.stateText == 4 then
                self.text = self.information:getChildByName("Image_get_score_or_oouble")
            elseif self.stateText == 5 then
                self.text = self.information:getChildByName("Image_take_score")
            elseif self.stateText == 6 then
                self.text = self.information:getChildByName("Image_take_score")
            end

            if self.stateText < 7 then
                if self.textAnimation == 1 then
                    if self.stateText == 1 or self.stateText == 2 or self.stateText == 3 or self.stateText == 6 then
                        self.textFrequency = self.textFrequency + 1
                    end
                    self.text:setVisible(true)
                    self.textAnimation = 2
                elseif self.textAnimation == 2 then
                    self.text:setVisible(false)
                    self.textAnimation = 1
                    if self.textFrequency == 1 and self.stateText == 1 then
                        self.textFrequency = 0
                        self.stateText = 4
                    elseif self.textFrequency == 1 and self.stateText == 2 then
                        self.textFrequency = 0
                        self.stateText = 4
                    elseif self.textFrequency == 1  and self.stateText == 3 then
                        self.textFrequency = 0
                    elseif self.textFrequency == 1  and self.stateText == 6 then
                        self.textFrequency = 0
                    end
                end
            end
        end
    end

    self.textTimer = SchedulerUtil.start(cc.Director:getInstance():getScheduler(), callbackTextTimer, 0.5, false);

end

--按钮得分功能
function CompareScene:scoreAction()
    DeskData.isGuessBig = 0;
    gamesvr.sendComporeCard(DeskData.isGuessBig);

    self.stateText = 5
    self.btnCompare:setBright(false)
    self.btnCompare:setTouchEnabled(false)
    self.btnScore:setBright(false)
    self.btnScore:setTouchEnabled(false)
    self.btnBig:setBright(false)
    self.btnBig:setTouchEnabled(false)
    self.btnSmall:setBright(false)
    self.btnSmall:setTouchEnabled(false)
    local function callTakeScoreTimer()
        if self.takeScoreTimer ~= null then
            SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.takeScoreTimer)
        end
        self:returnAction()
    end

    self.takeScoreTimer = SchedulerUtil.start(cc.Director:getInstance():getScheduler(), callTakeScoreTimer, 1.5, false);

    
end

--游戏说明
function CompareScene:gameExplain()
    self.isExplain = true
    self.explainPanel:setVisible(true)
    local returnExplain = self.explainPanel:getChildByName("Button_explain_return")
    local function returnFunction()
        self.isExplain = false
        self.explainPanel:setVisible(false)
    end
    returnExplain:addTouchEventListener(returnFunction) 
end

--返回功能
function CompareScene:returnAction()
    if self.textTimer ~= nil then
        SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.textTimer)
    end
    if self.compareTimer ~= nil then
        SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.compareTimer)
    end
    if self.autoTimer ~= nil then
        SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.autoTimer)
    end

    --计算比倍结果
    DeskData.computeCompareResult();

    -- local scene = GameScene.new()
    -- cc.Director:getInstance():replaceScene(scene)
    replaceScene(GameScene, TRANS_CONST.TRANS_SCALE)
end

--按钮记录功能
function CompareScene:historyRecord()
    getBackOff(2);
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler2)
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler1)
    -- local scene = RecordScene.new()
    -- cc.Director:getInstance():replaceScene(scene)
    replaceScene(RecordScene, TRANS_CONST.TRANS_SCALE)
end

--点击按钮【小】操作
function CompareScene:smallAction()
    -- DeskData.nextCompareStatus(); --进入下一个比倍状态
    DeskData.isGuessBig = 1;
    self:changeGameCompareStatus()
    --发送比牌消息到服务器
    gamesvr.sendComporeCard(DeskData.isGuessBig);
end

--点击按钮【大】操作
function CompareScene:bigAction()
    -- DeskData.nextCompareStatus(); --进入下一个比倍状态
    DeskData.isGuessBig = 2;
    self:changeGameCompareStatus()
    --发送比牌消息到服务器
    gamesvr.sendComporeCard(DeskData.isGuessBig);
end

--按钮比倍功能
function CompareScene:compareAction()
    MusicUtil.compare()

    self:movePoker()
    self:changeGameCompareStatus()
end

--翻牌事件
function CompareScene:turnOverCards(card, isCorrect)
    self.pokerValue = self.pokerValue + 1
    local cardFace = self.pannelDeskCards:getChildByName('Card_Target_0');
    local cardBack = nil
    local isCorrect = isCorrect
    self.card = card
    cardBack = self.pannelDeskCards:getChildByName(self.card)
    print("牌是：" .. self.card)
    AnimationUtil.handCardsAnimation(self.pannelDeskCards, cardFace, cardBack)
    if isCorrect == false then
        MusicUtil.noCard()
        self.btnCompare:setBright(false)
        self.btnCompare:setTouchEnabled(false)
        self.btnScore:setBright(false)
        self.btnScore:setTouchEnabled(false)
        for i = 1, #self.oldCard - 1 do
            self.pannelDeskCards:getChildByName('Card_Target_' .. i):setVisible(true);
            self.pannelDeskCards:getChildByName(self.oldCard[i]):setVisible(false);
        end
        local function callbackloseTimer() 
            self.stateText = 3
            SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.loseTimer)
        end
        self.loseTimer = SchedulerUtil.start(cc.Director:getInstance():getScheduler(), callbackloseTimer, 1, false);
        local function callbackCardsTimer()
            self:returnAction()
            SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.cardsTimer)
        end

        self.cardsTimer = SchedulerUtil.start(cc.Director:getInstance():getScheduler(), callbackCardsTimer, 2, false);
    else
        DeskData.nextCompareStatus();
        self:changeGameCompareStatus(DeskData.GAME_COMPARE_WAIT_BET)
        MusicUtil.compareWin()
    end
end

--移动牌事件
function CompareScene:movePoker()
    local cardPosition = nil
    local cardBack = nil
    if self.pokerValue == 1 then
        cardPosition = self.pannelDeskCards:getChildByName('Card_Target_1')
        cardBack = self.pannelDeskCards:getChildByName(self.card)
        cardBack:setLocalZOrder(1)
    elseif self.pokerValue == 2 then
        cardPosition = self.pannelDeskCards:getChildByName('Card_Target_2')
        cardBack = self.pannelDeskCards:getChildByName(self.card)
        cardBack:setLocalZOrder(2)
    elseif self.pokerValue == 3 then
        cardPosition = self.pannelDeskCards:getChildByName('Card_Target_3')
        cardBack = self.pannelDeskCards:getChildByName(self.card)
        cardBack:setLocalZOrder(3)
    elseif self.pokerValue == 4 then
        cardPosition = self.pannelDeskCards:getChildByName('Card_Target_4')
        cardBack = self.pannelDeskCards:getChildByName(self.card)
        cardBack:setLocalZOrder(4)
    elseif self.pokerValue == 5 then
        cardPosition = self.pannelDeskCards:getChildByName('Card_Target_5')
        cardBack = self.pannelDeskCards:getChildByName(self.card)
        cardBack:setLocalZOrder(5)
    elseif self.pokerValue == 6 then
        cardPosition = self.pannelDeskCards:getChildByName('Card_Target_6')
        cardBack = self.pannelDeskCards:getChildByName(self.card)
        cardBack:setLocalZOrder(6)
    end

    if self.pokerValue > 0 then
        local x, y = cardPosition:getPosition();
        cardPosition:setVisible(false);
        self.pannelDeskCards:getChildByName('Card_Target_0'):setVisible(true);
        cardBack:setPosition(x, y);
    end
end

function CompareScene:onEndEnterTransition()
    print("CompareScene:onEndEnterTransition()--------------------------------------------------------------------------------");

    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_COMPARE_CARD_RESULT, self, self.onCompareCardResult)
    --    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAME_FRAME_RESULT, self, self.onGameFrameResult)
    --    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAME_END_RESULT, self, self.onGameEndResult)
end

function CompareScene:onStartExitTransition()
    print("CompareScene:onStartExitTransition()--------------------------------------------------------------------------------");
    -- self:onStopTimer()

    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_COMPARE_CARD_RESULT, self)
    --    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAME_FRAME_RESULT, self)
    --    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAME_END_RESULT, self)
end

--比倍大小返回结果
function CompareScene:onCompareCardResult(param)
    print("CompareScene:onCompareCardResult ---------------------------------------------------------------------")

    MusicUtil.compare()

    PokerCard.computeCompareCard(param); --计算发牌的相关值

    if param.result == 2 then
        self.stateText = 1
    elseif param.result == 1 then
        self.stateText = 2
    elseif DeskData.isGuessBig == 0 then
        self.stateText = 6
    end

    self:turnOverCards(DeskData.CompareCard, DeskData.isCompareSuccess);

    for i = 1, 5 do
        self.arrow_animation[i]:setVisible(false)
        self.display_animation[i]:setVisible(false)
        self.score_red_animation[i]:setVisible(false)
        self.score_ash_animation[i]:setVisible(true)
    end

    if DeskData.compareNum == 5 then
        local function callbackCardsTimer()
            SchedulerUtil.stop(cc.Director:getInstance():getScheduler(), self.cardsTimer)
            self:scoreAction()
        end

        self.cardsTimer = SchedulerUtil.start(cc.Director:getInstance():getScheduler(), callbackCardsTimer, 3, false);
    end
end

function CompareScene:onGameEndResult(param)
    print("CompareScene:onGameEndResult ---------------------------------------------------------------------")
end

function CompareScene:onGameFrameResult(param)
    print("CompareScene:onGameFrameResult ---------------------------------------------------------------------")
end