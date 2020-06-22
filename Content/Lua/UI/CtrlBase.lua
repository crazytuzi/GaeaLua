CtrlBase = _G.Class("CtrlBase", AbstractCtrl)

function CtrlBase:InitCtrl(UICtrl)
    if not _G.IsUValid(UICtrl) then
        Logger.warn("CtrlBase:InitCtrlBase => UICtrl is nil")
        return
    end

    self.uiData = {}

    local Widget = UICtrl:GetWidget()

    self:Init(Widget)
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
