local Class = require "Utils/Class"

local SubCtrl = require "UI/SubCtrl"

local Logger = require "Logger/Logger"

local Test3Ctrl = Class("TestCtrl", SubCtrl)

local function OnInit()
    Logger.log("Test3Ctrl => OnInit")
end

local function InitEvent(self)
    Logger.log("Test3Ctrl => InitEvent")

    self:RegisterEvent(self.View.btn_close, _G.EWidgetEvent.Button.OnClicked, self.Hide, self)
end

local function OnStart()
    Logger.log("Test3Ctrl => OnStart")
end

local function OnShow()
    Logger.log("Test3Ctrl => OnShow")
end

local function OnHide()
    Logger.log("Test3Ctrl => OnHide")
end

local function OnDispose()
    Logger.log("Test3Ctrl => OnDispose")
end

Test3Ctrl.OnInit = OnInit
Test3Ctrl.OnStart = OnStart
Test3Ctrl.InitEvent = InitEvent
Test3Ctrl.OnShow = OnShow
Test3Ctrl.OnHide = OnHide
Test3Ctrl.OnDispose = OnDispose

return Test3Ctrl
