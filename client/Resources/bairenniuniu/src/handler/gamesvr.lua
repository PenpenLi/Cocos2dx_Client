module( "gamesvr", package.seeall )
print(pt.MDM_GF_GAME,"11111111111111111")
print(pt.MDM_GF_FRAME,"22222222222222222")
gsNetHandler[pt.MDM_GF_GAME] = {
	[pt.SUB_GF_S_GAME_HUNDRED_BEEF_GameFree]  		= onGameFree,
	[pt.SUB_GF_S_GAME_HUNDRED_BEEF_GameStart] 		= onGameStart,
	[pt.SUB_GF_S_GAME_HUNDRED_BEEF_GameEnd] 		= onGameEnd,
	[pt.SUB_GF_S_GAME_HUNDRED_BEEF_PlaceJetton] 	= onPlaceJetton,
	[pt.SUB_GF_S_GAME_HUNDRED_BEEF_ApplyBanker] 	= onApplyBanker,
	[pt.SUB_GF_S_GAME_HUNDRED_BEEF_ChangeBanker]	= onChangeBanker,
	[pt.SUB_GF_S_GAME_HUNDRED_BEEF_UpdateScore] 	= onUpdateUserScore,
	[pt.SUB_GF_S_GAME_HUNDRED_BEEF_PlaceJettonFail] = onPlaceJettonFail,
	[pt.SUB_GF_S_GAME_HUNDRED_BEEF_ApplyCancel] 	= onApplyCancel,
	[pt.SUB_GF_S_GAME_HUNDRED_BEEF_UserInfo] 		= onUserInfo,
	[pt.SUB_GF_S_GAME_HUNDRED_BEEF_UserEnter] 		= onUserEnter,
	[pt.SUB_GF_S_GAME_HUNDRED_BEEF_UserExit] 		= onUserExit,
	[pt.SUB_GF_S_GAME_HUNDRED_BEEF_Info] = onToubiInfo,
}

gsNetHandler[pt.MDM_GF_FRAME] = {
	[pt.SUB_GF_GAME_STATUS] = onGameStatus,
	[pt.SUB_GF_MESSAGE] 	= onSystemMessage,
	[pt.SUB_GF_SCENE] 		= onGameScene,
}