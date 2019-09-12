--工具杂项

local android_package = "org/cocos2dx/lua"

-- call java method return void
function calljavaMethodV(methodName, args)
    local className = android_package .. "/AppActivity"
    local ok,ret  = luaj.callStaticMethod(className, methodName, args)
    if not ok then
        print("luaj error:", ret)
    end
end

-- call java method return string
function calljavaMethodS(methodName, args)
    local className = android_package .. "/AppActivity"
    local ok,ret  = luaj.callStaticMethod2(className, methodName, args, "string")
    if not ok then
        print("luaj error:", ret)
    else
        return ret
    end    
end

-- call java method return integer
function calljavaMethodI(methodName, args)
    local className = android_package .. "/AppActivity"
    local ok,ret  = luaj.callStaticMethod2(className, methodName, args, "integer")
    if not ok then
        print("luaj error:", ret)
    else
        return ret
    end    
end

-- call java method return boolean
function calljavaMethodB(methodName, args)
    local className = android_package .. "/AppActivity"
    local ok,ret  = luaj.callStaticMethod2(className, methodName, args, "boolean")
    if not ok then
        print("luaj error:", ret)
    else
        return ret
    end    
end

-- call java method return float
function calljavaMethodF(methodName, args)
    local className = android_package .. "/AppActivity"
    local ok,ret  = luaj.callStaticMethod2(className, methodName, args, "number")
    if not ok then
        print("luaj error:", ret)
    else
        return ret
    end     
end

function isTable(t)
    return type(t) == "table"
end

function valueInTable(t, value)
    for k, v in pairs(t) do
        if v == value then return true end
    end
    return false
end

function keyInTable(t, key)
    for k, v in pairs(t) do
        if k == key then return true end
    end
    return false
end

function tableIsEmpty(t)
    return t == nil or _G.next( t ) == nil
end

function tableLength(t)
    if tableIsEmpty(t) then
        return 0
    end

    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

function compareTable(t1, t2)
    -- all key-value pairs in t1 must be in t2
    for k, v in pairs(t1) do
        if t2[k] ~= v then return false end
    end
    -- there must not be other keys in t2
    for k, v in pairs(t2) do
        if t1[k] == nil then return false end
    end
    return true
end

function printTable3Level( table,strName )
    print(strName,"===================")
    for k,v in pairs(table) do 
        print(" --",k,v)
            if type(v) == "table" then 
                for m,n in pairs(v) do 
                    print("  |-",m,n)
                    if type(n) == "table" then 
                        for p,q in pairs(n) do 
                        print("     |-",p,q)
                        
                        end
                    end
                end
            end
    end
    print("==========================")
end

function depCopyTable(st)
    local tab = {}
    for k, v in pairs(st or {}) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = depCopyTable(v)
        end
    end
    return tab
end

function TableConcat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

string.split = function(s, p)
    local rt= {}
    string.gsub(s, '[^'..p..']+', function(w) table.insert(rt, w) end )
    return rt
end

local setmetatableindex_
setmetatableindex_ = function(t, index)
    if type(t) == "userdata" then
        local peer = tolua.getpeer(t)
        if not peer then
            peer = {}
            tolua.setpeer(t, peer)
        end
        setmetatableindex_(peer, index)
    else
        local mt = getmetatable(t)
        if not mt then mt = {} end
        if not mt.__index then
            mt.__index = index
            setmetatable(t, mt)
        elseif mt.__index ~= index then
            setmetatableindex_(mt, index)
        end
    end
end
setmetatableindex = setmetatableindex_

function class(classname, ...)
    local cls = {__cname = classname}

    local supers = {...}
    for _, super in ipairs(supers) do
        local superType = type(super)
        assert(superType == "nil" or superType == "table" or superType == "function",
            string.format("class() - create class \"%s\" with invalid super class type \"%s\"",
                classname, superType))

        if superType == "function" then
            assert(cls.__create == nil,
                string.format("class() - create class \"%s\" with more than one creating function",
                    classname));
            -- if super is function, set it to __create
            cls.__create = super
        elseif superType == "table" then
            if super[".isclass"] then
                -- super is native class
                assert(cls.__create == nil,
                    string.format("class() - create class \"%s\" with more than one creating function or native class",
                        classname));
                cls.__create = function() return super:create() end
            else
                -- super is pure lua class
                cls.__supers = cls.__supers or {}
                cls.__supers[#cls.__supers + 1] = super
                if not cls.super then
                    -- set first super pure lua class as class.super
                    cls.super = super
                end
            end
        else
            error(string.format("class() - create class \"%s\" with invalid super type",
                        classname), 0)
        end
    end

    cls.__index = cls
    if not cls.__supers or #cls.__supers == 1 then
        setmetatable(cls, {__index = cls.super})
    else
        setmetatable(cls, {__index = function(_, key)
            local supers = cls.__supers
            for i = 1, #supers do
                local super = supers[i]
                if super[key] then return super[key] end
            end
        end})
    end

    if not cls.ctor then
        -- add default constructor
        cls.ctor = function() end
    end
    cls.new = function(...)
        local instance
        if cls.__create then
            instance = cls.__create(...)
        else
            instance = {}
        end
        setmetatableindex(instance, cls)
        instance.class = cls
        instance:ctor(...)
        return instance
    end
    cls.create = function(_, ...)
        return cls.new(...)
    end

    return cls
end

function new(moduleName)
    local obj = {}
    setmetatable(obj, {__index = moduleName})
    return obj
end

function baseClass(base, myClass)
    setmetatable(myClass, {__index = base})
end

function createObj(moduleName, ...)
    local obj = new(moduleName)
    obj:init(...)
    return obj
end

-- function replaceScene(_sceneNode, _nowSceneObj, noeffect)
--     if _nowSceneObj and _sceneNode then
--         local oOldScene = global.nowSceneObj
--         global.g_nowSceneObj = _nowSceneObj
--         if noeffect then
--             cc.Director:getInstance():replaceScene(_sceneNode)            
--         else
--             cc.Director:getInstance():replaceScene(cc.TransitionSlideInR:create(0.5, _sceneNode))            
--         end
--     else
--         cclog("replaceScene 参数错误")
--     end
-- end

function replaceScene(classT, trans, ...)
    local scene = cc.Director:getInstance():getRunningScene()
    scene:replaceScene(classT, trans, ...)
end

-- function showUI(_ui_t, ...)
--     local obj_t = createObj(_ui_t, ...)
--     local director = cc.Director:getInstance()

--     local running_scene = director:getRunningScene()
--     if running_scene then
--         running_scene:addChild(obj_t.node_, MAX_ZORDER)
--         return obj_t
--     end
--     return nil
-- end

function runSandBox(func, env)
    setmetatable(env, {__index = _G})
    setfenv(func, env)
    func()
end

function makeClickHandler(o, func)
    return function(sender, event) if event == 2 then func(o, sender, event) end end
end

function getDeviceModel()
    if (cc.PLATFORM_OS_ANDROID == cc.Application:getInstance():getTargetPlatform()) then
        return calljavaMethodS("getDeviceModel", {})
    end

    return ""
end

function getDeviceSystem()
    if (cc.PLATFORM_OS_ANDROID == cc.Application:getInstance():getTargetPlatform()) then
        return calljavaMethodS("getDeviceSystem", {})
    end
end

function getNetWorkType()
    if (cc.PLATFORM_OS_ANDROID == cc.Application:getInstance():getTargetPlatform()) then
        return calljavaMethodS("getNetWorkType", {})
    end
end

function changeOrientation( orient )
    if (cc.PLATFORM_OS_ANDROID == cc.Application:getInstance():getTargetPlatform()) then
        return calljavaMethodV("changeOrientation", {orient})
    elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
        luaoc.callStaticMethod("AppController", "changeOrientation", {orientation = orient})
    end
end

function handler(obj, method)
    return function(...)
        return method(obj, ...)
    end
end

function newTTFLabel(params)
    assert(type(params) == "table",
           "[framework.display] newTTFLabel() invalid params")

    local text       = tostring(params.text)
    local font       = params.font or "fullmain/res/fonts/FZY4JW.ttf"
    local size       = params.size or 24
    local color      = params.color or COLOR_WHITE
    local textAlign  = params.align or cc.TEXT_ALIGNMENT_LEFT
    local textValign = params.valign or cc.VERTICAL_TEXT_ALIGNMENT_TOP
    local x, y       = params.x, params.y
    local dimensions = params.dimensions or cc.size(0, 0)

    assert(type(size) == "number",
           "[framework.display] newTTFLabel() invalid params.size")

    local label
    if cc.FileUtils:getInstance():isFileExist(font) then
        label = cc.Label:createWithTTF(text, font, size, dimensions, textAlign, textValign)
        if label then
            label:setColor(color)
        end
    else
        label = cc.Label:createWithSystemFont(text, font, size, dimensions, textAlign, textValign)
        if label then
            label:setTextColor(color)
        end
    end

    if label then
        if x and y then label:setPosition(x, y) end

        if params.outline then
            label:enableOutline(params.outline.color, params.outline.size)
        end
    end

    return label
end

function checkAccountValid(account)
    local accLen = string.utf8len(account)
    if accLen < MIN_ACC_LEN then
        WarnTips.showTips(
                {
                    text = LocalLanguage:getLanguageString("L_f5fbd737396821c7"),
                    style = WarnTips.STYLE_Y
                }
            )
        return false
    end

    local s = utf8.strip(account)
    if s ~= account then
        WarnTips.showTips(
                {
                    text = LocalLanguage:getLanguageString("L_2394d4a305bb7b3e"),
                    style = WarnTips.STYLE_Y
                }
            )
        return false
    end
    return true
end

function checkPasswordValid(password)
    local pwdLen = string.utf8len(password)
    if pwdLen < MIN_PWD_LEN then
        WarnTips.showTips(
                {
                    text = LocalLanguage:getLanguageString("L_d173c5112d5a4362"),
                    style = WarnTips.STYLE_Y
                }
            )
        return false
    end

    local s = utf8.strip(password)
    if s ~= password then
        WarnTips.showTips(
                {
                    text = LocalLanguage:getLanguageString("L_002863a42f2d8bab"),
                    style = WarnTips.STYLE_Y
                }
            )
        return false
    end

    local anyNum = nil
    local anyLetter = nil
    for i = 1, string.len(s) do
        local n = string.byte(s, i)
        if n > 47 and n < 58 then
            anyNum = true
        elseif n > 64 and n < 123 then
            anyLetter = true
        end
    end

    if not (anyNum and anyLetter) then
        WarnTips.showTips(
                {
                    text = LocalLanguage:getLanguageString("L_709ce949ce86c1c8"),
                    style = WarnTips.STYLE_Y
                }
            )
        return false
    end

    return true
end

function setGray(node)
    local vertDefaultSource = "\n" ..
        "attribute vec4 a_position;\n" ..
        "attribute vec2 a_texCoord;\n" ..
        "attribute vec4 a_color;\n" ..
        "#ifdef GL_ES\n" ..
        "varying lowp vec4 v_fragmentColor;\n" ..
        "varying mediump vec2 v_texCoord;\n" ..
        "#else\n" ..
        "varying vec4 v_fragmentColor;\n" ..
        "varying vec2 v_texCoord;\n" ..
        "#endif\n" ..
        "void main()\n" ..
        "{\n" ..
        "gl_Position = CC_PMatrix * a_position;\n" ..
        "v_fragmentColor = a_color;\n" ..
        "v_texCoord = a_texCoord;\n" ..
        "}"

    local pszFragSource = "#ifdef GL_ES\n" ..
        "precision mediump float;\n" ..
        "#endif\n" ..
        "varying vec4 v_fragmentColor;\n" ..
        "varying vec2 v_texCoord;\n" ..
        "void main(void)\n" ..
        "{\n" ..
        "vec4 c = texture2D(CC_Texture0, v_texCoord);\n" ..
        "gl_FragColor.xyz = vec3(0.4*c.r + 0.4*c.g +0.4*c.b);\n" ..
        "gl_FragColor.w = c.w;\n" ..
        "}"

    local pProgram = cc.GLProgram:createWithByteArrays(vertDefaultSource, pszFragSource)
    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION, cc.VERTEX_ATTRIB_POSITION)
    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR)
    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)
    pProgram:link()
    pProgram:updateUniforms()
    node:setGLProgram(pProgram)
end

function number_format(num,deperator)  
    local str1 =""
    local str = tostring(num)
    local strLen = string.len(str)
    deperator = deperator or ","

    for i=1,strLen do
        str1 = string.char(string.byte(str,strLen+1 - i)) .. str1
        if math.mod(i,3) == 0 then
            --下一个数 还有
            if strLen - i ~= 0 then
                str1 = deperator .. str1
            end
        end
    end
    return str1
end

local MONEY_FORMATS = {
    {100000000, "亿"},
    {10000000, "千万"},
    {10000, "万"},
    {1, ""},
}
function moneyFormat(num)
    local words = tostring(num)
    for i = 1, #MONEY_FORMATS do
        local data = MONEY_FORMATS[i]
        if num >= data[1] then
            local p = math.floor(num / data[1])
            words = tostring(p) .. data[2]
            break
        end
    end
    return words
end

function getMachineId()
    if cc.PLATFORM_OS_ANDROID == PLATFROM then
        return calljavaMethodS("getMachineId", {})
    elseif cc.PLATFORM_OS_WINDOWS == PLATFROM then
        return util:getMachineId()
    elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
        local _, machineId = luaoc.callStaticMethod("AppController", "getMachineId", {})
        return machineId
    end
end

function isSameDay(time1, time2)
    local timeBase = os.time({year=1970, month=1, day=1, hour=0})
    local day1 = math.floor((time1 - timeBase) / 86400)
    local day2 = math.floor((time2 - timeBase) / 86400)

    return day1 == day2
end

function isSameWeek(time1, time2)
    local timeBase = os.time({year=1970, month=1, day=1, hour=0}) + 4 * 86400
    local week1 = math.floor((time1 - timeBase) / (7 * 86400))
    local week2 = math.floor((time2 - timeBase) / (7 * 86400))

    return week1 == week2
end

function formatTimeString(sec)
    local secHour = 3600
    local secMin = 60

    local remainSec = 0
    local hour = math.floor(sec/secHour)
    remainSec = sec % secHour
    local min = math.floor(remainSec/secMin)
    remainSec = remainSec % secMin

    local formatStr = hour > 0 and "%02d:%02d:%02d" or "%02d:%02d"
    if hour > 0 then
        return string.format(formatStr, hour, min, remainSec)
    else
        return string.format(formatStr, min, remainSec)
    end
end

function createCursorTextField(root, childname, inputMode)
    local textfield = ccui.Helper:seekWidgetByName(root, childname)

    local size = textfield:getContentSize()
    local px, py = textfield:getPosition()
    local ap = textfield:getAnchorPoint()
    local placeHolder = textfield:getPlaceHolder()
    local text = textfield:getString()
    local ipm = inputMode or cc.EDITBOX_INPUT_MODE_ANY

    local editbox = ccui.EditBox:create(cc.size(size.width, size.height), ccui.Scale9Sprite:create("main/res/common/alpha_4x4.png"))
    if textfield:isMaxLengthEnabled() then
        editbox:setMaxLength(textfield:getMaxLength())
    end

    if textfield:isPasswordEnabled() then
        editbox:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    end
    editbox:setInputMode(ipm)
    editbox:setPlaceHolder(placeHolder)
    editbox:setText(text)
    editbox:setPosition(cc.p(px, py))
    editbox:setAnchorPoint(ap)
    textfield:getParent():addChild(editbox)

    textfield:removeFromParent()

    return editbox
end

function createAnimateWithPathFormat(indexStart, pathFormat, delay, iLoops)
    local animation = cc.Animation:create()
    local index = indexStart
    local FileUtils = cc.FileUtils:getInstance() 
    local filesTextures = {}
    while true do
        local str = string.format(pathFormat, index)
        local isExist = FileUtils:isFileExist(str)
        if not isExist then break end
        filesTextures[#filesTextures + 1] = str 
        animation:addSpriteFrameWithFile(str)

        index = index + 1
    end
    animation:setLoops(iLoops) 
    animation:setDelayPerUnit(delay)
    animation:setRestoreOriginalFrame(true)

    return cc.Animate:create(animation), filesTextures
end

function createWithSingleFrameName(name, delay, iLoops)
    local cache = cc.SpriteFrameCache:getInstance() 
    local frame = nil 
    local index = 1 
    local animation = cc.Animation:create()
    repeat
        frame = cache:getSpriteFrame(string.format("%s%d.png", name, index))
        index = index + 1
        if(frame == nil) then 
            break 
        end 
        animation:addSpriteFrame(frame)
    until false;

    animation:setLoops(iLoops) 
    animation:setDelayPerUnit(delay)
    animation:setRestoreOriginalFrame(true)

    return cc.Animate:create(animation)
end

function createWithFrameFileName(file_name, delay, iLoops)
    local animation = cc.Animation:create()
    local index = 1
    local FileUtils = cc.FileUtils:getInstance() 
    local filesTextures = {}
    while true do
        index = index + 1
        local str = string.format(file_name .. "%d.png", index)
        local isExist = FileUtils:isFileExist(str)
        if not isExist then break end
        filesTextures[#filesTextures + 1] = str 
        animation:addSpriteFrameWithFile(str)
    end
    animation:setLoops(iLoops) 
    animation:setDelayPerUnit(delay)
    animation:setRestoreOriginalFrame(true)
    return cc.Animate:create(animation), filesTextures
end

function createWithFileName(file_name, delay, iLoops)
    local animation = cc.Animation:create()
    local index = 1
    local FileUtils = cc.FileUtils:getInstance() 
    while true do
        local str = string.format(file_name .. "%d.png", index)
        index = index + 1
        local isExist = FileUtils:isFileExist(str)
        if isExist then  
            animation:addSpriteFrameWithFile(str) 
        else 
            break 
        end
    end
    animation:setLoops(iLoops) 
    animation:setDelayPerUnit(delay)
    animation:setRestoreOriginalFrame(true)

    return cc.Animate:create(animation)
end

function stripextension(filename)
    local idx = filename:match(".+()%.%w+$")
    if(idx) then
        return filename:sub(1, idx-1)
    else
        return filename
    end
end

function getextension(filename)
    return filename:match(".+%.(%w+)$")
end

function getLayoutJson(path)
    local filename = stripextension(path)
    return filename .. CC_DESIGN_RESOLUTION.uisuffix .. ".json"
end

function handlerDelayed(callback, delaySec)
    delaySec = delaySec or 0

    local scheduleId
    local function onComplete()
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduleId)
        
        callback()
    end
    scheduleId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onComplete, delaySec, false)
end

function isRightEmail(str)
    if string.len(str or "") < 6 then return false end
    local b,e = string.find(str or "", '@')
    local bstr = ""
    local estr = ""
    if b then
        bstr = string.sub(str, 1, b-1)
        estr = string.sub(str, e+1, -1)
    else
        return false
    end

    local p1,p2 = string.find(bstr, "[%w_]+")
    if (p1 ~= 1) or (p2 ~= string.len(bstr)) then return false end

    if string.find(estr, "^[%.]+") then return false end
    if string.find(estr, "%.[%.]+") then return false end
    if string.find(estr, "@") then return false end
    if string.find(estr, "%s") then return false end
    if string.find(estr, "[%.]+$") then return false end

    _,count = string.gsub(estr, "%.", "")
    if (count < 1 ) or (count > 3) then
        return false
    end

    return true
end

function getLockSpreader()
    local content = LocalConfig:getLockData("spreader")
    if not content then
        return LocalConfig:getLockSpreader()
    end

    return tonumber(content)
end