AbstractCtrl = _G.Class("AbstractCtrl")

function AbstractCtrl:__delete()
    self:UnRegisterEvents()

    self:OnDispose()

    if self.View ~= nil then
        self.View:Delete()
    end

    self.bIsOpening = false
end

function AbstractCtrl:Init(Widget)
    if not _G.IsUValid(Widget) then
        Logger.warn("AbstractCtrl:InitCtrl => Widget is not valid")
        return
    end

    self._eventDelegates = {}

    self.View = ViewBase.New(Widget)

    self.View:Init()

    self.bIsOpening = true

    self:OnInit()

    self:InitEvent()

    self:OnStart()
end

function AbstractCtrl:OnInit()
    -- You can override this function
end

-- Called multiple times, when ui being init
function AbstractCtrl:InitEvent()
    -- You can override this function
end

function AbstractCtrl:OnStart()
    -- You can override this function
end

function AbstractCtrl:IsOpening()
    if not self.bIsOpening then
        return false
    end

    if self.View == nil or not self.View:IsValid() then
        Logger.warn("AbstractCtrl:IsOpening => View uiRoot is not valid")
        return false
    end

    return true
end

function AbstractCtrl:OnDispose()
    -- You can override this function
end

function AbstractCtrl:RegisterEvent(EventTarget, EventName, LuaFun, SelfTable, ...)
    local EventDelegate

    if type(EventTarget) == "table" then
        if EventTarget.super == _G.LuaDispatcher then
            EventDelegate = EventTarget:Add(EventName, LuaFun, SelfTable)
        end
    else
        EventDelegate = EventHelper.Add(EventTarget, EventName, LuaFun, SelfTable, ...)
    end

    if EventDelegate == nil then
        return
    end

    local Info = {EventTarget = EventTarget, EventName = EventName, EventDelegate = EventDelegate}

    table.insert(self._eventDelegates, Info)
end

function AbstractCtrl:UnRegisterEvents()
    for _, Delegate in ipairs(self._eventDelegates) do
        if type(Delegate.EventTarget) == "table" then
            if Delegate.EventTarget.super == _G.LuaDispatcher then
                Delegate.EventTarget:Remove(Delegate.EventName, Delegate.EventDelegate)
            end
        else
            EventHelper.Remove(Delegate.EventTarget, Delegate.EventName, Delegate.EventDelegate)
        end
    end

    self._eventDelegates = {}
end
