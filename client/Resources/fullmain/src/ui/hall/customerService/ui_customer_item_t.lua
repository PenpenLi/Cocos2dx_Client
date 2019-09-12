--
-- Author: lzg
-- Date: 2018-04-12 17:44:14
-- Function：客服聊天子控件

ui_customer_item_t = class("ui_customer_item_t")

function ui_customer_item_t:ctor(itemData)
	self.itemData_ = itemData
	self.node_ = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_customer_item.json")
	self.panel_myself = ccui.Helper:seekWidgetByName(self.node_, "Panel_L")
	self.panel_customer = ccui.Helper:seekWidgetByName(self.node_, "Panel_R")

	self:updateUI()
end

function ui_customer_item_t:updateUI()
	local itemData = self.itemData_
	self.panel_myself:setVisible(itemData.type == 0)
	self.panel_customer:setVisible(itemData.type == 1)
	local panel = nil
	local str_content = itemData.chat
	
	if itemData.type == 0 then
		panel = self.panel_myself
	else
		panel = self.panel_customer
	end

	local content = ccui.Helper:seekWidgetByName(panel, "lbl_conent")
	content:setString("")

	local imgContent = ccui.Helper:seekWidgetByName(panel, "img_content")

	local lsize = nil

	local fileUrl, imageWidth, imageHeight = string.match(str_content, "^(.+),(%d+),(%d+)$")
	if fileUrl and imageWidth and imageHeight then
		local url = string.format(uploadHomeUrl, fileUrl)
		local imageWid = tonumber(imageWidth)
		local imageHei = tonumber(imageHeight)
		local imageScale = 1
		if imageWid > 650 then
			imageScale = 650 / imageWid
		end
		imageWid = math.floor(imageWid * imageScale)
		imageHei = math.floor(imageHei * imageScale)

		lsize = cc.size(imageWid, imageHei)

		local imageRemote = ui_image_remote_t.new(url, lsize)
		imageRemote:setPosition(cc.p(imageWid/2 + 10, imageHei/2 + 10))
		imgContent:addChild(imageRemote)
	else
		content:enableShadow(cc.c4b(0,0,0,0))
		local contentVR = content:getVirtualRenderer()
		content:setString(str_content)

		contentVR:setDimensions(0, 0)
		lsize = content:getVirtualRendererSize()
		if lsize.width > 650 then
			contentVR:setDimensions(650, 0)
			lsize = content:getVirtualRendererSize()
		end
		content:ignoreContentAdaptWithSize(false)
		content:setTextAreaSize(lsize)
	end

	local height = lsize.height + 20
	local width = lsize.width + 20

	height = math.max(height, 40)
	width = math.max(width, 80)
	imgContent:setContentSize(width, height)
	self.node_:setContentSize(cc.size(1090, 105 + (height - 40)))

	local time = itemData.time
	local lbl_date = ccui.Helper:seekWidgetByName(panel, "lbl_date")
	local strTime = string.format("%d-%02d-%02d %02d:%02d:%02d", time.year, time.month, time.day, time.hour , time.minute , time.second)
	lbl_date:setString(strTime)
end

function ui_customer_item_t:getContentSize()
	return self.node_:getContentSize()
end

function ui_customer_item_t:setItemData(itemData)
	self.itemData_ = itemData
	self:updateUI()
end
