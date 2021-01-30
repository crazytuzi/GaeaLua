local CtrlBase = _G.Class("CtrlBase", _G.AbstractCtrl)

local function __init(self)
    self._Ctrls = {}
end

local function __delete(self)
    for _, _Ctrl in pairs(self._Ctrls) do
        _Ctrl:Delete()
    end

    self._Ctrl = {}
end

local function Show()
end

local function Hide()
end

local function RegisterCtrl(self, Widget, CtrlClass)
    local _Ctrl = CtrlClass.New(Widget)

    table.insert(self._Ctrls, 1, _Ctrl)
end

local function ShowCtrl(self, CtrlClass, ...)
    for _, _Ctrl in pairs(self._Ctrls) do
        if _Ctrl.__class_type == CtrlClass and not _Ctrl:IsVisible() then
            _Ctrl:Show(...)
        end
    end
end

local function HideCtrl(self, CtrlClass, ...)
    for _, _Ctrl in pairs(self._Ctrls) do
        if _Ctrl.__class_type == CtrlClass and _Ctrl:IsVisible() then
            _Ctrl:Hide(...)
        end
    end
end

local function Close(self)
    if not _G.IsStringNullOrEmpty(self.uiName) then
        _G.UIManager:Remove(self.uiName)
    end
end

CtrlBase.__init = __init
CtrlBase.__delete = __delete
CtrlBase.Show = Show
CtrlBase.Hide = Hide
CtrlBase.RegisterCtrl = RegisterCtrl
CtrlBase.ShowCtrl = ShowCtrl
CtrlBase.HideCtrl = HideCtrl
CtrlBase.Close = Close

return CtrlBase
