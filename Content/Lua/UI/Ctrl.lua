local Ctrl = _G.Class("Ctrl", _G.CtrlBase)

local function __init(self)
    self.uiName = string.split(self.__class_type.__cname, "Ctrl")[1]

    _G.UIManager.Register(self)
end

local function __delete()
end

local function Init(self, UICtrl, ...)
    if not _G.IsValid(UICtrl) then
        _G.Logger.warn("Ctrl:InitCtrl => UICtrl is nil")
        return
    end

    self.bIsDeleted = false

    local Widget = UICtrl:GetWidget()

    self.Super:Init(Widget, ...)
end

local function Close(self)
    if not _G.IsStringNullOrEmpty(self.uiName) then
        _G.UIManager:Remove(self.uiName)
    end
end

Ctrl.__init = __init
Ctrl.__delete = __delete
Ctrl.Init = Init
Ctrl.Close = Close

return Ctrl
