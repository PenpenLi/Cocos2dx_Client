module( "gamesvr", package.seeall )

gsNetHandler = {
	[pt_game.MDM_MB_LOGON] = {
		[pt_game.SUB_GP_LOGON_SUCCESS] = onLoginForRoomListSuccess,
		[pt_game.SUB_GP_LOGON_ERROR] = onLoginForRoomListFailed,
		[pt_game.SUB_GP_LOGON_FINISH] = onLoginForRoomListFinish,
		[pt_game.SUB_GP_LOGON_REPLACE] = onLoginForRoomAgain,
	},
	[pt_game.MDM_MB_SERVER_LIST] = {
		[pt_game.SUB_MB_LIST_SERVER] = onRoomList,
		[pt_game.SUB_MB_LIST_MATCH] = onMatchList,
		[pt_game.SUB_MB_LIST_FINISH] = onListFinish,
	},
	[pt_game.MDM_KN_COMMAND] = {
		[pt_game.SUB_KN_DETECT_SOCKET] = onHeartbeat,
	},
	[pt_game.MDM_GR_LOGON] = {
		[pt_game.SUB_GR_LOGON_SUCCESS] = onLoginRoomSuccess,
		[pt_game.SUB_GR_LOGON_FAILURE] = onLoginRoomFailed,
		[pt_game.SUB_GR_LOGON_FINISH] = onLoginRoomFinished,
		[pt_game.SUB_GR_UPDATE_NOTIFY] = onUpdateNotify,
	},
	[pt_game.MDM_GR_CONFIG] = {
		[pt_game.SUB_GR_CONFIG_SERVER] = onConfigRoom,
		[pt_game.SUB_GR_CONFIG_FINISH] = onConfigFinish,
	},
	[pt_game.MDM_GR_USER] = {
		[pt_game.SUB_GR_USER_COME] = onRoomUserCome,
		[pt_game.SUB_GR_USER_SCORE] = onRoomUserScore,
		[pt_game.SUB_GR_USER_STATUS] = onRoomUserStatus,
		[pt_game.SUB_GR_SIT_FAILED] = onRoomUserSitFailed,
		[pt_game.SUB_GR_USER_WAIT_DISTRUBUTE] = onRoomUserWaitDistrubute,
	},
	[pt_game.MDM_GR_STATUS] = {
		[pt_game.SUB_GR_TABLE_INFO] = onRoomTableInfo,
		[pt_game.SUB_GR_TABLE_STATUS] = onRoomTableStatus,
	},
	[pt_game.MDM_CM_SYSTEM] = {
		[pt_game.SUB_CM_SYSTEM_MESSAGE] = onSystemMessage,
	},
	[pt_game.MDM_GR_APP] = {
		[pt_game.SUB_GR_S_APP_LOGON_SUCCESS] = onAppLoginSuccess,
		[pt_game.SUB_GR_S_APP_LOGON_FAILURE] = onAppLoginFailure,
		[pt_game.SUB_GR_S_APP_SENDMSG] = onAppSendMsg,
	},
}

function onGsData( buffObj )
	local mainCmd = buffObj:getMainCmd()
	local subCmd = buffObj:getSubCmd()

	cclog(" onGsData MainCmd:%d SubCmd:%d", mainCmd, subCmd)
	local mainTbl = gsNetHandler[mainCmd]
	if mainTbl and mainTbl[subCmd] then
		local fun = mainTbl[subCmd]
		fun( buffObj )
	else
		cclog("in onGsData unmatch MainCmd:%d SubCmd:%d", mainCmd, subCmd )
	end
end

function onGsConnsucc( buffObj )
	-- 连接成功
	netmng.g_gs_ask_for_close = false
	netmng.g_gs_conn = netmng.NET_CONN
	netmng.sendAllGsData()
	cclog("onGsConnsucc ip: %s port: %d", netmng.GS_SERV_IP, netmng.GS_SERV_PORT )

	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAME_SERVER_CONNECT_SUCCESS)
end

function onGsConnfail( buffObj )
	-- 掉线
	netmng.g_gs_init = false
	netmng.g_gs_ask_for_close = false
	netmng.g_gs_conn = netmng.NET_DISCONN
	netmng.gs_offline_packet_tbl_ = {}
	cclog("onGsConnfail ip: %s port: %d", netmng.GS_SERV_IP, netmng.GS_SERV_PORT )

	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAME_SERVER_CONNECT_FAILED)

	LoadingView.closeTips()
end

function onGsConnlost( buffObj )
	netmng.g_gs_init = false
	netmng.g_gs_conn = netmng.NET_DISCONN
	netmng.gs_offline_packet_tbl_ = {}
	cclog("onGsConnlost ip: %s port: %d", netmng.GS_SERV_IP, netmng.GS_SERV_PORT )

	if netmng.g_gs_ask_for_close then
		--主动断开
	else
		--被动断开
		LoadingView.closeTips()
		
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAME_SERVER_CONNECT_LOST)

		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_1d9814824414b827"),
					style = WarnTips.STYLE_Y,
					confirm = function()
							display.setAutoScale(CC_DESIGN_RESOLUTION)

							require_ex ("main.src.prot.pt_gate")
							require_ex ("main.src.prot.pt_game")
							require_ex ("main.src.handler.gt_login_handler")
							require_ex ("main.src.handler.gt_hall_handler")
							require_ex ("main.src.handler.gatesvr")
							require_ex ("main.src.handler.gs_room_handler")
							require_ex ("main.src.handler.gs_config_handler")
							require_ex ("main.src.handler.gamesvr")
							
							-- local layer = createObj(login_scene_t)
							-- replaceScene(layer:getCCScene(),layer)
							replaceScene(LoginScene, TRANS_CONST.TRANS_SCALE)
						end,
				}
			)
	end
	netmng.g_gs_ask_for_close = false
end

fun_tbl = {
	[ recvBuff.eRecvType_data ] = onGsData,
	[ recvBuff.eRecvType_connsucc ] = onGsConnsucc,
	[ recvBuff.eRecvType_connfail ] = onGsConnfail,
	[ recvBuff.eRecvType_lost ] = onGsConnlost,
}

function onGsRecvHandler( buffObj )
	local tp = buffObj:getType()
	local fun = fun_tbl[ tp ] 
	if not fun then
		cclog("in onGsRecv unmatch tp: %d", pt )
		return 
	end

	fun( buffObj )
end
