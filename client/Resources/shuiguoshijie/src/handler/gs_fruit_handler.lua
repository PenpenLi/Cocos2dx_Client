module( "gamesvr", package.seeall )

--------------- 解包 --------------------
function onGameStatus(buffObj)

end

function onSystemMessage(buffObj)
	print("系统消息")
    --[[
	local mType = buffObj:readShort()
	local len = buffObj:readShort()
	local msg = buffObj:readString(len * 2)

	WarnTips.showTips(
		{
			text = msg,
			style = WarnTips.STYLE_Y
		}
	)
    --]]
    local param = {}
	param.nType = buffObj:readShort()
	local len = buffObj:readShort()
	param.message = buffObj:readString(len*2)
    print("系统消息:"..param.message)
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GF_MESSAGE, param)
end

function onGameScene(buffObj)

end

function onYafenResult( buffObj )
	print("onYafenResult")
	local param = {}
	param.betId = buffObj:readInt() --押分ID
	param.IsBet = buffObj:readInt() --是否押分成功1表示成功，0反之
    param.chair_id= buffObj:readInt();      --//座位
	param.bet_num= buffObj:readInt();       --//压分值
	param.userScore= buffObj:readInt64();--//玩家分数
    
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHUIGUOSHIJIE_YAFENRESULT, param)
end

function onFruitXuya( buffObj )
	local param = {}
	param.totalBet = buffObj:readInt() --续压总分
	param.yafenNum = {} --续压数组
	for i=1,8 do
		param.yafenNum[i] = buffObj:readInt()
	end
    param.chair_id = buffObj:readInt();  --    //座位
	param.userScore= buffObj:readInt64();--//玩家分数
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHUIGUOSHIJIE_FRUITXUYA, param)
end

--[[
	defen[1]
	0:普通奖
	1:BAR 2-6 
		defen[1]:1
		defen[2]:4  bar100
		后面随机2-6个分值
	2:射灯1-3 
		defen[1]:2
		defen[2]:9  good luck
		后面随机0-3个分值
	3:彩金 
		没有这个奖
	4:跑火车
		defen[1]:4
		defen[2]:9  good luck
		后面随机连续几个分值
	5:蜻蜓队长
		defen[1]:5
		defen[2]:9  good luck
		后面随机连续几个分值
	6:跑内圈
		defen[1]:6
		defen[2]:21 good luck
		defen[3]:14 内圈索引 最上面那个BAR为0，顺时针增加
	7:纵横四海
		defen[1]:7
		defen[2]:9  good luck
		后面随机连续几个分值
	8:大四喜
		defen[1]:8
		defen[2]:21 good luck
		defen[3]:15 苹果
		defen[4]:22 苹果
		defen[5]:10 苹果
		defen[6]:5  苹果
	9:小三元
		铃铛 芒果 橘子 
	10:大三元
		defen[1]:10
		defen[2]:9	good luck
		defen[3]:19	星星
		defen[4]:16 77
		defen[5]:7  西瓜
	11:九莲宝灯
		defen[1]:11
		defen[2]:9  good luck
		后面连续九个分值
	12:大满贯
		大满贯 24灯全中
	13:小猫变身 
		defen[2]的值为8、14、20或者11、17、23时有可能触发
		基础倍率为正常倍率,翻倍小猫变身次数
]]
--[[
	普通奖:defen[2]值
	左上角橘子索引为0，顺时针计算
		int sum = 0;
		switch (fruitIndex) {
		case 0:// 橘子1
		case 12:// 橘子1
			sum = fruitBet[7] * 10;
			break;
		case 11:// 橘子*2
			sum = fruitBet[7] * 2;
			break;
		case 1:// 铃铛1
		case 13:// 铃铛1
			sum = fruitBet[5] * 10;
			break;
		case 23:// 铃铛*2
			sum = fruitBet[5] * 2;
			break;
		case 2:// bar*50
			sum = fruitBet[1] * 50;
			break;
		case 4: // bar*100
			sum = fruitBet[1] * 100;
			break;
		case 5:// apple*5
		case 10:// apple*5
		case 15:// apple*5
		case 22:// apple*5
			sum = fruitBet[8] * 5;
			break;
		case 17:// 芒果*2
			sum = fruitBet[6] * 2;
			break;
		case 6:// 芒果
		case 18:// 芒果
			sum = fruitBet[6] * 10;
			break;
		case 7:// 西瓜
			sum = fruitBet[4] * 20;
			break;
		case 8:// 西瓜*2
			sum = fruitBet[4] * 2;
			break;
		case 14:// 77*2
			sum = fruitBet[2] * 2;
			break;
		case 16:// 77
			sum = fruitBet[2] * 20;
			break;
		case 19:// 星星
			sum = fruitBet[3] * 20;
			break;
		case 20:// 星星*2
			sum = fruitBet[3] * 2;
			break;
		default:
			sum = 0;
			break;
		}
]]
local t_index_run_=0;
function onFruitStart( buffObj )
	local param = {}
	param.fruitBet = {}
	for i=1,8 do
		param.fruitBet[i] = buffObj:readInt() --押分数组
	end
	--默认-1
	param.defen = {}
	for i=1,24 do
		param.defen[i] = buffObj:readInt() --游戏结果数组 //开奖结果 -1为没开奖
		--print("onFruitStart="..i.."="..param.defen[i] )
	end


	param.catCount = buffObj:readInt() --小猫变身次数 1-5次 小猫变身次数
	param.xiaomaoCurBianshenCount = buffObj:readInt() --小猫当前的变身次数
    param.caijinScore = buffObj:readInt()             --jp彩金数额
    param.chair_id = buffObj:readInt()                --中奖座位
    param.player_winScore = buffObj:readInt()         --玩家赢分
    param.player_gamescore = buffObj:readInt()         --玩家分数
  
      
--      param.defen[1] = 3
--	  param.defen[2] = 3
--	  param.defen[3] = -1
--	  param.defen[4] = -1
--      param.defen[5] = -1
--	  param.caijinScore =10000;
--      param.player_winScore=10000;
--      param.player_gamescore =10000000;
    
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHUIGUOSHIJIE_FRUITSTART, param)
end

function onFruitBibei( buffObj )
	local param = {}
	param.beibeiNum = buffObj:readInt() --用来显示最终的大小数字
	param.bibeiId = buffObj:readInt() --可以无视

	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHUIGUOSHIJIE_FRUITBIBEI, param)
end

function onFruitBaoji( buffObj )
	local param = {}
	param.baoji = buffObj:readChar() -- 1 爆机

	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHUIGUOSHIJIE_FRUITBAOJI, param)
end

function onUpDateScore(buffObj)
	local param = {}
	-- param.iMashagnchifangState = buffObj:readInt()
	-- param.iChifangfenNum = buffObj:readInt()
	param.score = buffObj:readInt64()
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_UPDATESCORE, param)
end

function onCancleYafenRes(buffObj) --取消压分结果
    local param = {}
    param.chair_id = buffObj:readInt()
    param.score = buffObj:readInt64()
     cclog("onCancleYafenRes(buffObj) chair_id=%d,score=%d", param.chair_id, param.score);
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHUIGUOSHIJIE_FRUITQUXIAO, param)
end
--------------- 封包 --------------------
--betID 从左到右 5-12
function sendFruitGameScore(betId,rate)
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_GF_GAME_FRUIT_YAFEN)
	buff:writeInt( betId )
	if(rate==nil) then buff:writeInt(0)
    else  buff:writeInt(rate) end

	netmng.sendGsData(buff)
end

function sendFruitCancel()
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_GF_GAME_FRUIT_CANCEL)

	netmng.sendGsData(buff)
end

function sendFruitXuya()
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_GF_GAME_FRUIT_XUYA)

	netmng.sendGsData(buff)
end

function sendFruitStart()
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_GF_GAME_FRUIT_START)

	netmng.sendGsData(buff)
end

--倍率切换默认是10，点击一下切换为100，再点击一下切换为1，再点击一下切换为10
function sendFruitBeilv()
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_GF_GAME_FRUIT_BEILV)

	netmng.sendGsData(buff)
end

--玩家押注1-7 bibeiId为3
--玩家押注8-14 bibeiId为4
function sendBibei(bibeiId)
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_GF_GAME_FRUIT_BIBEI)
	buff:writeInt( bibeiId )

	netmng.sendGsData(buff)
end

--开始游戏
function sendLoginGame()
	local gameKey = global.g_mainPlayer:getCurrentGameKey()
	local cfg = games_config[gameKey]

	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_FRAME)
	buff:setSubCmd(pt.SUB_GF_INFO)
	buff:writeChar(0)
	buff:writeInt(PlazaVersion)
	buff:writeInt(cfg.version)

	netmng.sendGsData(buff)
end

--保证每局能显示正确的总分 和 客户端与服务器连上线
function sendGuaranteeScore( )
	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_GF_GUARANTEE_SCORE_AND_ONLINE)

	netmng.sendGsData(buff)
end


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