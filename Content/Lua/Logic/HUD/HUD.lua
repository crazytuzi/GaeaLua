local HUD = _G.Class("HUD", _G.CtrlBase)

local function __init()
end

local function OnInit()
end

local function SendEvent()
    _G.Dispatcher:Dispatch(_G.Events.EVENT_UI_TEST_EVENT, {_G.EEventParamType.EEventParamType_int32, 250})
end

local function ReceiveEvent(Param)
    _G.Logger.log("HUD:ReceiveEvent => Param:" .. Param)
end

local function InitEvent(self)
    self:RegisterEvent(self.View.btn_remove, _G.EWidgetEvent.Button.OnClicked, self.Remove, self)

    self:RegisterEvent(self.View.btn_event, _G.EWidgetEvent.Button.OnClicked, SendEvent)

    self:RegisterEvent(_G.Dispatcher, _G.Events.EVENT_UI_TEST_EVENT, ReceiveEvent)
end

local function OnStart()
end

local function OnDispose()
end

HUD.__init = __init
HUD.OnInit = OnInit
HUD.InitEvent = InitEvent
HUD.OnStart = OnStart
HUD.OnDispose = OnDispose

return HUD.New()
