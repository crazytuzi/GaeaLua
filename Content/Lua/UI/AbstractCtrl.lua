local AbstractCtrl = _G.Class("AbstractCtrl")

local function __init(self)
    self.data = {}

    self._eventDelegates = {}
end

local function __delete(self)
    self:UnRegisterEvents()

    self:OnDispose()

    self.data = {}

    if self.View ~= nil then
        self.View:Delete()
    end

    self.bIsVisible = false
end

local function Init(self, Widget, ...)
    if not Widget then
        _G.Logger.warn("AbstractCtrl:InitCtrl => Widget is not valid")
        return
    end

    if _G.IsValid(Widget) and Widget:IsA(_G.UUserWidget) then
        self.View = _G.ViewBase.New(Widget)
    else
        self.View = Widget
    end

    if _G.IsStringNullOrEmpty(self.uiName) then
        self.uiName = _G.UKismetSystemLibrary.GetObjectName(self.View:GetRoot())
    end

    self:SetVisibility(true)

    self:OnInit(...)

    self:InitEvent()

    self:OnStart()
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
        _G.Logger.warn("AbstractCtrl:IsVisible => View uiRoot is not valid")
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
        EventDelegate = _G.EventHelper.Add(EventTarget, EventName, LuaFun, SelfTable, ...)
    end

    if EventDelegate == nil then
        return
    end

    local Info = {EventTarget = EventTarget, EventName = EventName, EventDelegate = EventDelegate}

    table.insert(self._eventDelegates, Info)
end

local function UnRegisterEvents(self)
    for _, Delegate in ipairs(self._eventDelegates) do
        if type(Delegate.EventTarget) == "table" then
            if Delegate.EventTarget == _G.Dispatcher then
                Delegate.EventTarget:Remove(Delegate.EventName, Delegate.EventDelegate)
            end
        else
            _G.EventHelper.Remove(Delegate.EventTarget, Delegate.EventName, Delegate.EventDelegate)
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
