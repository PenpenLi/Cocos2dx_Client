--
-- Author: lzg
-- Date: 2018-04-25 10:43:35
-- Function: 排行榜的相关操作

module("gatesvr", package.seeall)

--------------------解包-----------------
-- struct m_RichUserInfo
-- {
-- 	DWORD     dRandID;		//名次
-- 	SCORE     lScore;		//分数
-- 	DWORD	  dUserid;
-- 	TCHAR	  szNickName[LEN_NICKNAME];		//用户昵称
-- };
-- struct CMD_GP_UserRichList_Resualt
-- {
-- 	m_RichUserInfo m_info[10];
-- 	DWORD	  dType;		//0，金币   1兑换券  2 战绩(赢得场次)  3对局数目
-- };
--返回排行榜信息
function onGetRichlistResult(buffObj)
	local richList = {}
	for i = 1, 10 do
		richList[i] = {}
		richList[i].randId = buffObj:readInt()
		richList[i].score = buffObj:readInt64()
		richList[i].userId = buffObj:readInt()
		richList[i].nickName = buffObj:readString(64)
	end	
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GET_RICH_LIST_RESUALT, richList)
end


--------------------封包-----------------


--获取排行榜信息
function sendGetRichList(_type)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_GETRICHLIST)
	buff:writeInt(_type)
	netmng.sendGtData(buff)
end
