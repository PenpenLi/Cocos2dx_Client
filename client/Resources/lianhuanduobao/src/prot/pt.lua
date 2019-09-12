module("pt", package.seeall)

MDM_GF_GAME = 200 --游戏主命令

-- //服务器端消息
SUB_S_GAME_START = 701 --游戏开始,初始化界面信息
SUB_S_NEXT_GAME = 702 --发送宝石布局
SUB_S_GAME_END = 703 --游戏结束,写分
SUB_S_EXIT = 704 --退出

-- -- //客户端消息
SUB_C_BET		=			801		--下注
SUB_C_EXIT		=			802		--退出
SUB_C_NEW		=			803		--新一局(龙珠探宝结束后选择继续)
SUB_C_BONUS_REPORT		=	809		--客户端报告自己得到了多少奖金,服务端判断这个报告值是否在自己允许的范围内,是则合法,予以承认,否则按得奖0处理

SUB_GR_USER_STANDUP = 4

SUB_GF_INFO = 1 --加载完成信息
MDM_GF_FRAME = 100 --框架消息
SUB_GF_SCENE = 101 --场景信息

SUB_GF_USER_READY = 2