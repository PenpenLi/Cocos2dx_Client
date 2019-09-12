cc.exports.boodr = true       --定鱼
cc.exports.lock_fishid  = 0       --用于执行自动跟踪  锁定鱼的ID
cc.exports.lock_fish  = nil       --用于执行自动跟踪  锁定鱼的实体
cc.exports.ID = 0   --唯一标识

cc.exports.scheduler = cc.Director:getInstance():getScheduler()

cc.exports.winwidth = display.width  --屏幕固定宽度
cc.exports.winheight = display.height  --初始化全局变量屏幕高度

cc.exports.veIDnum1 = 0  --子弹ID
cc.exports.veIDnum2 = 10000  --子弹ID
cc.exports.veIDnum3 = 20000  --子弹ID
cc.exports.veIDnum4 = 30000  --子弹ID

cc.exports.bulletMap = {} --子弹表
cc.exports.fishMap = {} --鱼表

cc.exports.SuoFishrectTable = {}
for i = 1,6 do
    for j = 1,8 do                	
        local a = cc.rect((j-1)*80,(i-1)*107,80,107)
        table.insert(SuoFishrectTable,a)                	      
    end
end


local fish1 = {}
for i = 1,3 do
	for j = 1,4 do
		local a = cc.rect((j-1)*70,(i-1)*24,70,24)
		table.insert(fish1,a)
	end
end

local fish2 = {}
for i = 1,4 do
	for j = 1,4 do
		local a = cc.rect((j-1)*54,(i-1)*24,54,24)
		table.insert(fish2,a)
	end
end 

local fish3 = {}
for i = 1,6 do 
	for j = 1,4 do
		local a = cc.rect((j-1)*78,(i-1)*48,78,48)
		table.insert(fish3,a)
	end 
end

local fish4 = {}
for i = 1,6 do
	for j = 1,4 do
		local a = cc.rect((j-1)*100,(i-1)*64,100,64)
		table.insert(fish4,a)
	end 
end 

local fish5 = {}
for i = 1,6 do
	for j = 1,4 do
		local a = cc.rect((j-1)*124,(i-1)*45,124,45)
		table.insert(fish5,a)
	end 
end 

local fish6 = {}
for i = 1,5 do
	for j = 1,5 do
		local a = cc.rect((j-1)*105,(i-1)*72,105,72)
		table.insert(fish6,a)
	end 
end 

local fish7 = {}
for i = 1,6 do
	for j = 1,10 do
		local a = cc.rect((j-1)*120,(i-1)*58,120,58)
		table.insert(fish7,a)
	end 
end 

local fish8 = {}
for i = 1,4 do
	for j = 1,5 do
		local a = cc.rect((j-1)*132,(i-1)*74,132,74)
		table.insert(fish8,a)
	end 
end

local fish9 = {}
for i = 1,4 do
	for j = 1,6 do
		local a = cc.rect((j-1)*200,(i-1)*115,200,115)
		table.insert(fish9,a)
	end 
end

local fish10 = {}
for i = 1,4 do
	for j = 1,4 do
		local a = cc.rect((j-1)*135,(i-1)*145,135,145)
		table.insert(fish10,a)
	end 
end

local fish11 = {}
for i = 1,4 do
	for j = 1,6 do
		local a = cc.rect((j-1)*190,(i-1)*84,190,84)
		table.insert(fish11,a)
	end 
end

local fish12 = {}
for i = 1,3 do
	for j = 1,4 do
		local a = cc.rect((j-1)*158,(i-1)*164,158,164)
		table.insert(fish12,a)
	end 
end 

local fish13 = {}
for i = 1,4 do
	for j = 1,6 do
		local a = cc.rect((j-1)*220,(i-1)*88,220,88)
		table.insert(fish13,a)
	end 
end 

local fish14 = {}
for i = 1,5 do
	for j = 1,4 do
		local a = cc.rect((j-1)*285,(i-1)*97,285,97)
		table.insert(fish14,a)
	end 
end 

local fish15 = {}
for i = 1,4 do
	for j = 1,6 do
		local a = cc.rect((j-1)*210,(i-1)*260,210,260)
		table.insert(fish15,a)
	end 
end

local fish16 = {}
for i = 1,4 do
	for j = 1,6 do
		local a = cc.rect((j-1)*300,(i-1)*140,300,140)
		table.insert(fish16,a)
	end 
end

local fish17 = {}
for i = 1,4 do
	for j = 1,6 do
		local a = cc.rect((j-1)*300,(i-1)*140,300,140)
		table.insert(fish17,a)
	end 
end 

local fish18 = {}
for i = 1,2 do
	for j = 1,7 do
		local a = cc.rect((j-1)*128,(i-1)*117,128,117)
		table.insert(fish18,a)
	end 
end

local fish19 = {}
for i = 1,2 do
	for j = 1,4 do
		local a = cc.rect((j-1)*245,(i-1)*343,245,343)
		table.insert(fish19,a)
	end 
end 

local fish20 = {}
for i = 1,2 do
	for j = 1,4 do
		local a = cc.rect((j-1)*245,(i-1)*343,245,343)
		table.insert(fish20,a)
	end 
end

local fish21 = {}
for i = 1,2 do
	for j = 1,4 do
		local a = cc.rect((j-1)*245,(i-1)*343,245,343)
		table.insert(fish21,a)
	end 
end

local fish22 = {}
for i = 1,3 do
	local a = cc.rect((i-1)*133,0,133,165)
	table.insert(fish22,a)
end

local fish23 = {}
for i = 1,2 do
	for j = 1,5 do
		local a = cc.rect((j-1)*192,(i-1)*384,192,384)
		table.insert(fish23,a)
	end 
end

local fish24 = {}
for i = 1,2 do
	for j = 1,4 do
		local a = cc.rect((j-1)*140,(i-1)*169,140,169)
		table.insert(fish24,a)
	end 
end 

cc.exports.FishCreateTable = {
	[0] = fish1,
	[1] = fish2,
	[2] = fish3,
	[3] = fish4,
	[4] = fish5,
	[5] = fish6,
	[6] = fish7,
	[7] = fish8,
	[8] = fish9,
	[9] = fish10,
	[10] = fish11,
	[11] = fish12,
	[12] = fish13,
	[13] = fish14,
	[14] = fish15,
	[15] = fish16,
	[16] = fish17,
	[17] = fish18,
	[18] = fish19,
	[19] = fish20,
	[20] = fish21,
	[21] = fish22,
	[22] = fish23,
	[23] = fish24,
}

local fishd1 = {}
for i = 1,4 do
	local a = cc.rect((i-1)*92.5,0,92.5,27)
	table.insert(fishd1,a)
end 

local fishd2 = {}
for i = 1,3 do
	local a = cc.rect((i-1)*54,0,62,54)
	table.insert(fishd2,a)
end

local fishd3 = {}
for j = 1,3 do
	local a = cc.rect((j-1)*78,0,78,47)
	table.insert(fishd3,a)
end 


local fishd4 = {}
for i = 1,2 do
	for j = 1,5 do
		local a = cc.rect((j-1)*105,(i-1)*62,105,62)
		table.insert(fishd4,a)
	end 
end 

local fishd5 = {}
for j = 1,3 do
	local a = cc.rect((j-1)*124,0,124,50)
	table.insert(fishd5,a)
end 


local fishd6 = {}
for i = 1,2 do
	for j = 1,3 do
		local a = cc.rect((j-1)*105,(i-1)*76,105,76)
		table.insert(fishd6,a)
	end
end

local fishd7 = {}
for j = 1,6 do
	local a = cc.rect((j-1)*124,0,124,50)
	table.insert(fishd7,a) 
end


local fishd8 = {}
for i = 1,2 do
	for j = 1,3 do
		local a = cc.rect((j-1)*132,(i-1)*71,132,71)
		table.insert(fishd8,a)
	end 
end

local fishd9 = {}
for i = 1,4 do
	local a = cc.rect((i-1)*160,0,160,90)
	table.insert(fishd9,a)
end

local fishd10 = {}
for i = 1,7 do
	local a = cc.rect((i-1)*135,0,135,108)
	table.insert(fishd10,a)
end 

local fishd11 = {}
for j = 1,4 do
	local a = cc.rect((j-1)*190,0,190,200)
	table.insert(fishd11,a)
end 

local fishd12 = {}
for j = 1,4 do
	local a = cc.rect((j-1)*158,0,158,158)
	table.insert(fishd12,a)
end 


local fishd13 = {}
for j = 1,4 do
	local a = cc.rect((j-1)*220,0,220,92)
	table.insert(fishd13,a)
end 


local fishd14 = {}
for j = 1,3 do
	local a = cc.rect((j-1)*285,0,285,114)
	table.insert(fishd14,a)
end 


local fishd15 = {}
for j = 1,6 do
	local a = cc.rect((j-1)*210,0,210,252)
	table.insert(fishd15,a)
end 


local fishd16 = {}
for j = 1,6 do
	local a = cc.rect((j-1)*300,0,300,144)
	table.insert(fishd16,a)
end 


local fishd17 = {}
for j = 1,4 do
	local a = cc.rect((j-1)*300,0,300,144)
	table.insert(fishd17,a)
end 


local fishd18 = {}
for i = 1,2 do
	for j = 1,7 do
		local a = cc.rect((j-1)*128,(i-1)*117,128,117)
		table.insert(fishd18,a)
	end 
end


local fishd19 = {}
for j = 1,3 do
	local a = cc.rect((j-1)*240,0,240,375)
	table.insert(fishd19,a)
end 



local fishd20 = {}
for j = 1,3 do
	local a = cc.rect((j-1)*240.5,0,240,374)
	table.insert(fishd20,a)
end 


local fishd21 = {}
for j = 1,3 do
	local a = cc.rect((j-1)*245,0,245,383)
	table.insert(fishd21,a)
end

local fishd22 = {}
for i=1,3 do
	local a = cc.rect((i-1)*133,0,133,165)
	table.insert(fishd22,a)
end


local fishd23 = {}
for i = 1,3 do
	local a = cc.rect((i-1)*154,0,154,308)
	table.insert(fishd23,a)
end 
            
local fishd24 = {}
for i = 1,2 do
	local a = cc.rect((i-1)*140,0,140,169)
	table.insert(fishd24,a)
end             

cc.exports.FishDeathTable = {
	[0] = fishd1,
	[1] = fishd2,
	[2] = fishd3,
	[3] = fishd4,
	[4] = fishd5,
	[5] = fishd6,
	[6] = fishd7,
	[7] = fishd8,
	[8] = fishd9,
	[9] = fishd10,
	[10] = fishd11,
	[11] = fishd12,
	[12] = fishd13,
	[13] = fishd14,
	[14] = fishd15,
	[15] = fishd16,
	[16] = fishd17,
	[17] = fishd18,
	[18] = fishd19,
	[19] = fishd20,
	[20] = fishd21,
	[21] = fishd22,
	[22] = fishd23,
	[23] = fishd24,
}
