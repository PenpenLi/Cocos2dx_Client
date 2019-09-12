module("pt", package.seeall)

MDM_GF_GAME = 200 --游戏主命令

SUB_GF_C_GAME_HUNDRED_BEEF_PlaceJetton  = 1  	--用户下注
SUB_GF_C_GAME_HUNDRED_BEEF_ApplyBanker  = 2  	--申请上庄
SUB_GF_C_GAME_HUNDRED_BEEF_ChangeBanker = 3  	--申请下庄
SUB_GF_C_GAME_HUNDRED_BEEF_UpScore 		= 811   --玩家上分

SUB_GF_S_GAME_HUNDRED_BEEF_GameFree 		= 99  --游戏空闲
SUB_GF_S_GAME_HUNDRED_BEEF_GameStart 		= 100 --游戏开始
SUB_GF_S_GAME_HUNDRED_BEEF_PlaceJetton 	 	= 101 --下注
SUB_GF_S_GAME_HUNDRED_BEEF_GameEnd 			= 102 --游戏结束
SUB_GF_S_GAME_HUNDRED_BEEF_ApplyBanker 		= 103 --申请上庄
SUB_GF_S_GAME_HUNDRED_BEEF_ChangeBanker 	= 104 --申请下庄
SUB_GF_S_GAME_HUNDRED_BEEF_UpdateScore 		= 105 --更新积分
SUB_GF_S_GAME_HUNDRED_BEEF_GameRecord 		= 106 --游戏记录
SUB_GF_S_GAME_HUNDRED_BEEF_PlaceJettonFail  = 107 --下注失败
SUB_GF_S_GAME_HUNDRED_BEEF_ApplyCancel 		= 108 --取消申请
SUB_GF_S_GAME_HUNDRED_BEEF_UserInfo 		= 250 --用户更新
SUB_GF_S_GAME_HUNDRED_BEEF_UserEnter 		= 251 --用户进入
SUB_GF_S_GAME_HUNDRED_BEEF_UserExit 		= 252 --用户退出
SUB_GF_S_GAME_HUNDRED_BEEF_Info 				= 253 --兑换后分数

MDM_GR_USER = 3 --用户信息
SUB_GR_USER_STANDUP = 4 --起立请求
MDM_GF_FRAME = 100 --框架消息

SUB_GF_INFO 		= 1 --加载完成信息
SUB_GF_GAME_STATUS  = 100 --游戏状态
SUB_GF_SCENE 		= 101 --场景信息
SUB_GF_MESSAGE 		= 200 --系统消息