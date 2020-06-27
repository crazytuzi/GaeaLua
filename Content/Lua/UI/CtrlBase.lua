local Base = _G.AbstractCtrl

local CtrlBase = _G.Class("CtrlBase", Base)

local function __init(self)
    self.uiName = string.split(self._class_type.__cname, "Ctrl")[1]

    _G.UIManager.Register(self)
end

local function __delete(self)
    self.uiData = {}
end

local function Init(self, UICtrl)
    if not _G.IsUValid(UICtrl) then
        _G._Logger.warn("CtrlBase:InitCtrl => UICtrl is nil")
        return
    end

    self.uiData = {}

    local Widget = UICtrl:GetWidget()

    Base.Init(self, Widget)
end

local function Show(self)
    if not _G.IsStringNullOrEmpty(self.uiName) then
        _G.UIManager:Show(self.uiName)
    end
end

local function Remove(self)
    if not _G.IsStringNullOrEmpty(self.uiName) then
        _G.UIManager:Remove(self.uiName)
    end
end

CtrlBase.__init = __init
CtrlBase.__delete = __delete
CtrlBase.Init = Init
CtrlBase.Show = Show
CtrlBase.Remove = Remove

return CtrlBase
