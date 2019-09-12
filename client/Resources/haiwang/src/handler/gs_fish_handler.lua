module( "gamesvr", package.seeall )

--------------- 解包 --------------------
function onGameConfig( buffObj )
	cclog("FishHandler:onGameConfig")
	local param = {}
    param.game_ui_type = buffObj:readInt() --ui类型
    param.exchange_count = buffObj:readInt() --ui类型
  	param.fish_score_rate_num = buffObj:readInt() --鱼币比率
  	param.coin_score_rate_num = buffObj:readInt() --金币比率
	param.min_bullet_multiple = buffObj:readInt() --最小倍数
	param.max_bullet_multiple = buffObj:readInt() --最大倍数
	param.nfirst_bullet_multiple = buffObj:readInt() --起始子弹倍数
	param.bomb_range_width = buffObj:readInt() --炸弹范围
	param.bomb_range_height	= buffObj:readInt() --炸弹范围
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
    --cclog("onGameConfig( buffObj )  global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_GAME_CONFIG, param)");
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_GAME_CONFIG, param);
    --发送退换分
	gamesvr.sendExchangeFishScore()
end

function onFishTrace( buffObj )

	local fish_trace_count =1-- buffObj:getLength()/56 --数目
	local param = {[0]={}};
    local hscale = (1280 + 89)/ kRESOLUTIONWIDTH
	local vscale = (720 + 50)/ kRESOLUTIONHEIGHT
    local i=0;
	for i=0,fish_trace_count-1,1 do
		local fishtrace = {};
		fishtrace.init_pos = {[0]=cc.p(0,0)}; --轨迹点, 需要使用convertToGL转换为GL坐标系, 并根据当前屏幕与1136*640标准比例相乘
        local n=0;
		for n=0,4,1 do
			local point = cc.p(buffObj:readFloat(), buffObj:readFloat())
			local point1 = cc.Director:getInstance():convertToGL(point)
			fishtrace.init_pos[n] = cc.p(point1.x*hscale,point1.y*vscale)
		end
		fishtrace.init_count = buffObj:readInt() --init_pos可用数目
		fishtrace.fish_kind = buffObj:readInt() 
		fishtrace.fish_id = buffObj:readInt()
		fishtrace.trace_type = buffObj:readInt() -- 0线性 1贝塞尔曲线
		param[i] = fishtrace		
        --cclog("onFishTrace fish_kind=%d fish_trace_count=%d",fishtrace.fish_kind,fish_trace_count);
	end
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_FISH_TRACE, param)
end

function onExchangeFishScore( buffObj )
	--cclog("FishHandler:onExchangeFishScore.........")
	local param = {}
	param.chair_id = buffObj:readShort()
	param.increase = buffObj:readChar() --1上分 0下分
	param.bAutoChangeScore = buffObj:readChar()
	param.sw_fish_score = buffObj:readInt64() --上下分数值
	param.l_coin_score = buffObj:readInt64() --剩余金币
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_EXCHANGE_FISHSCORE, param)
end

function onUserFire( buffObj )
	--cclog("FishHandler:onUserFire")
	local param = {}
     param.from_server_flag=1;
	param.bullet_kind = buffObj:readInt() --子弹类型
	param.bullet_id = buffObj:readInt() --子弹ID
	param.bullet_specKindFlag = buffObj:readInt() --没用到 
	param.chair_id = buffObj:readShort() --位置ID
	param.android_chairid = buffObj:readShort()
	param.angle = buffObj:readFloat() --角度
	param.bullet_mulriple = buffObj:readInt() --正数,子弹倍率
	param.lock_fishid = buffObj:readInt() -- 0未锁定鱼,大于0锁定鱼id
	param.fish_score = buffObj:readInt64() -- 负数,子弹扣除的游戏币
	if not fishMap[param.lock_fishid] then
		param.lock_fishid = 0
	end

	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_USER_FIRE, param)
end

function onCatchFish( buffObj )
	--cclog("FishHandler:onCatchFish")
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
   -- cclog("FishHandler:onCatchFish  end")
end

function OnBulletIonTimeout( buffObj )
	--cclog("FishHandler:OnBulletIonTimeout")
	local chair_id = buffObj:readShort()
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_BULLET_ION_TIMEOUT, chair_id)
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
--	local param = {}
--	param.chair_id = buffObj:readShort() --没用
--	param.fish_id = buffObj:readInt() --鱼ID
--	param.fish_multiple = buffObj:readInt() --鱼倍率
--	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_HIT_FISH_LK, param)
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
	cclog("FishHandler:onSceneEnd");

    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_SCENE_END, param);
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
    print("FishHandler:onSystemMessage", param.nType, len, param.message)
    print("global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GF_MESSAGE, param):", param.nType, len, param.message)
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GF_MESSAGE, param)
	
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
  --]]
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
--街机信息
function OnSubUpdateJiejiPlayer( buffObj )
	cclog("OnSubUpdateJiejiPlayer")
	local param = {};
    param.jieji_player_flag={};
    for i=0,7,1 do
	   param.jieji_player_flag[i] = buffObj:readInt() --获取椅子
    end
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SUB_S_JIEJI_PLAYER_SEND, param)
end
--
function onRedEnvelopeSend( buffObj )
	--cclog("onRedEnvelopeSend")
	local param = {};
	param.chairID = buffObj:readInt() --获取椅子
	param.FishID = buffObj:readInt()  --
	param.score = buffObj:readInt64() --分数
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_RED_ENVELOPE_SEND, param)
end
-- 钻头炮捕获
function OnSubBroach_bulletCatch(buffObj)
   cclog("OnSubBroach_bulletCatch");
   local param = {};
	param.chairID=buffObj:readInt() ;       
	param.if_bom=buffObj:readInt() ;
	param.fish_id=buffObj:readInt() ;
	param.bulletid=buffObj:readInt() ;
    param.bullet_mul=buffObj:readInt() ;       
	param.fish_mul=buffObj:readInt() ;
	param.angle=buffObj:readInt() ;
	param.fish_score=buffObj:readInt64() ;
    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SUB_S_BROACHCATCH_SEND, param)
end
--电磁炮捕获
function OnSubDianci_bulletCatch(buffObj)
  cclog("OnSubDianci_bulletCatch");
   local param = {};
	param.chairID=buffObj:readInt() ;       
	param.bulletid=buffObj:readInt() ;
	param.bullet_mul=buffObj:readInt() ;
	param.fish_mul=buffObj:readInt() ;
    param.angle=buffObj:readInt() ;       
	param.fish_score=buffObj:readInt64() ;
    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SUB_S_DIANCICATCH_SEND, param)

end
--必杀弹捕获捕获
function OnSubMissile_bulletCatch(buffObj)
   cclog("OnSubMissile_bulletCatch");
    local param = {};
	param.chair_id=buffObj:readShort() ;       
	param.fish_id=buffObj:readInt() ;
	param.bulletID=buffObj:readInt() ;
	param.fish_kind=buffObj:readInt() ;
    param.bullet_mul=buffObj:readInt();       
	param.fish_mul=buffObj:readInt();
    param.fish_score=buffObj:readInt64();
    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SUB_S_MISSILECATCH_SEND, param)
end
--美人鱼捕获
function OnSubMRY_FishCatch(buffObj)
   cclog("OnSubMRY_FishCatch---------------");
   local param = {};
	param.chair_id=buffObj:readShort() ;       
	param._mulriple=buffObj:readInt() ;
	param._LeftTime=buffObj:readInt() ;
    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SUB_S_MRYCATCH_SEND, param);
end
--获得宝箱
function OnSubBaoxiangCatch(buffObj)
    cclog("OnSubBaoxiangCatch");
    local param = {};
	param.chair_id=buffObj:readShort() ;       
	param.fish_id=buffObj:readInt() ;
	param.catchnum=buffObj:readInt() ;
    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SUB_S_BAOXANGCATCH_SEND, param);
end

--宝箱任务完成
function OnSubBaoxiangCatchEnd(buffObj)
     cclog("OnSubBaoxiangCatchEnd");
    local param = {};
	param.chair_id=buffObj:readShort() ;       
    param.scorenum=buffObj:readInt64();
    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SUB_S_BAOXANGCATCHEND_SEND, param);
end

--美人鱼任务结束
function OnSubMRY_FishCatchEnd(buffObj)
    cclog("OnSubMRY_FishCatchEnd-----------------------");
    local param = {};
	param.chair_id=buffObj:readShort() ;       
	param.bullet_mul=buffObj:readInt() ;
	param.catch_mul=buffObj:readInt() ;
    param.scorenum=buffObj:readInt64();
    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SUB_S_MRY_CARCH_END_SEND, param);
end
--免费游戏结束
function OnSubFreebulletEnd(buffObj)
    cclog("OnSubFreebulletEnd");
    local param = {};
	param.chair_id=buffObj:readShort() ;       
    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SUB_S_FREE_BULLET_END_SEND, param);
end
--鱼阵
function OnSubFishQueue(buffObj)
--cclog("OnSubFishQueue");
local param = {}
	param.speed=buffObj:readInt() ;        --移动速度
	param.queue_kind=buffObj:readInt() ;--组合方式
	param.fish_num=buffObj:readInt() ;--鱼数量
	param.point_num=buffObj:readInt() ;--路径点数 简单3个点运动
    --移动路径
    param.mov_List = {[0]=cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0)};
	for i=0,4,1 do
		param.mov_List[i].x= buffObj:readFloat();
        param.mov_List[i].y= buffObj:readFloat();
	end
    --类型列表
    param.fish_kind={[0]=0,0,0,0,0,0,0,0,0,0,0};
    for i=0,9,1 do
		param.fish_kind[i]= buffObj:readInt();
	end
      --id列表
    param.fish_id={[0]=0};
    for i=0,9,1 do
		param.fish_id[i]= buffObj:readInt();
	end
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUYU_FISH_QUEUE, param)
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
function sendExchangeFishScore()
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_C_EXCHANGE_FISHSCORE)
	buff:writeChar(1)
	buff:writeChar(1)
    buff:writeInt64(10000000000)
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
	 local gameKey =166;
    if(global.g_mainPlayer) then  
       if(global.g_mainPlayer.getCurrentGameKey) then 
           gameKey=global.g_mainPlayer:getCurrentGameKey()
        end
      if(gameKey==nil) then gameKey=166 end
    end
	local cfg = games_config[gameKey]
	local buff = sendBuff:new()
    cclog("sendLoadFinis gameId=%d",gameKey);
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