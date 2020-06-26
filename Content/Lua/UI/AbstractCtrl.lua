local AbstractCtrl = _G.Class("AbstractCtrl")

local function __delete(self)
    self:UnRegisterEvents()

    self:OnDispose()

    if self.View ~= nil then
        self.View:Delete()
    end

    self.bIsOpening = false
end

local function Init(self, Widget)
    if not _G.IsUValid(Widget) then
        _G._Logger.warn("AbstractCtrl:InitCtrl => Widget is not valid")
        return
    end

    self._eventDelegates = {}

    self.View = _G.ViewBase.New(Widget)

    self.View:Init()

    self.bIsOpening = true

    self:OnInit()

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

local function IsOpening(self)
    if not self.bIsOpening then
        return false
    end

    if self.View == nil or not self.View:IsValid() then
        _G._Logger.warn("AbstractCtrl:IsOpening => View uiRoot is not valid")
        return false
    end

    return true
end

local function OnDispose()
    -- You can override this function
end

local function RegisterEvent(self, EventTarget, EventName, LuaFun, SelfTable, ...)
    local EventDelegate

    if type(EventTarget) == "table" then
        if EventTarget.super == _G.LuaDispatcher then
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
            if Delegate.EventTarget.super == _G.LuaDispatcher then
                Delegate.EventTarget:Remove(Delegate.EventName, Delegate.EventDelegate)
            end
        else
            _G.EventHelper.Remove(Delegate.EventTarget, Delegate.EventName, Delegate.EventDelegate)
        end
    end

    self._eventDelegates = {}
end

AbstractCtrl.__delete = __delete
AbstractCtrl.Init = Init
AbstractCtrl.OnInit = OnInit
AbstractCtrl.InitEvent = InitEvent
AbstractCtrl.OnStart = OnStart
AbstractCtrl.IsOpening = IsOpening
AbstractCtrl.OnDispose = OnDispose
AbstractCtrl.RegisterEvent = RegisterEvent
AbstractCtrl.UnRegisterEvents = UnRegisterEvents

return AbstractCtrl
