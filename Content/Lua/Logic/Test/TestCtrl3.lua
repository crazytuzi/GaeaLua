local Test3Ctrl = _G.Class("TestCtrl", _G.SubCtrlBase)

local function OnInit()
    _G.Logger.log("Test3Ctrl => OnInit")
end

local function InitEvent(self)
    _G.Logger.log("Test3Ctrl => InitEvent")

    self:RegisterEvent(self.View.btn_close, _G.EWidgetEvent.Button.OnClicked, self.Hide, self)
end

local function OnStart()
    _G.Logger.log("Test3Ctrl => OnStart")
end

local function OnShow()
    _G.Logger.log("Test3Ctrl => OnShow")
end

local function OnHide()
    _G.Logger.log("Test3Ctrl => OnHide")
end

local function OnDispose()
    _G.Logger.log("Test3Ctrl => OnDispose")
end

Test3Ctrl.OnInit = OnInit
Test3Ctrl.OnStart = OnStart
Test3Ctrl.InitEvent = InitEvent
Test3Ctrl.OnShow = OnShow
Test3Ctrl.OnHide = OnHide
Test3Ctrl.OnDispose = OnDispose

return Test3Ctrl
