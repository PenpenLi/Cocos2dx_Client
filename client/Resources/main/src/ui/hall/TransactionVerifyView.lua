TransactionVerifyView = class("TransactionVerifyView", PopUpView)

function TransactionVerifyView:ctor(options)
	TransactionVerifyView.super.ctor(self, true)

	self.handlers_ = {
		[cc.PLATFORM_OS_WINDOWS] = handler(self, self.checkTransactionWindows),
		[cc.PLATFORM_OS_ANDROID] = handler(self, self.checkTransactionAndroid),
		[cc.PLATFORM_OS_IPHONE] = handler(self, self.checkTransactionIOS),
		[cc.PLATFORM_OS_IPAD] = handler(self, self.checkTransactionIOS),
	}

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("main/res/json/ui_main_verify.json")
	self.nodeUI_:addChild(root)

	local content = LocalLanguage:getLanguageString("L_0ef3cc99a0ff7fee")
	if type(options) == "string" then
		content = options
	elseif type(options) == "table" then
		content = options.text or ""
	end

	local labelContent = ccui.Helper:seekWidgetByName(root, "Label_2")
	labelContent:setString(content)

	local iconLoad = ccui.Helper:seekWidgetByName(root, "Image_1")
	iconLoad:setScale(0.6)
	local action = cc.RepeatForever:create(cc.RotateBy:create(5, 359))
	iconLoad:runAction(action)
end

function TransactionVerifyView:onPopUpComplete()
	self:checkTransactions()
end

function TransactionVerifyView:checkTransactions()
	self.transactionsId_ = {}

	local transactions = global.g_mainPlayer:getTransactions()
	for k, v in pairs(transactions) do
		table.insert(self.transactionsId_, k)
	end

	self:checkTransaction()
end

function TransactionVerifyView:checkTransaction()
	if #self.transactionsId_ < 1 then
		gatesvr.sendInsureInfoQuery(true)
		self:close()
	else
		local func = self.handlers_[PLATFROM]
		func()
	end
end

function TransactionVerifyView:checkTransactionWindows()

end

function TransactionVerifyView:checkTransactionAndroid()
	local orderId = table.remove(self.transactionsId_)
	local transaction = global.g_mainPlayer:getTransaction(orderId)
	if transaction.state == 0 then
		calljavaMethodV("consumePurchase", {transaction.orderid, transaction.token})
	elseif transaction.state == 1 then
		self:onCheckTransactionAndroid(orderId)
	end
end

function TransactionVerifyView:onCheckTransactionAndroid(orderId)
	local transaction = global.g_mainPlayer:getTransaction(orderId)
	local url = string.format(GOOGLE_PLAY_VERIFY, transaction.extra, transaction.productid, transaction.token, transaction.packagename, transaction.orderid)

	MultipleDownloader:createDataDownLoad(
		{
			identifier = "onCheckTransactionAndroid",
			fileUrl = url,
			onDataTaskSuccess = function(dataTask, params)
				local luaTbl = json.decode(params)
				if luaTbl.code == 200 then
					global.g_mainPlayer:removeTransaction(luaTbl.data.orderId)
				elseif luaTbl.code == 400 then
					global.g_mainPlayer:removeTransaction(transaction.orderid)
				end

				self:checkTransaction()
			end,
			onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
				self:checkTransaction()
			end,
		}
	)
end

function TransactionVerifyView:checkTransactionIOS()
	local orderId = table.remove(self.transactionsId_)
	local transaction = global.g_mainPlayer:getTransaction(orderId)
	local url = string.format(APPLE_STORE_VERIFY, transaction.extra, transaction.orderid, transaction.receipt)

	MultipleDownloader:createDataDownLoad(
		{
			identifier = "checkTransactionIOS",
			fileUrl = url,
			onDataTaskSuccess = function(dataTask, params)
				local luaTbl = json.decode(params)
				if luaTbl.code == 200 then
					global.g_mainPlayer:removeTransaction(luaTbl.data.receipt.transaction_id)
				elseif luaTbl.code == 400 then
					global.g_mainPlayer:removeTransaction(transaction.orderid)
				end

				self:checkTransaction()
			end,
			onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
				self:checkTransaction()
			end,
		}
	)
end

function TransactionVerifyView:onStoreConsumeSuccess(options)
	local transaction = global.g_mainPlayer:getTransaction(options.orderid)
	transaction.state = 1
	global.g_mainPlayer:addTransaction(transaction)

	self:onCheckTransactionAndroid(transaction.orderid)
end

function TransactionVerifyView:onStoreConsumeFailed(options)
	self:checkTransaction()
end

function TransactionVerifyView:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_STORE_CONSUME_SUCCESS, self, self.onStoreConsumeSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_STORE_CONSUME_FAILED, self, self.onStoreConsumeFailed)
end

function TransactionVerifyView:removeMsgHandler()
	MultipleDownloader:removeFileDownload("onCheckTransactionAndroid")
	MultipleDownloader:removeFileDownload("checkTransactionIOS")

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_STORE_CONSUME_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_STORE_CONSUME_FAILED, self)
end