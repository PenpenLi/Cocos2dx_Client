module( "gamesvr", package.seeall )

--------------- 解包 --------------------

function onJettonList( buffObj )
	print("下注数据list")
	-- body
	local param = {}
	param.jettonList ={}
	for i=1,4 do
		param.jettonList[i] = buffObj:readInt() 
	end
	print(table.dump(param));
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAMEJETTONLIST, param)
end

function onRecord( buffObj )
	-- body
	local param = {}
	param.m_GameRecord ={}
	for i=1,100 do
		param.m_GameRecord[i] = buffObj:readChar() --记录 1 . 2 . 3 大小和  下标0是最新记录 0标示没有记录
	end

	-- print(table.dump(param));
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAMERECORD, param)
end
--游戏空闲
function  onGameFree(buffObj)
	print("游戏空闲")
	local param = {}
	param.m_UserScore = buffObj:readInt64() --用户分数
	param.lUserMaxScore = buffObj:readInt64() --玩家最大下注额
	param.lAreaLimitScore = buffObj:readInt64() --区域限制
	param.cbTimeLeave = buffObj:readChar() --剩余时间
	param.szGameRoomName = buffObj:readString(64) --房间名称
	param.m_GameRecord ={}
	for i=1,10 do
		param.m_GameRecord[i] = buffObj:readInt() --记录 1 . 2 . 3 大小和  下标0是最新记录
	end
	param.jushu = buffObj:readChar() --局数
	param.lunshu = buffObj:readInt() --轮数

	print(table.dump(param));
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAMEFREE, param)
end

--正在游戏
function onGamePlay( buffObj )
	print("正在游戏")
	-- body
	local param = {}
	param.lAreaInAllScore={} --区域下注总数
	for i=1,3 do
		param.lAreaInAllScore[i] = buffObj:readInt64();
	end
	param.lUserInAllScore={} --玩家下注总数
	for i=1,3 do
		param.lUserInAllScore[i] = buffObj:readInt64();
	end

	param.m_UserScore = buffObj:readInt64() --用户分数
	param.lAreaLimitScore = buffObj:readInt64() --区域限制
	param.lUserMaxScore = buffObj:readInt64() --玩家最大下注额
	param.lEndUserScore = buffObj:readInt64() --玩家成绩

	param.S1 = buffObj:readChar() --骰子一
	param.S2 = buffObj:readChar() --骰子二

	param.cbTimeLeave = buffObj:readChar() --剩余时间
	param.szGameRoomName = buffObj:readString(64) --房间名称
	param.cbGameStatus = buffObj:readChar() --游戏状态 空闲 -- 0  下注 -- 100  结束 -- 101
	param.m_GameRecord ={}
	for i=1,10 do
		param.m_GameRecord[i] = buffObj:readInt() --记录 1 . 2 . 3 大小和  下标0是最新记录
	end
	param.jushu = buffObj:readChar() --局数
	param.lunshu = buffObj:readInt() --轮数
	
	print(table.dump(param));
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAMEPLAY, param)
end

--开始游戏(可下注)
function onGameStart( buffObj)
	print("开始游戏")
	-- body
	local param = {}
	param.lUserMaxScore = buffObj:readInt64() --玩家最大下注额
	param.cbTimeLeave = buffObj:readChar() --剩余时间
	param.nChipRobotCount = buffObj:readInt() --人数上限 (下注机器人)
	param.jushu = buffObj:readChar() --局数
	print(table.dump(param));
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAMESTART, param)
end

--玩家下注结果
function onGetScore( buffObj )
	print("下注结果")
	local param = {}
	param.wChairID = buffObj:readShort() --下注玩家
	param.lJettonScore = buffObj:readInt64() --下注分数
	param.cbJettonArea = buffObj:readChar() --下注区域
	param.cbAndroid = buffObj:readChar() --机器人
	
	param.lUserInAllScore={} --玩家下注总数
	for i=1,3 do
		param.lUserInAllScore[i] = buffObj:readInt64();
	end
	param.lAreaInAllScore={} --区域下注总数
	for i=1,3 do
		param.lAreaInAllScore[i] = buffObj:readInt64();
	end
	print(table.dump(param));
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GETSCORE, param)
end

--下注失败
function onBibeiData( buffObj )
	print("下注失败")
	local param = {}
	param.wPlaceUser = buffObj:readShort() --下注玩家
	param.lJettonArea = buffObj:readChar() --下注区域
	param.lPlaceScore = buffObj:readInt64() --当前下注
	print(table.dump(param));
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BIBEIDATAM, param)
end

--游戏结束
function onGameEnd( buffObj )
	print("游戏结束")
	-- body
	local param = {}
	param.S1 = buffObj:readChar() --骰子一
	param.S2 = buffObj:readChar() --骰子二
	param.cbTimeLeave = buffObj:readChar() --剩余时间
	param.WinScore = buffObj:readInt64() --玩家成绩
	param.jushu = buffObj:readChar() --局数
	print(table.dump(param));
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BIBEISTART, param)
end

-- --比倍结果
-- function onBibeiStart( buffObj )
-- 	print("游戏比倍",buffObj:getLength());
-- 	local param = {}
-- 	param.S1 = buffObj:readInt() --骰子一
-- 	param.S2 = buffObj:readInt() --骰子二
-- 	param.WinScore = buffObj:readInt() --赢分
-- 	print(table.dump(param));
-- 	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BIBEISTART, param)
-- end


function onBaoji( buffObj )
	local baoji = buffObj:readInt()

	print("爆机:", baoji)
end

function onGameStatus( buffObj )
	local param = {}
	param.nGameStatus = buffObj:readChar() --游戏状态 GS_Free(0)休闲 GS_Playing(1)游戏中
	param.nAllowLookon = buffObj:readChar() --允许观看
end

function onGameScene( buffObj )
	-- body
end

function onSystemMessage( buffObj )
	print("系统消息")
	local mType = buffObj:readShort()
	local len = buffObj:readShort()
	local msg = buffObj:readString(len * 2)
--[[
	WarnTips.showTips(
		{
			text = msg,
			style = WarnTips.STYLE_Y
		}
	)
]]	
end

function onLookonStatus( buffObj )
	-- body
end




--------------- 封包 --------------------



function sendGameOption( )
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_FRAME)
	buff:setSubCmd(pt.SUB_GF_GAME_OPTION)
	buff:writeChar(0)
	buff:writeInt(PlazaVersion)
	buff:writeInt(PlazaVersion)

	netmng.sendGsData(buff)	
end

function sendUserReady( )
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_FRAME)
	buff:setSubCmd(pt.SUB_GF_USER_READY)

	netmng.sendGsData(buff)	
end

--下注 0,大,1,小,2,和
function sendAddScore(qu,score)
	print("下注区域:",qu,"下注分数",score);
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_C_JETTON)
	buff:writeInt(qu)
	buff:writeInt64(score)
	netmng.sendGsData(buff)	
end

function sendRecord()
	print("获取记录");
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_C_RECORD)
	netmng.sendGsData(buff)	
end

function sendContineJetton(  )
 	print("用户续押")
 	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_C_CONTINEJETTON)
	netmng.sendGsData(buff)	
 end 


-- --开始滚动
-- function sendTypeScroll()
-- 	local buff = sendBuff:new()
-- 	buff:setMainCmd(pt.MDM_GF_GAME)
-- 	buff:setSubCmd(pt.SUB_C_TYPESCROLL)

-- 	netmng.sendGsData(buff)	
-- end

-- --玛莉开始(点击开始)
-- function sendMaliStart()
-- 	local buff = sendBuff:new()
-- 	buff:setMainCmd(pt.MDM_GF_GAME)
-- 	buff:setSubCmd(pt.SUB_C_MALISTART)

-- 	netmng.sendGsData(buff)	
-- end

-- --得分 gettype 比倍得分1，其他得分0
-- function sendGetScore(gettype)
-- 	local buff = sendBuff:new()
-- 	buff:setMainCmd(pt.MDM_GF_GAME)
-- 	buff:setSubCmd(pt.SUB_C_GETSCORE)
-- 	buff:writeInt(gettype)

-- 	netmng.sendGsData(buff)		
-- end

-- --要求比倍
-- function sendRequestBibei()
-- 	local buff = sendBuff:new()
-- 	buff:setMainCmd(pt.MDM_GF_GAME)
-- 	buff:setSubCmd(pt.SUB_C_REQUESTBEIBEI)

-- 	netmng.sendGsData(buff)		
-- end

-- -- 比倍启动(买大小)
-- -- MaxOrOther 买大买小买和,0,大,1,小,2,和
-- -- BibeiType 比倍方式,0,比倍,1,半比倍,2,双比倍
-- function sendBibeiStart(MaxOrOther, BibeiType)
-- 	local buff = sendBuff:new()
-- 	buff:setMainCmd(pt.MDM_GF_GAME)
-- 	buff:setSubCmd(pt.SUB_C_BIBEISTART)
-- 	buff:writeInt(MaxOrOther)
-- 	buff:writeInt(BibeiType)

-- 	netmng.sendGsData(buff)	
-- end

--退出游戏，请求起立
--tableID目标桌子
--chairID目标椅子
function sendExitGame( tableID, chairID )
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GR_USER)
	buff:setSubCmd(pt.SUB_GR_USER_STANDUP)
	buff:writeShort(tableID)
	buff:writeShort(chairID)
	buff:writeChar(1)
	
	netmng.sendGsData(buff)
end