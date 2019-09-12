ui_turntable_reward_t = class("ui_turntable_reward_t", PopUpView)

POSITION_REWARDS = {
	[1] = {160},
	[2] = {195, 125},	
}

function ui_turntable_reward_t:ctor(rewards)
	ui_turntable_reward_t.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_turntable_reward.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_Close")
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	local count = #rewards
	local pos = POSITION_REWARDS[count]

	for i = 1, count do
		local dataReward = rewards[i]
		local nodeReward = ccui.Helper:seekWidgetByName(root, "Panel_R" .. i)
		nodeReward.icon = ccui.Helper:seekWidgetByName(nodeReward, "Image_Icon")
		nodeReward.labelCount = ccui.Helper:seekWidgetByName(nodeReward, "Label_Count")
		nodeReward.labelCount:setString(string.format("x%d", dataReward[2]))

		if dataReward[1] == 0 then
			nodeReward.icon:loadTexture("fullmain/res/hall/img_youxibi.png")
		elseif dataReward[1] == 1 then
			nodeReward.icon:loadTexture("fullmain/res/turntable/item1.png")
		elseif dataReward[2] == 2 then
			nodeReward.icon:loadTexture("fullmain/res/turntable/item2.png")
		end

		local py = pos[i]
		nodeReward:setPositionY(py)
		nodeReward:setVisible(true)
	end

	local labelTips = ccui.Helper:seekWidgetByName(root, "Image_Tips")
	labelTips:setVisible(count > 1)

	local panelParticle = ccui.Helper:seekWidgetByName(root, "Panel_Particle")

	local particleGainL = cc.ParticleSystemQuad:create("main/res/particles/ParticleGainL.plist")
	panelParticle:addChild(particleGainL)

	local particleGainR = cc.ParticleSystemQuad:create("main/res/particles/ParticleGainR.plist")
	panelParticle:addChild(particleGainR)

	local particleColourBarL = cc.ParticleSystemQuad:create("main/res/particles/ParticleColourBarL.plist")
	panelParticle:addChild(particleColourBarL)

	local particleColourBarR = cc.ParticleSystemQuad:create("main/res/particles/ParticleColourBarR.plist")
	panelParticle:addChild(particleColourBarR)

	local round = ccui.Helper:seekWidgetByName(root, "Image_Round")
	round:runAction(cc.RepeatForever:create(cc.RotateBy:create(2, 360)))

	local panelAnimation = ccui.Helper:seekWidgetByName(root, "Panel_Animation")
	cc.SpriteFrameCache:getInstance():addSpriteFrames("main/res/gainGold/shanshuo.plist")

	local spriteAni = cc.Sprite:create()
	panelAnimation:addChild(spriteAni)

	local animation = cc.Animation:create()
	for i = 1, 2 do
		local frameName = string.format("shanshuo%d.png", i)
    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
		animation:addSpriteFrame(frame)
	end
	animation:setDelayPerUnit(0.06)

	local action = cc.RepeatForever:create(cc.Animate:create(animation))
	spriteAni:runAction(action)
	spriteAni:setBlendFunc(gl.SRC_ALPHA,gl.ONE)
	spriteAni:setScale(3)
end

function ui_turntable_reward_t:onCloseHandler()
	self:close()
end