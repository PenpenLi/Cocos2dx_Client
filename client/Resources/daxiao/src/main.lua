function start_daxiao()
	cclog("start_daxiao")
	cc.FileUtils:getInstance():setPopupNotify(false)

	require_ex ("daxiao.src.global.global")
	require_ex ("daxiao.src.util.common")
	require_ex ("daxiao.src.prot.pt")
	-- require_ex ("daxiao.src.cocos.init")
	require_ex ("daxiao.src.handler.gs_bird_handler")
	require_ex ("daxiao.src.handler.gamesvr")
	require_ex ("daxiao.src.scene.LoadScene")
	require_ex ("daxiao.src.scene.GameScene")
	require_ex ("daxiao.src.ui.SettleView")
	require_ex ("daxiao.src.ui.ToubiView")
	require_ex ("daxiao.src.ui.SettingView")

	LoadSound()

	local gameId = global.g_mainPlayer:getCurrentGameId()
	local cfg = games_config[gameId]
	display.setAutoScale(cfg.resolution)
	replaceScene(LoadScene, TRANS_CONST.TRANS_SCALE)
	--声量
	local music_percent = global.g_mainPlayer:getLocalData("daxiao_music", 0.5)
	AudioEngine.setMusicVolume(music_percent)
	local effect_percent = global.g_mainPlayer:getLocalData("daxiao_effect", 0.5)
	AudioEngine.setEffectsVolume(effect_percent)

	collectgarbage("collect")
end

function exit_daxiao()
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

	netmng.gsClose()

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

function LoadSound( )
	AudioEngine.stopAllEffects()
	AudioEngine.stopMusic(true)
end

function UnloadSound( )
	AudioEngine.stopAllEffects()
	AudioEngine.stopMusic(true)
	AudioEngine.playMusic("fullmain/res/music/background.mp3", true)
end