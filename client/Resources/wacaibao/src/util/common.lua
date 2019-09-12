
textureCache = cc.Director:getInstance():getTextureCache()
frameCache = cc.SpriteFrameCache:getInstance() 

-- 消息常量 

GAME_MESSAGE_GAME_OPTION = "GAME_MESSAGE_GAME_OPTION"  -- 获取参数
GAME_MESSAGE_GAME_STARTBACK = "GAME_MESSAGE_GAME_STARTBACK"  -- 客户端请求开始游戏 服务端返回的消息 
GAME_MESSAGE_GAME_EATBACK = "GAME_MESSAGE_GAME_EATBACK" -- 客户端发送消除给服务端 服务端返回的消息
GAME_MESSAGE_GAME_DIRECTIONBACK = "GAME_MESSAGE_GAME_DIRECTIONBACK" -- 客户端请求屏幕方向服务端返回的消息

GAME_WCB_GAME_EXIT = "GAME_WCB_GAME_EXIT" -- 退出游戏
GAME_MESSAGE_START_COUNTTIME = "GAME_MESSAGE_START_COUNTTIME" -- 开始计时


-- 星球检查时的方向
E_CHECK_DIRECTION = {
    ["UP"] = 1 , 
    ["DOWN"] = 2 , 
    ["LEFT"] = 3 , 
    ["RIGHT"] = 4 , 
}

E_DIRECTION = {
    ["HORIZONTAL"] = 1 , 
    ["VERTICALLY"] = 2 ,  
}

-- 星球类型
PLANET_TYPE = {
    ["NORMAL"] = 1 , -- 正常
    ["FLAME"] = 2 , -- 火焰宝石
    ["MAGIC_LAMP"] = 3 , -- 神灯
    ["LIGHTNING"] = 4 , -- 闪电宝石
    ["SUPERNOVA"] = 5 , -- 超新星
    ["FROZEN"] = 6 , -- 冰冻宝石
}

-- 消除方式
REMOVE_MODE = {
    ["NORMAL"] = 1 , -- 正常消除
    ["BLAST"] = 2 , -- 爆炸消除
    ["LIGHTNING"] = 3 , -- 闪电消除
    ["MAGIC_LAMP"] = 4 , --神灯消除 
}

ACTION_TIME = 0.4 -- 动画执行的时间 0.4
LIGHTNING_PICTURE_WIDTH = 400 -- 闪电图片宽度 
RESOURCES_TOTAL_NUM = 8 -- 加载资源总数量
PARTICLE_MOVE_SPEED = 1000 -- 粒子每秒移动速度
PLANET_MOVE_SPEED = 1000 -- 星球每秒移动速度
PLANET_START_OFFSET_Y = 800 -- 星球开始创建时Y轴偏移距离
PLANET_MOVE_TIME = PLANET_START_OFFSET_Y / PLANET_MOVE_SPEED -- 星球创建时移动时间
UP_SPEED = 0.4 -- 上移速度

ADD_SCORE_ROOT = "wacaibao/res/common/img/addNum_1.png" -- 加分数字图片路径

-- 命令枚举
E_COM = {
    ["COM_INSERT_MONRY"] = 100 , -- 投钱
    ["COM_SCORE_IN"] = 101 , -- 上分
    ["COM_SCORE_OUT"] = 102 , -- 下分
    ["COM_ENTER_SETTING"] = 6 , -- 进入后台
    ["COM_ERR"] = 4 , -- 故障 
}

-- 游戏状态
E_GAME_STATE = 
{
    ["RANDOM"] = 1 , 
    ["DIFFICULT"] = 2, 
}

-- 星球实际的index
E_PLANET_INDEX = 
{
    [1] = 1 , 
    [2] = 2 ,
    [3] = 3 ,
    [4] = 4 ,
    [5] = 5 ,
    [6] = 6 ,
    [7] = 7 ,
    [8] = 9 ,
    [9] = 10 ,
    [10] = 11 ,
    [11] = 12 ,
    [12] = 13 ,
    [13] = 14 ,
}



---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
                                    --横版和竖版相关定义--
---------------------------------------------------------------------------------------------
HORV = 1 -- 横版还是竖版
JSON_HELP_ROOT = {[1] = "wacaibao/res/horizontal/json/H_Help_UI.json", [2] = "wacaibao/res/vertical/json/V_Help_UI.json"}
JSON_EXIT_ROOT = {[1] = "wacaibao/res/horizontal/json/H_PopUp_UI.json", [2] = "wacaibao/res/vertical/json/V_PopUp_UI.json"}
JSON_LOAD_ROOT = {[1] = "wacaibao/res/horizontal/json/H_Load_UI.json", [2] = "wacaibao/res/vertical/json/V_Load_UI.json"}
JSON_SCENE_ROOT = {[1] = "wacaibao/res/horizontal/json/H_Scene_UI.json", [2] = "wacaibao/res/vertical/json/V_Scene_UI.json"}

RES_HELPTEXT_ROOT = {[1] = "wacaibao/res/horizontal/img/Popup/h_helpText.png", [2] = "wacaibao/res/vertical/img/Popup/v_helpText.png"}

MATRIX_LBX = {[1] = 457, [2] = 200} 
MATRIX_LBY = {[1] = 0, [2] = 225} 
X_COUNT = {[1] = 10, [2] = 8} -- 水平方向格子数
Y_COUNT = {[1] = 8, [2] = 10} -- 垂直方向格子数
MUD_MAX_Y = {[1] = 3, [2] = 4} -- 泥块在矩阵中Y的最大值
STAR_MOVE_DISTANCE = {[1] = 934, [2] = 802} -- load场景进度条星星移动的距离
TIME_MOVE_DISTANCE = {[1] = 950, [2] = 715} -- 时间框节点需要移动的总距离 distance 715
TIME_MOVE_END_X = {[1] = 85, [2] = 143}  -- 时间框节点终点位置
TIME_MOVE_START_X = {[1] = 1040, [2] = 858} -- -- 时间框节点起始位置
MOVE_UP_NUM = {[1] = 2, [2] = 3} -- 上移行数
PLANET_JUDGE_INDEX = {[1] = 4, [2] = 5} -- 星球判断周围泥块的最大索引值
STRIP_LIGHTNING_SCALE = {[1]={vertical = 0.8, horizontal = 1}, [2]={vertical = 1, horizontal = 0.8}} -- 条形闪电垂直和水平方向的缩放比率
SCORE_SCALE = { [1]={[1] = 0.5, [2] = 0.6, [3] = 0.7}, [2]={[1] = 0.8, [2] = 1, [3] = 1} } -- 分数缩放比率
SCROLLVIEW_HIGHT = {[1]={width = 800, hight = 1169}, [2]={width = 757, hight = 1756}} -- 帮助窗口滚动层的内部大小


