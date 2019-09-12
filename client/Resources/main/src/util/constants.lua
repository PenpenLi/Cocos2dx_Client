switchUrl = "http://23.91.108.8:81/WS/SwitchInfosix.aspx"
momoUrl = "http://23.91.108.8:81/Pay/MomoPay/GetReceivablesMoMo.aspx"
locateUrl = "http://ip.aiwan920.com/ipquery.ashx"
noticeUrl = "http://23.91.108.8:81/ws/MobileInterface.ashx?action=getgooglemobilenotice&kindid=1"
passwordForgotUrl = "http://23.91.108.8:81/WS/ReLogonPass.ashx?email=%s"
orderUrl = "http://23.91.108.8:81/API/InvokeAPI.aspx?action=GetOrderList"
rechargeRateUrl = "http://23.91.108.8:81/WS/Nativeweb.ashx?action=getrate"
cityUrl = "http://23.91.108.8:81/WS/Nativeweb.ashx?action=getrate&id=%d"
mailUrl = "http://23.91.108.8:81/ws/AuctionHouse.ashx?action=getsitemail&userid=%d&timestamp=%d&pageIndex=%d&pageSize=%d&boolread=%d&sign=%s"
mailReadUrl = "http://23.91.108.8:81/ws/AuctionHouse.ashx?action=updatesitemail&id=%d"
mailReadAllUrl = "http://23.91.108.8:81/ws/AuctionHouse.ashx?action=onekeyupdatesitemail&userid=%d"
webPayUrl = "http://23.91.108.8:81/Pay/PayIndex.aspx"
domainUrl = "http://www.520ing.net/domain.txt"
vendingUrl = "http://23.91.108.8:85/WS/VendMachineAPI.ashx?action=payvending&userid=%d&orderid=%s&timestamp=%d&sign=%s"
shouchongUrl = "http://23.91.108.8:81/ws/AuctionHouse.ashx?action=firstcz&userid=%d"
privateMessageUserUrl = "http://23.91.108.8:81/SiteMail/AccountsInfo.aspx?userid=%d"
privateMessageChatRecordUrl = "http://23.91.108.8:81/SiteMail/sitemail.aspx?Action=%s&SendUserID=%d&RecvUserID=%d&pwd=%s&pageIndex=%d&pageSize=%d&sign=%s"
SendPivateMessageUrl = "http://23.91.108.8:81/SiteMail/ReplyMes.aspx?SendUserID=%d&RecvUserID=%s&Content=%s"
unReadMessageUrl = "http://23.91.108.8:81/SiteMail/sitemail.aspx?Action=%s&SendUserID=%d&RecvUserID=%d&pwd=%s&pageIndex=%d&pageSize=%d&sign=%s"
uploadUrl = "http://23.91.108.8:8787/Tools/PCUploadImgUrl.ashx"
uploadHomeUrl = "http://23.91.108.8:8787%s"

CREATE_STORE_ORDER = "http://23.91.108.91:8081/GetAPI/VietnamOrderInfo.ashx?PlatformId=%d&UserID=%d&ShopId=%s&ShopSum=%d"
APPLE_STORE_VERIFY = "http://23.91.108.91:8081/GetAPI/IOSreceipt.ashx?OrderId=%s&original=%s&data=%s" --苹果内购验证订单接口
GOOGLE_PLAY_VERIFY = "http://23.91.108.91:8081/GetAPI/GogePlay.ashx?OrderId=%s&productId=%s&purchaseToken=%s&packageName=%s&orderpayid=%s" --谷歌内购验证订单接口

MIN_ACC_LEN = 6
MAX_ACC_LEN = 12

MIN_NAME_LEN = 8
MAX_NAME_LEN = 12

MIN_PWD_LEN = 8
MAX_PWD_LEN = 12

APPLY_SCORE_TYPE_ADD = 0 --上分
APPLY_SCORE_TYPE_DOWN = 1 --下分