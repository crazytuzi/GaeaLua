local Test2Ctrl = _G.Class("TestCtrl", _G.SubCtrlBase)

local function OnInit()
    _G.Logger.log("Test2Ctrl => OnInit")
end

local function InitEvent(self)
    _G.Logger.log("Test2Ctrl => InitEvent")

    self:RegisterEvent(self.View.btn_close, _G.EWidgetEvent.Button.OnClicked, self.Hide, self)
end

local function OnStart()
    _G.Logger.log("Test2Ctrl => OnStart")
end

local function OnShow()
    _G.Logger.log("Test2Ctrl => OnShow")
end

local function OnHide()
    _G.Logger.log("Test2Ctrl => OnHide")
end

local function OnDispose()
    _G.Logger.log("Test2Ctrl => OnDispose")
end

Test2Ctrl.OnInit = OnInit
Test2Ctrl.OnStart = OnStart
Test2Ctrl.InitEvent = InitEvent
Test2Ctrl.OnShow = OnShow
Test2Ctrl.OnHide = OnHide
Test2Ctrl.OnDispose = OnDispose

return Test2Ctrl
