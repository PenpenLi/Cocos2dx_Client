module( "gamesvr", package.seeall )

gsNetHandler[pt.MDM_GF_GAME] = {
	
    [pt.SUB_GAME_OPTION] = onSubGameOption, -- 参数获取
    [pt.SUB_GAME_STARTBACK] = onSubGameStartBack, -- 客户端请求开始游戏 服务端返回消息
    [pt.SUB_GAME_EATBACK] = onSubGameEatBack, -- 消除返回  
    [pt.SUB_GAME_DIRECTIONBACK] = onSubGameDirectionBack, -- 客户端请求屏幕方向 服务端返回的消息  
}

gsNetHandler[pt.MDM_GF_FRAME] = {
	
}

function _exit_wacaibao()
    print("退出wacaibao---------------------------------------------------------")

    require_ex("main.src.prot.pt_gate")
    require_ex("main.src.prot.pt_game")
    require_ex("main.src.handler.gt_login_handler")
    require_ex("main.src.handler.gt_hall_handler")
    require_ex("main.src.handler.gatesvr")
    require_ex("main.src.handler.gs_room_handler")
    require_ex("main.src.handler.gs_config_handler")
    require_ex("main.src.handler.gamesvr")

    changeOrientation(0)
    local director = cc.Director:getInstance()
    local glview = director:getOpenGLView()
    -- glview:setFrameSize(g_wcb_window_size.width, g_wcb_window_size.height)
    glview:setFrameSize(LANDSCAPE_FRAME_SIZE.width, LANDSCAPE_FRAME_SIZE.height)
    display.setAutoScale(CC_DESIGN_RESOLUTION)
    display.centerWindows()
    -- glview:setDesignResolutionSize(1280, 720, cc.ResolutionPolicy.FIXED_WIDTH)

    UnloadSound()

    replaceScene(LoginScene, TRANS_CONST.TRANS_SCALE)
    -- local layer = createObj(login_scene_t)
    -- replaceScene(layer:getCCScene(),layer)

    --声量
    local musicVolume = global.g_mainPlayer:getMusicVolume()
    local effectVolume = global.g_mainPlayer:getEffectVolume()
    AudioEngine.setMusicVolume(musicVolume)
    AudioEngine.setEffectsVolume(effectVolume)

    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
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
							_exit_wacaibao()
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