module("utf8",package.seeall)

-- ABNF from RFC 3629
--
-- UTF8-octets = *( UTF8-char )
-- UTF8-char = UTF8-1 / UTF8-2 / UTF8-3 / UTF8-4
-- UTF8-1 = %x00-7F
-- UTF8-2 = %xC2-DF UTF8-tail
-- UTF8-3 = %xE0 %xA0-BF UTF8-tail / %xE1-EC 2( UTF8-tail ) /
-- %xED %x80-9F UTF8-tail / %xEE-EF 2( UTF8-tail )
-- UTF8-4 = %xF0 %x90-BF 2( UTF8-tail ) / %xF1-F3 3( UTF8-tail ) /
-- %xF4 %x80-8F 2( UTF8-tail )
-- UTF8-tail = %x80-BF

-- 0xxxxxxx                            | 007F   (127)
-- 110xxxxx	10xxxxxx                   | 07FF   (2047)
-- 1110xxxx	10xxxxxx 10xxxxxx          | FFFF   (65535)
-- 11110xxx	10xxxxxx 10xxxxxx 10xxxxxx | 10FFFF (1114111)

local pattern = '[%z\1-\127\194-\244][\128-\191]*'

-- helper function
local posrelat =
function (pos, len)
    if pos < 0 then
        pos = len + pos + 1
    end

    return pos
end

-- THE MEAT

-- maps f over s's utf8 characters f can accept args: (visual_index, utf8_character, byte_index)
function map(s, f, no_subs)
    local i = 0

    if no_subs then
        for b, e in s:gmatch('()' .. pattern .. '()') do
            i = i + 1
            local c = e - b
            f(i, c, b)
        end
    else
        for b, c in s:gmatch('()(' .. pattern .. ')') do
            i = i + 1
            f(i, c, b)
        end
    end
end

-- THE REST

-- generator for the above -- to iterate over all utf8 chars
function chars(s, no_subs)
    return coroutine.wrap(function () return map(s, coroutine.yield, no_subs) end)
end

-- returns the number of characters in a UTF-8 string
function len(s)
    -- count the number of non-continuing bytes
    return select(2, s:gsub('[^\128-\193]', ''))
end

-- replace all utf8 chars with mapping
function replace(s, map)
    return s:gsub(pattern, map)
end

-- reverse a utf8 string
function reverse(s)
    -- reverse the individual greater-than-single-byte characters
    s = s:gsub(pattern, function (c) return #c > 1 and c:reverse() end)

    return s:reverse()
end

-- strip non-ascii characters from a utf8 string
function strip(s)
    return s:gsub(pattern, function (c) return #c > 1 and '' end)
end

-- like string.sub() but i, j are utf8 strings
-- a utf8-safe string.sub()
function sub(s, i, j)
    local l = len(s)

    i =       posrelat(i, l)
    j = j and posrelat(j, l) or l

    if i < 1 then i = 1 end
    if j > l then j = l end

    if i > j then return '' end

    local diff = j - i
    local iter = chars(s, true)

    -- advance up to i
    for _ = 1, i - 1 do iter() end

    local c, b = select(2, iter())

    -- i and j are the same, single-charaacter sub
    if diff == 0 then
        return string.sub(s, b, b + c - 1)
    end

    i = b

    -- advance up to j
    for _ = 1, diff - 1 do iter() end

    c, b = select(2, iter())

    return string.sub(s, i, b + c - 1)
end

function unicode_to_utf8(convertStr)
    if type(convertStr)~="string" then
        return convertStr
    end

    local resultStr=""
    local i=1
    while true do
        local num1=string.byte(convertStr,i)
        local unicode
        if num1~=nil and string.sub(convertStr,i,i+1)=="\\u" then
            unicode=tonumber("0x"..string.sub(convertStr,i+2,i+5))
            i=i+6
        elseif num1~=nil then
            unicode=num1
            i=i+1
        else
            break
        end

        if unicode <= 0x007f then
            resultStr=resultStr..string.char(bit.band(unicode,0x7f))
        elseif unicode >= 0x0080 and unicode <= 0x07ff then
            resultStr=resultStr..string.char(bit.bor(0xc0,bit.band(bit.rshift(unicode,6),0x1f)))
            resultStr=resultStr..string.char(bit.bor(0x80,bit.band(unicode,0x3f)))
        elseif unicode >= 0x0800 and unicode <= 0xffff then
            resultStr=resultStr..string.char(bit.bor(0xe0,bit.band(bit.rshift(unicode,12),0x0f)))
            resultStr=resultStr..string.char(bit.bor(0x80,bit.band(bit.rshift(unicode,6),0x3f)))
            resultStr=resultStr..string.char(bit.bor(0x80,bit.band(unicode,0x3f)))
        end
    end
    resultStr=resultStr..'\0'
    return resultStr
end


function utf8_to_unicode(convertStr)
    if type(convertStr)~="string" then
        return convertStr
    end
    local resultStr=""
    local i=1
    local num1=string.byte(convertStr,i)
    while num1~=nil do
        local tempVar1,tempVar2
        if num1 >= 0x00 and num1 <= 0x7f then
            tempVar1=num1
            tempVar2=0
        elseif bit.band(num1,0xe0)== 0xc0 then
            local t1 = 0
            local t2 = 0
            t1 = bit.band(num1,bit.rshift(0xff,3))
            i=i+1
            num1=string.byte(convertStr,i)
            t2 = bit.band(num1,bit.rshift(0xff,2))
            tempVar1=bit.bor(t2,bit.lshift(bit.band(t1,bit.rshift(0xff,6)),6))
            tempVar2=bit.rshift(t1,2)
        elseif bit.band(num1,0xf0)== 0xe0 then
            local t1 = 0
            local t2 = 0
            local t3 = 0
            t1 = bit.band(num1,bit.rshift(0xff,3))
            i=i+1
            num1=string.byte(convertStr,i)
            t2 = bit.band(num1,bit.rshift(0xff,2))
            i=i+1
            num1=string.byte(convertStr,i)
            t3 = bit.band(num1,bit.rshift(0xff,2))
            tempVar1=bit.bor(bit.lshift(bit.band(t2,bit.rshift(0xff,6)),6),t3)
            tempVar2=bit.bor(bit.lshift(t1,4),bit.rshift(t2,2))
        end
        resultStr=resultStr..string.format("\\u%02x%02x",tempVar2,tempVar1)
        i=i+1
        num1=string.byte(convertStr,i)
    end
    return resultStr
end