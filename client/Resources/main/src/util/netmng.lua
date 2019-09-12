module( "netmng", package.seeall )

GS_SERV_IP = ""
GS_SERV_PORT = 0

NET_CONN    = true
NET_DISCONN = false

g_gt_init = g_gt_init or false
g_gt_sock = g_gt_sock or clientSock:getGtInstance()
g_gt_sock:setLuaFunc(gatesvr.onGateRecvHandler) 
g_gt_conn = g_gt_conn or NET_DISCONN

g_gs_init = g_gs_init or false
g_gs_ask_for_close = g_gs_ask_for_close or false
g_gs_sock = g_gs_sock or clientSock:getGsInstance()
g_gs_sock:setLuaFunc(gamesvr.onGsRecvHandler)
g_gs_conn = g_gs_conn or NET_DISCONN

-- 离线时发包缓存表
gt_offline_packet_tbl_ = gt_offline_packet_tbl_ or {}
gs_offline_packet_tbl_ = gs_offline_packet_tbl_ or {}

--
-- 网络相关
--
-- 连接gateserver
function gateInit()
    if g_gt_init then
        return
    end
    g_gt_init = true
    if g_gt_conn == NET_DISCONN then
        g_gt_sock:connect( GATE_SERV_IP, GATE_SERV_PORT )
    end
end

--初始化GS地址
function setGsNetAddress( ip, port )
    GS_SERV_IP = ip
    GS_SERV_PORT = port
end

-- 连接gsserver
function gsInit()
    if g_gs_init then
        return
    end
    g_gs_init = true
    if g_gs_conn == NET_DISCONN then
        g_gs_sock:connect(GS_SERV_IP, GS_SERV_PORT )
    end
end

-- 默认gs
function sendGsData( sendObj )
    if g_gs_conn == NET_DISCONN then 
        table.insert( gs_offline_packet_tbl_, sendObj )
        gsInit()
        return false
    end

    local mainCmd = sendObj:getMainCmd()
    local subCmd = sendObj:getSubCmd()

    cclog(" onGsSendHandler MainCmd:%d SubCmd:%d", mainCmd, subCmd)
    g_gs_sock:sendData( sendObj )
    return true
end

-- gt
function sendGtData( sendObj )
    if g_gt_conn == NET_DISCONN then
        table.insert( gt_offline_packet_tbl_, sendObj )
        gateInit()
        return false
    end

    local mainCmd = sendObj:getMainCmd()
    local subCmd = sendObj:getSubCmd()

    cclog(" onGtSendHandler MainCmd:%d SubCmd:%d", mainCmd, subCmd)
    g_gt_sock:sendData( sendObj )
    return true
end

-- send all offline data
function sendAllGtData()
    for k,sendObj in pairs(gt_offline_packet_tbl_) do
        sendGtData( sendObj )
    end
    gt_offline_packet_tbl_={}
end

function sendAllGsData()
    for k,sendObj in pairs(gs_offline_packet_tbl_) do
        sendGsData( sendObj )
    end
    gs_offline_packet_tbl_={}
end

function gsClose()
    if g_gs_conn then
        g_gs_ask_for_close = true
        g_gs_sock:close()
    end
end