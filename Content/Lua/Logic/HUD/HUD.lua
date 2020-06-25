HUD = _G.Class("HUD", CtrlBase)

function HUD:__init()
end

function HUD:OnInit()
end

function HUD:InitEvent()
    self:RegisterEvent(self.View.btn_remove, _G.EWidgetEvent.Button.OnClicked, self.Remove, self)

    self:RegisterEvent(self.View.btn_event, _G.EWidgetEvent.Button.OnClicked, self.SendEvent, self)

    self:RegisterEvent(_G.Dispatcher, _G.Events.EVENT_UI_TEST_EVENT, self.ReceiveEvent, self)
end

function HUD:OnStart()
end

function HUD:OnDispose()
end

function HUD:SendEvent()
    _G.Dispatcher:Dispatch(_G.Events.EVENT_UI_TEST_EVENT, {_G.EEventParamType.EEventParamType_int32, 250})
end

function HUD:ReceiveEvent(Param)
    Logger.log("HUD:ReceiveEvent => Param:" .. Param)
end

return HUD.New()
