module("gamesvr", package.seeall)

--游戏命令
gsNetHandler[pt.MDM_GF_GAME] = {
    --receive
    [pt.SUB_GF_GAME_ATT2_StartJettonResult] = onStartJettonResult,
    [pt.SUB_GF_GAME_ATT2_DealCardResult] = onDealCardResult,
    [pt.SUB_GF_GAME_ATT2_SwitchCardResult] = onSwitchCardResult,
    [pt.SUB_GF_GAME_ATT2_CompareCardResult] = onCompareCardResult,
    [pt.SUB_GF_GAME_ATT2_GameEndResult] = onGameEndResult,
    [pt.SUB_GF_GAME_ATT2_GameFrameResult] = onGameFrameResult,
    --send
}

--框架命令
gsNetHandler[pt.MDM_GF_FRAME] = {
    [pt.SUB_GF_GAME_STATUS] = onGameStatus,
    [pt.SUB_GF_MESSAGE] = onSystemMessage,
    [pt.SUB_GF_SCENE] = onGameScene,
}