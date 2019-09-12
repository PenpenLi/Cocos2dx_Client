UpdateScene = class("UpdateScene", LayerBase)

local fileUtils = cc.FileUtils:getInstance()

function UpdateScene:ctor()
    self.keypadHanlder_ = {
        [6] = self.keyboardBackClicked,
    }
    UpdateScene.super.ctor(self)

    local pathJson = getLayoutJson("main/res/json/ui_main_load.json")
    local root = ccs.GUIReader:getInstance():widgetFromJsonFile(pathJson)
    root:setClippingEnabled(true)
    self:addChild(root)

    self.panelLoad_ = ccui.Helper:seekWidgetByName(root, "Panel_Load")
    self.progressBar_ = ccui.Helper:seekWidgetByName(root, "ProgressBar_Progress")
    self.panelLoad_:setVisible(false)

    local light = ccui.Helper:seekWidgetByName(root, "Image_Light")
    local f1 = cc.FadeOut:create(1)
    local f2 = cc.FadeIn:create(1)
    light:runAction(cc.RepeatForever:create(cc.Sequence:create(f1, f2)))

    local lady = ccui.Helper:seekWidgetByName(root, "Image_Girl") 
    lady:setOpacity(0)
    local sp = cc.Sprite:create("main/res/login/girl/girl_1.png")
    local action = createWithFrameFileName("main/res/login/girl/girl_", 0.05, 10000000000)
    sp:runAction(action)
    local size = lady:getContentSize()
    sp:setPosition(cc.p(size.width / 2, size.height / 2))
    lady:addChild(sp)

    local gameLogo = ccui.Helper:seekWidgetByName(root, "Image_Logo")
    gameLogo:setOpacity(0)
    local sizeLogo = gameLogo:getContentSize()
    local animateLogo = cc.Sprite:create("main/res/login/logo/logo1_bingoclub1.png")
    local actionLogo = createWithFrameFileName("main/res/login/logo/logo1_bingoclub", 0.05, 1)
    local a2 = cc.RepeatForever:create(cc.Sequence:create({cc.DelayTime:create(3), actionLogo}))
    animateLogo:runAction(a2)
    animateLogo:setPosition(cc.p(sizeLogo.width / 2, sizeLogo.height / 2))
    gameLogo:addChild(animateLogo)
end

function UpdateScene:keyboardBackClicked()
    --返回按钮
    if self.updating_ then
        self:keyboardHandleRelease()
    else
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
end

function UpdateScene:checkMiniHallUpdate()
    if LocalConfig:getConfigUpdate() then
        MultipleDownloader:createDataDownLoad(
            {
                identifier = "mainVersion",
                fileUrl = CHECK_URL .. "main/main.json",
                onDataTaskSuccess = function(dataTask, params)
                        local dataJson = json.decode(params)
                        local mainVersion = LocalVersions:getModuleVersion(LOCAL_MAIN_VERSION_KEY)
                        if mainVersion >= dataJson.version then
                            handlerDelayed(handler(self, self.checkFullHallUpdate), 0)
                        else
                            local keyString = tostring(mainVersion)
                            local dataUpdate = dataJson.updates[keyString]
                            if dataUpdate then
                                local packageUrl = string.format("%smain/%s", CHECK_URL, dataUpdate.package)
                                local storagePath = string.format("%s%d_%s", device.writablePath, os.time(), dataUpdate.package)

                                MultipleDownloader:createFileDownLoad(
                                        {
                                            identifier = "mainVersion",
                                            fileUrl = packageUrl,
                                            storagePath = storagePath,
                                            onFileTaskSuccess = function(dataTask)
                                                    self:setProgressVisible(false)

                                                    fileUtils:uncompressAsyn(dataTask.storagePath, device.writablePath, function(success)
                                                            if success then
                                                                LocalVersions:setModuleVersion(LOCAL_MAIN_VERSION_KEY, dataJson.version)
                                                                fileUtils:removeFile(dataTask.storagePath)
                                                                handlerDelayed(handler(self, self.checkFullHallUpdate), 0)
                                                            else
                                                                handlerDelayed(handler(self, self.checkMiniHallUpdate), 0)
                                                            end
                                                        end)
                                                end,
                                            onTaskProgress = function(dataTask, bytesReceived, totalBytesReceived, totalBytesExpected)
                                                    self:updateProgress(totalBytesReceived, totalBytesExpected)
                                                end,
                                            onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
                                                    WarnTips.showTips(
                                                            {
                                                                text = errorMsg,
                                                                style = WarnTips.STYLE_Y,
                                                                confirm = function()
                                                                    handlerDelayed(handler(self, self.checkMiniHallUpdate), 0)
                                                                end
                                                            }
                                                        )
                                                end,
                                        }
                                    )

                                self:setProgressVisible(true)
                            else
                                --无可热更新版本
                                WarnTips.showTips(
                                        {
                                            text = LocalLanguage:getLanguageString("L_33b3880f732d4df2"),
                                            style = WarnTips.STYLE_Y,
                                            confirm = function()
                                                cc.Application:getInstance():openURL(share_content)
                                            end
                                        }
                                    )
                            end
                        end
                    end,
                onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
                        self:checkFullHallUpdate()
                    end,
            }
        )
    else
        self:checkFullHallUpdate()
    end
end

function UpdateScene:checkFullHallUpdate()
    if LocalConfig:getConfigUpdate() then
        MultipleDownloader:createDataDownLoad(
            {
                identifier = "fullmainVersion",
                fileUrl = CHECK_URL .. "fullmain/fullmain.json",
                onDataTaskSuccess = function(dataTask, params)
                        local dataJson = json.decode(params)
                        local keyVersion = "fullmainVersion"
                        local fullmainVersion = LocalVersions:getModuleVersion(keyVersion)
                        if fullmainVersion >= dataJson.version then
                            self:requireLocate()
                        else
                            local keyStringLocal = tostring(fullmainVersion)
                            local keyStringRemote = tostring(dataJson.version)
                            local dataUpdate = dataJson.updates[keyStringLocal] or dataJson.updates[keyStringRemote]

                            local packageUrl = string.format("%sfullmain/%s", CHECK_URL, dataUpdate.package)
                            local storagePath = string.format("%s%d_%s", device.writablePath, os.time(), dataUpdate.package)

                            MultipleDownloader:createFileDownLoad(
                                    {
                                        identifier = keyVersion,
                                        fileUrl = packageUrl,
                                        storagePath = storagePath,
                                        onFileTaskSuccess = function(dataTask)
                                                self:setProgressVisible(false)

                                                fileUtils:uncompressAsyn(dataTask.storagePath, device.writablePath, function(success)
                                                        if success then
                                                            LocalVersions:setModuleVersion(keyVersion, dataJson.version)
                                                            fileUtils:removeFile(dataTask.storagePath)
                                                            self:requireLocate()
                                                        else
                                                            handlerDelayed(handler(self, self.checkFullHallUpdate), 0)
                                                        end
                                                    end)
                                            end,
                                        onTaskProgress = function(dataTask, bytesReceived, totalBytesReceived, totalBytesExpected)
                                                self:updateProgress(totalBytesReceived, totalBytesExpected)
                                            end,
                                        onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
                                                WarnTips.showTips(
                                                        {
                                                            text = errorMsg,
                                                            style = WarnTips.STYLE_Y,
                                                            confirm = function()
                                                                handlerDelayed(handler(self, self.checkFullHallUpdate), 0)
                                                            end
                                                        }
                                                    )
                                            end,
                                    }
                                )

                            self:setProgressVisible(true)
                        end
                    end,
                onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
                        self:requireLocate()
                    end,
            }
        )
    else
        self:requireLocate()
    end
end

function UpdateScene:setProgressVisible(bVal)
    self.panelLoad_:setVisible(bVal)
    self.progressBar_:setPercent(0)
end

function UpdateScene:updateProgress(current, total)
    local rate = current / total
    self.progressBar_:setPercent(rate * 100)
end

function UpdateScene:requireLocate()
    MultipleDownloader:createDataDownLoad(
            {
                identifier = "location",
                fileUrl = locateUrl,
                onDataTaskSuccess = function(dataTask, params)
                        global.location_ = json.decode(params)
                        self:requireNotice()
                    end,
                onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
                        global.location_ = {province = "unknown", city = ""}
                        self:requireNotice()
                    end,
            }
        )
end

function UpdateScene:requireNotice()
    MultipleDownloader:createDataDownLoad(
            {
                identifier = "notice",
                fileUrl = noticeUrl,
                onDataTaskSuccess = function(dataTask, params)
                        local luaTbl = json.decode(params)
                        global.g_noticeData = luaTbl.data
                        self:enterGame()
                    end,
                onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
                        global.g_noticeData = {notice={{content=LocalLanguage:getLanguageString("L_13f271b0f4fa7152")}}}
                        self:enterGame()
                    end,
            }
        )
end

function UpdateScene:deleteUnusedFile()
    local files = fileUtils:listFiles(device.writablePath)
    for k, v in pairs(files) do
        local extension = getextension(v)
        if extension == "zip" or extension == "tmp" then
            fileUtils:removeFile(v)
        end
    end
end

function UpdateScene:startGame()
    self:deleteUnusedFile()
    self:checkMiniHallUpdate()
end

function UpdateScene:onPermissionsGrant()
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_PERMISSIONS_GRANT, self)
    
    self:startGame()
end

function UpdateScene:onEndEnterTransition()
    local platform = cc.Application:getInstance():getTargetPlatform()
    if cc.PLATFORM_OS_ANDROID == platform then
        global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_PERMISSIONS_GRANT, self, self.onPermissionsGrant)
        calljavaMethodV("checkPermissions", {})
    else
        self:startGame()
    end
end

function UpdateScene:onStartExitTransition()
    MultipleDownloader:removeFileDownload("mainVersion")
    MultipleDownloader:removeFileDownload("fullmainVersion")
    MultipleDownloader:removeFileDownload("location")
    MultipleDownloader:removeFileDownload("notice")

    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_PERMISSIONS_GRANT, self)
end

function UpdateScene:enterGame()
    -- global.g_noticeData = {notice={{content=LocalLanguage:getLanguageString("L_13f271b0f4fa7152")}}}
    require_ex("main.src.hall")
end