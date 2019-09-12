RecordScene = class("RecordScene", LayerBase)

function RecordScene:ctor()
	RecordScene.super.ctor(self)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("att2/res/json/ui_record.json")
	root:setClippingEnabled(true)
	self:addChild(root)

	self.return_function = ccui.Helper:seekWidgetByName(root, "Button_return")         	--返回按钮
	self.return_function:addTouchEventListener(makeClickHandler(self, self.returnClass))

	ccui.Helper:seekWidgetByName(root, "AtlasLabel_notea_in"):setString(global.g_attPlayer:getLocalReward_IN_NOTEA())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_notea_balance"):setString(global.g_attPlayer:getLocalReward_BALANCE_NOTEA())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_notea_out"):setString(global.g_attPlayer:getLocalReward_OUT_NOTEA())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_noteb_in"):setString(global.g_attPlayer:getLocalReward_IN_NOTEB())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_noteb_out"):setString(global.g_attPlayer:getLocalReward_OUT_NOTEB())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_noteb_balance"):setString(global.g_attPlayer:getLocalReward_BALANCE_NOTEB())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_5k_high"):setString(global.g_attPlayer:getLocalReward_HIGH_5K())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_5k_in"):setString(global.g_attPlayer:getLocalReward_IN_5K())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_5k_low"):setString(global.g_attPlayer:getLocalReward_LOW_5K())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_5k_sum"):setString(global.g_attPlayer:getLocalReward_SUM_5K())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_rs_high"):setString(global.g_attPlayer:getLocalReward_HIGH_RS())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_rs_in"):setString(global.g_attPlayer:getLocalReward_IN_RS())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_rs_low"):setString(global.g_attPlayer:getLocalReward_LOW_RS())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_rs_sum"):setString(global.g_attPlayer:getLocalReward_SUM_RS())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_sf_high"):setString(global.g_attPlayer:getLocalReward_HIGH_SF())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_sf_in"):setString(global.g_attPlayer:getLocalReward_IN_SF())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_sf_low"):setString(global.g_attPlayer:getLocalReward_LOW_SF())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_sf_sum"):setString(global.g_attPlayer:getLocalReward_SUM_SF())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_4k_high"):setString(global.g_attPlayer:getLocalReward_HIGH_4K())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_4k_in"):setString(global.g_attPlayer:getLocalReward_IN_4K())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_4k_low"):setString(global.g_attPlayer:getLocalReward_LOW_4K())
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_4k_sum"):setString(global.g_attPlayer:getLocalReward_SUM_4K())
end

function RecordScene:returnClass()
	if setBackOff() == 1 then 
		-- local scene = GameScene.new()
		-- cc.Director:getInstance():replaceScene(scene)
		replaceScene(GameScene, TRANS_CONST.TRANS_SCALE)
	elseif setBackOff() == 2 then
		-- local scene = CompareScene.new()
		-- cc.Director:getInstance():replaceScene(scene)
		replaceScene(CompareScene, TRANS_CONST.TRANS_SCALE)
	end
end

function RecordScene:data()
	
	-- body
end


--判断记录页面返回的页面
local page
function getBackOff(i)
	page = i
end

function setBackOff()
	return page; 
end