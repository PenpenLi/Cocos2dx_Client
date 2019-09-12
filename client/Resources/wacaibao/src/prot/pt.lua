module("pt", package.seeall)

MDM_GF_GAME = 200 --游戏主命令

-- //服务器端消息
SUB_GAME_OPTION = 101 -- 参数获取								
SUB_GAME_STARTBACK	= 103 -- 客户端请求开始游戏 服务端返回的消息													
SUB_GAME_EATBACK = 105	-- 消除返回	
SUB_GAME_DIRECTIONBACK = 100 -- 请求屏幕方向服务端返回的消息						
								

-- -- //客户端消息
SUB_GAME_REQUEST_DIRECTION = 100 -- 请求屏幕方向
SUB_GAME_START = 102 -- 请求开始
SUB_GAME_EAT = 104 -- 消除 
SUB_GAME_STANDUP = 107-- 玩家起立

SUB_GR_USER_STANDUP = 4
SUB_GF_INFO = 1 --加载完成信息
MDM_GF_FRAME = 100 --框架消息
SUB_GF_USER_READY = 2