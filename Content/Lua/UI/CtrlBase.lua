local Class = require "Utils/Class"

local AbstractCtrl = require "UI/AbstractCtrl"

local CtrlBase = Class("CtrlBase", AbstractCtrl)

local function __init(self)
    self._Ctrls = {}

    self._Packages = {}
end

local function __delete(self)
    for _, _Ctrl in pairs(self._Ctrls) do
        _Ctrl:Delete()
    end

    self._Ctrl = {}

    for _, CtrlClass in pairs(self._Packages) do
        package.loaded[CtrlClass.__path] = nil
    end

    self._Packages = {}
end

local function Show(self, Params)
    self:OnShow(Params)
end

local function Hide(self, Params)
    self:OnHide(Params)
end

local function RegisterCtrl(self, Widget, CtrlClass)
    table.insert(self._Packages, CtrlClass)
    
    local _Ctrl = CtrlClass(Widget)

    table.insert(self._Ctrls, 1, _Ctrl)
end

local function GetCtrl(self, CtrlClass)
    if type(CtrlClass) == "table" and CtrlClass:IsA(CtrlBase) then
        for _, _Ctrl in pairs(self._Ctrls) do
            if _Ctrl:IsA(CtrlClass) then
                return _Ctrl
            end
        end
    else
        for _, _Ctrl in pairs(self._Ctrls) do
            if _Ctrl.uiName == tostring(CtrlClass) then
                return _Ctrl
            end
        end
    end

    return nil
end

local function ShowCtrl(self, CtrlClass, ...)
    if type(CtrlClass) == "table" and CtrlClass:IsA(CtrlBase) then
        for _, _Ctrl in pairs(self._Ctrls) do
            if _Ctrl:IsA(CtrlClass) and not _Ctrl:IsVisible() then
                _Ctrl:Show(...)

                return
            end
        end
    else
        for _, _Ctrl in pairs(self._Ctrls) do
            if _Ctrl.uiName == tostring(CtrlClass) and not _Ctrl:IsVisible() then
                _Ctrl:Show(...)

                return
            end
        end
    end
end

local function HideCtrl(self, CtrlClass, ...)
    if type(CtrlClass) == "table" and CtrlClass:IsA(CtrlBase) then
        for _, _Ctrl in pairs(self._Ctrls) do
            if _Ctrl:IsA(CtrlClass) and _Ctrl:IsVisible() then
                _Ctrl:Hide(...)

                return
            end
        end
    else
        for _, _Ctrl in pairs(self._Ctrls) do
            if _Ctrl.uiName == tostring(CtrlClass) and _Ctrl:IsVisible() then
                _Ctrl:Hide(...)

                return
            end
        end
    end
end

local function IsShowCtrl(self, CtrlClass)
    if type(CtrlClass) == "table" and CtrlClass:IsA(CtrlBase) then
        for _, _Ctrl in pairs(self._Ctrls) do
            if _Ctrl:IsA(CtrlClass) and _Ctrl:IsVisible() then
                return true
            end
        end
    else
        for _, _Ctrl in pairs(self._Ctrls) do
            if _Ctrl.uiName == tostring(CtrlClass) and _Ctrl:IsVisible() then
                return true
            end
        end
    end

    return false
end

CtrlBase.__init = __init
CtrlBase.__delete = __delete
CtrlBase.Show = Show
CtrlBase.Hide = Hide
CtrlBase.RegisterCtrl = RegisterCtrl
CtrlBase.GetCtrl = GetCtrl
CtrlBase.ShowCtrl = ShowCtrl
CtrlBase.HideCtrl = HideCtrl
CtrlBase.IsShowCtrl = IsShowCtrl

return CtrlBase
