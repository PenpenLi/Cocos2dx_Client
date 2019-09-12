local eventsAmount = AutoAmount.new()

GAME_MESSAGE_ENTERFOREGROUND = eventsAmount:increase()
GAME_MESSAGE_ENTERBACKGROUND = eventsAmount:increase()
GAME_MESSAGE_PERMISSIONS_GRANT = eventsAmount:increase()
GAME_MESSAGE_REPLACE_SCENE = eventsAmount:increase()

GAME_MESSAGE_GAME_SERVER_CONNECT_SUCCESS = eventsAmount:increase() --房间连接成功
GAME_MESSAGE_GAME_SERVER_CONNECT_FAILED = eventsAmount:increase() --房间连接失败
GAME_MESSAGE_GAME_SERVER_CONNECT_LOST = eventsAmount:increase() --房间连接断开

GAME_MESSAGE_LOGIN_ROOM_FAILED = eventsAmount:increase() --进入房间失败
GAME_MESSAGE_SYSTEM_MESSAGE = eventsAmount:increase() --系统消息
GAME_MESSAGE_WECHAT_AUTHORIZATION = eventsAmount:increase() --微信授权
GAME_MESSAGE_WECHAT_SHARE_SUCCESS = eventsAmount:increase() --微信分享
GAME_MESSAGE_LOGIN_QRCODE_SCAN_SUCCESS = eventsAmount:increase() --扫码登录

GAME_MESSAGE_HALL_SCORE_CHANGE = eventsAmount:increase() --玩家游戏币变化
GAME_MESSAGE_GET_WECHAT_FACE = eventsAmount:increase() --获取微信头像url

GAME_MESSAGE_LOGIN_3RD_FAILED = eventsAmount:increase() --第三方登录失败

GAME_MESSAGE_ZALO_SHARE_SUCCESS = eventsAmount:increase() --Zalo分享成功
GAME_MESSAGE_FACEBOOK_SHARE_SUCCESS = eventsAmount:increase() --Facebook分享成功

GAME_MESSAGE_SHARE_3RD_FAILED = eventsAmount:increase() --第三方分享失败

GAME_MESSAGE_GET_RANK_LIST = eventsAmount:increase() --获取排行榜信息
GAME_MESSAGE_RANK_SHOW_SIMPLE = eventsAmount:increase() --显示简单排行
GAME_MESSAGE_RANK_SHOW_FULL = eventsAmount:increase() --显示详细排行
GAME_MESSAGE_RANK_HIDE_FULL = eventsAmount:increase() --隐藏详细排行

GAME_MESSAGE_ROOM_USER_COME = eventsAmount:increase() --玩家进入房间

GAME_MESSAGE_ROOM_USER_LEAVE = eventsAmount:increase() --玩家离开房间
GAME_MESSAGE_ROOM_USER_FREE = eventsAmount:increase() --玩家退出桌子或进入房间
GAME_MESSAGE_ROOM_USER_SITDOWN = eventsAmount:increase() --玩家坐下桌子
GAME_MESSAGE_ROOM_USER_READY = eventsAmount:increase() --玩家桌子上准备
GAME_MESSAGE_ROOM_USER_LOOKON = eventsAmount:increase() --玩家旁观
GAME_MESSAGE_ROOM_USER_PLAY = eventsAmount:increase() --玩家进入游戏
GAME_MESSAGE_ROOM_USER_OFFLINE = eventsAmount:increase() --玩家掉线
GAME_MESSAGE_ROOM_USER_QUEUE = eventsAmount:increase() --玩家排队
GAME_MESSAGE_ROOM_USER_QUIT = eventsAmount:increase() --玩家退出游戏
GAME_MESSAGE_ROOM_USER_WAIT_DISTRUBUTE = eventsAmount:increase() --玩家等待匹配
GAME_MESSAGE_ROOM_LOGIN_ROOM = eventsAmount:increase() --玩家登录房间成功
GAME_MESSAGE_ROOM_GET_SYSTEM_NAME_SUCCESS = eventsAmount:increase() --获取系统名称成功
GAME_MESSAGE_ROOM_USER_SITDOWN_FAILED = eventsAmount:increase() --玩家坐下失败

GAME_MESSAGE_SCORE_ORDER_EMPTY = eventsAmount:increase() --上下分申请不存在
GAME_MESSAGE_SCORE_ORDER_EXIST = eventsAmount:increase() --上下分申请存在
GAME_MESSAGE_SCORE_APPLY_SUCCESS = eventsAmount:increase() --上下分成功
GAME_MESSAGE_SCORE_CANCEL_SUCCESS = eventsAmount:increase() --取消申请成功

GAME_MESSAGE_BANK_INFO = eventsAmount:increase() --银行信息
GAME_MESSAGE_BANK_SUCCESS = eventsAmount:increase() --存取成功
GAME_MESSAGE_BANK_FAILURE = eventsAmount:increase() --存取失败
GAME_MESSAGE_BANK_OPEN_SUCCESS = eventsAmount:increase() --开通银行成功

GAME_MESSAGE_SHOP_INFO = eventsAmount:increase() --商店信息
GAME_MESSAGE_SHOP_BUY_SUCCESS = eventsAmount:increase() --购买成功
GAME_MESSAGE_SHOP_SELL_SUCCESS = eventsAmount:increase() --回收成功
GAME_MESSAGE_SHOP_GIVE_SUCCESS = eventsAmount:increase() --赠送成功
GAME_MESSAGE_SHOP_EXCHANGE_SUCCESS = eventsAmount:increase() --购买兑换品成功
GAME_MESSAGE_SHOP_GET_PAYCODE_SUCCESS = eventsAmount:increase() --获取付款码成功
GAME_MESSAGE_SHOP_CODE_EXCHANGE_SUCCESS = eventsAmount:increase() --兑换码兑换成功
GAME_MESSAGE_SHOP_ITEM_GIVE_SUCCESS = eventsAmount:increase() --赠送道具成功

GAME_MESSAGE_SHOP_GET_PAYCODE2_SUCCESS = eventsAmount:increase() --获取商品付款码成功

GAME_MESSAGE_WRITE_ORDER_SUCCESS = eventsAmount:increase() --提交订单成功

GAME_MESSAGE_LOCK_MACHINE_SUCCESS = eventsAmount:increase() --锁定机器成功

GAME_MESSAGE_REWARDS_INFO = eventsAmount:increase() --奖励界面信息
GAME_MESSAGE_CHECK_INFO = eventsAmount:increase() --签到信息
GAME_MESSAGE_DAYSIGN_SUCCESS = eventsAmount:increase() --签到成功
GAME_MESSAGE_TAKE_BASEENSURE_SUCCESS = eventsAmount:increase() --领取低保成功
GAME_MESSAGE_CHECK_REBATE = eventsAmount:increase() --检查消费返利

GAME_MESSAGE_APPLY_MATCH_SUCCESS = eventsAmount:increase() --比赛报名成功
GAME_MESSAGE_APPLY_MATCH_FAILED = eventsAmount:increase() --比赛报名失败

GAME_MESSAGE_LOTTERY_RESULT = eventsAmount:increase() --抽奖结果

GAME_MESSAGE_APP_GET_SEVER_SUCCESS = eventsAmount:increase() --获取房间信息成功
GAME_MESSAGE_APP_LOGIN_SUCCESS = eventsAmount:increase() --app登录成功
GAME_MESSAGE_APP_SITDOWN_SUCCESS = eventsAmount:increase() --app坐下成功
GAME_MESSAGE_APP_INFO_UPDATE = eventsAmount:increase() --app信息更新
GAME_MESSAGE_APP_SERVER_KICKOUT = eventsAmount:increase() --后端踢出
GAME_MESSAGE_APP_LOGIN_STATUS = eventsAmount:increase() --app登录状态

GAME_MESSAGE_DEVICE_LOGIN = eventsAmount:increase() --手机登录刷币
GAME_MESSAGE_DEVICE_INFO = eventsAmount:increase() --手机刷币信息
GAME_MESSAGE_DEVICE_UPSCORE = eventsAmount:increase() --手机刷币上分
GAME_MESSAGE_DEVICE_DOWNSCORE = eventsAmount:increase() --手机刷币下分
GAME_MESSAGE_DEVICE_LOST = eventsAmount:increase() --手机刷币断开

GAME_MESSAGE_COMPLETE_SPREADER_SUCCESS = eventsAmount:increase() --完善推广员信息成功
GAME_MESSAGE_GET_SPREADER_SUCCESS = eventsAmount:increase() --获取推广员信息成功
GAME_MESSAGE_COMPLETE_SPREADER_PASSWORD_SUCCESS = eventsAmount:increase() --完善推广员信息和登录密码成功
GAME_MESSAGE_COMPLETE_SPREADER_GIVE_EFFECT = eventsAmount:increase() --完善信息赠送金币效果

GAME_MESSAGE_UPDATE_CHAT = eventsAmount:increase() --更新聊天信息
GAME_MESSAGE_CUSTOMER_HEDDOT_UPDATE = eventsAmount:increase() --更新聊天信息红点
GAME_MESSAGE_GET_RICH_LIST_RESUALT = eventsAmount:increase() --返回排行榜数据

GAME_MESSAGE_STORE_ITEMS_SUCCESS = eventsAmount:increase() --获取商品列表成功
GAME_MESSAGE_STORE_ITEMS_FAILED = eventsAmount:increase() --获取商品列表失败
GAME_MESSAGE_STORE_BUY_SUCCESS = eventsAmount:increase() --购买商品成功
GAME_MESSAGE_STORE_BUY_FAILED = eventsAmount:increase() --购买商品失败
GAME_MESSAGE_STORE_CONSUME_SUCCESS = eventsAmount:increase() --消耗商品成功
GAME_MESSAGE_STORE_CONSUME_FAILED = eventsAmount:increase() --消耗商品失败

GAME_MESSAGE_REQUEST_USER_INFO = eventsAmount:increase() --获取个人信息
GAME_MESSAGE_MODIFY_USER_INFO = eventsAmount:increase() --修改个人信息
GAME_MESSAGE_PUTAWAY_SUCCESS = eventsAmount:increase() --上架成功
GAME_MESSAGE_BUY_SUCCESS = eventsAmount:increase() --购买成功

GAME_MESSAGE_NGANLUONG_PAYMENT_SUCCESS = eventsAmount:increase() --充值成功
GAME_MESSAGE_NGANLUONG_FREE_COUNT = eventsAmount:increase() --自定义购买数量
GAME_MESSAGE_EMAIL_UNREAD_UPDATE = eventsAmount:increase() --未读邮件刷新

GAME_MESSAGE_3RD_LOGIN_SUCCESS = eventsAmount:increase() --第三方登录成功
GAME_MESSAGE_3RD_BIND_SUCCESS = eventsAmount:increase() --第三方绑定成功
GAME_MESSAGE_EXIT_PRIVATE_MESSAGE = eventsAmount:increase() --退出私信页面

GAME_MESSAGE_REQUEST_SERVICE = eventsAmount:increase() --请求客服充值信息

GAME_MESSAGE_REQUEST_MATCH_RANK = eventsAmount:increase() --请求比赛排行榜成功

GAME_MESSAGE_TAKE_EMAIL_REWARD_SUCCESS = eventsAmount:increase() --领取比赛奖励成功

GAME_MESSAGE_COMPLETE_MOMO = eventsAmount:increase() --提示完善momo号
GAME_MESSAGE_AUTO_EXIT = eventsAmount:increase() --自动退出

GAME_MESSAGE_GET_DATA_BIND_SUCCESS = eventsAmount:increase() --获取绑定信息成功
GAME_MESSAGE_MODIFY_DATA_BIND_SUCCESS = eventsAmount:increase() --修改绑定信息成功

GAME_MESSAGE_UPLOAD_IMAGE_SUCCESS = eventsAmount:increase() --上传图片成功
GAME_MESSAGE_UPLOAD_IMAGE_FAILED = eventsAmount:increase() --上传图片失败

GAME_MESSAGE_REQUEST_MOMO_ORDER = eventsAmount:increase() --请求momo订单
GAME_MESSAGE_REQUEST_ZALOPAY_ORDER = eventsAmount:increase() --请求zalopay订单