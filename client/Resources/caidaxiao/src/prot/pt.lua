module("pt", package.seeall)

MDM_GF_FRAME = 100

SUB_GF_GAME_OPTION = 1 -- 游戏配置
SUB_GF_GAME_STATUS = 100 -- 游戏状态
SUB_GF_GAME_SCENE = 101 -- 游戏场景
SUB_GF_SYSTEM_MESSAGE = 200 -- 系统消息
SUB_GF_LOOKON_STATUS = 102 -- 旁观状态，暂不处理
SUB_GF_USER_READY = 2 -- 用户准备

MDM_GF_GAME = 200

SUB_GF_GAME_BAOJI = 810 --爆机

MDM_GR_USER = 3 --用户信息

SUB_GR_USER_STANDUP = 4 --起立请求


SUB_S_GAME_FREE=	101							--游戏空闲
SUB_S_GAME_PLAY=	102								--正在游戏
SUB_S_GAME_START=	103								--游戏开始
SUB_S_JETTON=		104								--玩家下注
SUB_S_PLACE_JETTON_FAIL= 105							--下注失败
SUB_S_GAME_END=		106						     --游戏结束
SUB_S_BIBEIDATAM=     107                              --比倍数据
SUB_S_RECORD = 108 									--游戏记录
SUB_S_JETTONLIST = 109									--押注数


SUB_C_JETTON = 201 --玩家下注
SUB_C_RECORD = 202 --游戏记录
SUB_C_CONTINEJETTON = 203   --续押