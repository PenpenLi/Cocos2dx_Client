module( "gamesvr", package.seeall )

--------------- 解包 --------------------
function onGameStatus(buffObj)
	local status = buffObj:readShort()
	global.g_gameData:setGameStatus(status)

	print("收到游戏状态:", status)
end

function onSystemMessage(buffObj)
	print("系统消息")
	local mType = buffObj:readShort()
	local len = buffObj:readShort()
	local msg = buffObj:readString(len * 2)

	WarnTips.showTips(
		{
			text = msg,
			style = WarnTips.STYLE_Y
		}
	)
end

function onGameScene(buffObj)
	local status = global.g_gameData:getGameStatus()
	if status == HUNDREDBEEF_GAMESTATE_FREE or status == HUNDREDBEEF_GAMESTATE_WAIT  then
		print("接收到onGameScene空闲状态数据长度:", buffObj:getLength())
		local remainTime = buffObj:readChar()				--剩余时间
		local userScore = buffObj:readInt64()				--玩家分数
		local bankerUser = buffObj:readShort()				--当前庄家
		local bankerTime = buffObj:readShort()				--庄家局数
		local bankerWinScore = buffObj:readInt64()			--庄家成绩
		local bankerScore = buffObj:readInt64()				--庄家分数
		local endGameMul = buffObj:readInt()				--提前开牌百分比
		local enableSysBanker = buffObj:readChar()			--系统做庄
		local applyBankerCondition = buffObj:readInt64()	--申请条件
		local areaLimitScore = buffObj:readInt64()			--区域限制
		local roomName = buffObj:readString(64)				--房间名称
		print("收到游戏场景:", status, remainTime, userScore, bankerUser, bankerTime, bankerWinScore, bankerScore,
			endGameMul, enableSysBanker, applyBankerCondition, areaLimitScore, roomName)

		--空闲状态
		global.g_gameDispatcher:sendMessage(GAME_EVENT_GAMESCENE_FREE,endGameMul,remainTime,userScore,bankerUser,bankerTime,bankerWinScore,bankerScore,enableSysBanker,applyBankerCondition,areaLimitScore)
	else
		print("接收到onGameScene游戏状态数据长度:", buffObj:getLength())
		local allJettons = {}
		for i = 1, 5 do
			table.insert(allJettons, buffObj:readInt64())
		end

		local userJettons = {}
		for i = 1, 5 do
			table.insert(userJettons, buffObj:readInt64())
		end

		local score = buffObj:readInt64()
		local applyBankerCondition = buffObj:readInt64()
		local areaLimitScore = buffObj:readInt64()
		local cards = {}
		for i = 1, 25 do
			table.insert(cards, buffObj:readChar())
		end
		local banker = buffObj:readShort()
		local bankerTime = buffObj:readShort()
		local bankerWinScore = buffObj:readInt64()
		local bankerScore = buffObj:readInt64()
		local endGameMul = buffObj:readInt()
		local enableSysBanker = buffObj:readChar()
		local endBankerScore = buffObj:readInt64()
		local endUserScore = buffObj:readInt64()
		local endUserReturnScore = buffObj:readInt64()
		local revenue = buffObj:readInt64()
		local remainTime = buffObj:readChar()
		local gamestatus = buffObj:readChar()
		local roomName = buffObj:readString(64)

		print("进入收到游戏场景:", status, score, applyBankerCondition, areaLimitScore, banker, bankerTime,
			bankerWinScore, bankerScore, endGameMul, enableSysBanker, endBankerScore, endUserScore, endUserReturnScore,
			revenue, remainTime,roomName)
		--游戏状态
		global.g_gameDispatcher:sendMessage(GAME_EVENT_GAMESCENE_PLAY,endGameMul,banker, bankerTime,bankerWinScore,bankerScore,enableSysBanker,endBankerScore,endUserScore,endUserReturnScore,allJettons,userJettons,cards,status,score,applyBankerCondition,areaLimitScore,remainTime,gamestatus)
		-- global.g_gameDispatcher:sendMessage(GAME_EVENT_STATUS_START,bankerMsg,remainTime)
	end
	-- global.g_gameScene_:loadTimer(msg_)
end

function onGameFree(buffObj)
	global.g_gameData:setGameStatus(HUNDREDBEEF_GAMESTATE_FREE)

	print("接收到onGameFree数据长度:", buffObj:getLength())
	local remainTime = buffObj:readChar() 	--剩余时间
	local userCount = buffObj:readInt64() 	--列表人数
	local storageStart = buffObj:readInt64() --库存
	print("收到游戏空闲:", remainTime, userCount, storageStart)
	global.g_gameDispatcher:sendMessage(GAME_EVENT_STATUS_IDLE,remainTime)
end

function onGameStart(buffObj)
	global.g_gameData:setGameStatus(HUNDREDBEEF_GAMESTATE_BET)

	print("接收到onGameStart数据长度:", buffObj:getLength())

	local banker = buffObj:readShort()
	local bankerScore = buffObj:readInt64()
	local score = buffObj:readInt64()
	local remainTime = buffObj:readChar()
	local continueCard = buffObj:readChar()
	local clipRobotCount = buffObj:readInt()
	local robotApplyCount = buffObj:readInt()

	print("收到游戏开始:", banker, bankerScore, score, remainTime, continueCard, clipRobotCount, robotApplyCount)
	global.g_gameDispatcher:sendMessage(GAME_EVENT_STATUS_START,remainTime,score,bankerScore)
end

function onGameEnd(buffObj)
	global.g_gameData:setGameStatus(HUNDREDBEEF_GAMESTATE_LICENSING)

	local remainTime = buffObj:readChar()
	local cards = {}
	for i = 1, 25 do
		table.insert(cards, buffObj:readChar())
		-- print("onGameEnd",i,"=",cards[i],"......")
	end
	local cardCount = buffObj:readChar()
	local bFirstCard = buffObj:readChar()
	local bankerScore = buffObj:readInt64()
	local bankerTotalScore = buffObj:readInt64()
	local bankerTime = buffObj:readInt()
	local myScore = buffObj:readInt64()
	local returnScore = buffObj:readInt64()
	local revenue = buffObj:readInt64()
	print("收到游戏结束:", remainTime, cardCount, bFirstCard, bankerScore, bankerTotalScore, bankerTime, myScore, returnScore, revenue)

	global.g_gameDispatcher:sendMessage(GAME_EVENT_STATUS_END,cards,remainTime,bFirstCard,myScore,returnScore,bankerScore, bankerTotalScore, bankerTime)
end


function onPlaceJetton(buffObj)
	local chairId = buffObj:readShort()
	local jettonArea = buffObj:readChar()
	local jettonScore = buffObj:readInt64()
	local isRobot = buffObj:readChar()
	local robot = buffObj:readChar()
	print("收到玩家下注", chairId, jettonArea, jettonScore, isRobot, robot)
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAMEPLACEJETTONRESULT,chairId, jettonArea, jettonScore)
end

function onPlaceJettonFail(buffObj)
	local placeUser = buffObj:readShort()    --下注玩家
	local jettonArea = buffObj:readChar()    --下注区域
	local placeScore = buffObj:readInt64()	 --当前下注

	print("收到下注失败:", placeUser, jettonArea, placeScore)
end

function onUpdateUserScore(buffObj)
	local chairId = buffObj:readShort()
	local score = buffObj:readInt64()
	local bankerChairId = buffObj:readShort()
	local bankerTime = buffObj:readChar()
	local bankerScore = buffObj:readInt64()

	print("收到更新积分:", chairId, score, bankerChairId, bankerTime, bankerScore)
end

function onApplyBanker(buffObj)
	local applyUser = buffObj:readShort()

	print("收到申请上庄:", applyUser)
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAMEAPPLYBANKER,applyUser)
end

function onChangeBanker(buffObj)
	local bankerUser  = buffObj:readShort()
	local bankerScore = buffObj:readInt64()

	print("收到切换庄家:", bankerUser, bankerScore)
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAMEChANGEBANKER,bankerUser,bankerScore)
end

function onApplyCancel(buffObj)
	local cancelUser = buffObj:readShort()

	print("收到取消申请:", cancelUser)
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAMEQUITBANKER,cancelUser)
end

function onUserInfo(buffObj)
	local gameId 	  = buffObj:readInt()
	local userId 	  = buffObj:readInt()
	local gender 	  = buffObj:readChar()
	local memberOrder = buffObj:readChar()
	local tableId 	  = buffObj:readShort()
	local chairId 	  = buffObj:readShort()
	local userStatus  = buffObj:readChar()
	local score 	  = buffObj:readInt64()
	local ingot 	  = buffObj:readInt()
	local nickname 	  = buffObj:readString(buffObj:getLength() - 27)

	print("收到玩家更新:", gameId, userId, gender, memberOrder, tableId, chairId, userStatus, score, ingot, nickname)
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_UPDATEUSERNAMELIST,userId,chairId,score,nickname)
end

--不投币的
function onUserEnter(buffObj)
	local gameId = buffObj:readInt()
	local userId = buffObj:readInt()
	local gender = buffObj:readChar()
	local memberOrder = buffObj:readChar()
	local tableId = buffObj:readShort()
	local chairId = buffObj:readShort()
	local userStatus = buffObj:readChar()
	local score = buffObj:readInt64()
	local ingot = buffObj:readInt()
	local nickname = buffObj:readString(buffObj:getLength() - 27)
	
	print("收到玩家进入:", gameId, userId, gender, memberOrder, tableId, chairId, userStatus, score, ingot, nickname)
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAMEUSERENTER,userId,chairId,score,nickname)
end

function onUserExit(buffObj)
	local gameId = buffObj:readInt()
	local userId = buffObj:readInt()
	local gender = buffObj:readChar()
	local memberOrder = buffObj:readChar()
	local tableId = buffObj:readShort()
	local chairId = buffObj:readShort()
	local userStatus = buffObj:readChar()
	local score = buffObj:readInt64()
	local ingot = buffObj:readInt()
	local nickname = buffObj:readString(buffObj:getLength() - 27)
	
	print("收到玩家退出:", gameId, userId, gender, memberOrder, tableId, chairId, userStatus, score, ingot, nickname)
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAMEUSERQUIT,userId,chairId,score,nickname)
end

--投币的
-- function onUserEnter(buffObj)
-- 	local userId   = buffObj:readInt()
-- 	local chairId  = buffObj:readShort()
-- 	local score    = buffObj:readInt64()
-- 	local nickname = buffObj:readString(buffObj:getLength() - 27)
-- 	print("收到玩家进入:", userId, chairId, score, nickname)
-- 	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAMEUSERENTER,userId,chairId,score,nickname)
-- end
-- function onUserExit(buffObj)
-- 	local userId   = buffObj:readInt()
-- 	local chairId  = buffObj:readShort()
-- 	local score    = buffObj:readInt64()
-- 	local nickname = buffObj:readString(buffObj:getLength() - 27)
	
-- 	print("收到玩家退出:", userId, chairId, score, nickname)
-- 	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAMEUSERQUIT,userId,chairId,score,nickname)
-- end

--------------- 封包 --------------------
function sendLoginGame()
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_FRAME)
	buff:setSubCmd(pt.SUB_GF_INFO)
	buff:writeChar(0)
	buff:writeInt(PlazaVersion)
	buff:writeInt(PlazaVersion)

	netmng.sendGsData(buff)
end

function sendExitGame( tableId, chairId )
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GR_USER)
	buff:setSubCmd(pt.SUB_GR_USER_STANDUP)
	buff:writeShort(tableId)
	buff:writeShort(chairId)
	buff:writeChar(1)
	
	netmng.sendGsData(buff)
end

--投币的时候用
function sendUpScore(upscore)
	--用户上分
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_GF_C_GAME_HUNDRED_BEEF_UpScore)
	buff:writeInt64(upscore)

	netmng.sendGsData(buff)
end

function sendPlaceJetton(jettonArea, jettonScore)
	--用户下注
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_GF_C_GAME_HUNDRED_BEEF_PlaceJetton)
	buff:writeChar(jettonArea)
	buff:writeInt64(jettonScore)

	netmng.sendGsData(buff)
end

function sendApplyBanker()
	--申请上庄
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_GF_C_GAME_HUNDRED_BEEF_ApplyBanker)

	netmng.sendGsData(buff)
end

function sendChangeBanker()
	--申请下庄
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_GF_C_GAME_HUNDRED_BEEF_ChangeBanker)

	netmng.sendGsData(buff)
end
