--[[

Copyright (c) 2014-2017 Chukong Technologies Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]

require "main.src.cocos.cocos2d.Cocos2d"
require "main.src.cocos.cocos2d.Cocos2dConstants"
require "main.src.cocos.cocos2d.functions"

__G__TRACKBACK__ = function(msg)
    local message = debug.traceback()
    local msgString = tostring(msg)
    print("----------------------------------------")
    print(string.format("LUA ERROR: %s\n", msgString))
    print(message)
    print("----------------------------------------")
    
    writeLog(string.format("LUA ERROR: %s\n%s", msgString, message))

    return msg
end

-- opengl
require "main.src.cocos.cocos2d.Opengl"
require "main.src.cocos.cocos2d.OpenglConstants"
-- audio
require "main.src.cocos.cocosdenshion.AudioEngine"
-- cocosstudio
if nil ~= ccs then
    require "main.src.cocos.cocostudio.CocoStudio"
end
-- ui
if nil ~= ccui then
    require "main.src.cocos.ui.GuiConstants"
    require "main.src.cocos.ui.experimentalUIConstants"
end

-- extensions
require "main.src.cocos.extension.ExtensionConstants"
-- network
require "main.src.cocos.network.NetworkConstants"
-- Spine
if nil ~= sp then
    require "main.src.cocos.spine.SpineConstants"
end

require "main.src.cocos.cocos2d.deprecated"
require "main.src.cocos.cocos2d.DrawPrimitives"

-- Lua extensions
require "main.src.cocos.cocos2d.bitExtend"

-- CCLuaEngine
require "main.src.cocos.cocos2d.DeprecatedCocos2dClass"
require "main.src.cocos.cocos2d.DeprecatedCocos2dEnum"
require "main.src.cocos.cocos2d.DeprecatedCocos2dFunc"
require "main.src.cocos.cocos2d.DeprecatedOpenglEnum"

-- register_cocostudio_module
if nil ~= ccs then
    require "main.src.cocos.cocostudio.DeprecatedCocoStudioClass"
    require "main.src.cocos.cocostudio.DeprecatedCocoStudioFunc"
end


-- register_cocosbuilder_module
require "main.src.cocos.cocosbuilder.DeprecatedCocosBuilderClass"

-- register_cocosdenshion_module
require "main.src.cocos.cocosdenshion.DeprecatedCocosDenshionClass"
require "main.src.cocos.cocosdenshion.DeprecatedCocosDenshionFunc"

-- register_extension_module
require "main.src.cocos.extension.DeprecatedExtensionClass"
require "main.src.cocos.extension.DeprecatedExtensionEnum"
require "main.src.cocos.extension.DeprecatedExtensionFunc"

-- register_network_module
require "main.src.cocos.network.DeprecatedNetworkClass"
require "main.src.cocos.network.DeprecatedNetworkEnum"
require "main.src.cocos.network.DeprecatedNetworkFunc"

-- register_ui_module
if nil ~= ccui then
    require "main.src.cocos.ui.DeprecatedUIEnum"
    require "main.src.cocos.ui.DeprecatedUIFunc"
end

-- cocosbuilder
require "main.src.cocos.cocosbuilder.CCBReaderLoad"

-- physics3d
require "main.src.cocos.physics3d.physics3d-constants"

-- luaj or luaoc
local platform = cc.Application:getInstance():getTargetPlatform()
if cc.PLATFORM_OS_ANDROID == platform then
    luaj = require "main.src.cocos.cocos2d.luaj"
elseif cc.PLATFORM_OS_IPHONE == platform or cc.PLATFORM_OS_IPAD == platform then
    luaoc = require "main.src.cocos.cocos2d.luaoc"
end

if CC_USE_FRAMEWORK then
    require "main.src.cocos.framework.init"
end
