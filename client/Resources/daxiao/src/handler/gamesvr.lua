module( "gamesvr", package.seeall )

gsNetHandler[pt.MDM_GF_GAME] = {
	[pt.SUB_GF_GAME_BIRD_GamePlaceJettonResult] = onJettonResult,
	[pt.SUB_GF_GAME_BIRD_GameFreeResult] = onFreeResult,
	[pt.SUB_GF_GAME_BIRD_GameStartResult] = onStartResult,
	[pt.SUB_GF_GAME_BIRD_GameEndResult] = onEndResult,
	[pt.SUB_S_SEND_RECORD] = onGameRecord,
	[pt.SUB_S_PLACE_JETTON_FAIL] = onJettonFailure,
	--[pt.SUB_GF_GAME_BIRD_ClearJettonResult] = onJettonCleanResult,
	[pt.SUB_GF_GAME_BIRD_ContinueJettonResult] = onJettonContinueResult,
	[pt.SUB_GF_GAME_BIRD_BAOJI] = onBaoJi,
}

gsNetHandler[pt.MDM_GF_FRAME] = {
	[pt.SUB_GF_GAME_STATUS] = onGameStatus,
	[pt.SUB_GF_MESSAGE] = onSystemMessage,
	[pt.SUB_GF_SCENE] = onGameScene,
}