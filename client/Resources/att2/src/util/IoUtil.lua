--IO工具类
module("IoUtil", package.seeall)

--按行读取文本文件
function readLines(filePath)
    local lines = {};
    local file = io.open(filePath, "r");
    assert(file);
    for line in file:lines() do
        lines[#lines] = line;
    end
    file:close();
    return lines;
end