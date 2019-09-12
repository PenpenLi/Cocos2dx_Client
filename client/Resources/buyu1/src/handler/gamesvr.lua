module( "gamesvr", package.seeall )

gsNetHandler[pt.MDM_GF_GAME] = {
	[pt.SUB_S_GAME_CONFIG] = onGameConfig,
	[pt.SUB_S_FISH_TRACE] = onFishTrace,
	[pt.SUB_S_EXCHANGE_FISHSCORE] = onExchangeFishScore,
	[pt.SUB_S_USER_FIRE] = onUserFire,
	[pt.SUB_S_CATCH_FISH] = onCatchFish,
	[pt.SUB_S_BULLET_ION_TIMEOUT] = OnBulletIonTimeout,
	[pt.SUB_S_LOCK_TIMEOUT] = onLockTimeout,
	--[pt.SUB_S_CATCH_SWEEP_FISH] = onCatchSweepFish,
	--[pt.SUB_S_CATCH_SWEEP_FISH_RESULT] = onCatchSweepFishResult,
	[pt.SUB_S_HIT_FISH_LK] = onHitFishLK,
	[pt.SUB_S_SWITCH_SCENE] = onSwitchScene,
	[pt.SUB_S_SCENE_END] = onSceneEnd,
	[pt.SUB_S_FIRESPEED_FLAG] = onFireSpeedFlag,
	[pt.SUB_S_MACTH_TOP] = onMatchTop,

	-- [pt.SUB_S_RED_ENVELOPE_FLAG] = onRedEnvelopeFlag,
	-- [pt.SUB_S_RED_ENVELOPE_SEND] = onRedEnvelopeSend,
	[pt.SUB_S_FISH_LINE] = onFishLine,
}

gsNetHandler[pt.MDM_GF_FRAME] = {
	[pt.SUB_GF_GAME_STATUS] = onGameStatus,
	[pt.SUB_GF_MESSAGE] = onSystemMessage,
	[pt.SUB_GF_SCENE] = OnGameSceneMessage,
}