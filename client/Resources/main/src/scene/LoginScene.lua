LoginScene = class("LoginScene", LayerBase)

function LoginScene:ctor()
  self.keypadHanlder_ = {
    [6] = self.keyboardBackClicked,
  }
	LoginScene.super.ctor(self)

	self.frameTextures = {}

	local pathJson = getLayoutJson("main/res/json/ui_main_login.json")
	local root = ccs.GUIReader:getInstance():widgetFromJsonFile(pathJson)
	root:setClippingEnabled(true)
	self:addChild(root)

	self.panelLoginMobile_ = ccui.Helper:seekWidgetByName(root, "Panel_LoginMobile")
	self.panelLoginMobile_:setVisible(false)

	self.panelLoginPC_ = ccui.Helper:seekWidgetByName(root, "Panel_LoginPC")
	self.panelLoginPC_:setVisible(false)

	if PLATFROM == cc.PLATFORM_OS_WINDOWS then
		self.inputAccount_ = createCursorTextField(self.panelLoginPC_, "TextField_Account")
		self.inputAccount_:setFontColor(cc.c3b(0, 0, 0))

		self.inputPassword_ = createCursorTextField(self.panelLoginPC_, "TextField_Password")
		self.inputPassword_:setFontColor(cc.c3b(0, 0, 0))

		self.cbRemember_ = ccui.Helper:seekWidgetByName(self.panelLoginPC_, "CheckBox_Remember")
		self.cbRemember_:addEventListener(handler(self, self.onRememberChange))

		local remember = global.g_mainPlayer:isRememb()
		if remember then
			local account = global.g_mainPlayer:getLoginAccount()
			local password = global.g_mainPlayer:getLoginPassword()
			self.inputAccount_:setText(account)
			self.inputPassword_:setText(password)
			self.cbRemember_:setSelected(true)
		end

		local btnRegister = ccui.Helper:seekWidgetByName(self.panelLoginPC_, "Button_Register")
		btnRegister:addTouchEventListener(makeClickHandler(self, self.onRegister))

		local btnForgot = ccui.Helper:seekWidgetByName(self.panelLoginPC_, "Button_Forgot")
		btnForgot:addTouchEventListener(makeClickHandler(self, self.onForgot))

		local btnLoginPC = ccui.Helper:seekWidgetByName(self.panelLoginPC_, "Button_LoginPC")
		btnLoginPC:addTouchEventListener(makeClickHandler(self, self.onLoginPC))

		local lady = ccui.Helper:seekWidgetByName(self.panelLoginPC_, "Image_LadyPC") 
		lady:setOpacity(0)

		local sp = cc.Sprite:create("main/res/login/girl/girl_1.png")
		local action, frameTextures = createWithFrameFileName("main/res/login/girl/girl_", 0.05, 10000000000)
		sp:runAction(action)

		local size = lady:getContentSize()
		sp:setPosition(cc.p(size.width / 2, size.height / 2))
		lady:addChild(sp)
		self:addFrameTexture(frameTextures)

		self.panelLoginPC_:setVisible(true)
	else
		local btnOneKey = ccui.Helper:seekWidgetByName(self.panelLoginMobile_, "Button_OneKey")
		btnOneKey:setVisible(false)
		-- btnOneKey:setOpacity(0)
		-- btnOneKey:addTouchEventListener(makeClickHandler(self, self.onOneKeyLogin))

		-- local sizeOneKey = btnOneKey:getContentSize()
		-- local animateOneKey = cc.Sprite:create("main/res/login/btn_login/btn_login_1.png")
		-- local actionOneKey, frameTexturesOneKey = createWithFrameFileName("main/res/login/btn_login/btn_login_", 0.05, 1)
		-- local a1 = cc.RepeatForever:create(cc.Sequence:create({cc.DelayTime:create(3), actionOneKey}))
		-- animateOneKey:runAction(a1)
		-- animateOneKey:setPosition(cc.p(sizeOneKey.width / 2, sizeOneKey.height / 2))
		-- btnOneKey:addChild(animateOneKey)
		-- self:addFrameTexture(frameTexturesOneKey)

		local btnZalo = ccui.Helper:seekWidgetByName(self.panelLoginMobile_, "Button_Zalo")
		btnZalo:setOpacity(0)
		btnZalo:addTouchEventListener(makeClickHandler(self, self.onZaloMobile))

		local sizeZalo = btnZalo:getContentSize()
		local animateZalo = cc.Sprite:create("main/res/login/btn_zalo/btn_zalo_1.png")
		local actionZalo, frameTexturesZalo = createWithFrameFileName("main/res/login/btn_zalo/btn_zalo_", 0.05, 1)
		local a1 = cc.RepeatForever:create(cc.Sequence:create({cc.DelayTime:create(3), actionZalo}))
		animateZalo:runAction(a1)
		animateZalo:setPosition(cc.p(sizeZalo.width / 2, sizeZalo.height / 2))
		btnZalo:addChild(animateZalo)
		self:addFrameTexture(frameTexturesZalo)

		local btnFacebook = ccui.Helper:seekWidgetByName(self.panelLoginMobile_, "Button_Facebook")
		btnFacebook:setOpacity(0)
		btnFacebook:addTouchEventListener(makeClickHandler(self, self.onFacebook))

		local sizeFacebook = btnFacebook:getContentSize()
		local animateFacebook = cc.Sprite:create("main/res/login/btn_facebook/btn_facebook_1.png")
		local actionFacebook, frameTexturesFacebook = createWithFrameFileName("main/res/login/btn_facebook/btn_facebook_", 0.05, 1)
		local a1 = cc.RepeatForever:create(cc.Sequence:create({cc.DelayTime:create(3), actionFacebook}))
		animateFacebook:runAction(a1)
		animateFacebook:setPosition(cc.p(sizeFacebook.width / 2, sizeFacebook.height / 2))
		btnFacebook:addChild(animateFacebook)
		self:addFrameTexture(frameTexturesFacebook)

		local lady = ccui.Helper:seekWidgetByName(self.panelLoginMobile_, "Image_LadyMobile") 
		lady:setOpacity(0)
		local sp = cc.Sprite:create("main/res/login/girl/girl_1.png")
		local action, frameTextures = createWithFrameFileName("main/res/login/girl/girl_", 0.05, 10000000000)
		sp:runAction(action)
		local size = lady:getContentSize()
		sp:setPosition(cc.p(size.width / 2, size.height / 2))
		lady:addChild(sp)
		self:addFrameTexture(frameTextures)

		local gameLogo = ccui.Helper:seekWidgetByName(self.panelLoginMobile_, "Image_LogoMobile")
		gameLogo:setOpacity(0)
		local sizeLogo = gameLogo:getContentSize()
		local animateLogo = cc.Sprite:create("main/res/login/logo/logo1_bingoclub1.png")
		local actionLogo, frameTexturesLogo = createWithFrameFileName("main/res/login/logo/logo1_bingoclub", 0.05, 1)
		local a2 = cc.RepeatForever:create(cc.Sequence:create({cc.DelayTime:create(3), actionLogo}))
		animateLogo:runAction(a2)
		animateLogo:setPosition(cc.p(sizeLogo.width / 2, sizeLogo.height / 2))
		gameLogo:addChild(animateLogo)
		self:addFrameTexture(frameTexturesLogo)

		self.panelLoginMobile_:setVisible(true)
	end

	--关闭按钮
	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_Back")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	local labelVersion = ccui.Helper:seekWidgetByName(root, "Label_Version")
	labelVersion:setTextColor(cc.c4b(255, 255, 0, 255))
	labelVersion:enableOutline(cc.c4b(0, 0, 0, 255), 1)

	local version = LocalVersions:getModuleVersion(LOCAL_MAIN_VERSION_KEY)
	labelVersion:setString(string.format(LocalLanguage:getLanguageString("L_4c7394d12f5cb884"), GameVersion, version))
	labelVersion:addTouchEventListener(makeClickHandler(self, self.onDebug))

	self.countDebug_ = 0
end

function LoginScene:onDebug()
	print("self.countDebug_="..self.countDebug_)
	self.countDebug_ = self.countDebug_ + 1
	if self.countDebug_ > 15 then
		PopUpView.showPopUpView(require("main.src.ui.common.GameLogView"))
		self.countDebug_ = 0
	end
end

function LoginScene:onRememberChange(sender, eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		global.g_mainPlayer:setRememb(true)
	elseif eventType == ccui.CheckBoxEventType.unselected then
		global.g_mainPlayer:setLocalData("account", "")
		global.g_mainPlayer:setLocalData("password", "")
		global.g_mainPlayer:setRememb(false)
	end
end

function LoginScene:addFrameTexture(frames)
	for k, v in ipairs(frames) do
		self.frameTextures[#self.frameTextures + 1] = v
	end
end

function LoginScene:onCloseHandler()
	WarnTips.showTips(
		{
			text = LocalLanguage:getLanguageString("L_d1ad447404464e52"),
			style = WarnTips.STYLE_YN,
			confirm = function()
					self:keyboardHandleRelease()
					os.exit()
				end,
			cancel = function()
					self:keyboardHandleRelease()
				end
		}
	)
end

function LoginScene:keyboardBackClicked()
	--返回按钮
	WarnTips.showTips(
		{
			text = LocalLanguage:getLanguageString("L_d1ad447404464e52"),
			style = WarnTips.STYLE_YN,
			confirm = function()
					self:keyboardHandleRelease()
					os.exit()
				end,
			cancel = function()
					self:keyboardHandleRelease()
				end
		}
	)
end

function LoginScene:onOneKeyLogin()
	LoadingView.showTips()

	local location = global.g_mainPlayer:getLocationCity()
	gatesvr.sendOneKeyLogin(location)
end

function LoginScene:onZaloMobile()
	if cc.PLATFORM_OS_ANDROID == PLATFROM then
		calljavaMethodV("openLoginZalo", {})
	elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
		luaoc.callStaticMethod("AppController", "openLoginZalo", {})
	elseif cc.PLATFORM_OS_WINDOWS == PLATFROM then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_73e00c897e0f97ff"),
					style = WarnTips.STYLE_Y
				}
			)
	end
end

function LoginScene:onFacebook()
	if cc.PLATFORM_OS_ANDROID == PLATFROM then
		calljavaMethodV("openLoginFacebook", {})
	elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
		luaoc.callStaticMethod("AppController", "openLoginFacebook", {})
	elseif cc.PLATFORM_OS_WINDOWS == PLATFROM then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_73e00c897e0f97ff"),
					style = WarnTips.STYLE_Y
				}
			)
	end
end

function LoginScene:onRegister()
	replaceScene(RegisterScene, TRANS_CONST.TRANS_SCALE)
end

function LoginScene:onForgot()
	PopUpView.showPopUpView(ForgotPasswordView)
end

function LoginScene:onLoginPC()
	local account = string.trim(self.inputAccount_:getText())
	if utf8.len(account) < 1 then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_60409c86ceabc538"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end

	local password = string.trim(self.inputPassword_:getText())
	if utf8.len(password) < 1 then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_7b7af01e000181c3"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end

	global.g_account = account
	global.g_password = password
	gatesvr.sendLogin(account, password)

	LoadingView.showTips(LocalLanguage:getLanguageString("L_1a29b9d96df40698"))
end

function LoginScene:onEndEnterTransition()
	
end

function LoginScene:onEndExitTransition()
	local textureCache = cc.Director:getInstance():getTextureCache()
	textureCache:removeUnusedTextures()
	collectgarbage("collect")
	collectgarbage("collect")
	collectgarbage("collect")
	for i,v in ipairs(self.frameTextures) do
		textureCache:removeTextureForKey(v)
	end
end