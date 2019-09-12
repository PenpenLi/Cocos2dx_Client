module("pt", package.seeall)

MDM_GF_GAME = 200 --游戏主命令

MDM_GR_USER = 3 --用户信息

SUB_GR_USER_STANDUP = 4 --起立请求

MDM_GF_FRAME = 100 --框架消息

SUB_GF_INFO = 1 --加载完成信息
SUB_GF_GAME_STATUS = 100 --游戏状态
SUB_GF_SCENE = 101 --场景信息
SUB_GF_MESSAGE = 200 --系统消息
SUB_GF_USER_READY = 2 --用户准备

-- att2 send
SUB_GF_GAME_ATT2_DealCardSend = 1001 --发牌
SUB_GF_GAME_ATT2_SwitchCardSend = 1009 --换牌
SUB_GF_GAME_ATT2_ComporeCardSend = 1003 --比倍大小

--atts recv
SUB_GF_GAME_ATT2_StartJettonResult = 2001 --开始下注
SUB_GF_GAME_ATT2_DealCardResult = 2002 --开始发牌
SUB_GF_GAME_ATT2_SwitchCardResult = 1007 --换牌
SUB_GF_GAME_ATT2_CompareCardResult = 1002 --比倍大小

SUB_GF_GAME_ATT2_GameEndResult = 2008 --游戏结束
SUB_GF_GAME_ATT2_GameFrameResult = 2009 --发给框架