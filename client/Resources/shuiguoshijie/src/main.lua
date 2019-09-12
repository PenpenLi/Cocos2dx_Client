

g_frame_size = nil
function start_shuiguoshijie()
	cclog("start_shuiguoshijie")
	cc.FileUtils:getInstance():setPopupNotify(false)

	require_ex ("shuiguoshijie.src.global.global")
	require_ex ("shuiguoshijie.src.util.common")
	require_ex ("shuiguoshijie.src.prot.pt")
	require_ex ("shuiguoshijie.src.handler.gs_fruit_handler")
	require_ex ("shuiguoshijie.src.handler.gamesvr")
	require_ex ("shuiguoshijie.src.scene.LoadScene")
	require_ex ("shuiguoshijie.src.scene.GameScene")
	require_ex ("shuiguoshijie.src.data.UpScoreNote")
	require_ex ("shuiguoshijie.src.data.DownScoreNote")
	require_ex ("shuiguoshijie.src.data.ActionClass")
	require_ex ("shuiguoshijie.src.ui.SettingView")
	require_ex ("shuiguoshijie.src.ui.ui_help")
	LoadSound()

	local director = cc.Director:getInstance()
	local glview = director:getOpenGLView()

	changeOrientation(1)
	glview:setFrameSize(PORTRAIT_FRAME_SIZE.width, PORTRAIT_FRAME_SIZE.height)
	-- glview:setDesignResolutionSize(720, 1280, cc.ResolutionPolicy.FIXED_HEIGHT)
    display.setAutoScale(
            {
                width = 720,
                height = 1280,
                autoscale = "FIXED_HEIGHT",
            }
        )
	display.centerWindows()
	
	replaceScene(LoadScene, TRANS_CONST.TRANS_SCALE)

	--声量
	local music_percent = global.g_mainPlayer:getLocalData("shuiguoshijie_music", 0.2)
	global.g_mainPlayer:setLocalData("shuiguoshijie_music", music_percent)
	AudioEngine.setMusicVolume(music_percent)
	local effect_percent = global.g_mainPlayer:getLocalData("shuiguoshijie_effect", 1)
	global.g_mainPlayer:setLocalData("shuiguoshijie_effect", effect_percent)
	AudioEngine.setEffectsVolume(effect_percent)

	collectgarbage("collect")
end

function exit_shuiguoshijie()
  require_ex ("main.src.prot.pt_gate")
	require_ex ("main.src.prot.pt_game")

	require_ex ("main.src.handler.gt_login_handler")
	require_ex ("main.src.handler.gt_hall_handler")
	require_ex ("main.src.handler.gatesvr")
	require_ex ("main.src.handler.gs_room_handler")
	require_ex ("main.src.handler.gs_config_handler")
	require_ex ("main.src.handler.gamesvr")

	local pd = global.g_mainPlayer:getRoomPlayer(global.g_mainPlayer.playerId_)
	if global.g_bsendexit==true then
		gamesvr.sendExitGame(pd.tableId, pd.chairId)
	end

	UnloadSound()

	changeOrientation(0)
	local director = cc.Director:getInstance()
	local glview = director:getOpenGLView()

	glview:setFrameSize(LANDSCAPE_FRAME_SIZE.width, LANDSCAPE_FRAME_SIZE.height)
	display.setAutoScale(CC_DESIGN_RESOLUTION)
	display.centerWindows()

	local gameId = global.g_mainPlayer:getCurrentGameId()
	replaceScene(SelectRoomScene, TRANS_CONST.TRANS_SCALE, gameId, true)

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

function LoadSound( )
	AudioEngine.stopAllEffects()
	AudioEngine.stopMusic(true)
end

function UnloadSound( )
	AudioEngine.stopAllEffects()
	AudioEngine.stopMusic(true)
	AudioEngine.playMusic("fullmain/res/music/background.mp3", true)
end