module( "gamesvr", package.seeall )

-- SUB_S_GAME_START = 701 --游戏开始,初始化界面信息
-- SUB_S_NEXT_GAME = 702 --发送宝石布局
-- SUB_S_GAME_END = 703 --游戏结束,写分
-- SUB_S_EXIT = 704 --退出

gsNetHandler[pt.MDM_GF_GAME] = {
	[pt.SUB_S_GAME_FREE] = onSubGameFree,
	[pt.SUB_S_GAME_START] = onSubGameStart,
	[pt.SUB_S_PLACE_JETTON] = onSubPlaceJetton,
	[pt.SUB_S_GAME_END] = onSubGameEnd,
	[pt.SUB_S_CHANGE_USER_SCORE] = onSubChangeUserScore,
	[pt.SUB_S_SEND_RECORD] = onSubSendRecord,
	[pt.SUB_S_PLACE_JETTON_FAIL] = onSubPlaceJettonFail,
	[pt.SUB_S_CLEAR_JETTON] = onSubClearJetton,
    [pt.SUB_S_GAME_RESULT] = onSubShowResult,
}

gsNetHandler[pt.MDM_GF_FRAME] = {
	[pt.SUB_GF_GAME_STATUS] = onGameStatus,
	[pt.SUB_GF_SCENE] = onGameScene,
}