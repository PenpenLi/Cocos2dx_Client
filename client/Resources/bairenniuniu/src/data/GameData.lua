GameData = class("GameData")

function GameData:ctor()

end

function GameData:setGameStatus(status)
	self.gameStatus_ = status
end

function GameData:getGameStatus()
	return self.gameStatus_
end