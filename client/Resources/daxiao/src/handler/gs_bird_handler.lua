module( "gamesvr", package.seeall )

--------------- 解包 --------------------
function onGameStatus(buffObj)

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
	print("onGameScene")
end

--[[
押注数组：2 兔子 3 燕子 4 鸽子 5 孔雀 6 老鹰 7 狮子 8 熊猫 9 猴子 10 银鲨
]]
function onJettonResult(buffObj)
	print("onJettonResult")
	local param = {}
	param.chairId = buffObj:readShort()
	param.jettonScore = buffObj:readInt64() --本押分ID增加的押分
	param.jettonArea = buffObj:readChar() 	--押分ID
	param.machine = buffObj:readChar()
	param.jettonTbj = {}
	param.jettonTbl = {}
	for i = 1, 3 do
		table.insert(param.jettonTbj, buffObj:readInt64()) --押注数组
	end
	for i = 1, 3 do
		table.insert(param.jettonTbl, buffObj:readInt64()) --押注数组
	end
	param.userId=buffObj:readInt()
	
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAMEPLACEJETTONRESULT, param)
end

function onFreeResult(buffObj)
	print("onFreeResult")
	local param = {}
	param.userScore = buffObj:readInt64()
	param.userMaxScore = buffObj:readInt64()
	param.areaLimitScore = buffObj:readInt64()
	param.timeLeave = buffObj:readChar()
	param.szGameRoomName = buffObj:readString(64)
	param.gameRecord = {}
	for i=1,100 do
		param.gameRecord[i] = buffObj:readInt()
	end   
	param.jushu = buffObj:readChar()
	param.lunshu = buffObj:readInt()
	print("空闲结果:")

	global.g_gameDispatcher:sendMessage(GAME_EVENT_STATUS_IDLE, param)
end

function onStartResult(buffObj)
	print("onStartResult")
	local param = {}
	param.userScore = buffObj:readInt64()
	param.remainTime = buffObj:readChar()
	param.nChipRobotCount = buffObj:readInt() --剩余时间
	param.jushu = buffObj:readChar()
	print("开始下注:")

	global.g_gameDispatcher:sendMessage(GAME_EVENT_STATUS_START, param)
end

function onEndResult(buffObj)
	print("onEndResult")
	local param = {}
	param.card1 = buffObj:readChar() --中奖ID, 左上角为0, 顺时针增加
	param.card2 = buffObj:readChar()
	param.remainTime = buffObj:readChar() --剩余时间
	param.lUserScore = buffObj:readInt64()
	param.jushu = buffObj:readChar()
	print("开奖结果:")

	global.g_gameDispatcher:sendMessage(GAME_EVENT_STATUS_END, param)
end

function onGameRecord(buffObj)
	print("游戏记录")
	local len = buffObj:getLength()/13
	local rs = {}
	for i = 1, len do
		local rec = {}
		for j = 1, 13 do
			table.insert(rec, buffObj:readChar())
		end
		table.insert(rs, rec)
	end
end

function onJettonCleanResult(buffObj)
	print("onJettonCleanResult")
	local param = {}
	param.jettons = {}
	for i = 1, 13 do
		--table.insert(param.jettons, buffObj:readInt64()) --全部为0
		table.insert(param.jettons, 0)
	end

	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_CLEARJETTONRESULT, param)
end

function onJettonContinueResult(buffObj)
	print("onJettonContinueResult")
	local param = {}
	param.allJettons = {}
	for i = 1, 13 do
		table.insert(param.allJettons, buffObj:readInt64()) 
	end

	param.ownJettons = {}
	for i = 1, 13 do
		table.insert(param.ownJettons, buffObj:readInt64()) --押注数组
	end

	param.charId = buffObj:readShort()
	param.machine = buffObj:readChar()

	local pd = global.g_mainPlayer:getRoomPlayer(global.g_mainPlayer.playerId_)
	if pd.chairId == param.charId then
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_CONTINUEJETTONRESULT, param)
	end
end

function onJettonFailure(buffObj)
	print("onJettonFailure")
	local param = {}
	param.lMaxScore = buffObj:readInt()

	WarnTips.showTips({
		text = "最大押注不能超过 " .. param.lMaxScore,
		style = WarnTips.STYLE_Y
	})
end

function onBaoJi(buffObj)
	print("onBaoJi")
	local baoji = buffObj:readChar()

	print("爆机:", baoji)
end

--------------- 封包 --------------------
function sendLoginGame()
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

function sendExitGame( tableID, chairID )
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GR_USER)
	buff:setSubCmd(pt.SUB_GR_USER_STANDUP)
	buff:writeShort(tableID)
	buff:writeShort(chairID)
	buff:writeChar(1)
	
	netmng.sendGsData(buff)
end

--[[
jettonArea 1 --兔子 2 --燕子 3 --鸽子 4 --孔雀 5 --老鹰 6 --狮子 7 --熊猫 8 --猴子 9 --鲨鱼 10 --通赔 11 --通杀 12 --金鲨
]]
function sendJetton(jettonArea, jettonScore)
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_GF_GAME_BIRD_JettoSend)
	buff:writeInt(jettonArea)
	buff:writeInt64(jettonScore)

	netmng.sendGsData(buff)
end

function sendJettonClean(chairId)
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_GF_GAME_BIRD_ClearMeJettoSend)
	buff:writeShort(chairId)

	netmng.sendGsData(buff)
end

function sendJettonContinue(chairId)
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_GF_GAME_BIRD_ContinueJettonSend)
	buff:writeShort(chairId)
	for i = 1, 26 do
		buff:writeInt64(0)
	end
	buff:writeChar(0)
	buff:writeInt64(0)
	buff:writeChar(0)

	netmng.sendGsData(buff)
end