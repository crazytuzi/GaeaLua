UIManager = _G.Class("UIManager", ManagerBase)

local _Ctrls = {}

function UIManager.__init()
end

function UIManager.Register(Ctrl)
    if Ctrl == nil then
        Logger.warn("Register => ctrl is nil")
        return
    end

    if _G.IsStringNullOrEmpty(Ctrl.uiName) then
        Logger.warn("Register => uiName is nil")
        return
    end

    _Ctrls[Ctrl.uiName] = Ctrl
end

function UIManager:OnInit()
    self._uiManager =
        _G.UGaeaFunctionLibrary.GetGameInstanceSubsystem(_G.GetContextObject(), _G.import("GaeaUISubsystem"))

    if not _G.IsUValid(self._uiManager) then
        Logger.warn("UIManager:OnInit => uiMgr is not valid")
        return
    end

    self.OnUIInit_Delegate = _G.Dispatcher:Add(_G.Events.EVENT_UI_ON_INIT, self.OnUIInit, self)

    self.OnUIDispose_Delegate = _G.Dispatcher:Add(_G.Events.EVENT_UI_ON_DISPOSE, self.OnUIDispose, self)
end

function UIManager:OnUIInit(UIName)
    local Ctrl = self.GetCtrl(UIName)

    if Ctrl == nil then
        return
    end

    local UICtrl = self._uiManager:GetUICtrl(UIName)

    if _G.IsUValid(UICtrl) then
        Ctrl:InitCtrl(UICtrl)
    else
        Logger.warn("UIManager:OnUIInit => UICtrl is not valid UIName " .. UIName)
    end
end

function UIManager:OnUIDispose(UIName)
    local Ctrl = self.GetCtrl(UIName)

    if Ctrl == nil then
        return
    end

    Ctrl:Delete()
end

function UIManager:OnReset()
    _Ctrls = {}

    _G.Dispatcher:Remove(_G.Events.EVENT_UI_ON_INIT, self.OnUIInit_Delegate)

    self.OnUIInit_Delegate = nil

    _G.Dispatcher:Remove(_G.Events.EVENT_UI_ON_DISPOSE, self.OnUIDispose_Delegate)

    self.OnUIDispose_Delegate = nil
end

function UIManager.GetCtrl(UIName)
    if _G.IsStringNullOrEmpty(UIName) then
        Logger.warn("UIManager:GetCtrl --> UIName is nil")
        return nil
    end

    return _Ctrls[UIName]
end

function UIManager:Remove(UIName)
    if _G.IsStringNullOrEmpty(UIName) then
        Logger.warn("UIManager:RemoveUI => UIName is nil")
        return
    end

    if not _G.IsUValid(self._uiManager) then
        Logger.warn("UIManager:RemoveUI --> self._uiManager is nil")
        return
    end

    self._uiManager:RemoveUI(UIName)
end

function UIManager:Show(UIName)
    if _G.IsStringNullOrEmpty(UIName) then
        Logger.warn("UIManager:Show => UIName is nil")
        return
    end

    if not _G.IsUValid(self._uiManager) then
        Logger.warn("UIManager:ShowUI => self._uiManager is nil")
        return
    end

    self._uiManager:ShowUI(UIName)
end

function UIManager:IsShowUI(UIName)
    if _G.IsStringNullOrEmpty(UIName) then
        Logger.warn("UIManager:IsShowUI => UIName is nil")
        return
    end

    if not _G.IsUValid(self._uiManager) then
        Logger.warn("UIManager:IsShowUI => self._uiManager is nil")
        return
    end

    return self._uiManager:IsShowUI(UIName)
end
