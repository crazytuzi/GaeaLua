local Class = require "Utils/Class"

local AbstractCtrl = Class("AbstractCtrl")

local Logger = require "Logger/Logger"

local View = require "UI/View"

local EventHelper = require "Event/EventHelper"

local function __init(self)
    self.data = {}

    self._eventDelegates = {}
end

local function __delete(self)
    xpcall(self.UnRegisterEvents, _G.CallBackError, self)

    xpcall(self.OnDispose, _G.CallBackError, self)

    self.data = {}

    if self.View ~= nil then
        self.View:Delete()

        self.View = nil
    end

    self.bIsVisible = false
end

local function Init(self, Widget, ...)
    if not Widget then
        Logger.warn("AbstractCtrl:InitCtrl => Widget is not valid")
        return
    end

    if _G.IsValid(Widget) and Widget:IsA(_G.UUserWidget) then
        self.View = View(Widget)
    else
        self.View = Widget
    end

    if _G.IsStringNullOrEmpty(self.uiName) then
        self.uiName = _G.UKismetSystemLibrary.GetObjectName(self.View:GetRoot())
    end

    self:SetVisibility(true)

    xpcall(self.OnInit, _G.CallBackError, self, ...)

    xpcall(self.InitEvent, _G.CallBackError, self)

    xpcall(self.OnStart, _G.CallBackError, self)
end

local function OnInit()
    -- You can override this function
end

-- Called multiple times, when ui being init
local function InitEvent()
    -- You can override this function
end

local function OnStart()
    -- You can override this function
end

local function IsVisible(self)
    if not self.bIsVisible then
        return false
    end

    if self.View == nil or not self.View:IsValid() then
        Logger.warn("AbstractCtrl:IsVisible => View uiRoot is not valid")
        return false
    end

    return true
end

local function GetRoot(self)
    return self.View:GetRoot()
end

local function SetVisibility(self, bIsVisible)
    self.bIsVisible = bIsVisible or false

    bIsVisible = (self.bIsVisible and _G.ESlateVisibility.SelfHitTestInvisible) or _G.ESlateVisibility.Collapsed

    self.View:SetVisibility(bIsVisible)
end

local function OnDispose()
    -- You can override this function
end

local function RegisterEvent(self, EventTarget, EventName, LuaFun, SelfTable, ...)
    local EventDelegate

    if type(EventTarget) == "table" then
        if EventTarget == _G.Dispatcher then
            EventDelegate = EventTarget:Add(EventName, LuaFun, SelfTable)
        end
    else
        EventDelegate = EventHelper.Add(EventTarget, EventName, LuaFun, SelfTable, ...)
    end

    if EventDelegate == nil then
        return
    end

    local Info = {EventTarget = EventTarget, EventName = EventName, EventDelegate = EventDelegate}

    setmetatable(Info, {__mode = "v"})

    table.insert(self._eventDelegates, Info)
end

local function UnRegisterEvents(self)
    for _, Delegate in ipairs(self._eventDelegates) do
        if Delegate.EventTarget then
            if type(Delegate.EventTarget) == "table" then
                if Delegate.EventTarget == _G.Dispatcher then
                    Delegate.EventTarget:Remove(Delegate.EventName, Delegate.EventDelegate)
                end
            else
                EventHelper.Remove(Delegate.EventTarget, Delegate.EventName, Delegate.EventDelegate)
            end
        end
    end

    self._eventDelegates = {}
end

AbstractCtrl.__init = __init
AbstractCtrl.__delete = __delete
AbstractCtrl.Init = Init
AbstractCtrl.OnInit = OnInit
AbstractCtrl.InitEvent = InitEvent
AbstractCtrl.OnStart = OnStart
AbstractCtrl.IsVisible = IsVisible
AbstractCtrl.GetRoot = GetRoot
AbstractCtrl.SetVisibility = SetVisibility
AbstractCtrl.OnDispose = OnDispose
AbstractCtrl.RegisterEvent = RegisterEvent
AbstractCtrl.UnRegisterEvents = UnRegisterEvents

return AbstractCtrl
