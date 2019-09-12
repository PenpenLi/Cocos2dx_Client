ShuoMingView = class("ShuoMingView", PopUpView)

function ShuoMingView:ctor(data)
	LuDanView.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("caidaxiao/res/json/ui_shuoming.json")
	self.nodeUI_:addChild(root)
	local  Label_3 = ccui.Helper:seekWidgetByName(root,"Label_3")
	Label_3:setString("Hướng dẫn:\nNhấp vào CHIP để thay đổi số lượng đặt cược\ncho mỗi lần nhấp. Nhấn vào khu vực bạn muốn\nđặt cược.\nQuy tắc :\nTổng điểm của hai xúc xắc từ : 2-6 là TIỂU, 7 là\nHÒA, 8-12 ĐẠI.\nTrúng cửa TIỂU, nhận lại gấp 2 lần số điểm đã\nđặt.\nTrúng cửa Đại, nhận lại gấp 1,95 lần số điểm đã\nđặt.\nTrúng cửa Hòa, nhận gấp 6 lần số điểm đã đặt,\ntrả lại toàn bộ số điểm đặt cho người chơi");
end



function ShuoMingView:onClose()
	self:close()
end


function ShuoMingView:touchBegan(_touchX, _touchY, _preTouchX, _preTouchY)
    --cclog("touchBegan")
    return true
end

function ShuoMingView:touchMoved(_touchX, _touchY, _preTouchX, _preTouchY)
    --cclog("touchMoved")
end

function ShuoMingView:touchEnded(_touchX, _touchY, _preTouchX, _preTouchY)
    --cclog("touchEnded")
    self:close()
end

function ShuoMingView:touchCancelled(_touchX, _touchY, _preTouchX, _preTouchY)
    --cclog("touchCancelled")
    self:touchEnded(_touchX, _touchY, _preTouchX, _preTouchY)
end