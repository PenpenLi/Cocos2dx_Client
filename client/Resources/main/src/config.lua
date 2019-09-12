
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = true

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = false

-- for module display
CC_DESIGN_RESOLUTION = {
    title = "Bá chủ đại dương",
    width = 1559,
    height = 720,
    uisuffix = "",
    autoscale = "FIXED_HEIGHT",
    callback = function(framesize)
        local params = {}
        local platform = cc.Application:getInstance():getTargetPlatform()
        if framesize.width > framesize.height then
            --横屏
            local ratio = framesize.width / framesize.height
            if ratio < 2 then
                params.width = 1280
                params.height = 720
                params.uisuffix = ""
                params.autoscale = "FIXED_WIDTH"
            else
                params.width = 1559
                params.height = 720
                if platform == cc.PLATFORM_OS_IPHONE or platform == cc.PLATFORM_OS_IPAD then
                    params.uisuffix = "_ipx"
                else
                    params.uisuffix = ""
                end
                params.autoscale = "FIXED_HEIGHT"
            end
        else
            --竖屏
            local ratio = framesize.height / framesize.width
            if ratio < 2 then
                params.width = 720
                params.height = 1280
                params.uisuffix = ""
                params.autoscale = "FIXED_HEIGHT"
            else
                params.width = 720
                params.height = 1559
                if platform == cc.PLATFORM_OS_IPHONE or platform == cc.PLATFORM_OS_IPAD then
                    params.uisuffix = "_ipx"
                else
                    params.uisuffix = ""
                end
                params.autoscale = "FIXED_WIDTH"
            end
        end
        return params
    end
}
