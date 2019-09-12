module("pt", package.seeall)

MDM_GF_GAME = 200 --游戏主命令

-- 服务器消息
SUB_S_GAME_RESULT	    = 98	-- 显示开奖结果
SUB_S_GAME_FREE			= 99	-- 游戏空闲
SUB_S_GAME_START		= 100	-- 游戏开始
SUB_S_PLACE_JETTON		= 101	-- 用户下注
SUB_S_GAME_END			= 102	-- 游戏结束
SUB_S_CHANGE_USER_SCORE	= 105	-- 更新积分
SUB_S_SEND_RECORD		= 106	-- 游戏记录
SUB_S_PLACE_JETTON_FAIL	= 107	-- 下注失败
SUB_S_CLEAR_JETTON		= 109	-- 清除下注

-- -- //客户端消息
SUB_C_PLACE_JETTON		=	1		--下注
SUB_C_CLEAR_JETTON		=	2		--清除下注

SUB_GR_USER_STANDUP = 4

SUB_GF_INFO = 1 --加载完成信息
MDM_GF_FRAME = 100 --框架消息
SUB_GF_GAME_STATUS = 100 --游戏状态
SUB_GF_SCENE = 101 --场景信息
SUB_GF_MESSAGE = 200 --系统消息
SUB_GF_USER_READY = 2

GS_GAME_IDLE = 0
GS_PLACE_JETTON = 100
GS_GAME_END = 101
