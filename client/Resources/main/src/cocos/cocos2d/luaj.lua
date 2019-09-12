
local luaj = {}

local callJavaStaticMethod = LuaJavaBridge.callStaticMethod

local function checkArguments(args, sig)
    if type(args) ~= "table" then args = {} end
    if sig then return args, sig end

    sig = {"("}
    for i, v in ipairs(args) do
        local t = type(v)
        if t == "number" then
            if v%1==0 then
                sig[#sig + 1] = "I"
            else
                sig[#sig + 1] = "F"
            end
        elseif t == "boolean" then
            sig[#sig + 1] = "Z"
        elseif t == "function" then
            sig[#sig + 1] = "I"
        else
            sig[#sig + 1] = "Ljava/lang/String;"
        end
    end
    sig[#sig + 1] = ")V"

    return args, table.concat(sig)
end

function luaj.callStaticMethod(className, methodName, args, sig)
    local args, sig = checkArguments(args, sig)
    --echoInfo("luaj.callStaticMethod(\"%s\",\n\t\"%s\",\n\targs,\n\t\"%s\"", className, methodName, sig)
    return callJavaStaticMethod(className, methodName, args, sig)
end

local function checkArguments2(args, ret)
    if type(args) ~= "table" then args = {} end

    sig = {"("}
    for i, v in ipairs(args) do
        local t = type(v)
        if t == "number" then
            if v%1==0 then
                sig[#sig + 1] = "I"
            else
                sig[#sig + 1] = "F"
            end
        elseif t == "boolean" then
            sig[#sig + 1] = "Z"
        elseif t == "function" then
            sig[#sig + 1] = "I"
        else
            sig[#sig + 1] = "Ljava/lang/String;"
        end
    end

    if ret == "number" then
        sig[#sig + 1] = ")F"
    elseif ret == "boolean" then
        sig[#sig + 1] = ")Z"
    elseif ret == "integer" then
        sig[#sig + 1] = ")I"
    elseif ret == "string" then
        sig[#sig + 1] = ")Ljava/lang/String;"
    end

    return args, table.concat(sig)
end

function luaj.callStaticMethod2(className, methodName, args, ret)
    local args, sig = checkArguments2(args, ret)
    --echoInfo("luaj.callStaticMethod(\"%s\",\n\t\"%s\",\n\targs,\n\t\"%s\"", className, methodName, sig)
    return callJavaStaticMethod(className, methodName, args, sig)
end

return luaj
