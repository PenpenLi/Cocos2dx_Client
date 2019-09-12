require_ex ("main.src.global.global")

require_ex ("main.src.prot.pt_gate")
require_ex ("main.src.prot.pt_game")

require_ex ("main.src.handler.gt_login_handler")
require_ex ("main.src.handler.gt_loginQRScan_handler")
require_ex ("main.src.handler.gt_mbLogin_handler")
require_ex ("main.src.handler.gt_hall_handler")
require_ex ("main.src.handler.gt_score_handler")
require_ex ("main.src.handler.gt_daySign_handler")
require_ex ("main.src.handler.gt_bank_handler")
require_ex ("main.src.handler.gt_order_handler")
require_ex ("main.src.handler.gt_shop_handler")
require_ex ("main.src.handler.gt_player_handler")
require_ex ("main.src.handler.gt_spreader_handler")
require_ex ("main.src.handler.gt_chat_handler")
require_ex ("main.src.handler.gt_leaderboard_handler")
require_ex ("main.src.handler.gt_auction_handler")
require_ex ("main.src.handler.gatesvr")
require_ex ("main.src.handler.gs_arcade_handler")
require_ex ("main.src.handler.gs_room_handler")
require_ex ("main.src.handler.gs_config_handler")
require_ex ("main.src.handler.gs_system_handler")
require_ex ("main.src.handler.gamesvr")

require_ex ("main.src.config.games_config")
require_ex ("main.src.config.shop_config")

require_ex ("main.src.util.tools")
require_ex ("main.src.util.AutoAmount")
require_ex ("main.src.util.EventConstants")
require_ex ("main.src.util.constants")
require_ex ("main.src.util.LocalLanguage")
require_ex ("main.src.util.LocalConfig")
require_ex ("main.src.util.LocalDataBase")
require_ex ("main.src.util.LocalVersions")

require_ex ("main.src.util.common")
require_ex ("main.src.util.MathEx")
require_ex ("main.src.util.StringEx")
require_ex ("main.src.util.TableEx")
require_ex ("main.src.util.utf8")
require_ex ("main.src.util.serializable")
require_ex ("main.src.util.netmng")
require_ex ("main.src.util.NodeEx")
require_ex ("main.src.util.MultipleDownloader")
require_ex ("main.src.ui.common.NodeBase")
require_ex ("main.src.ui.common.LayerBase")
require_ex ("main.src.ui.common.SceneBase")
require_ex ("main.src.ui.common.SwallowView")
require_ex ("main.src.ui.common.SwitchView")
require_ex ("main.src.ui.common.PopUpView")
require_ex ("main.src.ui.common.LoadingView")
require_ex ("main.src.ui.common.TextTipsUtils")
require_ex ("main.src.ui.common.WarnTips")
require_ex ("main.src.ui.common.VendingTips")
require_ex ("main.src.ui.common.GuideFinger")
require_ex ("main.src.ui.hall.ForgotPasswordView")
require_ex ("main.src.ui.hall.ui_complete_spreader_t")
require_ex ("main.src.ui.hall.ui_store_item_t")
require_ex ("main.src.ui.hall.ui_recharge_free_t")
require_ex ("main.src.ui.hall.ui_recharge_zalopay_t")
require_ex ("main.src.ui.hall.ui_recharge_momo_t")
require_ex ("main.src.ui.hall.RechargeScene")
require_ex ("main.src.ui.hall.ui_qr_login_t")
require_ex ("main.src.ui.hall.mbLogin.ui_mb_login_t")
require_ex ("main.src.ui.hall.mbLogin.ui_mb_toubi_t")
require_ex ("main.src.ui.hall.TransactionVerifyView")
require_ex ("main.src.data.player_t")

require_ex ("main.src.scene.UpdateScene")
require_ex ("main.src.scene.LoginScene")
require_ex ("main.src.scene.RegisterScene")
require_ex ("main.src.scene.MainScene")

local function main()
	global.g_mainPlayer = createObj(player_t)
	global.g_mainPlayer:setLocationData(global.location_)

	_G.GATE_SERV_PORT = math.random(GATE_SERV_PORT, GATE_SERV_PORT + 4)
	
	if cc.PLATFORM_OS_ANDROID == PLATFROM then
		
	elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
		luaoc.callStaticMethod("AppController", "initalizeIOSiAP", {})
	elseif cc.PLATFORM_OS_WINDOWS == PLATFROM then

	end

	replaceScene(LoginScene, TRANS_CONST.TRANS_SCALE)
end

function onLoginZaloSuccess(param)
	handlerDelayed(function()
			local dataZalo = serializable.unserialize(param)
			dataZalo.login3rd = LOGIN_3RD.ZALO_LOGIN
			global.g_mainPlayer:setLoginData3rd(dataZalo)

			LoadingView.showTips()

			_G.WX_PLATFORM = LOGIN_3RD.ZALO_LOGIN

			local location = global.g_mainPlayer:getLocationCity()
			gatesvr.sendLoginOtherPlatform(0, dataZalo.userid, dataZalo.name, dataZalo.name, "", location)
		end, ENTER_DELAY)
end

function onLoginFaceBookSuccess(param)
	handlerDelayed(function()
			local dataFaceBook = serializable.unserialize(param)
			dataFaceBook.login3rd = LOGIN_3RD.FACEBOOK_LOGIN
			global.g_mainPlayer:setLoginData3rd(dataFaceBook)

			LoadingView.showTips()

			_G.WX_PLATFORM = LOGIN_3RD.FACEBOOK_LOGIN
			
			local location = global.g_mainPlayer:getLocationCity()
			gatesvr.sendLoginOtherPlatform(0, dataFaceBook.userid, dataFaceBook.name, dataFaceBook.name, "", location)
		end, ENTER_DELAY)
end

function onLogin3rdFailed(param)
	handlerDelayed(function()
			global.g_gameDispatcher:sendMessage(GAME_MESSAGE_LOGIN_3RD_FAILED)
		end, ENTER_DELAY)
end

function onNganLuongPaymentSuccess(param)
	handlerDelayed(function()
			local dataPayment = serializable.unserialize(param)
			global.g_gameDispatcher:sendMessage(GAME_MESSAGE_NGANLUONG_PAYMENT_SUCCESS, dataPayment)
		end, ENTER_DELAY)
end

function onZaloShareSuccess(param)
	handlerDelayed(function()
			global.g_gameDispatcher:sendMessage(GAME_MESSAGE_ZALO_SHARE_SUCCESS)
		end, ENTER_DELAY)
end

function onFacebookShareSuccess(param)
	handlerDelayed(function()
			global.g_gameDispatcher:sendMessage(GAME_MESSAGE_FACEBOOK_SHARE_SUCCESS)
		end, ENTER_DELAY)
end

function onShare3rdFailed(param)
	handlerDelayed(function()
			global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHARE_3RD_FAILED)
		end, ENTER_DELAY)
end

function onStoreItemsSuccess(param)
	handlerDelayed(function()
			local storeItems = serializable.unserialize(param)
			global.g_gameDispatcher:sendMessage(GAME_MESSAGE_STORE_ITEMS_SUCCESS, storeItems)
		end, ENTER_DELAY)
end

function onStoreItemsFailed()
	handlerDelayed(function()
			global.g_gameDispatcher:sendMessage(GAME_MESSAGE_STORE_ITEMS_FAILED)
		end, ENTER_DELAY)
end

function onBuyStoreItemSuccess(param)
	handlerDelayed(function()
			local transaction = serializable.unserialize(param)
			global.g_mainPlayer:addTransaction(transaction)

			global.g_gameDispatcher:sendMessage(GAME_MESSAGE_STORE_BUY_SUCCESS)
		end, ENTER_DELAY)
end

function onBuyStoreItemFailed()
	handlerDelayed(function()
			global.g_gameDispatcher:sendMessage(GAME_MESSAGE_STORE_BUY_FAILED)
		end, ENTER_DELAY)
end

function onConsumeStoreItemSuccess(param)
	handlerDelayed(function()
			local options = serializable.unserialize(param)
			global.g_gameDispatcher:sendMessage(GAME_MESSAGE_STORE_CONSUME_SUCCESS, options)
		end, ENTER_DELAY)
end

function onConsumeStoreItemFailed(param)
	handlerDelayed(function()
			local options = serializable.unserialize(param)
			global.g_gameDispatcher:sendMessage(GAME_MESSAGE_STORE_CONSUME_FAILED, options)
		end, ENTER_DELAY)
end

function onUploadImageSuccess(param)
	handlerDelayed(function()
			global.g_gameDispatcher:sendMessage(GAME_MESSAGE_UPLOAD_IMAGE_SUCCESS, param)
		end, ENTER_DELAY)
end

function onUploadImageFailed(param)
	handlerDelayed(function()
			global.g_gameDispatcher:sendMessage(GAME_MESSAGE_UPLOAD_IMAGE_FAILED, param)
		end, ENTER_DELAY)
end

main()