local Class = require "Utils/Class"

local CtrlRoot = require "UI/CtrlRoot"

local Logger = require "Logger/Logger"

local ManagerBase = require "Manager/ManagerBase"

local UIConfig = require "Config/UIConfig"

local Events = require "Event/EEvent"

local UIManager = Class("UIManager", ManagerBase)

local function __create(self)
    self._mode = _G.EManagerMode.Clent
end

local function GetCtrl(self, Config)
    return self.CtrlRoot:GetCtrl(Config.Name)
end

local function OnUIInit(self, UIName)
    local Ctrl = GetCtrl(self, UIConfig[UIName])

    local CtrlParam = self.CtrlRoot:GetParam(UIName)

    if Ctrl == nil then
        Logger.warn("UIManager:OnUIInit --> Ctrl is nil")
    end

    local UICtrl = self._uiManager:GetUICtrl(UIName)

    if _G.IsValid(UICtrl) then
        xpcall(Ctrl.Init, _G.CallBackError, Ctrl, UICtrl, CtrlParam)
    else
        Logger.warn("UIManager:OnUIInit => UICtrl is not valid UIName " .. UIName)
    end
end

local function OnUIDispose(self, UIName)
    local Ctrl = GetCtrl(self, UIConfig[UIName])

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
    self.CtrlRoot = CtrlRoot()

    self._uiManager =
        _G.UGaeaFunctionLibrary.GetGameInstanceSubsystem(_G.GetContextObject(), _G.import("GaeaUISubsystem"))

    if not _G.IsValid(self._uiManager) then
        Logger.warn("UIManager:OnStartUp => uiMgr is not valid")
        return
    end

    self.OnUIInit_Delegate = _G.Dispatcher:Add(Events.EVENT_UI_ON_INIT, OnUIInit, self)

    self.OnUIDispose_Delegate = _G.Dispatcher:Add(Events.EVENT_UI_ON_DISPOSE, OnUIDispose, self)

    self.OnPreLoadMap_Delegate = _G.Dispatcher:Add(Events.EVENT_PRE_LOAD_MAP, OnPreLoadMap, self)
end

local function OnShutDown(self)
    self.CtrlRoot:Delete()

    self.CtrlRoot = nil

    _G.Dispatcher:Remove(Events.EVENT_UI_ON_INIT, self.OnUIInit_Delegate)

    self.OnUIInit_Delegate = nil

    _G.Dispatcher:Remove(Events.EVENT_UI_ON_DISPOSE, self.OnUIDispose_Delegate)

    self.OnUIDispose_Delegate = nil

    _G.Dispatcher:Remove(Events.EVENT_PRE_LOAD_MAP, self.OnPreLoadMap_Delegate)

    self.OnPreLoadMap_Delegate = nil
end

local function Show(self, Config, ...)
    local Ctrl = GetCtrl(self, Config)

    if Ctrl == nil then
        Logger.warn("UIManager:Show => Ctrl is nil")
        return
    end

    self.CtrlRoot:SetParam(Config.Name, table.pack(...))

    if not _G.IsValid(self._uiManager) then
        Logger.warn("UIManager:Show => self._uiManager is nil")
        return
    end

    self._uiManager:ShowUI(Config.Name)
end

local function Hide(self, Config)
    local Ctrl = GetCtrl(self, Config)

    if Ctrl == nil then
        Logger.warn("UIManager:Hide => Ctrl is nil")
        return
    end

    if not _G.IsValid(self._uiManager) then
        Logger.warn("UIManager:Hide => self._uiManager is nil")
        return
    end

    self._uiManager:HideUI(Config.Name)
end

local function Remove(self, Config)
    if not _G.IsValid(self._uiManager) then
        Logger.warn("UIManager:Remove --> self._uiManager is nil")
        return
    end

    self._uiManager:RemoveUI(Config.Name)
end

local function IsShowUI(self, Config)
    if not _G.IsValid(self._uiManager) then
        Logger.warn("UIManager:IsShowUI => self._uiManager is nil")
        return
    end

    return self._uiManager:IsShowUI(Config.Name)
end

UIManager.__create = __create
UIManager.OnStartUp = OnStartUp
UIManager.OnShutDown = OnShutDown
UIManager.Show = Show
UIManager.Hide = Hide
UIManager.Remove = Remove
UIManager.IsShowUI = IsShowUI
UIManager.GetCtrl = GetCtrl

return UIManager
