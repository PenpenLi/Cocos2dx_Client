module("pt", package.seeall)

MDM_GF_GAME = 200

SUB_GF_GUARANTEE_SCORE_AND_ONLINE = 120 --保证每局能显示正确的总分 和 客户端与服务器连上线
SUB_GF_UPDATESCORE=123--客户端接受GUARANTEE_SCORE_AND_ONLINE_CLIENT

SUB_GF_GAME_FRUIT_YAFEN = 124 --压分
SUB_GF_GAME_FRUIT_YAFENRESULT = 125 --压分结果

SUB_GF_GAME_FRUIT_CANCEL = 126 --取消压分
SUB_GF_GAME_FRUIT_QUXIAOYAFEN_RES = 200 --接收到取消压分结果
SUB_GF_GAME_FRUIT_XUYA = 127 --续压
SUB_GF_GAME_FRUIT_START = 128 --开始
SUB_GF_GAME_FRUIT_BEILV = 129 --切换倍率
SUB_GF_GAME_FRUIT_BIBEI = 130 --比倍

SUB_GF_GAME_FRUIT_BAOJI = 131 --爆机标志

MDM_GR_USER = 3 --用户信息

SUB_GR_USER_STANDUP = 4 --起立请求

MDM_GF_FRAME = 100 --框架消息

SUB_GF_INFO = 1 --加载完成信息
SUB_GF_GAME_STATUS = 100 --游戏状态
SUB_GF_SCENE = 101 --场景信息
SUB_GF_MESSAGE = 200 --系统消息