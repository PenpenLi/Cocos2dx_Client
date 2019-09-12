cc.exports.boodr = true       --定鱼
cc.exports.lock_fishid  = 0       --用于执行自动跟踪  锁定鱼的ID
cc.exports.lock_fish  = nil       --用于执行自动跟踪  锁定鱼的实体
cc.exports.ID = 0   --唯一标识

cc.exports.scheduler = cc.Director:getInstance():getScheduler()


cc.exports.veIDnum1 = 0  --子弹ID
cc.exports.veIDnum2 = 10000  --子弹ID
cc.exports.veIDnum3 = 20000  --子弹ID
cc.exports.veIDnum4 = 30000  --子弹ID

cc.exports.bulletMap = {} --子弹表
cc.exports.fishMap = {} --鱼表

cc.exports.SuoFishrectTable = {}
for i = 1,5 do
    for j = 1,8 do                	
        local a = cc.rect((j-1)*80,(i-1)*107,80,107)
        table.insert(SuoFishrectTable,a)                	      
    end
end


local fish1 = {}
for i = 1,3 do
	for j = 1,5 do
		if i == 3 and j == 5 then
			break
		else
			local a = cc.rect((j-1)*52,(i-1)*24,52,24)
			table.insert(fish1,a)
		end 
	end
end

local fish2 = {}
for i = 1,3 do
	for j = 1,6 do
		if i == 3 and j == 6 then
			break
		else
			local a = cc.rect((j-1)*66,(i-1)*45,66,45)
			table.insert(fish2,a)
		end 
	end
end 

local fish3 = {}
for i = 1,7 do 
	for j = 1,2 do
		local a = cc.rect((j-1)*101,(i-1)*56,101,56)
		table.insert(fish3,a)
	end 
end

local fish4 = {}
for i = 1,2 do
	for j = 1,3 do
		local a = cc.rect((j-1)*62,(i-1)*96,62,96)
		table.insert(fish4,a)
	end 
end 

local fish5 = {}
for i = 1,5 do
	for j = 1,3 do
		local a = cc.rect((j-1)*121,(i-1)*56,121,56)
		table.insert(fish5,a)
	end 
end 

local fish6 = {}
for i = 1,5 do
	for j = 1,3 do
		local a = cc.rect((j-1)*79,(i-1)*84,79,84)
		table.insert(fish6,a)
	end 
end 

local fish7 = {}
for i = 1,5 do
	for j = 1,6 do
		local a = cc.rect((j-1)*67,(i-1)*76,67,76)
		table.insert(fish7,a)
	end 
end 

local fish8 = {}
for i = 1,6 do
	for j = 1,5 do
		if i == 6 and j >= 5 then
			break
		else
			local a = cc.rect((j-1)*135,(i-1)*127,135,127)
			table.insert(fish8,a)
		end
	end 
end

local fish9 = {}
for i = 1,2 do
	for j = 1,7 do
		local a = cc.rect((j-1)*128,(i-1)*117,128,117)
		table.insert(fish9,a)
	end 
end

local fish10 = {}
for i = 1,7 do
	for j = 1,3 do
		local a = cc.rect((j-1)*114,(i-1)*94,114,94)
		table.insert(fish10,a)
	end 
end

local fish11 = {}
for i = 1,5 do
	for j = 1,3 do
		local a = cc.rect((j-1)*123,(i-1)*103,123,103)
		table.insert(fish11,a)
	end 
end

local fish12 = {}
for i = 1,4 do
	for j = 1,5 do
		if i == 4 and j >= 5 then
			break
		else
			local a = cc.rect((j-1)*111.2,(i-1)*111.25,111.2,111.25)
			table.insert(fish12,a)
		end
	end 
end 

local fish13 = {}
for i = 1,3 do
	for j = 1,3 do
		if i == 3 and j >= 3 then
			break
		else
			local a = cc.rect((j-1)*188.67,(i-1)*88,188.67,88)
			table.insert(fish13,a)
		end
	end 
end 

local fish14 = {}
for i = 1,6 do
	for j = 1,3 do
		if i == 6 and j >= 3 then
			break
		else
			local a = cc.rect((j-1)*180.33,(i-1)*166.17,180.33,166.17)
			table.insert(fish14,a)
		end
	end 
end 

local fish15 = {}
for i = 1,6 do
	for j = 1,3 do
		local a = cc.rect((j-1)*216,(i-1)*133,216,133)
		table.insert(fish15,a)
	end 
end

local fish16 = {}
for i = 1,6 do
	for j = 1,3 do
		local a = cc.rect((j-1)*288,(i-1)*148,288,148)
		table.insert(fish16,a)
	end 
end

local fish17 = {}
for i = 1,5 do
	for j = 1,2 do
		local a = cc.rect((j-1)*228,(i-1)*195,228,195)
		table.insert(fish17,a)
	end 
end 

local fish18 = {}
for i = 1,5 do
	for j = 1,2 do
		local a = cc.rect((j-1)*320,(i-1)*168,320,168)
		table.insert(fish18,a)
	end 
end

local fish19 = {}
for i = 1,6 do
	for j = 1,2 do
		local a = cc.rect((j-1)*297,(i-1)*172,297,172)
		table.insert(fish19,a)
	end 
end 

local fish20 = {}
for i = 1,3 do
	for j = 1,3 do
		local a = cc.rect((j-1)*368.33,(i-1)*167.67,368.33,167.67)
		table.insert(fish20,a)
	end 
end

local fish21 = {}
for i = 1,7 do
	for j = 1,2 do
		if i == 7 and j >= 2 then
			break
		else
			local a = cc.rect((j-1)*419.5,(i-1)*175,419.5,175)
			table.insert(fish21,a)
		end
	end 
end

local fish22 = {}
for i = 1,4 do
	for j = 1,2 do
		local a = cc.rect((j-1)*180,(i-1)*98,180,98)
		table.insert(fish22,a)
	end 
end

local fish23 = {}
for i = 1,3 do
	for j = 1,2 do
		local a = cc.rect((j-1)*103,(i-1)*145,103,145)
		table.insert(fish23,a)
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
}

local fishd1 = {}
for i = 1,2 do
	for j = 1,4 do
		local a = cc.rect((j-1)*70,(i-1)*31,70,31)
		table.insert(fishd1,a)
	end 
end 

local fishd2 = {}
for i = 1,2 do
	for j = 1,4 do
		local a = cc.rect((j-1)*62,(i-1)*37,62,37)
		table.insert(fishd2,a)
	end 
end

local fishd3 = {}
for i = 1,2 do
	for j = 1,3 do
		local a = cc.rect((j-1)*82,(i-1)*57,82,57)
		table.insert(fishd3,a)
	end 
end 

local fishd4 = {}
for i = 1,2 do
	for j = 1,3 do
		local a = cc.rect((j-1)*78,(i-1)*88,78,88)
		table.insert(fishd4,a)
	end 
end 

local fishd5 = {}
for i = 1,4 do
	for j = 1,2 do
		local a = cc.rect((j-1)*109,(i-1)*56,109,56)
		table.insert(fishd5,a)
	end 
end

local fishd6 = {}
for i = 1,2 do
	for j = 1,4 do
		if i == 2 and j == 4 then
			break
		else
			local a = cc.rect((j-1)*77,(i-1)*65,77,65)
			table.insert(fishd6,a)
		end 
	end
end

local fishd7 = {}
for i = 1,3 do
	for j = 1,6 do
		if i == 3 and j >= 3 then
			break
		else
			local a = cc.rect((j-1)*67,(i-1)*76,67,76)
			table.insert(fishd7,a)
		end 
	end
end

local fishd8 = {}
for i = 1,3 do
	for j = 1,3 do
		local a = cc.rect((j-1)*124,(i-1)*100,124,100)
		table.insert(fishd8,a)
	end 
end

local fishd10 = {}
for i = 1,3 do
	local a = cc.rect((i-1)*110,0,110,90)
	table.insert(fishd10,a)
end 

local fishd11 = {}
for i = 1,2 do
	for j = 1,3 do
		local a = cc.rect((j-1)*123,(i-1)*103,123,103)
		table.insert(fishd11,a)
	end 
end

local fishd12 = {}
for i = 1,2 do
	for j = 1,3 do
		local a = cc.rect((j-1)*123.33,(i-1)*101,123.33,101)
		table.insert(fishd12,a)
	end 
end

local fishd13 = {}
for i = 1,3 do
	for j = 1,3 do
		if i == 3 and j >= 3 then
			break
		else
			local a = cc.rect((j-1)*236,(i-1)*110,236,110)
			table.insert(fishd13,a)
		end
	end 
end

local fishd14 = {}
for i = 1,3 do
	for j = 1,2 do
		local a = cc.rect((j-1)*204.5,(i-1)*179,204.5,179)
		table.insert(fishd14,a)
	end 
end

local fishd15 = {}
for i = 1,2 do
	for j = 1,3 do
		if i == 2 and j >= 3 then
			break
		else
			local a = cc.rect((j-1)*221,(i-1)*134,221,134)
			table.insert(fishd15,a)
		end
	end 
end

local fishd16 = {}
for i = 1,4 do
	for j = 1,2 do
		local a = cc.rect((j-1)*293.5,(i-1)*125.5,293.5,125.5)
		table.insert(fishd16,a)
	end 
end

local fishd17 = {}
for i = 1,5 do
	for j = 1,2 do
		local a = cc.rect((j-1)*237,(i-1)*218,237,218)
		table.insert(fishd17,a)
	end 
end

local fishd18 = {}
for i = 1,6 do
	for j = 1,2 do
		local a = cc.rect((j-1)*319,(i-1)*193,319,193)
		table.insert(fishd18,a)
	end 
end

local fishd19 = {}
for i = 1,5 do
	for j = 1,2 do
		local a = cc.rect((j-1)*237,(i-1)*168,237,168)
		table.insert(fishd19,a)
	end 
end

local fishd20 = {}
for i = 1,4 do
	for j = 1,2 do
		if i == 4 and j >= 2 then
			break
		else
			local a = cc.rect((j-1)*390.5,(i-1)*207.5,390.5,207.5)
			table.insert(fishd20,a)
		end
	end 
end

local fishd21 = {}
for i = 1,5 do
	for j = 1,2 do
		local a = cc.rect((j-1)*428,(i-1)*222,428,222)
		table.insert(fishd21,a)
	end
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
}
