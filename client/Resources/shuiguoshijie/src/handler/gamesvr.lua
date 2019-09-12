module( "gamesvr", package.seeall )

gsNetHandler[pt.MDM_GF_GAME] = {
	[pt.SUB_GF_GAME_FRUIT_YAFENRESULT] = onYafenResult,
	[pt.SUB_GF_GAME_FRUIT_XUYA] = onFruitXuya,
	[pt.SUB_GF_GAME_FRUIT_START] = onFruitStart,
	[pt.SUB_GF_GAME_FRUIT_BIBEI] = onFruitBibei,
	[pt.SUB_GF_GAME_FRUIT_BAOJI] = onFruitBaoji,
	[pt.SUB_GF_UPDATESCORE]=onUpDateScore,
    [pt.SUB_GF_GAME_FRUIT_QUXIAOYAFEN_RES]=onCancleYafenRes,
}

gsNetHandler[pt.MDM_GF_FRAME] = {
	[pt.SUB_GF_GAME_STATUS] = onGameStatus,
	[pt.SUB_GF_MESSAGE] = onSystemMessage,
	[pt.SUB_GF_SCENE] = onGameScene,
}

function _exit_shuiguoshijie()
  require_ex ("main.src.prot.pt_gate")
	require_ex ("main.src.prot.pt_game")
	require_ex ("main.src.handler.gt_login_handler")
	require_ex ("main.src.handler.gt_hall_handler")
	require_ex ("main.src.handler.gatesvr")
	require_ex ("main.src.handler.gs_room_handler")
	require_ex ("main.src.handler.gs_config_handler")
	require_ex ("main.src.handler.gamesvr")

	UnloadSound()
	changeOrientation(0)

	local director = cc.Director:getInstance()
	local glview = director:getOpenGLView()
	-- local frame_size = glview:getFrameSize()
	-- if cc.PLATFORM_OS_WINDOWS ~= PLATFROM then
	-- 	glview:setFrameSize(frame_size.height, frame_size.width)
	-- else
	-- 	glview:setFrameSize(1280, 720)
	-- end 
	glview:setFrameSize(LANDSCAPE_FRAME_SIZE.width, LANDSCAPE_FRAME_SIZE.height)
	display.setAutoScale(CC_DESIGN_RESOLUTION)
	display.centerWindows()

	replaceScene(LoginScene, TRANS_CONST.TRANS_SCALE)
	-- local layer = createObj(login_scene_t)
	-- replaceScene(layer:getCCScene(),layer)

	--声量
	local musicVolume = global.g_mainPlayer:getMusicVolume()
	local effectVolume = global.g_mainPlayer:getEffectVolume()
	AudioEngine.setMusicVolume(musicVolume)
	AudioEngine.setEffectsVolume(effectVolume)

	cc.Director:getInstance():getTextureCache() :removeUnusedTextures()
	collectgarbage("collect")
	collectgarbage("collect")
	collectgarbage("collect")
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
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAME_SERVER_CONNECT_LOST)

		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_1d9814824414b827"),
					style = WarnTips.STYLE_Y,
					confirm = function()
							_exit_shuiguoshijie()
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