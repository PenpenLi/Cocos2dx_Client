module( "gamesvr", package.seeall )

--------------- 解包 --------------------
--
function OnSubFishBOSSUpate( buffObj )  --boss
  local param = {}
  param.num = buffObj:readInt(); --倍数
  param.x = buffObj:readInt(); --移动位置
  param.Dir = buffObj:readInt(); --方向
  global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_FEILONGPOS, param)
end
--
function OnSubCJNumUpate( buffObj ) --cj
  local param = {}
  param.num = buffObj:readInt(); --倍数
  global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_CJ_NUM_UPDATE, param)
end
--
function OnSubCJmessageUpate( buffObj ) --cj
  local param = {}
  param.num = buffObj:readInt(); --倍数
  param.x = buffObj:readInt(); --移动位置
  param.Dir = buffObj:readInt(); --方向
  global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_CJ_MSG, param)
end
--


function onGameConfig( buffObj )
	cclog("FishHandler:onGameConfig")
	local param = {}
    param.exchange_count= buffObj:readInt();
  	param.fish_score_rate_num = buffObj:readInt(); --鱼币比率
  	param.coin_score_rate_num = buffObj:readInt(); --金币比率
	param.min_bullet_multiple = buffObj:readInt(); --最小倍数
	param.max_bullet_multiple = buffObj:readInt(); --最大倍数
	param.nfirst_bullet_multiple = buffObj:readInt(); --起始子弹倍数
	param.fish_multiple = {} --倍率表
	for i=0,FISH_KIND_COUNT-1 do
		param.fish_multiple[i] = buffObj:readInt()
	end
	param.fish_speed = {} --速度
	for i=0,FISH_KIND_COUNT-1 do
		param.fish_speed[i] = buffObj:readInt()
	end
	param.fish_bounding_box_width = {} --碰撞盒W
	for i=0,FISH_KIND_COUNT-1 do
		param.fish_bounding_box_width[i] = buffObj:readInt()
	end
	param.fish_bounding_box_height = {} --碰撞盒H
	for i=0,FISH_KIND_COUNT-1 do
		param.fish_bounding_box_height[i] = buffObj:readInt()
	end
	param.fish_hit_radius = {} --碰撞半径,好像没用到
	for i=0,FISH_KIND_COUNT-1 do
		param.fish_hit_radius[i] = buffObj:readInt()
	end
	param.bullet_speed = {} --子弹速度 单帧行走的距离，按一帧1/30标准
	for i=0,BULLET_KIND_COUNT-1 do
		param.bullet_speed[i] = buffObj:readInt()
	end
	param.net_radius = {} --渔网半径
	for i=0,BULLET_KIND_COUNT-1 do
		param.net_radius[i] = buffObj:readInt()
	end
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_GAME_CONFIG, param)
	gamesvr.sendExchangeFishScore(1, 0)
end

function onFishTrace( buffObj )
	local fish_trace_count = buffObj:getLength()/56 --数目
	local param = {}
	for i=1,fish_trace_count do
		local fishtrace = {}
		fishtrace.init_pos = {} --轨迹点, 需要使用convertToGL转换为GL坐标系, 并根据当前屏幕与1136*640标准比例相乘
		for i=0,4 do
			fishtrace.init_pos[i]= cc.p(buffObj:readFloat(), buffObj:readFloat())
		end
		fishtrace.init_count = buffObj:readInt() --init_pos可用数目
		fishtrace.fish_kind = buffObj:readInt()  --
		fishtrace.fish_id = buffObj:readInt()    --
		fishtrace.trace_type = buffObj:readInt() -- 0线性 1贝塞尔曲线
		param[i] = fishtrace		
	end
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_FISH_TRACE, param)
end

function onExchangeFishScore( buffObj )
	cclog("FishHandler:onExchangeFishScore")
	local param = {}
	param.chair_id = buffObj:readShort()
	param.increase = buffObj:readChar() --1上分 0下分
	param.bAutoChangeScore = buffObj:readChar()
	param.sw_fish_score = buffObj:readInt64() --上下分数值
	param.l_coin_score = buffObj:readInt64() --剩余金币

	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_EXCHANGE_FISHSCORE, param)
end

function onUserFire( buffObj )
	cclog("FishHandler:onUserFire")
	local param = {}
	param.bullet_kind = buffObj:readInt() --子弹类型
	param.bullet_id = buffObj:readInt() --子弹ID
	param.bullet_specKindFlag = buffObj:readInt() --没用到 
	param.chair_id = buffObj:readShort() --位置ID
	param.android_chairid = buffObj:readShort()
	param.angle = buffObj:readFloat() --角度
	param.bullet_mulriple = buffObj:readInt() --正数,子弹倍率
	param.lock_fishid = buffObj:readInt() -- 0未锁定鱼,大于0锁定鱼id
	param.fish_score = buffObj:readInt64() -- 负数,子弹扣除的游戏币
    param.from_server_flag=1;
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_USER_FIRE, param)
end

function onCatchFish( buffObj )
	cclog("FishHandler:onCatchFish")
	local param = {}
	param.chair_id = buffObj:readShort() --位置ID
	param.fish_id = buffObj:readInt()        --鱼ID
	param.fish_kind = buffObj:readInt()    --鱼类型
    param.bullet_kind = buffObj:readInt()  --子弹类型
	param.bullet_ion = buffObj:readInt()    --标记
    param.bullet_mul= buffObj:readInt()     --子弹倍数
    param.fish_mul= buffObj:readInt()        --鱼倍数
	param.fish_score = buffObj:readInt64() --抓到的鱼的分数
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_CATCH_FISH, param)
end

function OnBulletIonTimeout( buffObj )
	cclog("FishHandler:OnBulletIonTimeout")
	local chair_id = buffObj:readShort()

	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_BULLET_ION_TIMEOUT, chair_id)
end

function OnSubUpdateJiejiPlayer( buffObj )
    local param = {};
    param.jieji_player_flag= {[0]=0};
	for i=0,7,1 do
		param.jieji_player_flag[i] =buffObj:readInt();
	end
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SUB_S_JIEJI_PLAYER_SEND, param);
end


function onLockTimeout( buffObj )
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_LOCK_TIMEOUT)
end
--[[
function onCatchSweepFish( buffObj )
	local param = {}
	param.chair_id = buffObj:readShort()
	param.bullet_id = buffObj:readInt()
	param.fish_id = buffObj:readInt()
	param.fish_score = buffObj:readInt64()
end

function onCatchSweepFishResult( buffObj )
	local param = {}
	param.chair_id = buffObj:readShort()
	param.fish_id = buffObj:readInt()
	param.fish_score = buffObj:readInt64()
	param.catch_fish_count = buffObj:readInt()
	param.catch_fish_id = {}
	for i=1,250 do
		param.catch_fish_id[i] = buffObj:readInt()
	end
end
]]
function onHitFishLK( buffObj )
	--cclog("FishHandler:onHitFishLK")
	local param = {}
	param.chair_id = buffObj:readShort() --没用
	param.fish_id = buffObj:readInt() --鱼ID
	param.fish_multiple = buffObj:readInt() --鱼倍率

	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_HIT_FISH_LK, param)
end

function onSwitchScene( buffObj )
	cclog("FishHandler:onSwitchScene")
	local param = {}
	param.scene_kind = buffObj:readInt() --鱼阵类型
	param.fish_count = buffObj:readInt() --鱼阵对应鱼的数量
	param.fish_kind = {[0]=0}
	for i=0,250-1,1 do
		param.fish_kind[i] = buffObj:readInt()
	end
	param.fish_id = {[0]=0}
	for i=0,250-1,1 do
		param.fish_id[i] = buffObj:readInt()
	end
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_SWITCH_SCENE, param)
end
--没做处理
function onSceneEnd( buffObj )
	cclog("FishHandler:onSceneEnd")
	-- body
end

function onFireSpeedFlag( buffObj )
	cclog("FishHandler:onFireSpeedFlag")
	local player_fire_speed = buffObj:readInt()
end

--比赛排行榜
function onMatchTop( buffObj )
	local param  = {}
	param.TopNum = buffObj:readInt() --数量
	param.Top_ScoreList = {} --分数列表
	for i=1,10 do
		param.Top_ScoreList[i] = buffObj:readInt()
	end
	param.Top_NameList = {} --名称列表
	for i=1,10 do
		param.Top_NameList[i] = buffObj:readString(128)
	end
	param.My_Order = buffObj:readInt() --本人排名
	param.My_TopNum = buffObj:readInt() --本人最高积分
	param.My_LTime = buffObj:readInt() --剩余比赛次数

	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_MATCH_TOP, param)
end

function onGameStatus( buffObj )
	cclog("FishHandler:onGameStatus")
	local param = {}
	param.nGameStatus = buffObj:readChar() --游戏状态 GS_Free(0)休闲 GS_Playing(1)游戏中
	param.nAllowLookon = buffObj:readChar() --允许观看

end

function onSystemMessage( buffObj )
	cclog("FishHandler:onSystemMessage")
	local param = {}
	param.nType = buffObj:readShort()
	local len = buffObj:readShort()
	param.message = buffObj:readString(len*2)

	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GF_MESSAGE, param)
	print("FishHandler:onSystemMessage", param.nType, len, param.message)
end

function OnGameSceneMessage( buffObj )
	cclog("FishHandler:OnGameSceneMessage")
	local param = {}
	param.game_version = buffObj:readInt()
	param._fish_score = {}
	for i=0,GAME_PLAYER-1,1 do
		param._fish_score[i] = buffObj:readInt64()
	end
	param._coin_score = {}
		for i=0,GAME_PLAYER-1,1 do
		param._coin_score[i] = buffObj:readInt64()
	end
	param.wKindID = buffObj:readShort()
	param.wServerID = buffObj:readShort()
	param.nfirst_bullet_multiple = buffObj:readInt()
	--param.bUserCanChangeShootCount = buffObj:readChar()
   param. scene_kind_= buffObj:readInt()
   global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_GF_SCENE, param)
end

function onRedEnvelopeFlag( buffObj )
	cclog("onRedEnvelopeFlag")
	local param = {}
	param.nextTime_h = buffObj:readInt() --下次送红包时间 小时
	param.nextTime_m = buffObj:readInt() --下次送红包时间 分钟
	param.nextTime_s = buffObj:readInt() --下次送红包时间 秒
	param.nextTime_l = buffObj:readInt() --下次送红包时间 剩余红包 -1标识还没开始
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_RED_ENVELOPE_FLAG, param)
    
end

function onRedEnvelopeSend( buffObj )
	cclog("onRedEnvelopeSend")
	local param = {};
	param.chairID = buffObj:readInt() --获取椅子
	param.FishID = buffObj:readInt()  --
	param.score = buffObj:readInt64() --分数
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_RED_ENVELOPE_SEND, param)
end

--------------- 封包 --------------------
function sendClientType()
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_C_PHONE_TYPE_NUM)
	buff:writeInt( 1 )

	netmng.sendGsData(buff)	
end

--increase 上分1 下分0
--exchangenum 金币个数
-- function sendExchangeFishScore()
-- 	local buff = sendBuff:new()
-- 	buff:setMainCmd(pt.MDM_GF_GAME)
-- 	buff:setSubCmd(pt.SUB_C_EXCHANGE_FISHSCORE)
-- 	buff:writeChar(1)
-- 	buff:writeChar(1)

-- 	netmng.sendGsData(buff)
-- end

function sendExchangeFishScore(increase, exchangenum)
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_C_EXCHANGE_FISHSCORE)
	buff:writeChar( 0 )
	buff:writeChar( increase )
	buff:writeInt64(exchangenum)

	netmng.sendGsData(buff)
end

function sendUserFire(bullet_kind, angle, bullet_multiple, lock_fishid, bullet_id)
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_C_USER_FIRE)
	buff:writeInt(bullet_kind)
	buff:writeFloat(angle)
	buff:writeInt(bullet_multiple)
	buff:writeInt(lock_fishid)
	buff:writeInt(bullet_id)

	netmng.sendGsData(buff)
end

function sendCatchFish(chair_id, bullet_id, bullet_kind, fish_id, bullet_multiple, param)
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_C_CATCH_FISH)
	buff:writeShort(chair_id)
	buff:writeInt(fish_id)
	buff:writeInt(bullet_kind)
	buff:writeInt(bullet_id)
	buff:writeInt(bullet_multiple)
	buff:writeInt(param)

	netmng.sendGsData(buff)	
end
--[[
function sendCatchSweepFish( ... )
	-- body
end
]]
function sendHitFishLK(fish_id)
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_C_HIT_FISH_I)
	buff:writeInt(fish_id)

	netmng.sendGsData(buff)	
end

function sendUserReady( )
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_FRAME)
	buff:setSubCmd(pt.SUB_GF_USER_READY)

	netmng.sendGsData(buff)	
end

function sendLoadFinish( )
	local gameKey =168;-- global.g_mainPlayer:getCurrentGameKey()
	local cfg = games_config[gameKey]

	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_FRAME)
	buff:setSubCmd(pt.SUB_GF_INFO)
	buff:writeChar(0)
	buff:writeInt(PlazaVersion)
	buff:writeInt(cfg.version)

	netmng.sendGsData(buff)
end

--退出游戏，请求起立
--tableID目标桌子
--chairID目标椅子
function sendExitGame( tableID, chairID )
	print(tableID,chairID,"===================")
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GR_USER)
	buff:setSubCmd(pt.SUB_GR_USER_STANDUP)
	buff:writeShort(tableID)
	buff:writeShort(chairID)
	buff:writeChar(1)
	
	netmng.sendGsData(buff)
end