
cc.FileUtils:getInstance():setPopupNotify(false)

pathErrlog = string.format("%serror.log", cc.FileUtils:getInstance():getWritablePath())
print("LOG path :", pathErrlog)
logFile = io.open(pathErrlog, "a")

function writeLog(errmsg)
    if CONFIG_WRITE_LOG then
		errmsg = "[ "..os.date() .. " ]\n" .. errmsg .. "\n"
		logFile:write(errmsg)
		logFile:flush()
    end
end

cclog = function(...)
	print(string.format(...))
end

function require_ex( _mname )
  print(string.format("require_ex = %s", _mname))
  if package.loaded[_mname] then
      print(string.format("require_ex module[%s] reload", _mname))
  end
  package.loaded[_mname] = nil
  return require(_mname)
end

require "main.src.config"
require "main.src.cocos.init"

require_ex ("main.src.global.cfg")
require_ex ("main.src.global.global")
require_ex ("main.src.util.tools")
require_ex ("main.src.util.AutoAmount")
require_ex ("main.src.util.EventConstants")
require_ex ("main.src.util.constants")
require_ex ("main.src.util.serializable")
require_ex ("main.src.util.LocalLanguage")
require_ex ("main.src.util.LocalConfig")
require_ex ("main.src.util.LocalDataBase")
require_ex ("main.src.util.LocalVersions")
-- require_ex ("main.src.util.common")
require_ex ("main.src.util.utf8")
require_ex ("main.src.util.game_dispatcher_t")
require_ex ("main.src.util.MultipleDownloader")
require_ex ("main.src.ui.common.NodeBase")
require_ex ("main.src.ui.common.LayerBase")
require_ex ("main.src.ui.common.SceneBase")
require_ex ("main.src.ui.common.SwallowView")
require_ex ("main.src.ui.common.PopUpView")
require_ex ("main.src.ui.common.WarnTips")
require_ex ("main.src.ui.common.LoadingView")
require_ex ("main.src.ui.common.VendingTips")
require_ex ("main.src.scene.UpdateScene")
require_ex ("main.src.scene.MainScene")

local function main()
	-- avoid memory leak
	collectgarbage("setpause", 100)
	collectgarbage("setstepmul", 5000)

    math.newrandomseed()

    LocalVersions:checkOldVersion()

    cc.Device:setKeepScreenOn(true)

    display.centerWindows()

	-- initialize director
	local director = cc.Director:getInstance()
	local glview = director:getOpenGLView()

	director:setProjection(cc.DIRECTOR_PROJECTION2_D)
	director:setAnimationInterval(1.0 / 60)

	global.g_gameDispatcher = createObj(game_dispatcher_t)

	local scene = MainScene.new(MAIN_SCENE_TYPE.SCENE_UPDATE)
	cc.Director:getInstance():runWithScene(scene)
end

function applicationWillEnterForeground()
	handlerDelayed(function() global.g_gameDispatcher:sendMessage(GAME_MESSAGE_ENTERFOREGROUND) end, ENTER_DELAY)
end

function applicationDidEnterBackground()
	handlerDelayed(function() global.g_gameDispatcher:sendMessage(GAME_MESSAGE_ENTERBACKGROUND) end, ENTER_DELAY)
end

function applicationPermissionsGrant()
	handlerDelayed(function() global.g_gameDispatcher:sendMessage(GAME_MESSAGE_PERMISSIONS_GRANT) end, ENTER_DELAY)
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end