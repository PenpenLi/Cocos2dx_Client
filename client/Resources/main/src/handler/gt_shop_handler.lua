module("gatesvr", package.seeall)

local shopItems = nil
local bagItems = nil
local buyIndex = nil
local buyNum = nil
local sellIndex = nil
local sellNum = nil
local giveIndex = nil
local giveNum = nil
local gitIndex = nil
local gitNum = nil
local targetId = nil

function getShopItemData(index)
	for _, v in pairs(shopItems) do
		if v.index == index then
			return v
		end
	end

	return shop_config[index]
end

--解包
function onPropertyInfo(buffObj)
	local isItem1Buyed = global.g_mainPlayer:isItem1Buyed()
	local len = buffObj:readChar()
	local items = {}
	for i = 1, len do
		local item = {}
		item.index = buffObj:readShort()
		item.discount = buffObj:readShort()
		item.issueArea = buffObj:readShort()
		item.propertyGold = buffObj:readInt64()
		item.propertyCash = buffObj:readInt64()
		item.sendLoveLiness = buffObj:readInt64()
		item.recvLoveLiness = buffObj:readInt64()
		shop_config[item.index].discount=item.discount

		if item.index == 1 and isItem1Buyed then
			
		else
			table.insert(items, item)
		end
	end
	shopItems = items

	if bagItems and shopItems then
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHOP_INFO, shopItems, bagItems)
	end
end

function onPropertyUserInfo(buffObj)
	local len = buffObj:readChar()
	local items = {}
	for i = 1, len do
		local item = {}
		item.index = buffObj:readShort()
		item.count = buffObj:readShort()
		item.issueArea = buffObj:readShort()
		item.propertyGold = buffObj:readInt64()
		item.propertyCash = buffObj:readInt64()
		item.sendLoveLiness = buffObj:readInt64()
		item.recvLoveLiness = buffObj:readInt64()
		table.insert(items, item)
	end
	bagItems = items

	if bagItems and shopItems then
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHOP_INFO, shopItems, bagItems)
	end
end

function onPropertySendResult(buffObj)
	local ret = buffObj:readShort()
	local desc = buffObj:readString(buffObj:getLength() - 2)

	if ret == 0 then
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHOP_GIVE_SUCCESS, giveIndex, giveNum)
	end

	WarnTips.showTips({
			text = desc,
			style = WarnTips.STYLE_Y
		})
end

function onPropertyBuyResult(buffObj)
	local ret = buffObj:readShort()
	local desc = buffObj:readString(buffObj:getLength() - 2)

	if ret == 0 then
		local data = depCopyTable(getShopItemData(buyIndex))
		data.count = buyNum
		if buyIndex == 1 then
			global.g_mainPlayer:setItem1Buyed()
		end
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHOP_BUY_SUCCESS, data, targetId)

		WarnTips.showTips(
				{	
					text = desc,
					style = WarnTips.STYLE_Y,
					confirm = function()
							PopUpView.showPopUpView(ui_shop_deal_t, data)
						end,
					cancel = function()
							PopUpView.showPopUpView(ui_shop_deal_t, data)
						end
				}
			)
	else
		WarnTips.showTips({
				text = desc,
				style = WarnTips.STYLE_Y
			})
	end
end

function onPropertySellResult(buffObj)
	local ret = buffObj:readShort()
	local desc = buffObj:readString(buffObj:getLength() - 2)

	if ret == 0 then
		if sellIndex > 5 then
			global.g_mainPlayer:setPlayerMedal(sellIndex, 1)
		else
			WarnTips.showTips({
					text = desc,
					style = WarnTips.STYLE_Y
				})
			global.g_mainPlayer:setPlayerVipLevel(sellIndex)
		end
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHOP_SELL_SUCCESS, sellIndex, sellNum)
	else
		WarnTips.showTips({
				text = desc,
				style = WarnTips.STYLE_Y
			})
	end
end

function onGetPayCodeResult(buffObj)
	local ret = buffObj:readInt()
	local paycode = buffObj:readString(64)
	local desc = buffObj:readString(256)
	if ret == 0 then
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHOP_GET_PAYCODE_SUCCESS, paycode)
	else
		WarnTips.showTips({
				text = desc,
				style = WarnTips.STYLE_Y
			})
	end
end

function onGetPayCode2Result(buffObj)
	local ret = buffObj:readInt()
	local paycode = buffObj:readString(64)
	local desc = buffObj:readString(256)
	if ret == 0 then
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHOP_GET_PAYCODE2_SUCCESS, paycode)
	else
		WarnTips.showTips({
				text = desc,
				style = WarnTips.STYLE_Y
			})
	end
end

function onUserExchange(buffObj)
	gatesvr.sendInsureInfoQuery(true)
	
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHOP_CODE_EXCHANGE_SUCCESS)
end

function onItemGive(buffObj)
	local ret = buffObj:readShort()
	local desc = buffObj:readString(buffObj:getLength() - 2)

	WarnTips.showTips(
		{
			text = desc,
			style = WarnTips.STYLE_Y
		}
	)

	if ret == 0 then
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHOP_ITEM_GIVE_SUCCESS, gitIndex, gitNum)
	end
end

--封包
function sendPropertyInfoQuery()
	shopItems = nil
	bagItems = nil

	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_CS_PROPERTY_INFO)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	if global.g_mainPlayer:isLogin3rdAvailable() then
		local data = global.g_mainPlayer:getLoginData3rd()
		buff:writeString(data.userid, 66)
	else
		buff:writeMD5(global.g_mainPlayer:getLoginPassword(), 66)
	end

	netmng.sendGtData(buff)
end

function sendPropertyItem(index, count, targetUserId, targetAccount, sign, password)
	giveIndex = index
	giveNum = count

	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_C_SEND_PROPERTY)
	buff:writeShort(count)
	buff:writeShort(index)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeInt(targetUserId)
	buff:writeString(targetAccount, 64)
	buff:writeInt(sign)
	buff:writeMD5(password, 66)

	netmng.sendGtData(buff)
end

function buyPropertyItem(index, count, targetUserId, password)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_C_BUY_PROPERTY)
	buff:writeShort(count)
	buff:writeShort(index)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeInt(targetUserId)
	buff:writeMD5(password, 66)

	buyIndex = index
	buyNum = count
	targetId = targetUserId

	netmng.sendGtData(buff)
end

function sellPropertyItem(index, count)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_C_SELL_PROPERTY)
	buff:writeShort(count)
	buff:writeShort(index)
	buff:writeInt(global.g_mainPlayer:getPlayerId())

	sellIndex = index
	sellNum = count

	netmng.sendGtData(buff)
end

function sendGetPayCode()
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_USER_GETPAYCODE)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	if global.g_mainPlayer:isLogin3rdAvailable() then
		local data = global.g_mainPlayer:getLoginData3rd()
		buff:writeString(data.userid, 66)
	else
		buff:writeMD5(global.g_mainPlayer:getLoginPassword(), 66)
	end

	netmng.sendGtData(buff)
end

function sendUserExchange()
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_USER_EXCHANGE)
	buff:writeInt(global.g_mainPlayer:getPlayerId())

	netmng.sendGtData(buff)
end

function sendGetPayCode2(itemId, itemCount)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_USER_GETPAYCODE2)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	if global.g_mainPlayer:isLogin3rdAvailable() then
		local data = global.g_mainPlayer:getLoginData3rd()
		buff:writeString(data.userid, 66)
	else
		buff:writeMD5(global.g_mainPlayer:getLoginPassword(), 66)
	end
	buff:writeInt(itemId)
	buff:writeInt(itemCount)

	netmng.sendGtData(buff)
end

function sendItemGive(itemId, itemCount, receiver)
	gitIndex = itemId
	gitNum = itemCount

	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_SEND_PROPERTY)
	buff:writeShort(itemCount)
	buff:writeShort(itemId)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeInt(receiver)
	if global.g_mainPlayer:isLogin3rdAvailable() then
		local data = global.g_mainPlayer:getLoginData3rd()
		buff:writeString(data.userid, 66)
	else
		buff:writeMD5(global.g_mainPlayer:getLoginPassword(), 66)
	end

	netmng.sendGtData(buff)
end