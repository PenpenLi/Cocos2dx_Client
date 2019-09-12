module( "gatesvr", package.seeall )

--------------- 解包 --------------------
function onLoginSuccess(buffObj)
	LoadingView.closeTips()

	removeHeartbeatHandler()

	local faceId = buffObj:readShort()
	local sex = buffObj:readChar()
	local customId = buffObj:readInt()
	local playerId = buffObj:readInt()
	local gameId = buffObj:readInt()
	local exp = buffObj:readInt()
	local loveLiness = buffObj:readInt()
	local wxBind = buffObj:readInt()
	local spreaderId = buffObj:readInt()
	local account = buffObj:readString(64)
	local name = buffObj:readString(64)
	local dynamicPass = buffObj:readString(66)
	local score = buffObj:readInt64()
	local ingot = buffObj:readInt64()
	local insure = buffObj:readInt64()
	local beans = buffObj:readInt64()
	local insureEnabled = buffObj:readChar()
	local momo = buffObj:readString(30)
	local ext = {}
	for i = 1, 10 do
		ext[i] = buffObj:readChar()
	end

	local lenPass = utf8.len(dynamicPass)
	global.g_mainPlayer:setCurrentGameId(nil)
	global.g_mainPlayer:initRoomList()
	global.g_mainPlayer:initMatchSignUp()
	global.g_mainPlayer:initRoomTable()
	global.g_mainPlayer:initRoomUser()
	global.g_mainPlayer:initAppLoginData()
	global.g_mainPlayer:initDeviceLoginData()

	--正常登录
	global.g_mainPlayer:initPlayerData(spreaderId, (playerId % 9) + 1, sex, customId, playerId, gameId, exp, loveLiness, wxBind, name, dynamicPass, score, ingot, insure, beans, insureEnabled, momo, ext)
	if not global.g_mainPlayer:isVisitorLogin() then
		global.g_mainPlayer:setLocalData("account", account)
		global.g_mainPlayer:setLocalData("password", global.g_password)
	end

	local alias = playerId .. g_jpush_tag
	if cc.PLATFORM_OS_ANDROID == PLATFROM then
		calljavaMethodV("setJPushOptions",{alias, g_jpush_tag})
	elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
		luaoc.callStaticMethod("AppController", "setJPushOptions", {alias=alias, g_jpush_tag=g_jpush_tag})
	end
	sendJPushData(gameId, alias, g_jpush_tag)

	global.g_mainPlayer:addLoginCount()

	require_ex("fullmain.src.load")
	
	replaceScene(HallScene, TRANS_CONST.TRANS_SCALE)
end

function onFanLi(buffObj)
	local fanli={}
	for i=1,7 do
		fanli[i] = buffObj:readInt()
		print("============1="..fanli[i])
	end
	global.g_mainPlayer:setFanLiInfo(fanli)
end

function onLoginFailed(buffObj)
	LoadingView.closeTips()

	if global.g_mainPlayer:isLogined3rd() then
		global.g_mainPlayer:setLoginData3rd(nil)
	end

	local errorCode = buffObj:readInt()
	local desc = buffObj:readString(buffObj:getLength() - 4)
	WarnTips.showTips(
			{
				text = desc,
				style = WarnTips.STYLE_Y
			}
		)
end

function onLoginFinish(buffObj)
	TextTipsUtils:showTips(LocalLanguage:getLanguageString("L_1b049bc79e1ada61"))
end

function onLogined(buffObj)
	WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_7abb5045325d595c"),
				style = WarnTips.STYLE_Y
			}
		)
end

function onRequireRegister(buffObj)
	TextTipsUtils:showTips(LocalLanguage:getLanguageString("L_1b96a4ed0d0db73b"))
end

function onRegisterResult(buffObj)
	TextTipsUtils:showTips(LocalLanguage:getLanguageString("L_cdc9f073c31464e7"))
end

function onUpdateNotify(buffObj)
	WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_02f0de8efa765208"),
				style = WarnTips.STYLE_Y
			}
		)
end

--------------- 封包 --------------------
function sendLogin(account, password)
	global.g_mainPlayer:setLoginWay(LOGIN_WAY.ACCOUNT_LOGIN)

	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_MB_LOGON)
	buff:setSubCmd(pt_gate.SUB_MB_LOGON_ACCOUNTS)
	buff:writeShort(HallModuleId)
	buff:writeInt(PlazaVersion)
	buff:writeChar(DeviceType)
	buff:writeMD5(password, 66)
	buff:writeString(account, 64)
	buff:writeMD5(MachineUUID, 66)
	buff:writeString("", 24)
	buff:writeString("", 64)
	buff:writeChar(WX_PLATFORM)

	netmng.sendGtData(buff)

	addGateHeartbeatHandler()
end

function sendLoginVisitor()
	global.g_mainPlayer:setLoginWay(LOGIN_WAY.VISITOR_LOGIN)

	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_MB_LOGON)
	buff:setSubCmd(pt_gate.SUB_MB_LOGON_VISITOR)
	buff:writeShort(HallModuleId)
	buff:writeInt(PlazaVersion)
	buff:writeChar(DeviceType)

	netmng.sendGtData(buff)

	addGateHeartbeatHandler()
end

function sendRegister(account, password, recAccount, location, email)
	global.g_mainPlayer:setLoginWay(LOGIN_WAY.ACCOUNT_LOGIN)

	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_MB_LOGON)
	buff:setSubCmd(pt_gate.SUB_MB_REGISTER_ACCOUNTS)
	buff:writeShort(HallModuleId)
	buff:writeInt(PlazaVersion)
	buff:writeChar( DeviceType )
	buff:writeMD5(password, 66)
	buff:writeShort(1)
	buff:writeChar(0)
	buff:writeString(account, 64)
	buff:writeString(account, 64)
	buff:writeMD5(MachineUUID, 66)
	buff:writeString("", 24)
	buff:writeString(recAccount, 64)
	buff:writeString(email, 64)
	buff:writeString(location, 64)
	buff:writeChar(WX_PLATFORM)

	netmng.sendGtData(buff)

	addGateHeartbeatHandler()
end

function sendLoginOtherPlatform(sex, unionId, nickname, realname, mobilePhone, location)
	global.g_mainPlayer:setLoginWay(LOGIN_WAY.THIRD_PATRY_LOGIN)

	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_MB_LOGON)
	buff:setSubCmd(pt_gate.SUB_MB_LOGON_OTHERPLATFORM)
	buff:writeShort(HallModuleId)
	buff:writeInt(PlazaVersion)
	buff:writeChar(DeviceType)
	buff:writeChar(sex)
	buff:writeChar(WX_PLATFORM)
	buff:writeString(unionId, 66)
	buff:writeString(nickname, 64)
	buff:writeString(realname, 32)
	buff:writeMD5(MachineId, 66)
	buff:writeString(mobilePhone, 24)
	buff:writeString(location, 64)
	buff:writeMD5(MachineUUID, 66)
	buff:writeInt(getLockSpreader())

	netmng.sendGtData(buff)

	addGateHeartbeatHandler()
end

function sendOneKeyLogin(location)
	global.g_mainPlayer:setLoginWay(LOGIN_WAY.ONE_KEY_LOGIN)

	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_MB_LOGON)
	buff:setSubCmd(pt_gate.SUB_MB_ONE_KEY_LOGIN)
	buff:writeShort(HallModuleId)
	buff:writeInt(PlazaVersion)
	buff:writeChar(DeviceType)
	buff:writeMD5(MachineUUID, 66)
	buff:writeMD5(MachineId, 66)
	buff:writeString(location, 64)
	buff:writeChar(WX_PLATFORM)
	buff:writeInt(getLockSpreader())

	netmng.sendGtData(buff)

	addGateHeartbeatHandler()
end

function sendJPushData(userID, alias, tag)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_SET_JIGUANG)
	buff:setSubCmd(pt_gate.SUB_MB_SET_JIGUANG)
	buff:writeInt(userID)
	buff:writeString(alias, 64)
	buff:writeString(tag, 64)

	netmng.sendGtData(buff)
end