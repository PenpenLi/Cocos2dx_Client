UpScoreNote = class("UpScoreNote", function() return cc.Node:create()  end)

function UpScoreNote:ctor(portion,scorebbtext)
    self.layer  =  cc.LayerColor:create(cc.c4f(0,0,0,125))
    self:addChild(self.layer,3) 
    self.root = ccs.GUIReader:getInstance():widgetFromJsonFile("shuiguoshijie/res/json/FishUI_5.json")
    self:addChild(self.root,100)
    local closebtn = ccui.Helper:seekWidgetByName(self.root,"closebtn")
    local function onTouch(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            self:removeFromParent()
        end 
    end 
    closebtn:addTouchEventListener(onTouch)

    local numtab = ccui.Helper:seekWidgetByName(self.root,"scoretext")
    numtab:setString(tostring(portion))

    local goldnumtext = ccui.Helper:seekWidgetByName(self.root,"goldnumtext")
    goldnumtext:setString(tostring(global.g_gold))

    local scorenum = ccui.Helper:seekWidgetByName(self.root,"sconetxet")
    local disbtn = ccui.Helper:seekWidgetByName(self.root,"pusbtn")
    local addbtn = ccui.Helper:seekWidgetByName(self.root,"addbtn")
    local surebtn = ccui.Helper:seekWidgetByName(self.root,"surebtn")

    local oneBox = ccui.Helper:seekWidgetByName(self.root,"cheaxbox1")
    local fiveBox = ccui.Helper:seekWidgetByName(self.root,"cheaxbox5")
    local tenBox = ccui.Helper:seekWidgetByName(self.root,"cheaxbox10")
    local fithBox = ccui.Helper:seekWidgetByName(self.root,"cheaxbox50")
    local hundBox = ccui.Helper:seekWidgetByName(self.root,"cheaxbox100")
    local fhunBox = ccui.Helper:seekWidgetByName(self.root,"cheaxbox500")

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
        if eventType == ccui.TouchEventType.ended then
            if global.g_gold >= golsum + dicbu and dicbu > 0 then 
                scoredd = scoredd + dicbu*portion
                scorenum:setString(tostring(scoredd))
                golsum = golsum + dicbu
            end 
        end 
    end
    addbtn:addTouchEventListener(addTouch)

    local function surTouch( sender,eventType )
        if eventType == ccui.TouchEventType.ended then
            self:removeFromParent()
            global.g_score = scoredd + global.g_score
            global.g_gold = global.g_gold - golsum
            scorebbtext:setString(tostring(global.g_score))
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
        if global.g_gold >= golsum + dicbu then
            scoredd = scoredd + dicbu*portion
            scorenum:setString(tostring(scoredd))
            golsum = golsum + dicbu
        end  
    end
    oneBox:addEventListener(oneEvent)

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
      if global.g_gold >= golsum + dicbu then      
        scoredd = scoredd + dicbu*portion
        scorenum:setString(tostring(scoredd))
        golsum = golsum + dicbu
      end 
    end
    fiveBox:addEventListener(fiveTouch)

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
      if global.g_gold >= golsum + dicbu then      
        scoredd = scoredd + dicbu*portion
        scorenum:setString(tostring(scoredd))
        golsum = golsum + dicbu
      end 
    end
    tenBox:addEventListener(tenTouch)

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
      if global.g_gold >= golsum + dicbu then
        scoredd = scoredd + dicbu*portion
        scorenum:setString(tostring(scoredd))
        golsum = golsum + dicbu
      end 
    end
    fithBox:addEventListener(fithTouch)

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
      if global.g_gold >= golsum + dicbu then     
        scoredd = scoredd + dicbu*portion
        scorenum:setString(tostring(scoredd))
        golsum = golsum + dicbu
      end 
    end
    hundBox:addEventListener(hunTouch)

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
      if global.g_gold >= golsum + dicbu then     
        scoredd = scoredd + dicbu*portion
        scorenum:setString(tostring(scoredd))
        golsum = golsum + dicbu
      end 
    end
    fhunBox:addEventListener(fhunTouch)
end