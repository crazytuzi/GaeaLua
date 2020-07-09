local Test1Ctrl = _G.Class("TestCtrl", _G.SubCtrlBase)

local function __init()
end

local function OnInit()
    _G.Logger.log("Test1Ctrl => OnInit")
end

local function InitEvent(self)
    _G.Logger.log("Test1Ctrl => InitEvent")

    self:RegisterEvent(self.View.btn_close, _G.EWidgetEvent.Button.OnClicked, self.Hide, self)
end

local function OnStart()
    _G.Logger.log("Test1Ctrl => OnStart")
end

local function OnShow()
    _G.Logger.log("Test1Ctrl => OnShow")
end

local function OnHide()
    _G.Logger.log("Test1Ctrl => OnHide")
end

local function OnDispose()
    _G.Logger.log("Test1Ctrl => OnDispose")
end

Test1Ctrl.__init = __init
Test1Ctrl.OnInit = OnInit
Test1Ctrl.OnStart = OnStart
Test1Ctrl.InitEvent = InitEvent
Test1Ctrl.OnShow = OnShow
Test1Ctrl.OnHide = OnHide
Test1Ctrl.OnDispose = OnDispose

return Test1Ctrl
