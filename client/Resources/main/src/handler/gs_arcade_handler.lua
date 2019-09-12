module("gamesvr", package.seeall)

--------------------解包-----------------
function onAppLoginSuccess(buffObj)
	LoadingView.closeTips()

	local userRight = buffObj:readInt()
	local masterRight = buffObj:readInt()
	local kindId = buffObj:readInt()
	local serverId = buffObj:readInt()
	local tableId = buffObj:readInt()
	local chairId = buffObj:readInt()
	local score = buffObj:readInt64()
	local serverName = buffObj:readString(buffObj:getLength() - 32)

	global.g_mainPlayer:setCurrentGameId(-1)

	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_APP_LOGIN_SUCCESS,
			{
				userRight = userRight,
				masterRight = masterRight,
				kindId = kindId,
				serverId = serverId,
				tableId = tableId,
				chairId = chairId,
				score = score,
				serverName = serverName,
			}
		)
end

function onAppLoginFailure(buffObj)
	LoadingView.closeTips()

	local errorCode = buffObj:readInt()
	local desc = buffObj:readString(buffObj:getLength() - 4)
	WarnTips.showTips(
			{
				text = desc,
				style = WarnTips.STYLE_Y
			}
		)
end

function onAppSendMsg(buffObj)
	local playerId = buffObj:readInt()
	local serverId = buffObj:readInt()
	local tableId = buffObj:readInt()
	local chairId = buffObj:readInt()

	local mSize = buffObj:readChar()
	local mCmd = buffObj:readChar()
	local mChairId = buffObj:readChar()
	local mTabelId = buffObj:readChar()
	local mPlayerId = buffObj:readInt()

	if playerId == global.g_mainPlayer:getPlayerId() then
		if mCmd == 20 or mCmd == 10 then
			--更新分数
			if mSize == 36 then
				local eChairId = buffObj:readShort()
				local eTableId = buffObj:readShort()
				local eCoinRate = buffObj:readInt()
				local eScoreRate = buffObj:readInt()
				local eCoinExchangeNum = buffObj:readInt64()
				local eScore = buffObj:readInt64()
				local eCoin = buffObj:readInt64()

				global.g_gameDispatcher:sendMessage(GAME_MESSAGE_APP_INFO_UPDATE,
						{
							tableId = eTableId,
							chairId = eChairId,
							coinRate = eCoinRate,
							scoreRate = eScoreRate,
							coinExchangeNum = eCoinExchangeNum,
							score = eScore,
							coin = eCoin,
						}
					)
			end
		elseif mCmd == 51 then
			--游戏未开启
		elseif mCmd == 52 then
			--服务器要求退出
			global.g_gameDispatcher:sendMessage(GAME_MESSAGE_APP_SERVER_KICKOUT)
		elseif mCmd == 30 then
			--充值请求结果
		end
	end
end

--------------- 封包 --------------------
function sendAppLogin(hallVer, gameVer, kindId, serverId, tableId, chairId)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_game.MDM_GR_APP)
	buff:setSubCmd(pt_game.SUB_GR_C_APP_LOGON)
	buff:writeInt(hallVer)
	buff:writeInt(gameVer)
	buff:writeInt(gameVer)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeString(global.g_mainPlayer:getDynamicPassword(), 66)
	buff:writeMD5("", 66)
	buff:writeMD5(MachineUUID, 66)
	buff:writeInt(kindId)
	buff:writeInt(serverId)
	buff:writeInt(tableId)
	buff:writeInt(chairId)

	netmng.sendGsData(buff)
end

function sendAppUserStandUp(serverId, tableId, chairId)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_game.MDM_GR_APP)
	buff:setSubCmd(pt_game.SUB_GR_C_APP_STANDUP)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeInt(serverId)
	buff:writeInt(tableId)
	buff:writeInt(chairId)

	netmng.sendGsData(buff)
end

function sendAppMsgToubi(serverId, tableId, chairId, inputCoin)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_game.MDM_GR_APP)
	buff:setSubCmd(pt_game.SUB_GR_C_APP_SENDMSG)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeInt(serverId)
	buff:writeInt(tableId)
	buff:writeInt(chairId)

	buff:writeChar(13)
	buff:writeChar(10)
	buff:writeChar(chairId)
	buff:writeChar(tableId)
	buff:writeInt(global.g_mainPlayer:getPlayerId())

	buff:writeChar(1)
	buff:writeShort(chairId)
	buff:writeShort(tableId)
	buff:writeInt64(inputCoin)

	buff:writeString("", 250)

	netmng.sendGsData(buff)
end