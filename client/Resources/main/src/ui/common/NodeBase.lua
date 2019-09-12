NodeBase = class("NodeBase", function()
		return cc.Node:create()
	end)

function NodeBase:ctor()
	local function onNodeEvent(event)
		if event == "enter" then
			self:onEnter()
		elseif event == "exit" then
			self:onExit()
		elseif event == "cleanup" then
			self:onCleanup()
		elseif event == "enterTransitionFinish" then
			self:onEnterTransitionFinish()
		elseif event == "exitTransitionStart" then
			self:onExitTransitionStart()
		end
	end
	self:registerScriptHandler(onNodeEvent)

	self:initMsgHandler()
end

function NodeBase:onEnter()
	-- print("NodeBase onEnter ...")
end

function NodeBase:onExit()
	-- print("NodeBase onExit ...")
	self:removeMsgHandler()
end

function NodeBase:onCleanup()
	-- print("NodeBase onCleanup ...")
end

function NodeBase:onEnterTransitionFinish()
	-- print("NodeBase onEnterTransitionFinish ...")
end

function NodeBase:onExitTransitionStart()
	-- print("NodeBase onExitTransitionStart ...")
end

function NodeBase:close()
	self:removeFromParent()
end

function NodeBase:initMsgHandler()
  -- print("NodeBase initMsgHandler ...")
end

function NodeBase:removeMsgHandler()
	-- print("NodeBase removeMsgHandler ...")
end