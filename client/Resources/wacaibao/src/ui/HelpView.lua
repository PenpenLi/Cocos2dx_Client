HelpView = class("HelpView", PopUpView)

function HelpView:ctor()
	HelpView.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile(JSON_HELP_ROOT[HORV])
	self.nodeUI_:addChild(root)

    local buttonClose = ccui.Helper:seekWidgetByName(root, "button_close")
    buttonClose:addTouchEventListener(handler(self, self.onButtonClose))

     -- 滚动层
    self.scrollView = ccui.Helper:seekWidgetByName(root, "scrollView")
    self:initScrollItem() 
end

-- 初始化滚动项
function HelpView:initScrollItem()
    self.scrollView:removeAllChildren() -- 删除所有子节点

    local sp = cc.Sprite:create(RES_HELPTEXT_ROOT[HORV])
    sp:setPosition(cc.p(10, 0))
    sp:setAnchorPoint(cc.p(0, 0))
    self.scrollView:addChild(sp)

    self.scrollView:setInnerContainerSize(cc.size(SCROLLVIEW_HIGHT[HORV].width, SCROLLVIEW_HIGHT[HORV].hight)) -- 设置滚动层内部大小 1670 1170
end 


function HelpView:onButtonClose()
    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_START_COUNTTIME)  -- 开始计时
	self:close()
end