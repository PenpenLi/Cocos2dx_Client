RegisterScene = class("RegisterScene", LayerBase)

function RegisterScene:ctor()
  self.keypadHanlder_ = {
    [6] = self.keyboardBackClicked,
    [8] = self.keyboardTabClicked,
  }
	RegisterScene.super.ctor(self)

	self.frameTextures = {}
		
	local pathJson = getLayoutJson("main/res/json/ui_main_register.json")
	local root = ccs.GUIReader:getInstance():widgetFromJsonFile(pathJson)
	root:setClippingEnabled(true)
	self:addChild(root)

	local labelTips = ccui.Helper:seekWidgetByName(root, "Label_Tips")
	labelTips:setTextColor(cc.c4b(255, 255, 0, 255))

	--返回按钮
	local appbtn = ccui.Helper:seekWidgetByName(root,"Button_9")
	appbtn:setPressedActionEnabled(true)
	appbtn:addTouchEventListener(makeClickHandler(self, self.AppFun))

	--注册按钮 
	local regibtn = ccui.Helper:seekWidgetByName(root,"regibtn")
	regibtn:setPressedActionEnabled(true)
	regibtn:addTouchEventListener(makeClickHandler(self, self.RegFun))

	--注册账号文本 
	self.acnumtext = createCursorTextField(root, "TextField_Account")
	self.acnumtext:setFontColor(cc.c3b(0, 0, 0))
	--密码文本
	self.passwtext = createCursorTextField(root, "TextField_Password")
	self.passwtext:setFontColor(cc.c3b(0, 0, 0))

	--邮箱地址
	self.inputEmail = createCursorTextField(root, "TextField_Email")
	self.inputEmail:setFontColor(cc.c3b(0, 0, 0))

	local girl = ccui.Helper:seekWidgetByName(root, "Image_42") 
	girl:setOpacity(0)
	local sp = cc.Sprite:create("main/res/login/girl/girl_1.png")
	local action, frameTextures = createWithFrameFileName("main/res/login/girl/girl_", 0.05, 10000000000)
	sp:runAction(action)
	local size = girl:getContentSize()
	sp:setPosition(cc.p(size.width / 2, size.height / 2))
	girl:addChild(sp)
	self:addFrameTexture(frameTextures)
end

function RegisterScene:addFrameTexture(frames)
	for k, v in ipairs(frames) do
		self.frameTextures[#self.frameTextures + 1] = v
	end
end

function RegisterScene:keyboardBackClicked()
	--返回按钮
	self:keyboardHandleRelease()

	self:AppFun()
end

-- function keyboardEnterClicked(self)
--     self:keyboardHandleRelease()
-- 	local account = string.trim(self.acnumtext:getText())
-- 	if utf8.len(account) < 1 then
-- 		WarnTips.showTips(
-- 				{
-- 					text = "帐号不能为空",
-- 					style = WarnTips.STYLE_Y
-- 				}
-- 			)
-- 		return
-- 	end

-- 	local password = string.trim(self.passwtext:getText())
-- 	if utf8.len(password) < 1 then
-- 		WarnTips.showTips(
-- 				{
-- 					text = "密码不能为空",
-- 					style = WarnTips.STYLE_Y
-- 				}
-- 			)
-- 		return
-- 	end

-- 	local location = global.g_mainPlayer:getLocationCity()
-- 	global.g_account = account
-- 	global.g_password = password
-- 	gatesvr.sendRegister(account, password, "", location)

-- 	require_ex ("main.src.scene.hall_scene_t")
-- end

function RegisterScene:keyboardTabClicked()
    self:keyboardHandleRelease()
    if self.count==nil or self.count==0 then
        self.count=1
        self.acnumtext:attachWithIME()
    else
        self.count=0
        self.passwtext:attachWithIME()
    end
    -- local account = string.trim(self.acnumtext:getText())
    -- print(account)
end

function RegisterScene:ClosFun(...)
	replaceScene(LoginScene, TRANS_CONST.TRANS_SCALE)
end

function RegisterScene:AppFun(...)
	replaceScene(LoginScene, TRANS_CONST.TRANS_SCALE)
end

function RegisterScene:RegFun(...)
	local account = string.trim(self.acnumtext:getText())
	if utf8.len(account) < 6 then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_d1d9bfc82e436144"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end

	local password = string.trim(self.passwtext:getText())
	if utf8.len(password) < 6 then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_305b1dea6d282d9a"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end

	local email = string.trim(self.inputEmail:getText())
	if not isRightEmail(email) then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_feaeb597fc478f58"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end

	LoadingView.showTips()
	
	local location = global.g_mainPlayer:getLocationCity()
	global.g_account = account
	global.g_password = password
	gatesvr.sendRegister(account, password, "", location, email)
end

function RegisterScene:onEndExitTransition()
	local textureCache = cc.Director:getInstance():getTextureCache()
	textureCache:removeUnusedTextures()
	collectgarbage("collect")
	collectgarbage("collect")
	collectgarbage("collect")
	for i,v in ipairs(self.frameTextures) do
		textureCache:removeTextureForKey(v)
	end
end