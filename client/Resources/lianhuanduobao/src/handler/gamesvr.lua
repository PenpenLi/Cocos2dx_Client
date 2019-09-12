module( "gamesvr", package.seeall )

-- SUB_S_GAME_START = 701 --游戏开始,初始化界面信息
-- SUB_S_NEXT_GAME = 702 --发送宝石布局
-- SUB_S_GAME_END = 703 --游戏结束,写分
-- SUB_S_EXIT = 704 --退出

gsNetHandler[pt.MDM_GF_GAME] = {
	[pt.SUB_S_GAME_START] = onSubGameStart,--游戏开始,初始化界面信息
	[pt.SUB_S_NEXT_GAME] = onSubNextGame,--发送宝石布局
	[pt.SUB_S_GAME_END] = onSubGameEnd,--游戏结束,写分
	[pt.SUB_S_EXIT] = onSubGameExit,--退出
}

gsNetHandler[pt.MDM_GF_FRAME] = {
	-- [pt.SUB_GF_GAME_STATUS] = onGameStatus,
	-- [pt.SUB_GF_MESSAGE] = onSystemMessage,
	[pt.SUB_GF_SCENE] = onGameScene,
}