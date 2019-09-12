LuDanView = class("LuDanView", PopUpView)

function LuDanView:ctor(data)
	LuDanView.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("caidaxiao/res/json/ui_ludan.json")
	self.nodeUI_:addChild(root)

	self.scrollView_ = ccui.Helper:seekWidgetByName(root, "ScrollView_8")


	local back = ccui.Helper:seekWidgetByName(root, "back")
	back:addTouchEventListener(makeClickHandler(self, self.onClose))
	local xian = cc.Sprite:create("caidaxiao/res/game/BiBei/Other/11.png")
	self.scrollView_:addChild(xian)
	-- xian:setScale(0.8)
	xian:setPosition(25,290)
	self:show(data)
end

function LuDanView:show( data ) --下标最大的是最新的
	-- body
	for i=100,1,-1 do --删除全0
		if data[i] ==0 then
			table.remove(data,i)  
		end	
	end

	-- local datas = {}
	-- for i=1,#data do
	-- 	datas[i] = data[#data-i+1]
	-- end
	local datas = data

	--去掉最开始的和
	for i = #datas,1,-1 do
		if datas[i] ==3 and i== (#datas) then
			-- print("需要移除的数据",datas[i])
			table.remove(datas,i)  
		end	
	end
	-- table.dump( datas )

	local dataH = {}
	local ds = {}
	ds[1] = datas[#datas]
	local index = datas[#datas]

	for i= #datas-1,1,-1 do
		-- print("执行",i)
		if ds[i-1] == datas[i] or datas[i] == 3 or datas[i] == index  then
			table.insert(ds,datas[i])
			if i==1 then --最后一个
				table.insert(dataH,ds)
			end 
		else
			index = datas[i]
			table.insert(dataH,ds)
			ds = {}
			ds[1] = datas[i]
			if i==1 then --最后一个
				table.insert(dataH,ds)
			end 
		end
	end
	-- table.dump( dataH )

	self.scrollView_:setInnerContainerSize(cc.size((#dataH)*50+100,600))
	for i=1,#dataH do
		local x = 50*i
		for j=1,#dataH[i] do
			local y = 500- 45*(j-1)
			local ld = nil;
			if dataH[i][j] == 1 then
				ld = cc.Sprite:create("caidaxiao/res/game/BiBei/Other/da2.png")
			elseif dataH[i][j] == 2 then
				ld = cc.Sprite:create("caidaxiao/res/game/BiBei/Other/xiao2.png")
			elseif dataH[i][j] == 3  then
				ld= cc.Sprite:create("caidaxiao/res/game/BiBei/Other/he2.png")
			end
			-- ld:setScale(0.7)
			ld:setPosition(x,y)
			self.scrollView_:addChild(ld)
		end
		local xian = cc.Sprite:create("caidaxiao/res/game/BiBei/Other/11.png")
		self.scrollView_:addChild(xian)
		-- xian:setScale(0.8)
		xian:setPosition(x+25,283)
	end
	
end

function LuDanView:onClose()
	self:close()
end


function LuDanView:touchBegan(_touchX, _touchY, _preTouchX, _preTouchY)
    --cclog("touchBegan")
    return true
end

function LuDanView:touchMoved(_touchX, _touchY, _preTouchX, _preTouchY)
    --cclog("touchMoved")
end

function LuDanView:touchEnded(_touchX, _touchY, _preTouchX, _preTouchY)
    --cclog("touchEnded")
    self:close()
end

function LuDanView:touchCancelled(_touchX, _touchY, _preTouchX, _preTouchY)
    --cclog("touchCancelled")
    self:touchEnded(_touchX, _touchY, _preTouchX, _preTouchY)
end