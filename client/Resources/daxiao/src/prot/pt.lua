module("pt", package.seeall)

MDM_GF_GAME = 200 --游戏主命令

SUB_GF_GAME_BIRD_JettoSend = 201 --押分
SUB_GF_GAME_BIRD_GamePlaceJettonResult = 104 --游戏押注结果

SUB_GF_GAME_BIRD_GameFreeResult = 101 --游戏空闲结果 休息时间
SUB_GF_GAME_BIRD_GameStartResult = 103 --游戏开始结果 下注时间
SUB_GF_GAME_BIRD_GameEndResult = 106 --游戏结束结果 开奖时间
SUB_S_SEND_RECORD = 107 --游戏记录 手机版没实现
SUB_S_PLACE_JETTON_FAIL = 114 --下注失败

SUB_GF_GAME_BIRD_ClearMeJettoSend = 157 --清零
SUB_GF_GAME_BIRD_ClearJettonResult = 111 --游戏清零结果

SUB_GF_GAME_BIRD_ContinueJettonSend = 203 --续押
SUB_GF_GAME_BIRD_ContinueJettonResult = 112 --续押结果

SUB_GF_GAME_BIRD_BAOJI = 113 --爆机

MDM_GR_USER = 3 --用户信息

SUB_GR_USER_STANDUP = 4 --起立请求

MDM_GF_FRAME = 100 --框架消息

SUB_GF_INFO = 1 --加载完成信息
SUB_GF_GAME_STATUS = 100 --游戏状态
SUB_GF_SCENE = 101 --场景信息
SUB_GF_MESSAGE = 200 --系统消息