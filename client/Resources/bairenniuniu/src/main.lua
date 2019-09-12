function start_bairenniuniu()
	cclog("start_bairenniuniu")
	cc.FileUtils:getInstance():setPopupNotify(false)

	require_ex ("bairenniuniu.src.global.global")
	require_ex ("bairenniuniu.src.data.GameData")
	require_ex ("bairenniuniu.src.util.common")
	require_ex ("bairenniuniu.src.prot.pt")
	require_ex ("bairenniuniu.src.handler.gs_cow_handler")
	require_ex ("bairenniuniu.src.handler.gamesvr")
	require_ex ("bairenniuniu.src.scene.LoadScene")
	require_ex ("bairenniuniu.src.scene.GameScene")

	require_ex ("bairenniuniu.src.ui.ToubiView")
	require_ex ("bairenniuniu.src.ui.SettleView")
	require_ex ("bairenniuniu.src.ui.SettingView")
	require_ex ("bairenniuniu.src.ui.HelpView")

	LoadSound()

	global.g_gameData = GameData.new()

	replaceScene(LoadScene, TRANS_CONST.TRANS_SCALE)

	--声量
	local music_percent = global.g_mainPlayer:getLocalData("bairenniuniu_music", 100)
	AudioEngine.setMusicVolume(music_percent/100)
	local effect_percent = global.g_mainPlayer:getLocalData("bairenniuniu_effect", 100)
	AudioEngine.setEffectsVolume(effect_percent/100)

	collectgarbage("collect")
end

function exit_bairenniuniu()
  	require_ex ("main.src.prot.pt_gate")
	require_ex ("main.src.prot.pt_game")

	require_ex ("main.src.handler.gt_login_handler")
	require_ex ("main.src.handler.gt_hall_handler")
	require_ex ("main.src.handler.gatesvr")
	require_ex ("main.src.handler.gs_room_handler")
	require_ex ("main.src.handler.gs_config_handler")
	require_ex ("main.src.handler.gamesvr")

	display.setAutoScale(CC_DESIGN_RESOLUTION)
	
	global.g_gameData = nil

	local playerId = global.g_mainPlayer:getPlayerId()
  local pd = global.g_mainPlayer:getRoomPlayer(playerId)
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