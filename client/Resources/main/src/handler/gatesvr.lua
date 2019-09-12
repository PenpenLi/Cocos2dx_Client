module( "gatesvr", package.seeall )

gtNetHandler = {
	[pt_gate.MDM_GR_LOGON] = {
		[pt_gate.SUB_GR_UPDATE_NOTIFY] = onUpdateNotify,
		[pt_gate.SUB_GP_MATCH_SIGNUPINFO] = onMatchSignUpInfo,
	},
	[pt_gate.MDM_MB_LOGON] = {
		[pt_gate.SUB_GP_LOGON_SUCCESS] = onLoginSuccess,
		[pt_gate.SUB_GP_LOGON_ERROR] = onLoginFailed,
		[pt_gate.SUB_GP_LOGON_FINISH] = onLoginFinish,
		[pt_gate.SUB_GP_LOGON_REPLACE] = onLogined,
		[pt_gate.SUB_GP_ASK_REGISTER_REQ] = onRequireRegister,
		[pt_gate.SUB_GP_REGISTER_RESULT_REQ] = onRegisterResult,
		[pt_gate.SUB_MB_FANLI] = onFanLi,
	},
	[pt_gate.MDM_MB_SERVER_LIST] = {
		[pt_gate.SUB_MB_LIST_SERVER] = onServerList,
		[pt_gate.SUB_MB_LIST_MATCH] = onMatchList,
		[pt_gate.SUB_MB_LIST_FINISH] = onListFinish,
		[pt_gate.SUB_GP_LIST_CONFIG] = onConfigList,
		[pt_gate.SUB_GP_LIST_PROCESS] = onProcessList,
		[pt_gate.SUB_GP_LIST_PROP] = onPropList,
		[pt_gate.SUB_GP_LIST_APPLY] = onApplyList,
	},
	[pt_gate.MDM_SCORE_UPDOWN] = {
		[pt_gate.SUB_SCORE_GET_RESUALT] = onScoreGet,
		[pt_gate.SUB_SCORE_ADD_RESUALT] = onScoreApply,
		[pt_gate.SUB_SCORE_DEL_RESUALT] = onScoreApplyCancel,
	},
	[pt_gate.MDM_GP_USER_SERVICE] = {
		[pt_gate.SUB_GP_MATCH_SIGNUP_RESULT] = onMatchSignUpResult,
		[pt_gate.SUB_GP_OPERATE_SUCCESS] = onOperateSuccess,
		[pt_gate.SUB_GP_OPERATE_FAILURE] = onOperateFailure,
		[pt_gate.SUB_GP_S_CHECKIN_INFO] = onCheckInInfo,
		[pt_gate.SUB_GP_S_CHECKIN_RESULT] = onCheckInResult,
		[pt_gate.SUB_GP_S_BASEENSURE_PARAMETER] = onBaseEnsureParam,
		[pt_gate.SUB_GP_S_BASEENSURE_RESULT] = onBaseEnsureResult,
		[pt_gate.SUB_GP_S_USER_INSURE_ENABLE_RESULT] = onInsureEnable,
		[pt_gate.SUB_GP_S_USER_INSURE_INFO] = onUserInsureInfo,
		[pt_gate.SUB_GP_S_USER_INSURE_SUCCESS] = onUserInsureSuccess,
		[pt_gate.SUB_GP_S_USER_INSURE_FAILURE] = onUserInsureFailure,
		[pt_gate.SUB_GP_S_MB_WRITE_ORDER_REASULT] = onWriteOrderResult,
		[pt_gate.SUB_GP_CS_PROPERTY_INFO] = onPropertyInfo,
		[pt_gate.SUB_GP_S_PROPERTY_USER_INFO] = onPropertyUserInfo,
		[pt_gate.SUB_GP_S_SEND_PROPERTY_REASULT] = onPropertySendResult,
		[pt_gate.SUB_GP_S_BUY_PROPERTY_REASULT] = onPropertyBuyResult,
		[pt_gate.SUB_GP_S_SELL_PROPERTY_REASULT] = onPropertySellResult,
		[pt_gate.SUB_GP_SEND_PROPERTY_REASULT] = onItemGive,
		[pt_gate.SUB_GP_USER_GETPAYCODE_RESULT] = onGetPayCodeResult,
		[pt_gate.SUB_GP_USER_GETPAYCODE2_RESULT] = onGetPayCode2Result,
		[pt_gate.SUB_GP_S_USER_BIND_WX_RESULT] = onBindWechatResult,
		[pt_gate.SUB_GP_S_USER_WX_SHAREINFO_RESULT] = onShareObtain,
		[pt_gate.SUB_GP_S_USER_WX_GETPRICE_RESULT] = onTurntableLottery,
		[pt_gate.SUB_GP_USER_WX_INPUTSPRINFO_RESULT] = onCompleteSpreader,
		[pt_gate.SUB_GP_USER_WX_INPUTSPRINFO2_RESULT] = onCompleteSpreaderPassword,
		[pt_gate.SUB_GP_USER_WX_GETSPRINFO_RESULT] = onSpreaderInfo,
		[pt_gate.SUB_GP_USER_GETSYSNAME_RESULT] = onGetSystemName,
		[pt_gate.SUB_GP_USER_EXCHANGE] = onUserExchange,
		[pt_gate.SUB_GP_GETWXFACE_RESULT] = onGetWxFace,
		[pt_gate.SUB_GP_GETRICHLIST_RESULT] = onGetRichlistResult,
		[pt_gate.SUB_GP_CHATINFO_RESULT] = onChatInfoResult,
		[pt_gate.SUB_GP_GETCHATINFO_RESULT] = onGetChatInfoResult,
		[pt_gate.SUB_GP_GETCHATINFO_END] = onGetChatInfoEnd,
		[pt_gate.SUB_GP_GETMATCHRANDLIST_RESULT] = onRequestMatchRank,
		[pt_gate.SUB_GP_MATCHPRICEGET_RESULT] = onTakeEmailReward,
	},
	[pt_gate.MDM_APP] = {
		[pt_gate.SUB_APP_USER_STATUS] = onAppUserStatus,
		[pt_gate.SUB_APP_SITDOWN_RESUALT] = onAppSitdown,
		[pt_gate.SUB_APP_GET_SERVER_SUCCESS] = onAppGetServerSuccess,
		[pt_gate.SUB_APP_GET_SERVER_FAILURE] = onAppGetServerFailure,
	},
	[pt_gate.MDM_COIN_DEVICE] = {
		[pt_gate.SUB_COIN_MBLOGON_RESULT] = onCoinMBLogin,
		[pt_gate.SUB_COIN_MBINFO_RESULT] = onCoinMBInfo,
		[pt_gate.SUN_COIN_MBUPSCORE_RESULT] = onCoinMBUpScore,
		[pt_gate.SUN_COIN_MBDOWNSCORE_RESUL] = onCoinMBDownScore,
	},
	[pt_gate.MDM_PAIMAIHANG] = {
		[pt_gate.SUB_PMH_UPPROP_RESULT] = onPutaway,
		[pt_gate.SUB_PMH_BUYPROP_RESULT] = onBuyCommodity,
		[pt_gate.SUB_PMH_USERINFO_RESULT] = onRequireUserInfo,
		[pt_gate.SUB_PMH_USERINFO_MODIFY_RESULT] = onUpdateUserInfo,
		[pt_gate.SUB_PMH_USERINFONEW_RESULT] = onGetUserInfoNew,
		[pt_gate.SUB_PMH_USERINFONEW_MODIFY_RESULT] = onUserInfoUpdateNew,
	},
}

function onGateData( buffObj )
	local mainCmd = buffObj:getMainCmd()
	local subCmd = buffObj:getSubCmd()

	cclog(" onGateData MainCmd:%d SubCmd:%d", mainCmd, subCmd)

	local mainTbl = gtNetHandler[mainCmd]
	if mainTbl and mainTbl[subCmd] then
		local fun = mainTbl[subCmd]
		fun( buffObj )
	else
		cclog("in onGateData unmatch MainCmd:%d SubCmd:%d", mainCmd, subCmd )
	end
end

function onGateConnsucc( buffObj )
	-- 连接成功
	netmng.g_gt_conn = netmng.NET_CONN
	netmng.sendAllGtData()
	cclog("onGateRecv recvBuff.eRecvType_connsucc %d ip: %s port: %d", recvBuff.eRecvType_connsucc, GATE_SERV_IP, GATE_SERV_PORT )
end

function onGateConnfail( buffObj )
	-- 连接失败
	netmng.g_gt_init = false
	netmng.g_gt_conn = netmng.NET_DISCONN
	netmng.gt_offline_packet_tbl_ = {}
	cclog("onGateConnfail ip: %s port: %d", GATE_SERV_IP, GATE_SERV_PORT )

	LoadingView.closeTips()
end

function onGateConnlost( buffObj )
	netmng.g_gt_init = false
	netmng.g_gt_conn = netmng.NET_DISCONN
	netmng.gt_offline_packet_tbl_ = {}
	cclog("onGateConnlost ip: %s port: %d", GATE_SERV_IP, GATE_SERV_PORT )

	LoadingView.closeTips()
end

fun_tbl = {
	[ recvBuff.eRecvType_data ] = onGateData,
	[ recvBuff.eRecvType_connsucc ] = onGateConnsucc,
	[ recvBuff.eRecvType_connfail ] = onGateConnfail,
	[ recvBuff.eRecvType_lost ] = onGateConnlost;
}

function onGateRecvHandler( buffObj )
	local tp = buffObj:getType()
	local fun = fun_tbl[ tp ] 
	if not fun then
			cclog("in onGateRecvHandler unmatch tp: %d", pt )
			return 
	end

	fun( buffObj )
end