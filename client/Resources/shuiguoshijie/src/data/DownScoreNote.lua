DownScoreNote = class("DownScoreNote", function() return cc.Node:create() end)

function DownScoreNote:ctor(portion,scorebbtext)
	self.layer  =  cc.LayerColor:create(cc.c4f(0,0,0,125))
    self:addChild(self.layer,3) 
	self.root = ccs.GUIReader:getInstance():widgetFromJsonFile("shuiguoshijie/res/json/FishUI_7.json")
	self:addChild(self.root,100)

	local funnum = ccui.Helper:seekWidgetByName(self.root,"numtext")
	funnum:setString(tostring(portion))

	local goldd = ccui.Helper:seekWidgetByName(self.root,"scoretext")
	local golda = ccui.Helper:seekWidgetByName(self.root,"goldtext")
	local surdbtn = ccui.Helper:seekWidgetByName(self.root,"surebtn")
	local closebtn = ccui.Helper:seekWidgetByName(self.root,"closebtn")
	goldd:setString(tostring(global.g_score))
	local golsum = math.floor(global.g_score/ portion)
	golda:setString(tostring(golsum))
	local function surTouch(sender,eventType)
	    if eventType == ccui.TouchEventType.ended then
	    	global.g_score = global.g_score - golsum*portion
	    	global.g_gold = global.g_gold + golsum
	    	scorebbtext:setString(tostring(global.g_score))
	      	self:removeFromParent()
	    end 
  	end
  	surdbtn:addTouchEventListener(surTouch)
  	local function closTouch(sender,eventType)
  		if eventType == ccui.TouchEventType.ended then
	      	self:removeFromParent()
	    end 
  	end
  	closebtn:addTouchEventListener(closTouch)
end