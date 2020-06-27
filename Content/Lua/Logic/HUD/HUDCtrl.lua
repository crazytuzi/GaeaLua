local HUDCtrl = _G.Class("HUDCtrl", _G.CtrlBase)

local function __init()
end

local function OnInit()
end

local function OnTestBtnClick()
    _G.UIManager:Show("Test")
end

local function InitEvent(self)
    self:RegisterEvent(self.View.btn_test, _G.EWidgetEvent.Button.OnClicked, OnTestBtnClick)
end

local function OnStart()
end

local function OnDispose()
end

HUDCtrl.__init = __init
HUDCtrl.OnInit = OnInit
HUDCtrl.InitEvent = InitEvent
HUDCtrl.OnStart = OnStart
HUDCtrl.OnDispose = OnDispose

return HUDCtrl.New()
