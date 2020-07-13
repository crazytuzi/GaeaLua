local TestCtrl = _G.Class("TestCtrl", _G.CtrlBase)

local TestCtrl1 = require "Logic/Test/TestCtrl1"

local TestCtrl2 = require "Logic/Test/TestCtrl2"

local TestCtrl3 = require "Logic/Test/TestCtrl3"

local function OnInit(self)
    self:RegisterSubCtrl(self.View.UITest1, TestCtrl1)

    self:RegisterSubCtrl(self.View.UITest2, TestCtrl2)

    self:RegisterSubCtrl(self.View.UITest3, TestCtrl3)
end

local function SendEvent()
    _G.Dispatcher:Dispatch(_G.Events.EVENT_UI_TEST_EVENT, {_G.EEventParamType.EEventParamType_int32, 250})
end

local function OnSubCtrlClick(self, SubCtrl)
    self:Show(SubCtrl[1])
end

local function ReceiveEvent(Param)
    _G.Logger.log("TestCtrl:ReceiveEvent => Param:" .. Param)
end

local function InitEvent(self)
    self:RegisterEvent(self.View.btn_close, _G.EWidgetEvent.Button.OnClicked, self.Close, self)

    self:RegisterEvent(self.View.btn_event, _G.EWidgetEvent.Button.OnClicked, SendEvent)

    self:RegisterEvent(self.View.btn_subctrl1, _G.EWidgetEvent.Button.OnClicked, OnSubCtrlClick, self, {TestCtrl1})

    self:RegisterEvent(self.View.btn_subctrl2, _G.EWidgetEvent.Button.OnClicked, OnSubCtrlClick, self, {TestCtrl2})

    self:RegisterEvent(self.View.btn_subctrl3, _G.EWidgetEvent.Button.OnClicked, OnSubCtrlClick, self, {TestCtrl3})

    self:RegisterEvent(_G.Dispatcher, _G.Events.EVENT_UI_TEST_EVENT, ReceiveEvent)
end

local function OnStart(self)
    self:Show(TestCtrl1)
end

local function OnDispose()
end

TestCtrl.OnInit = OnInit
TestCtrl.InitEvent = InitEvent
TestCtrl.OnStart = OnStart
TestCtrl.OnDispose = OnDispose

return TestCtrl.New()
