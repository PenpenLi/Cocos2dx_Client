RoomPlayerView = class("RoomPlayerView", PopUpView)

function RoomPlayerView:ctor(data)
	RoomPlayerView.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("caidaxiao/res/json/ui_player.json")
	self.nodeUI_:addChild(root)
    self.listCreate_ = ccui.Helper:seekWidgetByName(root, "ListView_12")

	self:showPlayer()
end

function RoomPlayerView:showPlayer( ... )
    -- body
    local playerList = global.g_mainPlayer:getRoomAllPlayer();
    -- table.dump(playerList)
    local playerListData = {}
    local index = 1;
    for i, v in pairs(playerList) do
        table.insert(playerListData,playerList[i])
    end

    table.sort(playerListData,function(a,b) return a.score>b.score end )
    -- table.dump(playerListData)
    for i=1,#playerListData do
        local data = playerListData[i]
        data.paiming = i;
        local item = ui_item_player_t.new(data)
        self.listCreate_:pushBackCustomItem(item.node_)
    end


end

function RoomPlayerView:onClose()
	self:close()
end


function RoomPlayerView:touchBegan(_touchX, _touchY, _preTouchX, _preTouchY)
    --cclog("touchBegan")
    return true
end

function RoomPlayerView:touchMoved(_touchX, _touchY, _preTouchX, _preTouchY)
    --cclog("touchMoved")
end

function RoomPlayerView:touchEnded(_touchX, _touchY, _preTouchX, _preTouchY)
    --cclog("touchEnded")
    self:close()
end

function RoomPlayerView:touchCancelled(_touchX, _touchY, _preTouchX, _preTouchY)
    --cclog("touchCancelled")
    self:touchEnded(_touchX, _touchY, _preTouchX, _preTouchY)
end