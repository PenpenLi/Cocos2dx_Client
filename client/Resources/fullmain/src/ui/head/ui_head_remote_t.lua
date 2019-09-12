ui_head_remote_t = class("ui_head_remote_t", NodeBase)

local fileUtils = cc.FileUtils:getInstance()

function ui_head_remote_t:ctor(urlHead, sizeHead, pathMask, rect9Mask, sizeMask)
	ui_head_remote_t.super.ctor(self)

	self.urlHead_ = urlHead
	self.sizeHead_ = sizeHead
	self.pathMask_ = pathMask
	self.rect9Mask_ = rect9Mask
	self.sizeMask_ = sizeMask

	self.identifier_ = cc.utils:getDataMD5Hash(self.urlHead_)
	self.storagePath_ = string.format("%sface_%s.jpg", device.writablePath, self.identifier_)

	self:download()
end

function ui_head_remote_t:download()
	if fileUtils:isFileExist(self.storagePath_) then
		--文件已存在
		self:makeRemoteHead()
	else
		--文件不存在,开始下载
        MultipleDownloader:createFileDownLoad(
                {
                    identifier = self.identifier_,
                    fileUrl = self.urlHead_,
                    storagePath = self.storagePath_,
                    onFileTaskSuccess = function(dataTask)
			        		self:makeRemoteHead()
			            end,
                    onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
			        		self:makeLocalHead()
			            end,
                }
            )
	end
end

function ui_head_remote_t:makeRemoteHead()
	local headSprite = cc.Sprite:create(self.storagePath_)
    local size = headSprite:getContentSize()
    local scale = self.sizeHead_.width / size.width
    headSprite:setScale(scale)

    local maskSprite = ccui.Scale9Sprite:create(self.rect9Mask_, self.pathMask_)
    maskSprite:setContentSize(self.sizeMask_)

    local clipingNode = cc.ClippingNode:create(maskSprite)
	clipingNode:setInverted(false)
	clipingNode:setAlphaThreshold(0.5)
	clipingNode:addChild(headSprite)
	self:addChild(clipingNode)
end

function ui_head_remote_t:makeLocalHead()
	local headSprite = cc.Sprite:create("fullmain/res/portrait/head/1.jpg")
    local size = headSprite:getContentSize()
    local scale = self.sizeHead_.width / size.width
    headSprite:setScale(scale)

    local maskSprite = ccui.Scale9Sprite:create(self.rect9Mask_, self.pathMask_)
    maskSprite:setContentSize(self.sizeMask_)

    local clipingNode = cc.ClippingNode:create(maskSprite)
	clipingNode:setInverted(false)
	clipingNode:setAlphaThreshold(0.5)
	clipingNode:addChild(headSprite)
	self:addChild(clipingNode)
end

function ui_head_remote_t:removeMsgHandler()
	MultipleDownloader:removeFileDownload(self.identifier_)
end