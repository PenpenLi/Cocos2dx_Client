--
-- Author: lzg
-- Date: 2018-04-16 13:15:56
-- Function: 客服相关命令操作

module("gatesvr", package.seeall)

--------------------解包-----------------
--返回未读条数
function onChatInfoResult(buffObj)
	local unReadCount = buffObj:readInt()
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_CUSTOMER_HEDDOT_UPDATE, unReadCount > 0)

	if unReadCount > 0 then
		gatesvr.sendGetChatInfo()
	end
end

--返回未读信息的内容
-- struct tagChatInfo
-- {
-- 	DWORD		dwUserID;
-- 	TCHAR		szNickName[32];
-- 	DWORD		dwSprID;
-- 	TCHAR		szSpreaderName[32];
-- 	DWORD		dwChatID;
-- 	TCHAR		szChat[100];		//聊天内容，最长100
-- 	DWORD		dwType;				//0玩家发送  1推广员发送
-- 	SYSTEMTIME	mTime;
-- };
function onGetChatInfoResult(buffObj)
	local len = buffObj:getLength()
	for i = 1, len / 1160 do
		local t = {}
		t.userId = buffObj:readInt()
		t.nickName = buffObj:readString(64)
		t.sprID = buffObj:readInt()
		t.spreaderName = buffObj:readString(64)
		t.chatID = buffObj:readInt()
		t.chat = buffObj:readString(1000)
		t.type = buffObj:readInt()
		local time = {}
		time.year = buffObj:readShort()
		time.month = buffObj:readShort()
		time.dayOfWeek = buffObj:readShort()
		time.day = buffObj:readShort()
		time.hour = buffObj:readShort()
		time.minute = buffObj:readShort()
		time.second = buffObj:readShort()
		time.milliseconds = buffObj:readShort()
		t.time = time
		global.g_mainPlayer:setChatInfo(t)
		-- local chatInfo = global.g_mainPlayer:getChatInfo()
		-- global.g_gameDispatcher:sendMessage(GAME_MESSAGE_UPDATE_CHAT, #chatInfo, t, true)
	end
	local chatInfo = global.g_mainPlayer:getChatInfo()
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_UPDATE_CHAT, #chatInfo, t, true)
	-- global.g_gameDispatcher:sendMessage(GAME_MESSAGE_CUSTOMER_HEDDOT_UPDATE, false)
end

--返回
function onGetChatInfoEnd(buffObj)
	-- global.g_gameDispatcher:sendMessage(GAME_MESSAGE_CUSTOMER_HEDDOT_UPDATE, false)
end


--------------------封包-----------------

--获取聊天信息
function sendChatInfo()
	local playerId = global.g_mainPlayer:getPlayerId()
	local maxChatID = global.g_mainPlayer:getMaxChatID()
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_CHATINFO)
	buff:writeInt(playerId)
	buff:writeInt(maxChatID)
	netmng.sendGtData(buff)
end

--获取未读信息
function sendGetChatInfo()
	local playerId = global.g_mainPlayer:getPlayerId()
	local maxChatID = global.g_mainPlayer:getMaxChatID()
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_GETCHATINFO)
	buff:writeInt(playerId)
	buff:writeInt(0)
	netmng.sendGtData(buff)
end

--发送聊天内容
function sendChatSend(char)
	local playerId = global.g_mainPlayer:getPlayerId()
	local maxChatID = global.g_mainPlayer:getMaxChatID()
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_CHATSEND)
	buff:writeInt(playerId)
	buff:writeInt(maxChatID)
	buff:writeString(char, 1000)
	netmng.sendGtData(buff)
end
