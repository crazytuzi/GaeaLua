local Base = AbstractCtrl

CtrlBase = _G.Class("CtrlBase", Base)

function CtrlBase:__init()
    self.uiName = self._class_type.__cname

    _G.UIManager:GetInstance().Register(self)
end

function CtrlBase:Init(UICtrl)
    if not _G.IsUValid(UICtrl) then
        Logger.warn("CtrlBase:InitCtrl => UICtrl is nil")
        return
    end

    self.uiData = {}

    local Widget = UICtrl:GetWidget()

    Base.Init(self, Widget)
end

function CtrlBase:Show()
    if not _G.IsStringNullOrEmpty(self.uiName) then
        UIManager:GetInstance():Show(self.uiName)
    end
end

function CtrlBase:Remove()
    if not _G.IsStringNullOrEmpty(self.uiName) then
        UIManager:GetInstance():Remove(self.uiName)
    end
end
