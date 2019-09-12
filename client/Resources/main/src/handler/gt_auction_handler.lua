module("gatesvr", package.seeall)

local putaway_itemid = nil

--解包
function onPutaway(buffObj)
	LoadingView.closeTips()

	local ret = buffObj:readInt()
	local desc = buffObj:readString(256)

	if ret == 0 then
		PopUpView.showPopUpView(ShareAuctionView, putaway_itemid)
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_PUTAWAY_SUCCESS)
	else
		WarnTips.showTips(
				{
					text = desc,
					style = WarnTips.STYLE_Y
				}
			)
	end
end

function onBuyCommodity(buffObj)
	LoadingView.closeTips()

	local ret = buffObj:readInt()
	local desc = buffObj:readString(256)

	WarnTips.showTips(
			{
				text = desc,
				style = WarnTips.STYLE_Y
			}
		)

	if ret == 0 then
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BUY_SUCCESS)
	end
end

function onRequireUserInfo(buffObj)
	LoadingView.closeTips()

	local playerId = buffObj:readInt()
	local i1 = buffObj:readString(100)
	local i2 = buffObj:readString(100)
	local i3 = buffObj:readString(100)
	local i4 = buffObj:readString(100)
	local i5 = buffObj:readString(100)
	local i6 = buffObj:readString(100)
	local i7 = buffObj:readString(100)

	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_REQUEST_USER_INFO, i1, i2, i3, i4, i5, i6, i7)
end

function onUpdateUserInfo(buffObj)
	LoadingView.closeTips()

	local ret = buffObj:readInt()
	local desc = buffObj:readString(256)
	local playerId = buffObj:readInt()
	local i1 = buffObj:readString(100)
	local i2 = buffObj:readString(100)
	local i3 = buffObj:readString(100)
	local i4 = buffObj:readString(100)
	local i5 = buffObj:readString(100)
	local i6 = buffObj:readString(100)
	local i7 = buffObj:readString(100)

	WarnTips.showTips(
			{
				text = desc,
				style = WarnTips.STYLE_Y
			}
		)

	if ret == 0 then
		global.g_mainPlayer:setViMomo(i6)
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_MODIFY_USER_INFO, i1, i2, i3, i4, i5, i6, i7)
	end
end

--封包
function sendPutaway(goodsId, goodsCount)
	putaway_itemid = goodsId

	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_PAIMAIHANG)
	buff:setSubCmd(pt_gate.SUB_PMH_UPPROP)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	if global.g_mainPlayer:isLogin3rdAvailable() then
		local data = global.g_mainPlayer:getLoginData3rd()
		buff:writeString(data.userid, 66)
	else
		buff:writeMD5(global.g_mainPlayer:getLoginPassword(), 66)
	end
	buff:writeInt(goodsId)
	buff:writeInt(goodsCount)

	netmng.sendGtData(buff)
end

function buyCommodity(orderId)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_PAIMAIHANG)
	buff:setSubCmd(pt_gate.SUB_PMH_BUYPROP)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	if global.g_mainPlayer:isLogin3rdAvailable() then
		local data = global.g_mainPlayer:getLoginData3rd()
		buff:writeString(data.userid, 66)
	else
		buff:writeMD5(global.g_mainPlayer:getLoginPassword(), 66)
	end
	buff:writeInt(orderId)

	netmng.sendGtData(buff)
end

function requireUserInfo()
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_PAIMAIHANG)
	buff:setSubCmd(pt_gate.SUB_PMH_USERINFO)
	buff:writeInt(global.g_mainPlayer:getPlayerId())

	netmng.sendGtData(buff)
end

function updateUserInfo(i1, i2, i3, i4, i5, i6, i7)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_PAIMAIHANG)
	buff:setSubCmd(pt_gate.SUB_PMH_USERINFO_MODIFY)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	if global.g_mainPlayer:isLogin3rdAvailable() then
		local data = global.g_mainPlayer:getLoginData3rd()
		buff:writeString(data.userid, 66)
	else
		buff:writeMD5(global.g_mainPlayer:getLoginPassword(), 66)
	end
	buff:writeString(i1, 100)
	buff:writeString(i2, 100)
	buff:writeString(i3, 100)
	buff:writeString(i4, 100)
	buff:writeString(i5, 100)
	buff:writeString(i6, 100)
	buff:writeString(i7, 100)

	netmng.sendGtData(buff)
end