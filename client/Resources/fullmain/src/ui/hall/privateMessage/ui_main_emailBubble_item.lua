ui_main_emailBubble_item  = class("ui_main_emailBubble_item")

MAX_CONTENT_WIDTH = 600

POP_ORIENT = {
    LEFT = 2,
    RIGHT = 3,
}

function ui_main_emailBubble_item:ctor(orient, dataEmail, account, userID)
    self.dataEmail_ = dataEmail

    self.root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_emailBubble_item.json")

    local rect = cc.rect(8, 8, 44, 44)
    if orient == POP_ORIENT.LEFT then
        local panel_leftMessage = ccui.Helper:seekWidgetByName(self.root, "panel_leftMessage")
        panel_leftMessage:setVisible(true)

        self.panel_chatBubble = ccui.Helper:seekWidgetByName(panel_leftMessage, "panel_chatBubble")

        local lab_time = ccui.Helper:seekWidgetByName(panel_leftMessage, "lab_time")
        lab_time:setString(self.dataEmail_.InsertTime)

        local lab_account = ccui.Helper:seekWidgetByName(panel_leftMessage, "lab_account")
        lab_account:setString(account .. "(" .. userID .. ")")

        self.btnTake_ = ccui.Helper:seekWidgetByName(panel_leftMessage, "Button_Take")
        self.btnTake_:setPressedActionEnabled(true)
        self.btnTake_:addTouchEventListener(makeClickHandler(self, self.onTake))
        self.btnTake_:setVisible(self.dataEmail_.status == 10)

        self.frame_ = ccui.Scale9Sprite:create(rect, "fullmain/res/privateMessage/bg_chat01.png")
        self.frame_:setAnchorPoint(cc.p(0, 1))
        self.frame_:setContentSize(cc.size(200, 60))
        self.panel_chatBubble:addChild(self.frame_)

    elseif orient == POP_ORIENT.RIGHT then
        local panel_rightMessage = ccui.Helper:seekWidgetByName(self.root, "panel_rightMessage")
        panel_rightMessage:setVisible(true)

        self.panel_chatBubble = ccui.Helper:seekWidgetByName(panel_rightMessage, "panel_chatBubble")

        local lab_time = ccui.Helper:seekWidgetByName(panel_rightMessage, "lab_time")
        lab_time:setString(self.dataEmail_.InsertTime)

        local lab_account = ccui.Helper:seekWidgetByName(panel_rightMessage, "lab_account")
        lab_account:setString(account .. "(" .. userID .. ")")

        self.frame_ = ccui.Scale9Sprite:create(rect, "fullmain/res/privateMessage/bg_chat02.png")
        self.frame_:setAnchorPoint(cc.p(1, 1))
        self.frame_:setContentSize(cc.size(200, 60))
        self.panel_chatBubble:addChild(self.frame_)
    end

    self:refreshString(self.dataEmail_.Content, orient)
end

function ui_main_emailBubble_item:refreshString(content, orient) 
    print("content = " .. content)
    --local content = "我爱北京天安门，我爱北京"
    --local content = "AS ASAD FDSD FGDSG FSDHGGDFHJ  YYTJ   JYGTF J JH KHGK KGK LIJ LKJL SD GHHJ K KK K fgdh hgs hh hdf jfj jfjj"

    local tempLab = cc.Label:createWithTTF(content, "fullmain/res/fonts/FZY4JW.ttf", 25)
    
    local tempLabSize = tempLab:getContentSize()
    local textWidth 
    if tempLabSize.width >= MAX_CONTENT_WIDTH then 
        textWidth = MAX_CONTENT_WIDTH
    else 
        textWidth = tempLabSize.width
    end
    
    local labelContent = newTTFLabel(
        {
            text = content,
            font = "fullmain/res/fonts/FZY4JW.ttf",
            color = cc.c3b(35, 29, 73),
            size = 25,
            x = 0,
            y = 0,
            dimensions = cc.size(textWidth, 0)
        }
    )

    if orient == POP_ORIENT.LEFT then
        labelContent:setAnchorPoint(0, 1)
        labelContent:setPosition(cc.p(10, -10))
    elseif orient == POP_ORIENT.RIGHT then
        labelContent:setAnchorPoint(1, 1)
        labelContent:setPosition(cc.p(-10, -10))
    end 
    self.panel_chatBubble:addChild(labelContent)

    local sz = labelContent:getContentSize()
    
    local frameWidth = math.max(200, sz.width + 20)
    local frameHeight = math.max(60, sz.height + 20)
    self.frame_:setContentSize(cc.size(frameWidth, frameHeight))
    self.root:setContentSize(cc.size(frameWidth, frameHeight + 50))
end

function ui_main_emailBubble_item:onTake()
    LoadingView.showTips()
    gatesvr.sendTakeEmailReward(self.dataEmail_.ID)
end

function ui_main_emailBubble_item:setTaked()
    self.dataEmail_.status = 11
    self.btnTake_:setVisible(false)
end