module( "gamesvr", package.seeall )

gsNetHandler[pt.MDM_GF_GAME] = {
	[pt.SUB_S_GAME_FREE] = onGameFree, --游戏空闲
	[pt.SUB_S_GAME_PLAY] = onGamePlay,--正在游戏
	[pt.SUB_S_GAME_START] = onGameStart,--游戏开始
	[pt.SUB_S_JETTON] = onGetScore,--玩家下注
	[pt.SUB_S_PLACE_JETTON_FAIL] = onBibeiData,--下注失败
	[pt.SUB_S_GAME_END] = onGameEnd, --游戏结束
	[pt.SUB_S_BIBEIDATAM] = onBibeiStart,--比倍数据 
	[pt.SUB_S_RECORD] = onRecord,--游戏路单
	[pt.SUB_S_JETTONLIST] = onJettonList,--游戏押注数据切换
	
	 
	[pt.SUB_GF_GAME_BAOJI] = onBaoji, --暴击
}

gsNetHandler[pt.MDM_GF_FRAME] = {
	[pt.SUB_GF_GAME_STATUS] = onGameStatus,
	[pt.SUB_GF_GAME_SCENE] = onGameScene,
	[pt.SUB_GF_SYSTEM_MESSAGE] = onSystemMessage,
	[pt.SUB_GF_LOOKON_STATUS] = onLookonStatus,
}