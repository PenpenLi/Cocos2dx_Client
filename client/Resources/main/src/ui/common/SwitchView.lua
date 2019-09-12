--组切换界面
SwitchView = class("SwitchView", SwallowView)

switch_view_groups = switch_view_groups or {}

function SwitchView.switchView(group, zorder, cls, ...)
	local v = switch_view_groups[group]
	if v then
		SwitchView.closeView(v)
	end

	local scene = cc.Director:getInstance():getRunningScene()
	local view = cls.new(...)
	-- scene:addChild(view, zorder)
	scene:addChildWithLayerType(MAIN_LAYER.LAYER_VIEW, view, zorder)
	
	view.__group__ = group
	switch_view_groups[group] = view
end

function SwitchView.closeView(view)
	view:close()
end

function SwitchView:ctor()
	SwitchView.super.ctor(self)
end

function SwitchView:close()
	switch_view_groups[self.__group__] = nil

	SwitchView.super.close(self)
end