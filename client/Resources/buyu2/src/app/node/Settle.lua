local Settle = class("Settle", function()
  return cc.Node:create()
end)
function Settle:ctor(portion)

  self.root = ccs.GUIReader:getInstance():widgetFromJsonFile("buyu2/res/Json/FishUI_2.json")
  self:addChild(self.root,100)
  self.root:setAnchorPoint(cc.p(0.5,0.5))
  local closebtn = ccui.Helper:seekWidgetByName(self.root,"closebtn")
  local function onTouch(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
      self.root:getParent():removeFromParent()
      g_bolchex = false
    end 
  end 
  closebtn:addTouchEventListener(onTouch)
  local numtab = ccui.Helper:seekWidgetByName(self.root,"numtab")
  numtab:setString(tostring(portion))
  local scorenum = ccui.Helper:seekWidgetByName(self.root,"scorenum")
  local disbtn = ccui.Helper:seekWidgetByName(self.root,"disbtn")
  local addbtn = ccui.Helper:seekWidgetByName(self.root,"addbtn")
  local surebtn = ccui.Helper:seekWidgetByName(self.root,"surebtn")
  local oneBox = ccui.Helper:seekWidgetByName(self.root,"oneBox")
  local fiveBox = ccui.Helper:seekWidgetByName(self.root,"fiveBox")
  local tenBox = ccui.Helper:seekWidgetByName(self.root,"tenBox")
  local fithBox = ccui.Helper:seekWidgetByName(self.root,"fithBox")
  local hundBox = ccui.Helper:seekWidgetByName(self.root,"hundBox")
  local fhunBox = ccui.Helper:seekWidgetByName(self.root,"fhunBox")
  fiveBox:setSelected(true)
  local dicbu = 0
  local scoredd = 0
  local golsum = 0


  local function disTouch(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
      if scoredd >= dicbu*portion then
        scoredd = scoredd - dicbu*portion
        scorenum:setString(tostring(scoredd))        
        golsum = golsum - dicbu
      end 
    end 
  end
  disbtn:addTouchEventListener(disTouch)
  local function addTouch( sender,eventType )
    if eventType == ccui.TouchEventType.ended and g_gold[num] >= golsum + dicbu then
      scoredd = scoredd + dicbu*portion
      scorenum:setString(tostring(scoredd))
      golsum = golsum + dicbu
    end 
  end
  addbtn:addTouchEventListener(addTouch)

  local function surTouch( sender,eventType )
    if eventType == ccui.TouchEventType.ended then
      if g_gold[num] >= golsum then
        gamesvr.sendExchangeFishScore(1,golsum)
      end 
      self.root:getParent():removeFromParent()
      g_bolchex = false
    end 
  end
  surebtn:addTouchEventListener(surTouch)

  local function oneEvent(sender,eventType)
    if eventType == ccui.CheckBoxEventType.selected then
      fiveBox:setSelected(false)
      tenBox:setSelected(false)
      fithBox:setSelected(false)
      hundBox:setSelected(false)
      fhunBox:setSelected(false)
    elseif eventType == ccui.CheckBoxEventType.unselected then
      oneBox:setSelected(true)
    end 
    dicbu = 1
    if g_gold[num] >= golsum + dicbu then
        scoredd = scoredd + dicbu*portion
        scorenum:setString(tostring(scoredd))
        golsum = golsum + dicbu
    end  
  end
  oneBox:addEventListenerCheckBox(oneEvent)

  local function fiveTouch(sender,eventType)
    if eventType == ccui.CheckBoxEventType.selected then     
      oneBox:setSelected(false)
      tenBox:setSelected(false)
      fithBox:setSelected(false)
      hundBox:setSelected(false)
      fhunBox:setSelected(false)
    elseif eventType == ccui.CheckBoxEventType.unselected then
      fiveBox:setSelected(true)
    end
    dicbu = 5
    if g_gold[num] >= golsum + dicbu then      
      scoredd = scoredd + dicbu*portion
      scorenum:setString(tostring(scoredd))
      golsum = golsum + dicbu
    end 
  end
  fiveBox:addEventListenerCheckBox(fiveTouch)

  local function tenTouch(sender,eventType)
    if eventType == ccui.CheckBoxEventType.selected then
      oneBox:setSelected(false)
      fiveBox:setSelected(false)
      fithBox:setSelected(false)
      hundBox:setSelected(false)
      fhunBox:setSelected(false)
    elseif eventType == ccui.CheckBoxEventType.unselected then
      tenBox:setSelected(true)
    end
    dicbu = 10
    if g_gold[num] >= golsum + dicbu then      
      scoredd = scoredd + dicbu*portion
      scorenum:setString(tostring(scoredd))
      golsum = golsum + dicbu
    end 
  end
  tenBox:addEventListenerCheckBox(tenTouch)

  local function fithTouch(sender,eventType)
    if eventType == ccui.CheckBoxEventType.selected then
      oneBox:setSelected(false)
      fiveBox:setSelected(false)
      tenBox:setSelected(false)
      hundBox:setSelected(false)
      fhunBox:setSelected(false)
    elseif eventType == ccui.CheckBoxEventType.unselected then
      fithBox:setSelected(true)
    end
    dicbu = 50
    if g_gold[num] >= golsum + dicbu then
      scoredd = scoredd + dicbu*portion
      scorenum:setString(tostring(scoredd))
      golsum = golsum + dicbu
    end 
  end
  fithBox:addEventListenerCheckBox(fithTouch)

  local function hunTouch(sender,eventType)
    if eventType == ccui.CheckBoxEventType.selected then
      oneBox:setSelected(false)
      fiveBox:setSelected(false)
      tenBox:setSelected(false)
      fithBox:setSelected(false)
      fhunBox:setSelected(false)
    elseif eventType == ccui.CheckBoxEventType.unselected then 
      hundBox:setSelected(true)
    end
    dicbu = 100
    if g_gold[num] >= golsum + dicbu then     
      scoredd = scoredd + dicbu*portion
      scorenum:setString(tostring(scoredd))
      golsum = golsum + dicbu
    end 
  end
  hundBox:addEventListenerCheckBox(hunTouch)

  local function fhunTouch(sender,eventType)
    if eventType == ccui.CheckBoxEventType.selected then
      oneBox:setSelected(false)
      fiveBox:setSelected(false)
      tenBox:setSelected(false)
      fithBox:setSelected(false)
      hundBox:setSelected(false)
    elseif eventType == ccui.CheckBoxEventType.unselected then
      fhunBox:setSelected(true)
    end
    dicbu = 500
    if g_gold[num] >= golsum + dicbu then     
      scoredd = scoredd + dicbu*portion
      scorenum:setString(tostring(scoredd))
      golsum = golsum + dicbu
    end 
  end
  fhunBox:addEventListenerCheckBox(fhunTouch)
end

return Settle