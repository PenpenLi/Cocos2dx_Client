module("game_dispatcher_t", package.seeall)

function init(self)
	self.handlers_ = {}
end

function addMessageListener(self, msg, obj, func)
	self.handlers_[msg] = self.handlers_[msg] or {}
	local msgHandler = self.handlers_[msg]
	msgHandler[obj] = func
end

function removeMessageListener(self, msg, obj)
	if self.handlers_[msg] and self.handlers_[msg][obj] then
		self.handlers_[msg][obj] = nil
	end
end
--同步调用
function sendMessage(self, msg, ...)
	if self.handlers_[msg] == nil then
		return
	end
	local msgHandlers = depCopyTable(self.handlers_[msg])
	for k, v in pairs(msgHandlers) do
		v(k, ...)
	end
end