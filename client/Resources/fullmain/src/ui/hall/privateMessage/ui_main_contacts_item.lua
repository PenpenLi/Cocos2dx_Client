ui_main_contacts_item = class("ui_main_contacts_item")

function ui_main_contacts_item:ctor(userId, account, isRead)
    self.userId = userId
    self.account = account
    self.isRead = isRead

    self.root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_contacts_item.json")
    self.root:setTag(userId)
    self.img_background = ccui.Helper:seekWidgetByName(self.root, "img_background")
    self:setBackgroundVisible(false)
    
    local lab_account =  ccui.Helper:seekWidgetByName(self.root, "lab_account")
    lab_account:setString(tostring(self.userId))

    self.img_sign =  ccui.Helper:seekWidgetByName(self.root, "img_sign")
    if isRead == "1" then -- 1表示已读 2表示有未读消息
        self.img_sign:setVisible(false)
    else
        self.img_sign:setVisible(true)
    end 
    print("isRead = " .. isRead .. "   userId = " .. userId)
end

function ui_main_contacts_item:setSignVisible(isVisible)
    self.img_sign:setVisible(isVisible)
end 

function ui_main_contacts_item:setBackgroundVisible(isVisible)
    self.img_background:setVisible(isVisible)
end 

function ui_main_contacts_item:getUserID()
    return self.userId
end 

function ui_main_contacts_item:getIndex()
    return self.index
end 

function ui_main_contacts_item:getItem()
    return self.root
end 
