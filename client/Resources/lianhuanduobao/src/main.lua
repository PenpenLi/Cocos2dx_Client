function start_lianhuanduobao()
	cclog("start_lianhuanduobao")
	cc.FileUtils:getInstance():setPopupNotify(false)

	require_ex ("lianhuanduobao.src.util.common")
	require_ex ("lianhuanduobao.src.util.LHDBLogic")
	require_ex ("lianhuanduobao.src.prot.pt")
	require_ex ("lianhuanduobao.src.handler.gs_lhdb_handler")
	require_ex ("lianhuanduobao.src.handler.gamesvr")
	require_ex ("lianhuanduobao.src.scene.LoadScene")
	require_ex ("lianhuanduobao.src.scene.GameScene")
	require_ex ("lianhuanduobao.src.scene.DragonBall")
	require_ex ("lianhuanduobao.src.ui.ExitView")
	require_ex ("lianhuanduobao.src.ui.HelpView")
	require_ex ("lianhuanduobao.src.ui.AwardView")

	LoadSound()

	local director = cc.Director:getInstance()
	local glview = director:getOpenGLView()
	-- glview:setDesignResolutionSize(1024, 768, cc.ResolutionPolicy.EXACT_FIT)
	local gameId = global.g_mainPlayer:getCurrentGameId()
	local cfg = games_config[gameId]
	display.setAutoScale(cfg.resolution)
	replaceScene(GameScene, TRANS_CONST.TRANS_SCALE)

	--声量
	local music_percent = global.g_mainPlayer:getLocalData("lianhuanduobao_music", 0.5)
	AudioEngine.setMusicVolume(music_percent)
	local effect_percent = global.g_mainPlayer:getLocalData("lianhuanduobao_effect", 0.5)
	AudioEngine.setEffectsVolume(effect_percent)

	collectgarbage("collect")
end

function exit_lianhuanduobao()
	print('exit_lianhuanduobao')
  	require_ex ("main.src.prot.pt_gate")
	require_ex ("main.src.prot.pt_game")

	require_ex ("main.src.handler.gt_login_handler")
	require_ex ("main.src.handler.gt_hall_handler")
	require_ex ("main.src.handler.gatesvr")
	require_ex ("main.src.handler.gs_room_handler")
	require_ex ("main.src.handler.gs_config_handler")
	require_ex ("main.src.handler.gamesvr")

	display.setAutoScale(CC_DESIGN_RESOLUTION)

	local pd = global.g_mainPlayer:getRoomPlayer(global.g_mainPlayer.playerId_)
	gamesvr.sendExitGame(pd.tableId, pd.chairId)
	UnloadSound()

	local gameId = global.g_mainPlayer:getCurrentGameId()
	replaceScene(SelectRoomScene, TRANS_CONST.TRANS_SCALE, gameId)

	--声量
	local musicVolume = global.g_mainPlayer:getMusicVolume()
	local effectVolume = global.g_mainPlayer:getEffectVolume()
	AudioEngine.setMusicVolume(musicVolume)
	AudioEngine.setEffectsVolume(effectVolume)

	cc.Director:getInstance():getTextureCache():removeUnusedTextures()
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