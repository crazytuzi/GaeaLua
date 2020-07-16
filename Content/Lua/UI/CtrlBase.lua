local Base = _G.AbstractCtrl

local CtrlBase = _G.Class("CtrlBase", Base)

local function __init(self)
    self.uiName = string.split(self._class_type.__cname, "Ctrl")[1]

    _G.UIManager.Register(self)
end

local function __delete(self)
    for _, SubCtrl in pairs(self._subCtrls) do
        SubCtrl:OnDispose()
    end

    self._subCtrls = {}
end

local function Init(self, UICtrl)
    if not _G.IsValid(UICtrl) then
        _G._Logger.warn("CtrlBase:InitCtrl => UICtrl is nil")
        return
    end

    self._subCtrls = {}

    local Widget = UICtrl:GetWidget()

    Base.Init(self, Widget)
end

local function RegisterSubCtrl(self, Widget, SubCtrlClass)
    local SubCtrl = SubCtrlClass.New(Widget)

    table.insert(self._subCtrls, 1, SubCtrl)
end

local function Show(self, SubCtrlClass)
    for _, SubCtrl in pairs(self._subCtrls) do
        if SubCtrl._class_type == SubCtrlClass and not SubCtrl:IsVisible() then
            SubCtrl:Show()
        end
    end
end

local function Hide(self, SubCtrlClass)
    for _, SubCtrl in pairs(self._subCtrls) do
        if SubCtrl._class_type == SubCtrlClass and SubCtrl:IsVisible() then
            SubCtrl:Hide()
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
CtrlBase.Init = Init
CtrlBase.RegisterSubCtrl = RegisterSubCtrl
CtrlBase.Show = Show
CtrlBase.Hide = Hide
CtrlBase.Close = Close

return CtrlBase
