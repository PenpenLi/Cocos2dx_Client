module( "LHDBLogic", package.seeall )
--[[
	游戏格子分布(以第一关为例)：
	(1, 4) (2, 4) (3, 4) (4, 4)
	(1, 3) (2, 3) (3, 3) (4, 3)
	(1, 2) (2, 2) (3, 2) (4, 2)
	(1, 1) (2, 1) (3, 1) (4, 1)
]]

-- 查询游戏表里有多少个钻头
-- gt 游戏表
-- stage 关卡，从1开始
function getZuanTouNum( gt, stage )
	local n = STAGE_SIZE[stage]  -- 游戏表的宽度
	local count = 0
	for i = 1, n do
		for j = 1, n do
			if ZUAN_TOU == gt[i][j] then
				count = count + 1
			end
		end
	end
	return count
end

-- 查询游戏表里能消除的连锁链
-- gt 游戏表
-- stage 关卡，从1开始
-- @return 有效连锁链组成的数组，如 
-- 		 	{{{1,1}, {1,2}, {2,2}, {2,1}}, 
-- 			 {{2,3}, {3,3}, {4,3}, {4,2}}}
-- 		 表示有两条有效连锁链，连锁链数组里相邻两个数据表示的宝石不一定相邻
function findChain( gt, stage )
	local n = STAGE_SIZE[stage]  -- 游戏表的宽度
	local tCheck = {}  -- 已经搜索过的点
	for i = 1, n do
		tCheck[i] = {}
	end
	local gid = 0  -- 宝石分组编号
	local gmax = 0  -- 当前最大分组编号
	local gemGroup = {}  -- 宝石分组,该组的宝石种类
	local gemMark = {}  -- 宝石分组,某个格子当前被划分为哪个组
	local gemCount = {}  -- 分组内宝石数量
	for i = 1, n do
		for j = 1, n do
			local gem = gt[i][j]  -- 当前宝石各类
			if tCheck[i][j] then  -- 当前宝石已被分组
				gid = gemMark[i][j]  -- 
			else
				-- 设置新分组
				gmax = gmax + 1
				gid = gmax
				tCheck[i][j] = true
				gemGroup[gid] = gem
				gemMark[i][j] = gid
				gemCount[gid] = 1
			end
			-- 只检查[i+1]和[j+1]方向的格子,减少重复检查
			for k = 1, 2 do
				local iNext = i + 1
				local jNext = j
				if k > 1 then
					iNext = i
					jNext = j + 1
				end
				if iNext <= n and jNext <= n then
					if tCheck[iNext][jNext] then 
						-- 邻接的格子已经归为某组,检查宝石种类是否一致
						ngid = gemMark[iNext][jNext]  -- 下一个宝石的分组id
						if gem == gemGroup[ngid] and gid ~= ngid then  -- 宝石种类一致但分组号不一致，则合并两个分组
							for ii = 0, n do
								for jj = 0, n do
									if tCheck[ii][jj] and ngid == gemMark[ii][jj] then
										gemMark[ii][jj] = gid
									end
								end
							end
							gemCount[gid] = gemCount[gid] + gemCount[ngid]
							gemCount[ngid] = 0
						end
					elseif gem == gt[iNext][jNext] then  -- 未被分组宝石种类一致的话归为同一个组
						tCheck[iNext][jNext] = true
						gemMark[iNext][jNext] = gid
						gemCount[gid] = gemCount[gid] + 1
					end
				end 
			end
		end
	end
	-- 找出有效连锁链
	local tValid = {}  -- 连锁分组是否有效
	local tRes = {}
	for k,v in pairs(gemCount) do
		if v >= n then
			tValid[k] = true
			tRes[k] = {}
		end
	end
	for i = 1, n do
		for j = 1, n do
			local gid = gemMark[i][j]
			if tValid[gid] then
				table.insert(tRes[gid], {i,j})
			end
		end
	end
	local res = {}
	for k,v in pairs(tRes) do
		table.insert(res, v)
	end
	return res
end

-- 解压数据
-- data 压缩后的数据
-- sz data里有效数据的大小
-- stage 关卡，从1开始
function unzip( data, sz, stage )
	if stage < 1 then
		return
	end
	local lineRes = {}  -- 一维数组结果数组
	local index = 0  -- 一维数组结果数组下标
	for i = 1, sz do
		local wRes = data[i]
		if index + 5 > GEM_WIDE * GEM_HIGH then  -- 已经全部解压完成
			break
		end
		for j = 1, 5 do 
			index = index + 1
			lineRes[index] = wRes % 8
			wRes = math.floor(wRes / 8)
		end
	end
	local res = {}
	for ii,v in ipairs(lineRes) do  -- 把一维数组转换成二维数组
		local i = math.ceil(ii / GEM_WIDE)
		local j = ii - (i - 1) * GEM_WIDE
		res[i] = res[i] or {}
		if 0 == v then
			res[i][j] = ZUAN_TOU
		elseif 7 == v then
			res[i][j] = FAKE_GEM
		else
			res[i][j] = v + 5 * (stage - 1)
		end
	end
	return res
end