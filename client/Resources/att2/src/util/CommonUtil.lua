module("CommonUtil", package.seeall)

local socket = require("socket") -- 需要用到luasocket库

local function getSeed()
    local t = string.format("%f", socket.gettime())
    local st = string.sub(t, string.find(t, "%.") + 1, -1)
    return tonumber(string.reverse(st))
end

function sleep(n)
    socket.select(nil, nil, n)
end

--获取随机数
--用法参考：http://www.cnblogs.com/tangyikejun/p/luaRandSort.html
function randFetch(list, num, poolSize, pool) -- list 存放筛选结果，num 筛取个数，poolSize 筛取源大小，pool 筛取源
    pool = pool or {}
    math.randomseed(getSeed())

    local count = 0; --循环次数
    local MAX_COUNT = 10; --最多循环次数

    while count < MAX_COUNT and #list < num do
        count = count + 1;

        for i = 1, num do
            local rand = math.random(i, poolSize)
            local tmp = pool[rand] or rand -- 对于第二个池子，序号跟id号是一致的
            pool[rand] = pool[i] or i
            pool[i] = tmp

            table.insert(list, tmp)
        end
        if isHaveSameItems(list) == true then
            print("随机数组中存在相同的元素，继续调用获取随机数");
            removeAll(list);
        end
    end
end

--判断是否存在值相同的元素
function isHaveSameItems(array)
    local result = false;
    for i = 1, #array - 1 do
        for j = i + 1, #array do
            if array[i] == array[j] then
                result = true;
                break;
            end
        end
    end
    return result;
end

--table删除所有元素
function removeAll(array)
    for i = #array, 1, -1 do
        if remove[array[i]] then
            table.remove(array, i)
        end
    end
end