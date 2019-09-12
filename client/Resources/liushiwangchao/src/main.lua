function start_liushiwangchao()
	cclog("start_liushiwangchao...........")
	cc.FileUtils:getInstance():setPopupNotify(false)

	require_ex ("liushiwangchao.src.util.common")
	require_ex ("liushiwangchao.src.prot.pt")
	require_ex ("liushiwangchao.src.handler.gs_lswc_handler")
	require_ex ("liushiwangchao.src.handler.gamesvr")
	require_ex ("liushiwangchao.src.scene.GameScene")
	require_ex ("liushiwangchao.src.ui.ExitView")
	require_ex ("liushiwangchao.src.ui.HelpView")
	require_ex ("liushiwangchao.src.ui.SettingView")
	require_ex ("liushiwangchao.src.ui.RecordView")
	require_ex ("liushiwangchao.src.ui.BetView")
	require_ex ("liushiwangchao.src.ui.ResultView")

	LoadSound()

	local gameId = global.g_mainPlayer:getCurrentGameId()
	local cfg = games_config[gameId]
	display.setAutoScale(cfg.resolution)
	replaceScene(GameScene, TRANS_CONST.TRANS_DELAY)

	--声量
	local music_percent = global.g_mainPlayer:getLocalData("liushiwangchao_music", 0.5)
	AudioEngine.setMusicVolume(music_percent)
	local effect_percent = global.g_mainPlayer:getLocalData("liushiwangchao_effect", 0.5)
	AudioEngine.setEffectsVolume(effect_percent)

	collectgarbage("collect")
end
function exit_liushiwangchao()
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
	replaceScene(SelectRoomScene, TRANS_CONST.TRANS_SCALE, gameId, true)

	--声量
	local musicVolume = global.g_mainPlayer:getMusicVolume()
	local effectVolume = global.g_mainPlayer:getEffectVolume()
	AudioEngine.setMusicVolume(musicVolume)
	AudioEngine.setEffectsVolume(effectVolume)

	cc.Director:getInstance():getTextureCache():removeUnusedTextures()
	collectgarbage("collect")

	gatesvr.sendInsureInfoQuery(true)
	netmng.gsClose()
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