module("pt", package.seeall)

MDM_GF_GAME = 200 --游戏命令

SUB_C_EXCHANGE_FISHSCORE = 1 --自动换币
SUB_C_USER_FIRE = 2 --发射子弹
SUB_C_CATCH_FISH = 3 --捕鱼
--SUB_C_CATCH_SWEEP_FISH = 4 --好像没发送过
SUB_C_HIT_FISH_I = 5 --子弹倍率最大,彩金鱼,非锁定
SUB_C_PHONE_TYPE_NUM = 110 --发送设备类型

SUB_S_GAME_CONFIG = 100 --游戏配置
SUB_S_FISH_TRACE = 101 --鱼出现 
SUB_S_EXCHANGE_FISHSCORE = 102 --分数变化
SUB_S_USER_FIRE = 103 --发射子弹(会接收到自己的发射响应)
SUB_S_CATCH_FISH = 104 --自己或对方捕抓到鱼
SUB_S_BULLET_ION_TIMEOUT = 105 --特殊子弹结束
SUB_S_LOCK_TIMEOUT = 106 --定屏结束
--SUB_S_CATCH_SWEEP_FISH = 107 --捕获特殊鱼
--SUB_S_CATCH_SWEEP_FISH_RESULT = 108
SUB_S_HIT_FISH_LK = 109 --服务器返回特定鱼随机倍率
SUB_S_SWITCH_SCENE = 110 --场景切换鱼阵
SUB_S_SCENE_END = 112 --场景切换结束
SUB_S_FIRESPEED_FLAG = 160 --玩家发炮速度,好像没用

SUB_S_FISH_LINE = 201 --鱼出现

SUB_S_RED_ENVELOPE_FLAG = 159 --红包命令标记
SUB_S_RED_ENVELOPE_SEND = 160 --红包命令发送标记

SUB_S_MACTH_TOP = 154 --比赛排行榜

MDM_GF_FRAME = 100 --框架消息

SUB_GF_INFO = 1 --加载完成信息
SUB_GF_USER_READY = 2 --用户准备
SUB_GF_GAME_STATUS = 100 --游戏状态
SUB_GF_MESSAGE = 200 --系统消息
SUB_GF_SCENE = 101 --场景信息

MDM_GR_USER = 3 --用户信息

SUB_GR_USER_STANDUP = 4 --起立请求