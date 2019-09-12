module( "SoundManager", package.seeall )


local sound_items = 
{
    [100] = {path = "caidaxiao/res/sound/movie.mp3", effect = false},
    [5] = {path = "caidaxiao/res/sound/luzhisheng.mp3", effect = true},
    [0] = {path = "caidaxiao/res/sound/shuihuchuan.mp3", effect = true},
    [1] = {path = "caidaxiao/res/sound/zhongyitang.mp3", effect = true},
    [2] = {path = "caidaxiao/res/sound/titianxingdao.mp3", effect = true},
    [3] = {path = "caidaxiao/res/sound/songjiang.mp3", effect = true},
    [4] = {path = "caidaxiao/res/sound/linchong.mp3", effect = true},
    [6] = {path = "caidaxiao/res/sound/linchong.mp3", effect = true},
    [7] = {path = "caidaxiao/res/sound/linchong.mp3", effect = true},
    [8] = {path = "caidaxiao/res/sound/linchong.mp3", effect = true},



    [15] = {path = "caidaxiao/res/sound/daoguang.mp3", effect = true},
    [16] = {path = "caidaxiao/res/sound/gundong.mp3", effect = true},
    [17] = {path = "caidaxiao/res/sound/xiongdiwushu.mp3", effect = false},
    [18] = {path = "caidaxiao/res/sound/shangfen.mp3", effect = true},
    [19] = {path = "caidaxiao/res/sound/defen.wav", effect = true},
    [20] = {path = "caidaxiao/res/sound/xiabi.wav", effect = true},
    [21] = {path = "caidaxiao/res/sound/gundong.wav", effect = true},
    [22] = {path = "caidaxiao/res/sound/bibeibgsound.wav", effect = false},
    [23] = {path = "caidaxiao/res/sound/xia.wav", effect = true},
    [25] = {path = "caidaxiao/res/sound/xia.wav", effect = true},
    [24] = {path = "caidaxiao/res/sound/yaosaizi.mp3", effect = true},


    [102] = {path = "caidaxiao/res/sound/2dian.mp3", effect = true},
    [103] = {path = "caidaxiao/res/sound/3dian.mp3", effect = true},
    [104] = {path = "caidaxiao/res/sound/4dian.mp3", effect = true},
    [105] = {path = "caidaxiao/res/sound/5dian.mp3", effect = true},
    [106] = {path = "caidaxiao/res/sound/6dian.mp3", effect = true},
    [107] = {path = "caidaxiao/res/sound/7dian.mp3", effect = true},
    [108] = {path = "caidaxiao/res/sound/8dian.mp3", effect = true},
    [109] = {path = "caidaxiao/res/sound/9dian.mp3", effect = true},
    [110] = {path = "caidaxiao/res/sound/10dian.mp3", effect = true},
    [111] = {path = "caidaxiao/res/sound/11dian.mp3", effect = true},
    [112] = {path = "caidaxiao/res/sound/12dian.mp3", effect = true},
    [113] = {path = "caidaxiao/res/sound/shu.mp3", effect = true},
    [114] = {path = "caidaxiao/res/sound/ying.mp3", effect = true},
    [115] = {path = "caidaxiao/res/sound/winsound.mp3", effect = true},
    [116] = {path = "caidaxiao/res/sound/gundong_1.mp3", effect = true},    
}

function PlaySound( id )
    local item = sound_items[id]
    
    if item.effect then
        AudioEngine.playEffect(item.path)
    else
        AudioEngine.playMusic(item.path, true)
    end
end

  