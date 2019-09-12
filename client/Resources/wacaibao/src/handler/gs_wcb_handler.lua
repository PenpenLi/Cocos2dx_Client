module( "gamesvr", package.seeall )

-- 参数获取
function onSubGameOption(buffObj)
    local param = {}
	param.dwBeilv1 = buffObj:readInt()-- 一币多少分 币值
	param.dwBeilv2 = buffObj:readInt()-- 一币多少分 分值
    param.curScore = buffObj:readInt() -- 当前分数
    param.modifyScore = buffObj:readInt() -- 变化的分数
    param.keyt = buffObj:readInt() -- 密钥
	param.three = buffObj:readInt()-- 三消得分 
	param.four = buffObj:readInt()--四消得分 
	param.five = buffObj:readInt()--五消得分
	param.flame = buffObj:readInt()-- 火焰
	param.lightning = buffObj:readInt() -- 闪电
	param.magicLamp = buffObj:readInt()-- 神灯
	param.iec = buffObj:readInt()-- 破冰
	param[11] = buffObj:readInt()-- 金矿石
	param[12] = buffObj:readInt()--金砖
    param[13] = buffObj:readInt()--宝箱
    param[14] = buffObj:readInt()--红宝石
    param.playtime = buffObj:readInt()--游戏时间
    param.difficultNum = buffObj:readInt()--游戏难度

    gamesvr.sendRequestDirection() -- 请求屏幕方向

    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAME_OPTION, param)

--    global.g_nowSceneObj = createObj(WCB_GameScene)
--	cc.Director:getInstance():replaceScene(global.g_nowSceneObj:getCCScene())
--    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAME_OPTION, param)

--    global.g_nowSceneObj = createObj(GameScene)
--    global.g_nowSceneObj.paraValueTab = param
--	cc.Director:getInstance():replaceScene(global.g_nowSceneObj:getCCScene())
end

function onSubGameDirectionBack(buffObj)
    print("onSubGameDirectionBack+++++++++++++++++++++++++++")
    
    _G["HORV"] = buffObj:readInt() 

    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAME_DIRECTIONBACK)
end 

-- 客户端请求开始游戏 服务端返回的消息	
function onSubGameStartBack(buffObj)
	local param = {}
    param.keyt = buffObj:readInt() -- 密钥
	param.isCanBegin = buffObj:readChar()-- 是否能开始  
	param.curScore = buffObj:readInt()-- 当前分数
    param.modifyScore = buffObj:readInt() -- 变化的分数
    
    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAME_STARTBACK, param)
end

-- 客户端发送消除得分 服务端返回的消息	
function onSubGameEatBack(buffObj)
	local param = {}
	param.curScore = buffObj:readInt()-- 当前分数
    param.modifyScore = buffObj:readInt() -- 变化的分数
    param.keyt = buffObj:readInt() -- 密钥
	
    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAME_EATBACK, param)
end


--------------- 封包 --------------------
function sendUserReady( )
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_FRAME)
	buff:setSubCmd(pt.SUB_GF_USER_READY)

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

-- 请求屏幕方向 横屏还是竖屏
function sendRequestDirection()
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME) 
	buff:setSubCmd(pt.SUB_GAME_REQUEST_DIRECTION)

	print('sendRequestDirection',pt.MDM_GF_GAME,pt.SUB_GAME_REQUEST_DIRECTION)
	netmng.sendGsData(buff)
end

-- 请求开始 每次时间为0的时候请求一次
function sendRequestStart( keyt )
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME) 
	buff:setSubCmd(pt.SUB_GAME_START)
    buff:writeInt(keyt)

	print('sendRequestStart',pt.MDM_GF_GAME,pt.SUB_GAME_START)
	netmng.sendGsData(buff)
end

-- 发送消除数据
function sendRemoveData( removeScore, keyt, effMd5)
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME) 
	buff:setSubCmd(pt.SUB_GAME_EAT)
    buff:writeInt(removeScore)
    buff:writeInt(keyt)
    buff:writeMD5(tostring(effMd5), 66)

	--print('sendRemoveData',removeScore, keyt, effMd5,pt.MDM_GF_GAME,pt.SUB_GAME_EAT)
    print("客户端发送消除命令", keyt, removeScore )
	netmng.sendGsData(buff)
end

function sendStandup()
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_GAME_STANDUP) 
	netmng.sendGsData(buff)

	print('sendStandup',pt.MDM_GF_GAME,pt.SUB_GAME_STANDUP)
end

