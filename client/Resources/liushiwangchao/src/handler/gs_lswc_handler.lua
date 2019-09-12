module( "gamesvr", package.seeall )

--------------- 解包 --------------------

function onSubGameFree(buffObj)
	print('^^^^^^^^^^^^^^^^^^^^^^^onSubGameFree')
	local param = {}
	param.iUserScore = buffObj:readInt64()
	param.cbTimeLeave = buffObj:readChar()
	print("time1==="..param.cbTimeLeave)
	param.qwGameTimes = buffObj:readInt64()
	global.g_gameDispatcher:sendMessage(GAME_LSWC_GAME_FREE, param)
end

function onSubGameStart(buffObj)
	print('^^^^^^^^^^^^^^^^^^^^^^^onSubGameStart')
	local param = {}
	param.iUserScore = buffObj:readInt64()  						-- 我的金币
	param.cbTimeLeave = buffObj:readChar()  						-- 剩余时间
    param.nAnimalRotateAngle=buffObj:readInt() --动物转盘角度
    param.nPointerRatateAngle=buffObj:readInt() --指针转盘角度
    param.AnimalJettonLimit=buffObj:readInt64() --动物下注限制
    cclog("onSubGameStart param.iUserScore=%d",param.iUserScore);
    param.BetItemRatioList={};
    for i = 1, 4 do
		param.BetItemRatioList[i] = {}
        for j = 1, 3 do
          param.BetItemRatioList[i][j]=buffObj:readInt();--动物倍率
          cclog("onSubGameStart param.BetItemRatioList[%d][%d]=%d",i,j,param.BetItemRatioList[i][j]);
        end
    end
     param.ColorLightIndexList={};
    for i = 1, 24 do
       param.ColorLightIndexList[i]=buffObj:readInt();--颜色
      -- cclog("onGameScene ColorLightIndexList[%d]=%d",i,param.ColorLightIndexList[i]);
    end

    param.nPointerRatateAngle=24-param.nPointerRatateAngle; 
    if(param.nPointerRatateAngle<0) then param.nPointerRatateAngle=param.nPointerRatateAngle+24; end
    param.nAnimalRotateAngle=(param.nAnimalRotateAngle+param.nPointerRatateAngle);
    param.nAnimalRotateAngle=24-param.nAnimalRotateAngle;
    if(param.nAnimalRotateAngle<0) then param.nAnimalRotateAngle=param.nAnimalRotateAngle+24; end
    --
    param.EnjoyGameJettonLimit=buffObj:readInt64()    --庄闲和下注限制
    param.EnjoyRatioList={};
    for i = 1, 3 do
       param.EnjoyRatioList[i]=buffObj:readInt();     --庄闲和倍率
    end
    --[[
	print("time2==="..param.cbTimeLeave)
	param.arrSTAnimalAtt = {}   -- 动物属性
	for i = 1, ANIMALTYPE_MAX do
		param.arrSTAnimalAtt[i] = {}
		for j = 1, COLORTYPE_MAX do
			local animAttr = {}
			animAttr.stAnimal = {}-- 动物类型
			animAttr.stAnimal.eAnimal = buffObj:readInt() -- 动物
			animAttr.stAnimal.eColor = buffObj:readInt() -- 颜色
			animAttr.dwMul = buffObj:readInt() -- 动物开奖倍率
			animAttr.qwJettonLimit = buffObj:readInt64() -- 动物下注最高限制
			param.arrSTAnimalAtt[i][j] = animAttr
		end
	end
	param.arrColorRate = {}  -- 颜色分布概率
	for i = 1, COLORTYPE_MAX do
		param.arrColorRate[i] = buffObj:readInt()
	end
	param.arrSTEnjoyGameAtt = {}  -- 庄闲和属性
	for i = 1, ENJOYGAMETYPE_MAX do
		local data = {}
		data.eEnjoyGame = buffObj:readInt() -- 庄闲和类型
		data.dwMul = buffObj:readInt() -- 倍率
		data.qwJettonLimit = buffObj:readInt64() -- 下注最高限制
		param.arrSTEnjoyGameAtt[i] = data
	end
    --]]
	global.g_gameDispatcher:sendMessage(GAME_LSWC_GAME_START, param)
end

function onSubShowResult(buffObj)
  print('^^^^^^^^^^^^^^^^^^^^^^^onSubShowResult')
  local param = {}
  param.DrawResultCount = buffObj:readInt()  -- 剩余时间
  param.ChairID = buffObj:readInt()          -- 座位
  param.lGameScore = buffObj:readInt64()     -- 游戏分数
  param.lWinScore = buffObj:readInt64()      -- 中奖分数
  param.lInScore= buffObj:readInt64()
  cclog("onSubShowResult(buffObj) lGameScore=%d,lWinScore=%d,lInScore=%d",param.lGameScore,  param.lWinScore, param.lInScore);
  global.g_gameDispatcher:sendMessage(GAME_LSWC_GAME_SHOWRESULT, param)
  
end

function onSubSendRecord(buffObj)--出奖记录
	print('^^^^^^^^^^^^^^^^^^^^^^^onSubSendRecord')
    local param = {}
    param.cbGameTimes = buffObj:readInt64()  -- 局
    param.stWinAnimal ={}
    local animalInfo = {}
	animalInfo.eAnimal = buffObj:readInt()  -- 动物
	animalInfo.eColor = buffObj:readInt()  -- 颜色
    param.stWinAnimal.stAnimalInfo = animalInfo
	param.stWinAnimal.ePrizeMode = buffObj:readInt()
	param.stWinAnimal.qwFlag = buffObj:readInt64()
	param.stWinAnimal.arrstRepeatModePrize = {}
	for i = 1, 20 do
        param.stWinAnimal.arrstRepeatModePrize[i]={};
		param.stWinAnimal.arrstRepeatModePrize[i].eAnimal =buffObj:readInt() -- 动物
		param.stWinAnimal.arrstRepeatModePrize[i].eColor = buffObj:readInt()  -- 颜色
	end
    param.stWinEnjoyGameType = buffObj:readInt()	    -- 开奖庄闲和
    param.iUserScore=0;
    global.g_gameDispatcher:sendMessage(GAME_LSWC_SEND_RECORD, param)
end
function onSubGameEnd(buffObj)
	print('^^^^^^^^^^^^^^^^^^^^^^^onSubGameEnd')
	local param = {}
	param.dwTimeLeave = buffObj:readInt()  -- 剩余时间
	print("time3==="..param.dwTimeLeave)
	param.stWinAnimal = {}				-- 开奖动物
	local animalInfo = {}
	animalInfo.eAnimal = buffObj:readInt()  -- 动物
	animalInfo.eColor = buffObj:readInt()  -- 颜色
	param.stWinAnimal.stAnimalInfo = animalInfo
	param.stWinAnimal.ePrizeMode = buffObj:readInt()
	param.stWinAnimal.qwFlag = buffObj:readInt64()
	param.stWinAnimal.arrstRepeatModePrize = {}
	for i = 1, 20 do
        param.stWinAnimal.arrstRepeatModePrize[i]={};
		param.stWinAnimal.arrstRepeatModePrize[i].eAnimal =buffObj:readInt() -- 动物
		param.stWinAnimal.arrstRepeatModePrize[i].eColor = buffObj:readInt()  -- 颜色
	end
	param.stWinEnjoyGameType = buffObj:readInt()	    -- 开奖庄闲和
	param.iUserScore = buffObj:readInt64()				-- 玩家成绩
    param.lGameScore = buffObj:readInt64()				-- 游戏分数
	param.iRevenue = buffObj:readInt64()				-- 游戏税收
    param.nCurrAnimalAngle=buffObj:readInt();
	param.nCurrPointerAngle=buffObj:readInt();
	param.nAnimalAngle=buffObj:readInt();
	param.nPointerAngle=buffObj:readInt();
    cclog("onSubGameEnd(buffObj) iUserScore=%d,lGameScore=%d",param.iUserScore,param.lGameScore);
  
    if(param.nAnimalAngle%4~=param.stWinAnimal.stAnimalInfo.eAnimal) then 
       cclog("onSubGameEnd error 9999999 eAnimal=%d,eColor=%d,nAnimalAngle=%d,nPointerAngle=%d", 
       param.stWinAnimal.stAnimalInfo.eAnimal,param.stWinAnimal.stAnimalInfo.eColor,param.nAnimalAngle,param.nPointerAngle);
       param.nAnimalAngle=param.stWinAnimal.stAnimalInfo.eAnimal;
    end
   
    param.nCurrAnimalAngle=(param.nCurrPointerAngle-param.nCurrAnimalAngle);
	param.nCurrPointerAngle=24-param.nCurrPointerAngle;  
    param.nCurrAnimalAngle=24-param.nCurrAnimalAngle; 
    if(param.nCurrPointerAngle<0) then param.nCurrPointerAngle=param.nCurrPointerAngle+24; end   
    if(param.nCurrAnimalAngle<0) then param.nCurrAnimalAngle=param.nCurrAnimalAngle+24; end
    param.nAnimalAngle0=param.nAnimalAngle;
    param.nPointerAngle0=param.nPointerAngle;
    param.nAnimalAngle=(param.nPointerAngle-param.nAnimalAngle);
    param.nPointerAngle=24-param.nPointerAngle;
    param.nAnimalAngle=24-param.nAnimalAngle;	

    if(param.nPointerAngle<0) then param.nPointerAngle=param.nPointerAngle+24; end   
    if(param.nAnimalAngle<0) then param.nAnimalAngle=param.nAnimalAngle+24; end
    param.nPointerAngle=param.nPointerAngle%24;
    param.nAnimalAngle=param.nAnimalAngle%24;
--    cclog("onSubGameEnd  eAnimal0=%d,eColor0=%d, eAnimal=%d,eColor=%d,nAnimalAngle=%d,nPointerAngle=%d",
--     param.nAnimalAngle0,param.nPointerAngle0,
--    param.stWinAnimal.stAnimalInfo.eAnimal,param.stWinAnimal.stAnimalInfo.eColor,param.nAnimalAngle,param.nPointerAngle);

     cclog("onSubGameEnd  ePrizeMode=%d,qwFlag(%d) (%d,%d)[(%d,%d),(%d,%d),(%d,%d),(%d,%d),(%d,%d),(%d,%d),(%d,%d)]",
     param.stWinAnimal.ePrizeMode
     ,param.stWinAnimal.qwFlag
     ,param.stWinAnimal.stAnimalInfo.eAnimal 
	 ,param.stWinAnimal.stAnimalInfo.eColor
     ,param.stWinAnimal.arrstRepeatModePrize[1].eAnimal
     ,param.stWinAnimal.arrstRepeatModePrize[1].eColor
     ,param.stWinAnimal.arrstRepeatModePrize[2].eAnimal
     ,param.stWinAnimal.arrstRepeatModePrize[2].eColor
     ,param.stWinAnimal.arrstRepeatModePrize[3].eAnimal
     ,param.stWinAnimal.arrstRepeatModePrize[3].eColor
     ,param.stWinAnimal.arrstRepeatModePrize[4].eAnimal
     ,param.stWinAnimal.arrstRepeatModePrize[4].eColor
     ,param.stWinAnimal.arrstRepeatModePrize[5].eAnimal
     ,param.stWinAnimal.arrstRepeatModePrize[5].eColor
     ,param.stWinAnimal.arrstRepeatModePrize[6].eAnimal
     ,param.stWinAnimal.arrstRepeatModePrize[6].eColor
     ,param.stWinAnimal.arrstRepeatModePrize[7].eAnimal
     ,param.stWinAnimal.arrstRepeatModePrize[7].eColor
     );
	global.g_gameDispatcher:sendMessage(GAME_LSWC_GAME_END, param)
   
end

function onSubChangeUserScore(buffObj)
	print('^^^^^^^^^^^^^^^^^^^^^^^onSubChangeUserScore')
end


function onSubPlaceJettonFail(buffObj)
	print('^^^^^^^^^^^^^^^^^^^^^^^onSubPlaceJettonFail')
	local param = {}
	param.eGamble = buffObj:readInt()  -- 类型
	param.stAnimalInfo = {}  -- 动物加注信息
	param.stAnimalInfo.eAnimal = buffObj:readInt()  -- 动物
	param.stAnimalInfo.eColor = buffObj:readInt()  -- 颜色
	param.eEnjoyGameInfo = buffObj:readInt()  -- 庄闲和加注信息
	param.iPlaceJettonScore = buffObj:readInt64()      -- 当前下注
	param.dwErrorCode = buffObj:readInt()
	global.g_gameDispatcher:sendMessage(GAME_LSWC_PLACE_JETTON_FAIL, param)
end

function onSubPlaceJetton(buffObj)
	print('^^^^^^^^^^^^^^^^^^^^^^^onSubPlaceJetton')
	local param = {}
	param.wChairID = buffObj:readShort()			-- 用户位置
	param.eGamble = buffObj:readInt()
	param.stAnimalInfo = {}
	param.stAnimalInfo.eAnimal = buffObj:readInt()  -- 动物
	param.stAnimalInfo.eColor = buffObj:readInt()  -- 颜色
	param.eEnjoyGameInfo = buffObj:readInt()
	param.iPlaceJettonScore = buffObj:readInt64()  -- 当前下注
    param.iUsreScore = buffObj:readInt64()	       -- 玩家分数
	param.cbBanker = buffObj:readChar()			   -- 是否是庄家，0： 非庄家，1：庄家
	param.iTotalPlayerJetton = buffObj:readInt64()				-- 庄家时候，显示其他玩家下注总和
   -- print('^^^^^^^^^^^^^^^^^^^^^^^onSubPlaceJetton 11')
	global.g_gameDispatcher:sendMessage(GAME_LSWC_PLACE_JETTON, param)


end
function onSubClearJetton(buffObj)
	print('^^^^^^^^^^^^^^^^^^^^^^^onSubClearJetton')
    local param = {}
	param.errCode = buffObj:readInt()
    param.chair_id = buffObj:readInt()
    param.userScore=buffObj:readInt64()      -- 清除后分数
    param.TotalJettonScore={};
    --
    local i=0;
    local j=0;
    for i = 1, 4 do
		param.TotalJettonScore[i] = {}
        for j = 1, 3 do
          param.TotalJettonScore[i][j]=buffObj:readInt64();--动物倍率    
          cclog("onSubClearJetton[%d][%d]=%d",i,j,param.TotalJettonScore[i][j])      
        end
    end
    --
    param.TotalEnjorJettonScore={};
    for j = 1, 3 do
        param.TotalEnjorJettonScore[j]=buffObj:readInt64();--动物倍率          
    end
    --
	global.g_gameDispatcher:sendMessage(GAME_LSWC_CLEAR_JETTON, param)
end

local lswcStatus = pt.GS_GAME_IDLE

function onGameStatus( buffObj )
	lswcStatus = buffObj:readChar()
	print("************************onGameStatus************************", lswcStatus)
end
--场景消息
function onGameScene(buffObj)
	print("主命令：100，次命令：101，函数名：onGameScene")
    local i=0;
	local param = {}
	param.exchangerate = buffObj:readInt()     -- 倍率
    param.game_running_state=buffObj:readInt() -- 游戏状态
	param.iUserScore = buffObj:readInt64()     -- 我的金币
	param.cbTimeLeave = buffObj:readChar()     -- 剩余时间
    param.nAnimalRotateAngle=buffObj:readInt() --动物转盘角度
    param.nPointerRatateAngle=buffObj:readInt() --指针转盘角度

    param.nPointerRatateAngle=24-param.nPointerRatateAngle; 
    if(param.nPointerRatateAngle<0) then param.nPointerRatateAngle=param.nPointerRatateAngle+24; end
    param.nAnimalRotateAngle=(param.nAnimalRotateAngle+param.nPointerRatateAngle);
    param.nAnimalRotateAngle=24-param.nAnimalRotateAngle;
    if(param.nAnimalRotateAngle<0) then param.nAnimalRotateAngle=param.nAnimalRotateAngle+24; end


    param.AnimalJettonLimit=buffObj:readInt64() --动物下注限制
    param.BetItemRatioList={};
    for i = 1, 4 do
		param.BetItemRatioList[i] = {}
        for j = 1, 3 do
          param.BetItemRatioList[i][j]=buffObj:readInt();--动物倍率
          
        end
    end
     param.ColorLightIndexList={};
    for i = 1, 24 do
       param.ColorLightIndexList[i]=buffObj:readInt();--动物倍率
      -- cclog("onGameScene ColorLightIndexList[%d]=%d",i,param.ColorLightIndexList[i]);
    end

    --
    param.EnjoyGameJettonLimit=buffObj:readInt64()    --庄闲和下注限制
    param.EnjoyRatioList={};
    for i = 1, 3 do
       param.EnjoyRatioList[i]=buffObj:readInt();     --庄闲和倍率
    end
    --
    --[[
	param.arrSTAnimalAtt = {}   -- 动物属性
	for i = 1, ANIMALTYPE_MAX do
		param.arrSTAnimalAtt[i] = {}
		for j = 1, COLORTYPE_MAX do
			local animAttr = {}
			animAttr.stAnimal = {}-- 动物类型
			animAttr.stAnimal.eAnimal = buffObj:readInt() -- 动物
			animAttr.stAnimal.eColor = buffObj:readInt() -- 颜色
			animAttr.dwMul = buffObj:readInt() -- 动物开奖倍率
			animAttr.qwJettonLimit = buffObj:readInt64() -- 动物下注最高限制
			param.arrSTAnimalAtt[i][j] = animAttr
		end
	end
	param.arrColorRate = {}  -- 颜色分布概率
	for i = 1, COLORTYPE_MAX do
		param.arrColorRate[i] = buffObj:readInt()
	end
	param.arrSTEnjoyGameAtt = {}  -- 庄闲和属性
	for i = 1, ENJOYGAMETYPE_MAX do
		local data = {}
		data.eEnjoyGame = buffObj:readInt() -- 庄闲和类型
		data.dwMul = buffObj:readInt() -- 倍率
		data.qwJettonLimit = buffObj:readInt64() -- 下注最高限制
		param.arrSTEnjoyGameAtt[i] = data
	end
    --]]
	global.g_gameDispatcher:sendMessage(GAME_LSWC_GS_GAME_SCENE, param)
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
	local gameKey = 614;--global.g_mainPlayer:getCurrentGameKey()
	local cfg = games_config[gameKey]

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
	print('LSWC sendExitGame', tableID, chairID, pt_game.MDM_GR_USER, pt.SUB_GR_USER_STANDUP)
	netmng.sendGsData(buff)
end

-- 下注
-- 可以是动物下注(enjoy < 0)，也可以是休闲下注，由enjoy是否小于0决定
function sendBet( count, anim, color,enjoy,iType)
    print("sendBet( count=%d, anim=%d, color=%d,enjoy=%d,iType=%d)",count, anim, color,enjoy,iType);
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_C_PLACE_JETTON)
	--local iType = enjoy < 0 and GAMBLETYPE_ANIMALGAME or GAMBLETYPE_ENJOYGAME
	buff:writeInt(iType)
	buff:writeInt(anim)
	buff:writeInt(color)
	buff:writeInt(enjoy)
	buff:writeInt64(count)
	netmng.sendGsData(buff)
end

-- 清空下注
function clearBet( )
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_C_CLEAR_JETTON)
	netmng.sendGsData(buff)
end
