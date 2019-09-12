TextTipsUtils = class("TextTipsUtils")

local scheduler = cc.Director:getInstance():getScheduler()

local isDisplaying = false
local remainTips = {}

function TextTipsUtils:showTips(options)
	if options == nil or options == "" then
		return
	end
	local param = nil
	if type(options) == "string" then
		param = {text = options}
	else
		param = options
	end
	table.insert(remainTips, param)

	self:_displayTips(param)
end

function TextTipsUtils:_displayTips()
	if isDisplaying then
		return
	end

	isDisplaying = true

	local director = cc.Director:getInstance()

	local options = table.remove(remainTips, 1)
	local nowScene = director:getRunningScene()
	local label = self:_createNormalTextLabel(options)
	label:setAnchorPoint(CCPointMidCenter)
	label:setPosition(cc.p(display.cx, display.cy))
	nowScene:addChildWithLayerType(MAIN_LAYER.LAYER_TIPS, label)

	local action = cc.Sequence:create(
		{
			cc.Spawn:create(
				{
					cc.FadeIn:create(2),
					cc.MoveTo:create(2, cc.p(display.cx, display.cy + 40))
				}
			),
			cc.CallFunc:create(function()
					label:removeFromParent()
				end)
		}
	)

	label:runAction(action)

	self:_nextStart()
end

function TextTipsUtils:_nextStart()
	local handlerId = nil

	handlerId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(handlerId)
			isDisplaying = false
			if #remainTips > 0 then
				self:_displayTips()
			end

		end, 0, false)
end

function TextTipsUtils:_createNormalTextLabel(options)
	local label = newTTFLabel({
			text = options.text,
			color = options.color or cc.c4b(255, 255, 255),
			size = options.size or 30,
			outline = {color = cc.c4b(0, 0, 0, 255), size = 2},
		})

	return label
end