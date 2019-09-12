module( "gamesvr", package.seeall )

--------------- 解包 --------------------
-- function onGameStatus(buffObj)

-- end

-- function onSystemMessage(buffObj)
-- 	print("系统消息")
-- 	local mType = buffObj:readShort()
-- 	local len = buffObj:readShort()
-- 	local msg = buffObj:readString(len * 2)

-- 	WarnTips.showTips(
-- 		{
-- 			text = msg,
-- 			style = WarnTips.STYLE_Y
-- 		}
-- 	)
-- end

-- //玩家下注
-- struct CMD_C_Bet
-- {
-- 	LONG		lBetPoint;						//用户每一注的下注点数
-- 	LONG		lBetCount;						//用户下注注数
-- };
-- //玩家向服务端汇报中奖奖金额
-- struct CMD_C_BonusReport
-- {
-- 	LONG		lGemBonus;						//用户中奖奖金额(不包含超级大奖的奖金额)
-- 	bool		bSuperCreated;					//用户获得超级大奖
-- };

-- struct CMD_C_Exit
-- {
-- 	bool		bSave;							//是否保存当前状态
-- };
-- //游戏结束
-- struct CMD_S_GameEnd
-- {
-- 	LONG		lGameTax;						//游戏税收
-- 	LONG		lGameScore;						//游戏积分
-- 	LONG		lHonor;							//荣誉
-- 	bool		bDoubleHonor;					//荣誉翻倍卡使用情况
-- };


-- //新游戏开始(用户刚进桌子时仅发送一次,无宝石区域信息)和下局游戏开始(回应用户下注时发送,包含宝石区域信息)
	-- //共用
	-- LONG		lCurrentTotal;					//当前总【累积奖】
	-- LONG		lBetPoint;						//用户每一注的下注点数
	-- LONG		lBetCount;						//用户下注注数
	-- LONGLONG	lCardPoint;						//玩家卡片中的总点数
	-- LONG		lNowPoint;						//玩家当前本场点数
	-- int			cBrickLeft;						//当前关对应的墙壁或地板中剩余砖块数
	-- int			cStage;							//当前处于第几关

	-- //新游戏开始时用
	-- LONG		lMaxBetPoint;					//单注点数上限
	-- LONG		lMinBetPoint;					//单注点数下限
	-- LONG		lCellScore;						//底分:用【下注点数】*【底分】的结果修改玩家的【金币总额】

	-- LONG		lSuperBonusUnit;				//超级大奖每注奖金额

	-- //下局游戏开始时用
	-- //signed char	pGem[GEM_WIDE][GEM_HIGH];		//宝石分布
	-- WORD				pData[60];				//压缩过的宝石分布
	-- signed short int	nDataSize;				//上记数组的size

	-- //LONG		lAdmitBonus;					//允许获得的奖金最大值(不包含超级大奖的奖金额)
	-- //bool		bSuperOK;						//允许生成超级大奖(每注5000000点)
	-- //signed char cAskForDrill;					//要求宝石区域中包含钻头的个数

	-- //龙珠探宝部分
	-- LONG		pDragonBall[5];					//5个宝壶里的奖金额
	-- signed char	cTarget;						//龙珠探到了哪个宝壶

	-- //新游戏开始(用户刚进桌子时仅发送一次,无宝石区域信息)和下局游戏开始(回应用户下注时发送,包含宝石区域信息)
function onSubGameStart(buffObj)--游戏开始,初始化界面信息
	print('onSubGameStart游戏开始,初始化界面信息')
	local param = {}
	param.lCurrentTotal = buffObj:readInt()--//当前总【累积奖】
	param.lBetPoint = buffObj:readInt()--//用户每一注的下注点数
	param.lBetCount = buffObj:readInt()--//用户下注注数
	param.lCardPoint = buffObj:readInt64()--//玩家卡片中的总点数
	param.lNowPoint = buffObj:readInt()--//玩家当前本场点数
	param.cBrickLeft = buffObj:readInt()--//当前关对应的墙壁或地板中剩余砖块数
	param.cStage = buffObj:readInt() + 1 --//当前处于第几关

	-- //新游戏开始时用
	param.lMaxBetPoint = buffObj:readInt()--//单注点数上限
	param.lMinBetPoint = buffObj:readInt()--//单注点数下限
	param.lCellScore = buffObj:readInt()--//底分:用【下注点数】*【底分】的结果修改玩家的【金币总额】
	param.lSuperBonusUnit = buffObj:readInt() + 1 --//超级大奖每注奖金额

	param.pData = {}--//压缩过的宝石分布
	for i = 1, 60 do
		table.insert(param.pData, buffObj:readShort())
	end
	param.nDataSize = buffObj:readShort()--上记数组的size
	-- param.gameTable = LHDBLogic.unzip(param.pData, param.nDataSize, param.cStage)  -- 解压数据
	-- param.gameTable = decodeArray(param.pData, param.cStage)
	param.pData = nil
	param.nDataSize = nil
	-- //龙珠探宝部分
	param.pDragonBall = {}--//压缩过的宝石分布
	for i = 1, 5 do
		table.insert(param.pDragonBall, buffObj:readInt())
	end
	param.cTarget = buffObj:readChar()--上记数组的size

	-- dump(param)

	global.g_gameDispatcher:sendMessage(GAME_LHDB_GAME_START, param)
end

-- //新游戏开始(用户刚进桌子时仅发送一次,无宝石区域信息)和下局游戏开始(回应用户下注时发送,包含宝石区域信息)
function onSubNextGame(buffObj)--发送宝石布局
	print('onSubNextGame发送宝石布局')
	local param = {}
	param.lCurrentTotal = buffObj:readInt()--//当前总【累积奖】
	param.lBetPoint = buffObj:readInt()--//用户每一注的下注点数
	param.lBetCount = buffObj:readInt()--//用户下注注数
	param.lCardPoint = buffObj:readInt64()--//玩家卡片中的总点数
	param.lNowPoint = buffObj:readInt()--//玩家当前本场点数
	param.cBrickLeft = buffObj:readInt()--//当前关对应的墙壁或地板中剩余砖块数
	param.cStage = buffObj:readInt() + 1--//当前处于第几关

	-- //新游戏开始时用
	param.lMaxBetPoint = buffObj:readInt()--//单注点数上限
	param.lMinBetPoint = buffObj:readInt()--//单注点数下限
	param.lCellScore = buffObj:readInt()--//底分:用【下注点数】*【底分】的结果修改玩家的【金币总额】
	param.lSuperBonusUnit = buffObj:readInt()--//超级大奖每注奖金额

	param.pData = {}--//压缩过的宝石分布
	for i = 1, 60 do
		table.insert(param.pData, buffObj:readShort())
	end
	-- local array = decodeArray(param.pData, param.cStage)
	-- dump(array)
	param.nDataSize = buffObj:readShort()--上记数组的size
	-- param.gameTable = LHDBLogic.unzip(param.pData, param.nDataSize, param.cStage)  -- 解压数据
	param.gameTable = decodeArray(param.pData, param.cStage)
	param.pData = nil
	param.nDataSize = nil
	-- //龙珠探宝部分
	param.pDragonBall = {}--//压缩过的宝石分布
	for i = 1, 5 do
		table.insert(param.pDragonBall, buffObj:readInt())
	end
	param.cTarget = buffObj:readChar()--上记数组的size

	-- dump(param)

	global.g_gameDispatcher:sendMessage(GAME_LHDB_GAME_NEXT, param)
end

function onSubGameEnd(buffObj)--游戏结束,写分
	print('onSubGameEnd游戏结束,写分')
	local param = {}
	param.lGameTax = buffObj:readInt()--//游戏税收
	param.lGameScore = buffObj:readInt()--//游戏积分
	param.lHonor = buffObj:readInt()--//荣誉
	param.bDoubleHonor = buffObj:readChar()--//荣誉翻倍卡使用情况
	global.g_gameDispatcher:sendMessage(GAME_LHDB_GAME_END, param)
end

function onSubGameExit(buffObj)--退出
	print('onSubGameExit 退出')
	-- local bSave = buffObj:readChar() --是否保存当前状态   bool
	global.g_gameDispatcher:sendMessage(GAME_LHDB_GAME_EXIT, true)
end

function onGameScene(buffObj)
	-- print('操你妈逼')
end


--------------- 封包 --------------------
function sendUserReady( tableID, chairID )
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_FRAME)
	buff:setSubCmd(pt.SUB_GF_USER_READY)

	print('sendUserReady',tableID,chairID,pt.MDM_GF_FRAME,pt.SUB_GF_USER_READY)
	netmng.sendGsData(buff)
end

function sendLoginGame()
	local gameId = global.g_mainPlayer:getCurrentGameId()
	local cfg = games_config[gameId]

	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_FRAME)
	buff:setSubCmd(pt.SUB_GF_INFO)
	buff:writeChar(0)
	buff:writeInt(PlazaVersion)
	buff:writeInt(cfg.version)

	print('sendLoginGame',gameId)
	netmng.sendGsData(buff)
end


function sendExitGame( tableID, chairID )
	local buff = sendBuff:new()
	buff:setMainCmd(pt_game.MDM_GR_USER)
	buff:setSubCmd(pt.SUB_GR_USER_STANDUP)
	buff:writeShort(tableID)
	buff:writeShort(chairID)
	buff:writeChar(1)
	print('LHDB sendExitGame', tableID, chairID, pt_game.MDM_GR_USER, pt.SUB_GR_USER_STANDUP)
	netmng.sendGsData(buff)
end

-- 下注
-- line 线数
-- point 单线点数
function sendBet( line, point )
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_C_BET)
	buff:writeInt(point)
	buff:writeInt(line)
	netmng.sendGsData(buff)
end
