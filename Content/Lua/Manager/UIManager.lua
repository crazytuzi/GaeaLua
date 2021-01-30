local UIManager = _G.Class("UIManager", _G.ManagerBase)

local function GetCtrl(self, UIConfig)
    return self.CtrlRoot:GetCtrl(UIConfig.Name)
end

local function OnUIInit(self, UIName)
    local Ctrl = GetCtrl(self, _G.Config.UIConfig[UIName])

    local CtrlParam = self.CtrlRoot:GetParam(UIName)

    if Ctrl == nil then
        _G.Logger.warn("UIManager:OnUIInit --> Ctrl is nil")
    end

    local UICtrl = self._uiManager:GetUICtrl(UIName)

    if _G.IsValid(UICtrl) then
        Ctrl:Init(UICtrl, CtrlParam)
    else
        _G.Logger.warn("UIManager:OnUIInit => UICtrl is not valid UIName " .. UIName)
    end
end

local function OnUIDispose(self, UIName)
    local Ctrl = GetCtrl(self, _G.Config.UIConfig[UIName])

    if Ctrl == nil then
        return
    end

    Ctrl:Delete()

    self.CtrlRoot:SetParam(UIName)
end

local function OnPreLoadMap(self)
    self.CtrlRoot:Delete()
end

local function OnStartUp(self)
    self.CtrlRoot = _G.CtrlRoot.New()

    self._uiManager =
        _G.UGaeaFunctionLibrary.GetGameInstanceSubsystem(_G.GetContextObject(), _G.import("GaeaUISubsystem"))

    if not _G.IsValid(self._uiManager) then
        _G.Logger.warn("UIManager:OnStartUp => uiMgr is not valid")
        return
    end

    self.OnUIInit_Delegate = _G.Dispatcher:Add(_G.Events.EVENT_UI_ON_INIT, OnUIInit, self)

    self.OnUIDispose_Delegate = _G.Dispatcher:Add(_G.Events.EVENT_UI_ON_DISPOSE, OnUIDispose, self)

    self.OnPreLoadMap_Delegate = _G.Dispatcher:Add(_G.Events.EVENT_PRE_LOAD_MAP, OnPreLoadMap, self)
end

local function OnShutDown(self)
    self.CtrlRoot:Delete()

    self.CtrlRoot = nil

    _G.Dispatcher:Remove(_G.Events.EVENT_UI_ON_INIT, self.OnUIInit_Delegate)

    self.OnUIInit_Delegate = nil

    _G.Dispatcher:Remove(_G.Events.EVENT_UI_ON_DISPOSE, self.OnUIDispose_Delegate)

    self.OnUIDispose_Delegate = nil

    _G.Dispatcher:Remove(_G.Events.EVENT_PRE_LOAD_MAP, self.OnPreLoadMap_Delegate)

    self.OnPreLoadMap_Delegate = nil
end

local function Show(self, UIConfig, ...)
    local Ctrl = GetCtrl(self, UIConfig)

    if Ctrl == nil then
        _G.Logger.warn("UIManager:Show => Ctrl is nil")
        return
    end

    self.CtrlRoot:SetParam(UIConfig.Name, table.pack(...))

    if not _G.IsValid(self._uiManager) then
        _G.Logger.warn("UIManager:ShowUI => self._uiManager is nil")
        return
    end

    self._uiManager:ShowUI(UIConfig.Name)
end

local function Remove(self, UIConfig)
    if not _G.IsValid(self._uiManager) then
        _G.Logger.warn("UIManager:RemoveUI --> self._uiManager is nil")
        return
    end

    self._uiManager:RemoveUI(UIConfig.Name)
end

local function IsShowUI(self, UIConfig)
    if not _G.IsValid(self._uiManager) then
        _G.Logger.warn("UIManager:IsShowUI => self._uiManager is nil")
        return
    end

    return self._uiManager:IsShowUI(UIConfig.Name)
end

UIManager.OnStartUp = OnStartUp
UIManager.OnShutDown = OnShutDown
UIManager.Show = Show
UIManager.Remove = Remove
UIManager.IsShowUI = IsShowUI
UIManager.GetCtrl = GetCtrl

return UIManager:GetInstance(UIManager)
