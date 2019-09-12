--音乐工具类
module("MusicUtil", package.seeall)

isPlayMusic=true;


--停止全部音乐
function stopAll()
    AudioEngine.stopMusic()
    global.g_attPlayer:setMusicVolume(0)
    isPlayMusic=false;
end

--启动全部音乐
function startAll()
    backGround()
    global.g_attPlayer:setMusicVolume(0.5)
    isPlayMusic=true;
end

--启动背景音乐
function backGround()
    --AudioEngine.playEffect("att2/res/music/")
end

--选中一台机器后，启动att2_music_joinRoom音乐
function joinGame()
    if isPlayMusic == true then
        AudioEngine.playEffect("att2/res/music/att2_music_joinGame.mp3")
    end
end

--启动att2_music_win4k音乐
function win4k()
    if isPlayMusic == true then
        AudioEngine.playEffect("att2/res/music/att2_music_win4k.mp3")
    end
end

--启动att2_music_win5k音乐
function win5k()
    if isPlayMusic == true then
        AudioEngine.playEffect("att2/res/music/att2_music_win5k.mp3")
    end
end

--【比倍】、【大】、【小】按钮，启动att2_music_compare音乐
function compare()
    if isPlayMusic == true then
        AudioEngine.playEffect("att2/res/music/att2_music_compare.mp3")
    end
end

--猜中大小，启动att2_music_compareWin音乐
function compareWin()
    if isPlayMusic == true then
        AudioEngine.playEffect("att2/res/music/att2_music_compareWin.mp3")
    end
end

--第一次发牌，点【开始】按钮，启动att2_music_dealCard音乐
function dealCard()
    if isPlayMusic == true then
        AudioEngine.playEffect("att2/res/music/att2_music_dealCard.mp3")
    end
end

--有牌，启动att2_music_haveCard音乐
function haveCard()
    if isPlayMusic == true then
        AudioEngine.playEffect("att2/res/music/att2_music_haveCard.mp3")
    end
end

--点【下注】按钮，启动att2_music_jetton音乐
function jetton()
    if isPlayMusic == true then
        AudioEngine.playEffect("att2/res/music/att2_music_jetton.mp3")
    end
end

--点【第1张牌】，held或者取消，启动att2_music_keep_card1音乐
function keepCard1()
    if isPlayMusic == true then
        AudioEngine.playEffect("att2/res/music/att2_music_keepCard1.mp3")
    end
end

--点【第2张牌】，held或者取消，启动att2_music_keep_card2音乐
function keepCard2()
    if isPlayMusic == true then
        AudioEngine.playEffect("att2/res/music/att2_music_keepCard2.mp3")
    end
end

--点【第3张牌】，held或者取消，启动att2_music_keep_card3音乐
function keepCard3()
    if isPlayMusic == true then
        AudioEngine.playEffect("att2/res/music/att2_music_keepCard3.mp3")
    end
end

--点【第4张牌】，held或者取消，启动att2_music_keep_card4音乐
function keepCard4()
    if isPlayMusic == true then
        AudioEngine.playEffect("att2/res/music/att2_music_keepCard4.mp3")
    end
end

--点【第5张牌】，held或者取消，启动att2_music_keep_card5音乐
function keepCard5()
    if isPlayMusic ==true then
        AudioEngine.playEffect("att2/res/music/att2_music_keepCard5.mp3")
    end
end

--不中奖，启动att2_music_no_card音乐
function noCard()
    if isPlayMusic ==true then
        AudioEngine.playEffect("att2/res/music/att2_music_noCard.mp3")
    end
end

--启动att2_music_winRS音乐
function winRS()
    if isPlayMusic ==true then
        AudioEngine.playEffect("att2/res/music/att2_music_winRS.mp3")
    end
end

--启动att2_music_winSF音乐
function winSF()
    if isPlayMusic ==true then
        AudioEngine.playEffect("att2/res/music/att2_music_winSF.mp3")
    end
end


