GameVersion = "1.0.0" --游戏版本号

g_jpush_tag = "com.bqd.hyzw"

PAYMENT_CONST = {
	merchantAccount = "tiepthigiaitri@gmail.com",
	merchantId = "57402",
	merchantPassword = "190df1d4b868ea7baea930b39d4ded7a",
	mainUrl = "https://www.nganluong.vn/mobile_checkout_api_post.php",
	returnUrl = "http://47.244.20.209:8081/GetAPI/ReturnPay.ashx?orderid=%s",
	cancelUrl = "http://47.244.20.209:8081/GetAPI/cancel_urlPay.ashx?orderid=%s",
	notifyUrl = "http://47.244.20.209:8081/GetAPI/notify_urPay.ashx?orderid=%s",
	
	orderUrl = "http://47.244.20.209:8081/GetAPI/OrderinfoBuyu.ashx?mcid=%s&userid=%d&amount=%d&money=%d",
	updateUrl = "http://47.244.20.209:8081/GetAPI/UpOrder.ashx?merchant=%s&MerchantPass=%s&orderid=%s&token_code=%s&checkurl=%s",
}

LOGIN_WAY = {
	VISITOR_LOGIN = 0, --游客登录
	ACCOUNT_LOGIN = 1, --帐号登录
	ONE_KEY_LOGIN = 2, --一键登录
	THIRD_PATRY_LOGIN = 3, --第三方登录
}

LOGIN_3RD = {
	ZALO_LOGIN = 1, --zalo登录
	FACEBOOK_LOGIN = 2, --facebook登录
}

SHARE_OBTAIN_TYPE = {
	NORMAL = 1, --下载连接
	PUTAWAY = 2, --商品上架
	MATCH_PRIZE = 3, --比赛奖励
}

BOOL_VALUE = {
	FALSE = 0,
	TRUE = 1,
}

VIP_LEVEL_NAMES = {
	[0] = LocalLanguage:getLanguageString("L_58eb63237d1a4708"),
	[1] = LocalLanguage:getLanguageString("L_3112135fc16e8aa9"),
	[2] = LocalLanguage:getLanguageString("L_31cd97940a1b0293"),
	[3] = LocalLanguage:getLanguageString("L_d29da65a47059263"),
	[4] = LocalLanguage:getLanguageString("L_4c16a00c9f81dbf6"),
	[5] = LocalLanguage:getLanguageString("L_ee6bf23bc2b84374"),
}

--系统平台
PLATFROM = cc.Application:getInstance():getTargetPlatform()
PLATFROM_CODE = "P500"
share_title = LocalLanguage:getLanguageString("L_ee8ba48df7301829")
share_desc = ""

if cc.PLATFORM_OS_ANDROID == PLATFROM then
	STORE_ITEMS_PRODUCTID = {
		"com.bqd.hyzw_200",
		"com.bqd.hyzw_500",
		"com.bqd.hyzw_1000",
		"com.bqd.hyzw_5000",
	}
	share_content = "https://play.google.com/store/apps/details?id=com.bqd.hyzw"
elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
	STORE_ITEMS_PRODUCTID = {
		"com.bqd.hyzw_176",
		"com.bqd.hyzw_360",
		"com.bqd.hyzw_712",
		"com.bqd.hyzw_1432",
		"com.bqd.hyzw_5032",
	}
	share_content = "https://itunes.apple.com/vn/app/Gold-Wings/id1448981527?mt=8"
elseif cc.PLATFORM_OS_WINDOWS == PLATFROM then
	share_content = "https://yuenan.aiwan920.com"
end

STORE_ITEMS_SONG = {
--android
	["com.bqd.hyzw_200"] = 0,
	["com.bqd.hyzw_500"] = 0,
	["com.bqd.hyzw_1000"] = 0,
	["com.bqd.hyzw_5000"] = 0,
--ios
	["com.bqd.hyzw_176"] = 0,
	["com.bqd.hyzw_360"] = 0,
	["com.bqd.hyzw_712"] = 0,
	["com.bqd.hyzw_1432"] = 0,
	["com.bqd.hyzw_5032"] = 0,
}

GOLD_RATE = 110
ZALOPAY_RATE = 100
SELL_RATE = 100
ITEM1_COST = 204

SHARE_CONST = {
	MESSAGE = LocalLanguage:getLanguageString("L_34b21a3bf68837b5"),
	LINK = share_content,
	LINK_TITLE = LocalLanguage:getLanguageString("L_ee8ba48df7301829"),
	LINK_SOURCE = share_content,
	LINK_DESC = "",
	LINK_THUMB = "http://23.91.108.8:5557/item/item9.png",
	SHARE_TYPE = SHARE_OBTAIN_TYPE.NORMAL,
}

SHARE_MATCH_CONST = {
	MESSAGE = LocalLanguage:getLanguageString("L_f790e29bd961a499"),
	LINK = share_content,
	LINK_TITLE = LocalLanguage:getLanguageString("L_ee8ba48df7301829"),
	LINK_SOURCE = share_content,
	LINK_DESC = "",
	LINK_THUMB = "http://23.91.108.8:5557/item/item9.png",
	SHARE_TYPE = SHARE_OBTAIN_TYPE.MATCH_PRIZE,
}

SHARE_AUCTION_CONST = {
	MESSAGE = LocalLanguage:getLanguageString("L_2e7b127a97a23911"),
	LINK = share_content,
	LINK_TITLE = LocalLanguage:getLanguageString("L_ee8ba48df7301829"),
	LINK_SOURCE = share_content,
	LINK_DESC = "",
	LINK_THUMB = "http://23.91.108.8:5557/item/item9.png",
	SHARE_TYPE = SHARE_OBTAIN_TYPE.PUTAWAY,
}

if cc.PLATFORM_OS_WINDOWS == PLATFROM then
	ENTER_DELAY = 0
elseif cc.PLATFORM_OS_ANDROID == PLATFROM then
	ENTER_DELAY = 0.5
else
	ENTER_DELAY = 0
end

--常用锚点坐标
CCPointZero = cc.p(0, 0)
CCPointMidCenter = cc.p(0.5, 0.5)
CCPointUpperLeft = cc.p(0, 1)
CCPointUpperRight = cc.p(1, 1)
CCPointLowerRight = cc.p(1, 0)
CCPointMidLeft = cc.p(0, 0.5)
CCPointMidRight = cc.p(1, 0.5)
CCPointLowerMid = cc.p(0.5, 0)
CCPointUpperMid = cc.p(0.5, 1)

-------------定义颜色-------------------------
COLOR_RED = cc.c3b(255, 0, 0)
COLOR_GREEN = cc.c3b(0, 255, 0)
COLOR_WHITE = cc.c3b(255, 255, 255)
COLOR_DARK = cc.c3b(240, 240, 240)
COLOR_DIM = cc.c3b(150, 150, 150)
COLOR_BLACK = cc.c3b(0, 0, 0)
COLOR_BLUE = cc.c3b(0, 0, 255)
COLOR_YELLOW = cc.c3b(255, 255, 0)
COLOR_PEONY = cc.c3b(255, 0, 255)
COLOR_CYAN = cc.c3b(0, 255, 255)
COLOR_ORANGE = cc.c3b(255, 78, 0)
COLOR_BROWN = cc.c3b(140, 98, 56)
COLOR_PURPLE = cc.c3b(214,63,234)
COLOR_GOLD = cc.c3b(255,194,0)
COLOR_GRAY = cc.c3b(96,96,96)
COLOR_PURGE_YELLOW = cc.c3b(245,129,20)

REGISTER_COUNT_MAX = 10000000 --注册用户上限

WX_PLATFORM = 100 --平台id
HallModuleId = 160 --登录参数的游戏标识
PlazaVersion = util:makeVersion(6, 7, 0, 1) --登录参数的大厅版本
DeviceType = 18 --登录参数的设备类型
MachineId = getMachineId() --设备ID
MachineUUID = MachineId --设备ID2

GameStyleVertical = 0
GameStyleHorizontal = 1

MODIFY_LOGIN_PASSWORD = 0
MODIFY_INSURE_PASSWORD = 1
MODIFY_LOCK_MACHINE = 2

MIN_ACC_LEN = 6
MAX_ACC_LEN = 12

MIN_NAME_LEN = 8
MAX_NAME_LEN = 12

MIN_PWD_LEN = 8
MAX_PWD_LEN = 12

ROOM_USER_NULL = 0 --离开房间
ROOM_USER_FREE = 1 --空闲
ROOM_USER_SIT = 2 --坐下
ROOM_USER_READY = 3 --准备
ROOM_USER_LOOKON = 4 --旁观
ROOM_USER_PLAY = 5 --游戏
ROOM_USER_OFFLINE = 6 --掉线
ROOM_USER_QUEUE = 7 --排队
ROOM_USER_LEAVE = 8 --离开

ROOM_TYPE_TIYAN = 0 --体验房
ROOM_TYPE_PUTONG = 1 --普通房
ROOM_TYPE_HUIYUAN = 2 --会员房
ROOM_TYPE_HAOHUA = 3 --豪华房

APPLY_SCORE_TYPE_ADD = 0 --上分
APPLY_SCORE_TYPE_DOWN = 1 --下分

APP_GAME_TYPE_GATHER = 0 --合集
APP_GAME_TYPE_ARCADE = 1 --街机

GAME_GUIDES = {
	GUIDE_HALL = 1,
	GUIDE_SHOP_BUY = 2,
	GUIDE_SHOP_AUCTION = 3,
	GUIDE_AUCTION_WANT_PUTAWAY = 4,
}