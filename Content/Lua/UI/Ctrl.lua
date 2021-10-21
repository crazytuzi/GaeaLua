local Class = require "Utils/Class"

local CtrlBase = require "UI/CtrlBase"

local Logger = require "Logger/Logger"

local UIConfig = require "Config/UIConfig"

local Ctrl = Class("Ctrl", CtrlBase)

local function __init(self, UIName)
    self.uiName = UIName
end

local function __delete()
end

local function Init(self, UICtrl, ...)
    if not _G.IsValid(UICtrl) then
        Logger.warn("Ctrl:InitCtrl => UICtrl is nil")
        return
    end

    self.bIsDeleted = false

    local Widget = UICtrl:GetWidget()

    self.Super:Init(Widget, ...)
end

local function Close(self)
    if not _G.IsStringNullOrEmpty(self.uiName) then
        _G.UIManager:Get():Remove(UIConfig[self.uiName])
    end
end

Ctrl.__init = __init
Ctrl.__delete = __delete
Ctrl.Init = Init
Ctrl.Close = Close

return Ctrl
