local Class = require "Utils/Class"

local SubCtrl = require "UI/SubCtrl"

local Logger = require "Logger/Logger"

local Test2Ctrl = Class("TestCtrl", SubCtrl)

local function OnInit()
    Logger.log("Test2Ctrl => OnInit")
end

local function InitEvent(self)
    Logger.log("Test2Ctrl => InitEvent")

    self:RegisterEvent(self.View.btn_close, _G.EWidgetEvent.Button.OnClicked, self.Hide, self)
end

local function OnStart()
    Logger.log("Test2Ctrl => OnStart")
end

local function OnShow()
    Logger.log("Test2Ctrl => OnShow")
end

local function OnHide()
    Logger.log("Test2Ctrl => OnHide")
end

local function OnDispose()
    Logger.log("Test2Ctrl => OnDispose")
end

Test2Ctrl.OnInit = OnInit
Test2Ctrl.OnStart = OnStart
Test2Ctrl.InitEvent = InitEvent
Test2Ctrl.OnShow = OnShow
Test2Ctrl.OnHide = OnHide
Test2Ctrl.OnDispose = OnDispose

return Test2Ctrl
