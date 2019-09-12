ui_main_private_message = class("ui_main_private_message", PopUpView)

SWITCH_PRIVATE_CODE = {
    SWITCH_EMAIL = 1, --邮件
    SWITCH_PRIVATER = 2, --私信
}

function ui_main_private_message:ctor()
    ui_main_private_message.super.ctor(self, true)

    self.defaultContacts = nil -- 默认选择的联系人
    self.curChatUser = nil -- 当前聊天用户
    self.contactsTab = {} -- 联系过的人
    self.searchID = nil -- 搜索的用户ID

    local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_private_message.json")
    self.nodeUI_:addChild(root)

    local btn_close = ccui.Helper:seekWidgetByName(root, "btn_close")
    btn_close:setPressedActionEnabled(true)
    btn_close:addTouchEventListener(makeClickHandler(self, self.onClose))

    local btn_send = ccui.Helper:seekWidgetByName(root, "btn_send")
    btn_send:setPressedActionEnabled(true)
    btn_send:addTouchEventListener(makeClickHandler(self, self.onSend)) 

    local btn_search = ccui.Helper:seekWidgetByName(root, "btn_search")
    btn_search:setPressedActionEnabled(true)
    btn_search:addTouchEventListener(makeClickHandler(self, self.onSearch))

    self.textField_sendContent = createCursorTextField(root, "textField_sendContent")
    self.textField_sendContent:setFontColor(cc.c3b(255, 255, 255))

    self.textField_search = createCursorTextField(root, "textField_search")
    self.textField_search:setFontColor(cc.c3b(255, 255, 255))
    
    self.listView_chatWindow = ccui.Helper:seekWidgetByName(root, "listView_chatWindow")

    local lab = ccui.Helper:seekWidgetByName(root, "Label_17")
    --lab:setString("AAAAA")

    self.listView_contacts = ccui.Helper:seekWidgetByName(root, "listView_contacts")
    self.listView_contacts:addEventListener(handler(self, self.onContactsListView))

    self.img_tips = ccui.Helper:seekWidgetByName(root, "img_tips")
    self.img_tips:setVisible(false)

    self.panelEmail_ = ccui.Helper:seekWidgetByName(root, "Panel_Email")
    self.panelEmail_.bgEmail = ccui.Helper:seekWidgetByName(self.panelEmail_, "Image_EmailBg")
    self.panelEmail_.iconUnread = ccui.Helper:seekWidgetByName(self.panelEmail_, "Image_EmailRead")

    self.panelEmail_.bgEmail:setVisible(false)
    self.panelEmail_.iconUnread:setVisible(false)

    self.panelEmail_:addTouchEventListener(makeClickHandler(self, self.onTouchEmail))

    -- self:getChatInfo()
    -- self:m_update()
end

function ui_main_private_message:onPopUpComplete()
    self:requestEmailUnread()
end

function ui_main_private_message:requestEmailUnread()
    LoadingView.showTips()

    local time = os.time()
    local playerId = global.g_mainPlayer:getPlayerId()
    local str = string.format("keyD60807C36977BD71D4B9375D3DD73815userId%dtimestamp%d", playerId, time)
    local sign = string.upper(cc.utils:getDataMD5Hash(str))
    local url = string.format(mailUrl, playerId, time, 1, 100, 3, sign)

    MultipleDownloader:createDataDownLoad(
        {
            identifier = "EmailUnread",
            fileUrl = url,
            onDataTaskSuccess = function(dataTask, params)
                LoadingView.closeTips()

                local luaTbl = json.decode(params)
                if luaTbl.code == 100 and luaTbl.data.UnRead > 0 then
                    self.panelEmail_.iconUnread:setVisible(true)
                end

                self:requestPrivater()
            end,
            onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
                LoadingView.closeTips()

                WarnTips.showTips(
                        {
                            text = errorMsg,
                            style = WarnTips.STYLE_Y
                        }
                    )
            end,
        }
    )
end

function ui_main_private_message:requestPrivater()
    LoadingView.showTips()

    local playerId = global.g_mainPlayer:getPlayerId() 
    local url = string.format(privateMessageUserUrl,playerId)

    MultipleDownloader:createDataDownLoad(
        {
            identifier = "Privater",
            fileUrl = url,
            onDataTaskSuccess = function(dataTask, params)
                LoadingView.closeTips()

                local tab = json.decode(params)
                self:initContacts(tab.data)

                self:m_update()

                self:onTouchEmail()
            end,
            onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
                LoadingView.closeTips()

                WarnTips.showTips(
                        {
                            text = errorMsg,
                            style = WarnTips.STYLE_Y
                        }
                    )
            end,
        }
    )
end

function ui_main_private_message:onTouchEmail()
    if self.switchCode_ == SWITCH_PRIVATE_CODE.SWITCH_EMAIL then
        return
    end

    self:readAllEmail()
    -- self:requestEmail()
end

function ui_main_private_message:readAllEmail()
    LoadingView.showTips()

    local playerId = global.g_mainPlayer:getPlayerId()
    local url = string.format(mailReadAllUrl, playerId)

    MultipleDownloader:createDataDownLoad(
        {
            identifier = "ReadAllEmail",
            fileUrl = url,
            onDataTaskSuccess = function(dataTask, params)
                LoadingView.closeTips()

                local luaTbl = json.decode(params)
                self.panelEmail_.iconUnread:setVisible(false)
                self:requestEmail()
            end,
            onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
                LoadingView.closeTips()

                WarnTips.showTips(
                        {
                            text = errorMsg,
                            style = WarnTips.STYLE_Y
                        }
                    )
            end,
        }
    )
end

function ui_main_private_message:requestEmail()
    LoadingView.showTips()

    local time = os.time()
    local playerId = global.g_mainPlayer:getPlayerId()
    local str = string.format("keyD60807C36977BD71D4B9375D3DD73815userId%dtimestamp%d", playerId, time)
    local sign = string.upper(cc.utils:getDataMD5Hash(str))
    local url = string.format(mailUrl, playerId, time, 1, 20, 2, sign)

    MultipleDownloader:createDataDownLoad(
        {
            identifier = "RequestEmail",
            fileUrl = url,
            onDataTaskSuccess = function(dataTask, params)
                LoadingView.closeTips()

                local luaTbl = json.decode(params)

                self.switchCode_ = SWITCH_PRIVATE_CODE.SWITCH_EMAIL
                self.listView_chatWindow:removeAllChildren()

                self.nodeEmails_ = {}
                self.dataEmails_ = {}
                if luaTbl.code == 100 then
                    for i = #luaTbl.data.data, 1, -1 do
                        local dataEmail = luaTbl.data.data[i]
                        local emailRecordItem = ui_main_emailBubble_item.new(POP_ORIENT.LEFT, dataEmail, LocalLanguage:getLanguageString("L_1224824cbefeaee0"), 0)
                        self.listView_chatWindow:pushBackCustomItem(emailRecordItem.root)

                        self.nodeEmails_[dataEmail.ID] = emailRecordItem
                        self.dataEmails_[dataEmail.ID] = dataEmail
                    end
                end

                self:refreshChatWindow()

                self:releaseSelectedContact()
                self.panelEmail_.bgEmail:setVisible(true)
            end,
            onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
                LoadingView.closeTips()

                WarnTips.showTips(
                        {
                            text = errorMsg,
                            style = WarnTips.STYLE_Y
                        }
                    )
            end,
        }
    )
end

function ui_main_private_message:releaseSelectedEmail()
    self.nodeEmails_ = {}
    self.panelEmail_.bgEmail:setVisible(false)
end

function ui_main_private_message:m_update()
    function update(dt)
        self:getUnReadMessage()
    end 
    self.updateHandle = cc.Director:getInstance():getScheduler():scheduleScriptFunc(update, 15, false) 
end 

-- 获取未读消息
function ui_main_private_message:getUnReadMessage()
    if self.defaultContacts == nil then 
        return 
    end 

    self.curChatUser = self.defaultContacts -- 记录当前是跟谁在聊天， 获取到未读消息后需要对比一下是否还是这个用户

    local playerId = global.g_mainPlayer:getPlayerId() 
    local recvUserId = self.contactsTab[self.defaultContacts]:getUserID()
    local time = os.time()
    local str = string.format("keyD60807C36977BD71D4B9375D3DD73815SendUserID%dRecvUserID%d", playerId, recvUserId)
    local sign = string.upper(cc.utils:getDataMD5Hash(str))

    local pwd=cc.utils:getDataMD5Hash(global.g_mainPlayer:getLoginPassword())
    pwd=string.upper(pwd) 

    local url = string.format(unReadMessageUrl, "GetPrivateStatus", playerId, recvUserId, pwd, 1, 10000, sign)

    MultipleDownloader:createDataDownLoad(
        {
            identifier = "GetUnReadMessage",
            fileUrl = url,
            onDataTaskSuccess = function(dataTask, params)
                local tab = json.decode(params)
                self:unReadMessageHandle(tab.data.data)
                self:getOtherUesrIsUnread() -- 获取其他用户是否有未读消息 如果有未读消息 那么就需要标记出来
            end,
        }
    )
end

-- 获取其他用户是否有未读消息
function ui_main_private_message:getOtherUesrIsUnread()
    local playerId = global.g_mainPlayer:getPlayerId() 
    local url = string.format(privateMessageUserUrl,playerId)

    MultipleDownloader:createDataDownLoad(
        {
            identifier = "GetOtherUesrIsUnread",
            fileUrl = url,
            onDataTaskSuccess = function(dataTask, params)
                local tab = json.decode(params)
                self:signUnreadUser(tab.data)
            end,
        }
    )
end

-- 标记有未读消息的联系人
function ui_main_private_message:signUnreadUser(tab)
    if tab == nil or #tab <= 0 then 
        return 
    end  

    for i = 1, #tab do
        if tab[i].MeStatus == "2" then -- 2表示未读状态 
            local id = tab[i].UserID
            if self.contactsTab[id] then 
                self.contactsTab[id]:setSignVisible(true)
            else
                self:createContacts(id, tab[i].Accounts, "2") -- 新建联系人
            end 
        end 
    end 
end

-- 获取所有聊天记录
function ui_main_private_message:getChatRecord(recvUserID, isSendMessageFlag)
    local playerId = global.g_mainPlayer:getPlayerId() 

    local time = os.time()
    local str = string.format("keyD60807C36977BD71D4B9375D3DD73815SendUserID%dRecvUserID%d", playerId, recvUserID)
    local sign = string.upper(cc.utils:getDataMD5Hash(str))

    local pwd=cc.utils:getDataMD5Hash(global.g_mainPlayer:getLoginPassword())
    pwd=string.upper(pwd)

    local url = string.format(privateMessageChatRecordUrl, "GetPrivatesite", playerId, recvUserID, pwd, 1, 10000, sign)

    LoadingView.showTips()

    MultipleDownloader:createDataDownLoad(
        {
            identifier = "GetChatRecord",
            fileUrl = url,
            onDataTaskSuccess = function(dataTask, params)
                LoadingView.closeTips()

                local tab = json.decode(params)
                self:initChatRecord(tab.data)
                if isSendMessageFlag then -- 是否需要发送消息
                    self:sendMessage()
                end 
            end,
            onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
                LoadingView.closeTips()

                WarnTips.showTips(
                        {
                            text = errorMsg,
                            style = WarnTips.STYLE_Y
                        }
                    )
            end,
        }
    )
end

function ui_main_private_message:initChatRecord(dataTab)
    local playerId = global.g_mainPlayer:getPlayerId() 
    local messageTab = dataTab.data
    local orient
    for i = 1, #messageTab do 
        if messageTab[i].UserID == playerId then -- 当前玩家自己发送的聊天记录 需要显示在右边
            orient = POP_ORIENT.RIGHT
        else
            orient = POP_ORIENT.LEFT
        end 
        local chatRecordItem = ui_main_chatBubble_item.new(orient, messageTab[i].InsertTime, messageTab[i].Accounts, messageTab[i].UserID, messageTab[i].Content)
        self.listView_chatWindow:pushBackCustomItem(chatRecordItem.root)
    end 

    self:refreshChatWindow()
end 

function ui_main_private_message:unReadMessageHandle(dataTab)
    if dataTab == nil or #dataTab <= 0 or self.curChatUser ~= self.defaultContacts then 
        return 
    end  

    for i = 1, #dataTab do
        local chatRecordItem = ui_main_chatBubble_item.new(POP_ORIENT.LEFT, dataTab[i].InsertTime, dataTab[i].Accounts, dataTab[i].UserID, dataTab[i].Content)
        self.listView_chatWindow:pushBackCustomItem(chatRecordItem.root)
    end 

    self:refreshChatWindow()
end

function ui_main_private_message:changeChatRecord(recvUserID)
    self.listView_chatWindow:removeAllChildren()

    self:getChatRecord(recvUserID)
end 

function ui_main_private_message:createContacts(userId, account, isRead)
    self.contactsTab[userId] = ui_main_contacts_item.new(userId, account, isRead)
    self.listView_contacts:pushBackCustomItem(self.contactsTab[userId].root)
end

function ui_main_private_message:initContacts(tab)
    if tab == nil or #tab <= 0 then 
        return 
    end 

    -- self.defaultContacts = tab[1].UserID -- 初始化默认选择的联系人 默认选择第一个联系人 如果有未读消息的联系人 那么就选择到最后一个未读的联系人

    for i = 1, #tab do
        self:createContacts(tab[i].UserID, tab[i].Accounts, tab[i].MeStatus)
        -- if tab[i].MeStatus == "2" then 
        --     self.defaultContacts = tab[i].UserID -- 默认选择的联系人
        -- end 
    end

    -- self.textField_search:setText(self.defaultContacts)

    -- self.contactsTab[self.defaultContacts]:setBackgroundVisible(true)
    -- self.contactsTab[self.defaultContacts]:setSignVisible(false)
    -- self:getChatRecord(self.contactsTab[self.defaultContacts]:getUserID())
end 

function ui_main_private_message:onContactsListView(sender, eventType)
    if eventType == ccui.ListViewEventType.ONSELECTEDITEM_END then
        self:releaseSelectedEmail()

        self.switchCode_ = SWITCH_PRIVATER

        local index = self.listView_contacts:getCurSelectedIndex()
        local item = self.listView_contacts:getItem(index)
        local userId = item:getTag()
        if userId ~= self.defaultContacts then 
            self:changeSelect(userId)
            self.textField_search:setText(self.defaultContacts)
        end 
    end
end

function ui_main_private_message:releaseSelectedContact()
    if self.defaultContacts then
        self.contactsTab[self.defaultContacts]:setBackgroundVisible(false)
        self.defaultContacts = nil
    end
end

function ui_main_private_message:onSend() 
    local strSearch = string.trim(self.textField_search:getText())
    self.searchID = tonumber(strSearch)

    if strSearch == "" or self.searchID == nil then -- 用户ID为数字，请正确输入搜索的ID
        WarnTips.showTips(
            {
                text = LocalLanguage:getLanguageString("L_11b89b365b1d9b96"),
                style = WarnTips.STYLE_Y
            }
        )
        self.textField_search:setText("")
        return false
    end

    if self.contactsTab[self.searchID] then
        if self.searchID ~= self.defaultContacts then 
            local item = self.contactsTab[self.searchID]:getItem()
            local index = self.listView_contacts:getIndex(item) 
            local percent = self:calculationPercent(index)
            self.listView_contacts:scrollToPercentVertical(percent, 0.5, true)
            
            if self.defaultContacts ~= nil then 
                self.contactsTab[self.defaultContacts]:setBackgroundVisible(false)
            end 
            self.defaultContacts = self.searchID 
            self.contactsTab[self.defaultContacts]:setBackgroundVisible(true)
            self.contactsTab[self.defaultContacts]:setSignVisible(false)

            self.listView_chatWindow:removeAllChildren()
            self:getChatRecord(self.searchID, true)
        else
            self:sendMessage()
        end 
    else 
        self.listView_chatWindow:removeAllChildren()
        if self.defaultContacts ~= nil then 
            self.contactsTab[self.defaultContacts]:setBackgroundVisible(false)
        end 
        self.defaultContacts = nil
        self:sendMessage()
    end
end

function ui_main_private_message:sendMessage() 
    local strSend = string.trim(self.textField_sendContent:getText())

    if strSend == "" then -- 请输入发送内容
        WarnTips.showTips(
            {
                text = LocalLanguage:getLanguageString("L_8276607e586ecabe"),
                style = WarnTips.STYLE_Y
            }
        )
        return 
    end 

    local playerId = global.g_mainPlayer:getPlayerId()
    local recvUserId
    if self.defaultContacts == nil then  -- 搜索了一个新的用户  当前默认的联系人为nil 表示自己目前的联系人中没有这个搜索的人
        recvUserId = self.searchID -- 接收消息者为搜索的用户
    else 
        recvUserId = self.contactsTab[self.defaultContacts]:getUserID()
    end 

    local url = string.format(SendPivateMessageUrl,playerId, recvUserId, strSend)
    url = string.gsub(url, " ", "+")

    MultipleDownloader:createDataDownLoad(
        {
            identifier = "SendMessage",
            fileUrl = url,
            onDataTaskSuccess = function(dataTask, params)
                local tab = json.decode(params)
                if tab.code == 200 then  -- 发送消息成功
                    if self.defaultContacts == nil then 
                        self.defaultContacts = tab.data.UserIDRecv
                        self:createContacts(tab.data.UserIDRecv, tab.data.AccountRecv, "1") -- 新建联系人
                        
                        self.contactsTab[self.defaultContacts]:setBackgroundVisible(true)
                        local percent = self:calculationPercent(self.defaultContacts)
                        self.listView_contacts:scrollToPercentVertical(percent, 0.5, true)
                    end
                    self:sendMessageSuccessHandle(strSend, tab.data)
                elseif tab.code == 500 then -- 发送消息错误
                    WarnTips.showTips(
                        {
                            text = LocalLanguage:getLanguageString("L_75ae419de5467022"), -- tab.msg
                            style = WarnTips.STYLE_Y
                        }
                    )
                end 
            end,
            onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
                WarnTips.showTips(
                        {
                            text = errorMsg,
                            style = WarnTips.STYLE_Y
                        }
                    )
            end,
        }
    )

    self.textField_sendContent:setText("")
    
    if cc.PLATFORM_OS_WINDOWS == PLATFROM then
        self.textField_sendContent:attachWithIME()
    end
end 

function ui_main_private_message:sendMessageSuccessHandle(strSend, data) 
    local playerId = global.g_mainPlayer:getPlayerId()
    local chatRecordItem = ui_main_chatBubble_item.new(POP_ORIENT.RIGHT, data.inserttime, data.AccountSend, playerId, strSend)
    self.listView_chatWindow:pushBackCustomItem(chatRecordItem.root)

    self:refreshChatWindow()

    self.switchCode_ = SWITCH_PRIVATER
    self:releaseSelectedEmail()
end

function ui_main_private_message:calculationPercent(searchIndex)
    local itemNum = self.listView_contacts:getChildrenCount()
    return searchIndex * 100 / itemNum
end 

function ui_main_private_message:changeSelect(userId)
    if self.defaultContacts ~= nil then 
        self.contactsTab[self.defaultContacts]:setBackgroundVisible(false)
    end 

    self.defaultContacts = userId 
    self.contactsTab[self.defaultContacts]:setBackgroundVisible(true)
    self.contactsTab[self.defaultContacts]:setSignVisible(false)

    self:changeChatRecord(userId)
end  

-- 刷新聊天窗口
function ui_main_private_message:refreshChatWindow()
    local delay = cc.DelayTime:create(0.5)
    local callFunc = cc.CallFunc:create(function()
        self.listView_chatWindow:scrollToBottom(0.1, true)
        self.listView_chatWindow:refreshView()
    end)
    self.listView_chatWindow:runAction(cc.Sequence:create(delay, callFunc, nil))
end

function ui_main_private_message:onClose()
    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_EXIT_PRIVATE_MESSAGE)
    self:close()
end

function ui_main_private_message:onTakeEmailRewardSuccess(emailid)
    local dataEmail = self.dataEmails_[emailid]
    PopUpView.showPopUpView(ShareEmailTakeView, dataEmail.MatchRewardScore)

    local nodeEmail = self.nodeEmails_[emailid]
    if not nodeEmail then return end

    nodeEmail:setTaked()
end

function ui_main_private_message:initMsgHandler()
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_TAKE_EMAIL_REWARD_SUCCESS, self, self.onTakeEmailRewardSuccess)
end

function ui_main_private_message:removeMsgHandler()
    MultipleDownloader:removeFileDownload("EmailUnread")
    MultipleDownloader:removeFileDownload("Privater")
    MultipleDownloader:removeFileDownload("ReadAllEmail")
    MultipleDownloader:removeFileDownload("RequestEmail")
    MultipleDownloader:removeFileDownload("GetUnReadMessage")
    MultipleDownloader:removeFileDownload("GetOtherUesrIsUnread")
    MultipleDownloader:removeFileDownload("GetChatRecord")
    MultipleDownloader:removeFileDownload("SendMessage")

    if self.updateHandle then 
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.updateHandle)
        self.updateHandle = nil 
    end 

    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_TAKE_EMAIL_REWARD_SUCCESS, self)
end
