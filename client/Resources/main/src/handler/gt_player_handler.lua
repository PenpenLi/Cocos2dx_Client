module("gatesvr", package.seeall)

--解包


--封包
function sendBindingMachine(sign, password)
	global.g_modify_type = MODIFY_LOCK_MACHINE
	global.g_modify_value = sign

	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_MODIFY_MACHINE)
	buff:writeChar(sign)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeMD5(password, 66)
	buff:writeMD5(MachineUUID, 66)

	netmng.sendGtData(buff)
end