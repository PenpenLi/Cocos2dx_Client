ui_notice_t = class("ui_notice_t", PopUpView)

function ui_notice_t:ctor()
	ui_notice_t.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_notice.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_3")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onClose))

	self.labelContent_ = ccui.Helper:seekWidgetByName(root, "Label_4")
	self.labelContent_:setString("")

	self.scrollView_ = ccui.Helper:seekWidgetByName(root, "ScrollView_43")

	self.panelImage_ = ccui.Helper:seekWidgetByName(root, "Panel_Image")
end

function ui_notice_t:onPopUpComplete()
	local notice = global.g_noticeData.notice[1]
	if notice.isText == 0 then
		self:requestImageContent(notice.linkurl)
	else
		local msg = notice and notice.content or LocalLanguage:getLanguageString("L_7622ff14cfcaeec8")	
		self:setNoticeContent(msg)
	end
end

function ui_notice_t:requestImageContent(link)
	local remoteImage = ui_image_remote_t.new(link, cc.size(770, 497))
	self.panelImage_:addChild(remoteImage)
end

function ui_notice_t:setNoticeContent(content)
	self.labelContent_:setString(content)

	local labelVr = self.labelContent_:getVirtualRenderer()
	labelVr:setDimensions(670, 0)
	
	local lsize = labelVr:getContentSize()
	self.labelContent_:ignoreContentAdaptWithSize(false)
	self.labelContent_:setTextAreaSize(lsize)

	self.scrollView_:setInnerContainerSize(cc.size(670, lsize.height))
end

function ui_notice_t:onClose()
	self:close()
end