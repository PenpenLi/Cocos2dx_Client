local Under = class("Under", function()
  return cc.Node:create()
end)

function Under:ctor(portion)
	self.root = ccs.GUIReader:getInstance():widgetFromJsonFile("buyu1/res/Json/FishUI_3.json")
	self:addChild(self.root,100)
	self.root:setAnchorPoint(cc.p(0.5,0.5))
	local funnum = ccui.Helper:seekWidgetByName(self.root,"funnum")
	funnum:setString(tostring(portion))
	local goldd = ccui.Helper:seekWidgetByName(self.root,"goldd")
	local golda = ccui.Helper:seekWidgetByName(self.root,"golda")
	local surdbtn = ccui.Helper:seekWidgetByName(self.root,"surdbtn")
	local closebtn = ccui.Helper:seekWidgetByName(self.root,"closebtn")
	goldd:setString(tostring(g_score[num]))
	local golsum = math.floor(g_score[num] / portion)
	golda:setString(tostring(golsum))
	local function surTouch(sender,eventType)
	    if eventType == ccui.TouchEventType.ended then
	      	if golsum >= 1 then
	      		gamesvr.sendExchangeFishScore(0,golsum)
	      	end 
	      	self.root:getParent():removeFromParent()
	    end 
  	end
  	surdbtn:addTouchEventListener(surTouch)
  	local function closTouch(sender,eventType)
  		if eventType == ccui.TouchEventType.ended then
	      	self.root:getParent():removeFromParent()
      		closebtn = nil
	    end 
  	end
  	closebtn:addTouchEventListener(closTouch)
end

return Under