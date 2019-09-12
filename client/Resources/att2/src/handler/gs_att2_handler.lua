module("gamesvr", package.seeall)

--------------- 框架解包 --------------------
function onGameStatus(buffObj)
    print("【框架解包】接收游戏状态---------------------------------------------------------")
end

function onSystemMessage(buffObj)
    print("【框架解包】接收系统消息---------------------------------------------------------")
    local mType = buffObj:readShort()
    local len = buffObj:readShort()
    local msg = buffObj:readString(len * 2)

    WarnTips.showTips({
        text = msg,
        style = WarnTips.STYLE_Y
    })
end

--进入游戏机，获取服务器发送的结果
function onGameScene(buffObj)
    print("【框架解包】接收游戏场景---------------------------------------------------------")

    local param = {}
    param.exchangeScale = buffObj:readInt() --兑换比例
    param.isCompare = buffObj:readChar() --是否可以比倍
    param.smallChip = buffObj:readInt() --最小下注
    param.largeChip = buffObj:readInt() --最大下注
    param.lastWinType = buffObj:readInt() --最后赢的类型
    param.lastWinTable = buffObj:readInt() --最后赢的类型
    param.currentScore = buffObj:readInt64() --当前分数

    print("exchangeScale=", param.exchangeScale)
    print("isCompare=", param.isCompare)
    print("smallChip=", param.smallChip)
    print("largeChip=", param.largeChip)
    print("lastWinType=", param.lastWinType)
    print("lastWinTable=", param.lastWinTable)
    print("currentScore=", param.currentScore)

    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAME_SCENE_RESULT, param)

end

--------------- 游戏解包 --------------------

-- 第一次点【开始】按钮，接收牌结果
function onDealCardResult(buffObj)
    print("【游戏解包】onDealCardResult---------------------------------------------------------")

    local param = {}
    param.winType = buffObj:readShort() --赢的类型
    param.userType = buffObj:readShort() --用户类型
    param.peiLvType = buffObj:readInt() --赔率类型
    param.cbCard = {}
    for i = 1, 5 do
        param.cbCard[i] = buffObj:readChar();
    end
    param.bBarter = {}
    for i = 1, 5 do
        param.bBarter[i] = buffObj:readChar();
    end
    param.wID = buffObj:readShort();
    param.nHistoryJetton = buffObj:readInt();
    param.cbHistoryCard = {};
    for i = 1, 6 do
        param.cbHistoryCard[i] = buffObj:readChar();
    end
    param.score5K = buffObj:readInt();
    param.scoreRS = buffObj:readInt();
    param.scoreSF = buffObj:readInt();
    param.score4K = buffObj:readInt();
    param.chip = buffObj:readInt64();
    param.die = buffObj:readInt();
    param.state = buffObj:readInt();
    param.currentScore = buffObj:readInt64() --当前分数

    print("param.winType=", param.winType)
    print("param.userType=", param.userType)
    print("param.peiLvType=", param.peiLvType)
    for i = 1, 5 do
        print("param.cbCard[i]=", param.cbCard[i]);
        print("param.bBarter[i]=", param.bBarter[i]);
    end
    print("param.wID=", param.wID)
    print("param.nHistoryJetton=", param.nHistoryJetton)
    for i = 1, 6 do
        print("param.cbHistoryCard[i]=", param.cbHistoryCard[i]);
    end
    print("param.score5K=", param.score5K)
    print("param.scoreRS=", param.scoreRS)
    print("param.scoreSF=", param.scoreSF)
    print("param.score4K=", param.score4K)
    print("param.chip=", param.chip)
    print("param.die=", param.die)
    print("param.state=", param.state)
    print("param.currentScore=", param.currentScore)

    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_DEAL_CARD_RESULT, param)
end

function onUpdateScoreResult(buffObj)
    print("【游戏解包】onUpdateScoreResult---------------------------------------------------------")

    local param = {}
    param.result = buffObj:readChar();

    print("param.result", param.result);

    --没有用处，所以，不作处理
    --global.g_gameDispatcher:sendMessage(GAME_MESSAGE_UPDATE_SCORE_RESULT, param)
end

--第二次点击【开始】按钮，返回结果，接收:SUB_C_RESULT  1007, 结构CMD_C_WinLose
function onSwitchCardResult(buffObj)
    print("【游戏解包】onSwitchCardResult---------------------------------------------------------")

    local param = {}
    param.chip = buffObj:readInt64() --筹码
    param.cardType = buffObj:readChar() --牌的类型
    param.die = buffObj:readInt() --赔率类型
    param.cbCard = {}
    for i = 1, 5 do
        param.cbCard[i] = buffObj:readChar();
    end
    param.bBarter = {}
    for i = 1, 5 do
        param.bBarter[i] = buffObj:readChar();
    end
    param.nState = buffObj:readInt()
    param.wID = buffObj:readShort();
    param.nHistoryJetton = buffObj:readInt(); --历史筹码
    param.cbHistoryCard = {};
    for i = 1, 6 do
        param.cbHistoryCard[i] = buffObj:readChar();
    end
    param.score5K = buffObj:readInt();
    param.scoreRS = buffObj:readInt();
    param.scoreSF = buffObj:readInt();
    param.score4K = buffObj:readInt();
    param.currentScore = buffObj:readInt64() --当前分数

    print("param.chip=", param.chip)
    print("param.cardType=", param.cardType)
    print("param.die=", param.die)
    for i = 1, 5 do
        print("param.cbCard[i]=", param.cbCard[i]);
        print("param.bBarter[i]=", param.bBarter[i]);
    end
    print("param.nState=", param.nState)
    print("param.wID=", param.wID)
    print("param.nHistoryJetton=", param.nHistoryJetton)
    for i = 1, 6 do
        print("param.cbHistoryCard[i]=", param.cbHistoryCard[i]);
    end
    print("param.score5K=", param.score5K)
    print("param.scoreRS=", param.scoreRS)
    print("param.scoreSF=", param.scoreSF)
    print("param.score4K=", param.score4K)
    print("param.currentScore=", param.currentScore)

    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SWITCH_CARD_RESULT, param)
end

--接收比倍大小结果
function onCompareCardResult(buffObj)
    print("【游戏解包】onCompareCardResult---------------------------------------------------------")

    local param = {}
    param.carddata = buffObj:readChar(); --carddata;
    param.result = buffObj:readInt(); --result;
    param.StartBBIDCopy = buffObj:readChar(); --StartBBIDCopy;
    param.cbHisCard = {};
    for i = 1, 6 do
        param.cbHisCard[i] = buffObj:readChar(); --历史点
    end

    print("param.carddata=", param.carddata, PokerCard.buildCardFromDecimal(param.carddata))
    print("param.result=", param.result)
    print("param.StartBBIDCopy=", param.StartBBIDCopy)
    for i = 1, 6 do
        print("param.cbHisCard[i]=", param.cbHisCard[i]);
    end

    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_COMPARE_CARD_RESULT, param)
end

function onGameEndResult(buffObj)
    print("【游戏解包】onGameEndResult---------------------------------------------------------")
    local param = {}

    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAME_END_RESULT, param)
end

function onGameFrameResult(buffObj)
    print("【游戏解包】onGameFrameResult---------------------------------------------------------")
    local param = {}

    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAME_FRAME_RESULT, param)
end

--------------- 框架封包 --------------------
function sendLoginGame()
    print("【框架封包】sendLoginGame---------------------------------------------------------")
    local gameId = global.g_mainPlayer:getCurrentGameId()
    local cfg = games_config[gameId]

    local buff = sendBuff:new()
    buff:setMainCmd(pt.MDM_GF_FRAME)
    buff:setSubCmd(pt.SUB_GF_INFO)
    buff:writeChar(0)
    buff:writeInt(PlazaVersion)
    buff:writeInt(cfg.version)

    netmng.sendGsData(buff)
end


function sendExitGame(tableID, chairID)
    print("【框架封包】sendExitGame---------------------------------------------------------")
    local buff = sendBuff:new()
    buff:setMainCmd(pt.MDM_GR_USER)
    buff:setSubCmd(pt.SUB_GR_USER_STANDUP)
    buff:writeShort(tableID)
    buff:writeShort(chairID)
    buff:writeChar(1)

    netmng.sendGsData(buff)
end

function sendUserReady( tableID, chairID )
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_FRAME)
	buff:setSubCmd(pt.SUB_GF_USER_READY)

	print('sendUserReady',tableID,chairID,pt.MDM_GF_FRAME,pt.SUB_GF_USER_READY)
	netmng.sendGsData(buff)
end


--att send
--客户端发送开始发牌消息
function sendStartDeal(bet)
    print("【框架封包】sendStartDeal---------------------------------------------------------")
    local buff = sendBuff:new()
    buff:setMainCmd(pt.MDM_GF_GAME)
    buff:setSubCmd(pt.SUB_GF_GAME_ATT2_DealCardSend)
    --buff:writeInt64(bet * DeskData.exchangeScale);
    buff:writeInt64(bet);
    print("【框架封包】sendStartDeal,bet=", bet, "exchangeScale=", DeskData.exchangeScale);
    if bet<100 then
        print("【框架封包】sendStartDeal,错误！！！bet=", bet, "exchangeScale=", DeskData.exchangeScale);
    else
        netmng.sendGsData(buff)
    end
end

--发送换牌数组，第二次点【开始】按钮，SUB_C_WINLOSE_JX	  1009    CMD_S_CARD
function sendSwitchCard(deskCards, holdCards)
    print("【封包】sendWinlose-----第二次点【开始】按钮,发送换牌数组----")
    local buff = sendBuff:new()
    buff:setMainCmd(pt.MDM_GF_GAME)
    buff:setSubCmd(pt.SUB_GF_GAME_ATT2_SwitchCardSend)
    for i = 1, 5 do
        buff:writeChar(PokerCard.getDecimalFromCard(deskCards[i]))
    end
    for i = 1, 5 do
        if holdCards[i] == true then
            buff:writeChar('0')
        else
            buff:writeChar('1')
        end
    end
    netmng.sendGsData(buff)
end

function sendComporeCard(isBig)
    print("【框架封包】sendComporeCard---比倍压大或者小，SUB_C_WINLOSEPZ_JX  1003, CMD_C_BigSmall")
    local buff = sendBuff:new()
    buff:setMainCmd(pt.MDM_GF_GAME)
    buff:setSubCmd(pt.SUB_GF_GAME_ATT2_ComporeCardSend)
    -- if isBig == true then --1是小、2是大
    --     buff:writeInt(2)
    -- else
    --     buff:writeInt(1)
    -- end
    buff:writeInt(isBig)
    netmng.sendGsData(buff)
end
