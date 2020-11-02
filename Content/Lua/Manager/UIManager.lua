local UIManager = _G.Class("UIManager", _G.ManagerBase)

local _Ctrls = {}

local function GetCtrl(UIName)
    if _G.IsStringNullOrEmpty(UIName) then
        _G.Logger.warn("UIManager:GetCtrl --> UIName is nil")
        return nil
    end

    local Ctrl = _Ctrls[UIName]

    if Ctrl == nil or Ctrl.Ctrl == nil then
        _G.Logger.warn("UIManager:GetCtrl --> Ctrl is nil")
        return nil
    end

    return Ctrl.Ctrl
end

local function Register(Ctrl)
    if Ctrl == nil then
        _G.Logger.warn("Register => ctrl is nil")
        return
    end

    if _G.IsStringNullOrEmpty(Ctrl.uiName) then
        _G.Logger.warn("Register => uiName is nil")
        return
    end

    _Ctrls[Ctrl.uiName] = {Ctrl = Ctrl, Param = nil}
end

local function OnUIInit(self, UIName)
    local Ctrl = _Ctrls[UIName]

    if Ctrl == nil or Ctrl.Ctrl == nil then
        return
    end

    local UICtrl = self._uiManager:GetUICtrl(UIName)

    if _G.IsValid(UICtrl) then
        Ctrl.Ctrl:Init(UICtrl, table.unpack(Ctrl.Param))
    else
        _G.Logger.warn("UIManager:OnUIInit => UICtrl is not valid UIName " .. UIName)
    end
end

local function OnUIDispose(UIName)
    local Ctrl = _Ctrls[UIName]

    if Ctrl == nil or Ctrl.Ctrl == nil then
        return
    end

    Ctrl.Param = nil

    Ctrl.Ctrl:Delete()
end

local function OnStartUp(self)
    self._uiManager =
        _G.UGaeaFunctionLibrary.GetGameInstanceSubsystem(_G.GetContextObject(), _G.import("GaeaUISubsystem"))

    if not _G.IsValid(self._uiManager) then
        _G.Logger.warn("UIManager:OnStartUp => uiMgr is not valid")
        return
    end

    self.OnUIInit_Delegate = _G.Dispatcher:Add(_G.Events.EVENT_UI_ON_INIT, OnUIInit, self)

    self.OnUIDispose_Delegate = _G.Dispatcher:Add(_G.Events.EVENT_UI_ON_DISPOSE, OnUIDispose)
end

local function OnShutDown(self)
    _Ctrls = {}

    _G.Dispatcher:Remove(_G.Events.EVENT_UI_ON_INIT, self.OnUIInit_Delegate)

    self.OnUIInit_Delegate = nil

    _G.Dispatcher:Remove(_G.Events.EVENT_UI_ON_DISPOSE, self.OnUIDispose_Delegate)

    self.OnUIDispose_Delegate = nil
end

local function Show(self, UIName, ...)
    if _G.IsStringNullOrEmpty(UIName) then
        _G.Logger.warn("UIManager:Show => UIName is nil")
        return
    end

    local Ctrl = _Ctrls[UIName]

    if Ctrl == nil or Ctrl.Ctrl == nil then
        _G.Logger.warn("UIManager:Show => Ctrl is nil")
        return
    end

    Ctrl.Param = table.pack(...)

    if not _G.IsValid(self._uiManager) then
        _G.Logger.warn("UIManager:ShowUI => self._uiManager is nil")
        return
    end

    self._uiManager:ShowUI(UIName)
end

local function Remove(self, UIName)
    if _G.IsStringNullOrEmpty(UIName) then
        _G.Logger.warn("UIManager:RemoveUI => UIName is nil")
        return
    end

    if not _G.IsValid(self._uiManager) then
        _G.Logger.warn("UIManager:RemoveUI --> self._uiManager is nil")
        return
    end

    self._uiManager:RemoveUI(UIName)
end

local function IsShowUI(self, UIName)
    if _G.IsStringNullOrEmpty(UIName) then
        _G.Logger.warn("UIManager:IsShowUI => UIName is nil")
        return
    end

    if not _G.IsValid(self._uiManager) then
        _G.Logger.warn("UIManager:IsShowUI => self._uiManager is nil")
        return
    end

    return self._uiManager:IsShowUI(UIName)
end

UIManager.Register = Register
UIManager.OnStartUp = OnStartUp
UIManager.OnShutDown = OnShutDown
UIManager.Show = Show
UIManager.Remove = Remove
UIManager.IsShowUI = IsShowUI
UIManager.GetCtrl = GetCtrl

return UIManager:GetInstance(UIManager)
