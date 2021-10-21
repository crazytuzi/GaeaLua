local Class = require "Utils/Class"

local SubCtrl = require "UI/SubCtrl"

local Logger = require "Logger/Logger"

local Test1Ctrl = Class("TestCtrl", SubCtrl)

local function OnInit()
    Logger.log("Test1Ctrl => OnInit")
end

local function InitEvent(self)
    Logger.log("Test1Ctrl => InitEvent")

    self:RegisterEvent(self.View.btn_close, _G.EWidgetEvent.Button.OnClicked, self.Hide, self)
end

local function OnStart()
    Logger.log("Test1Ctrl => OnStart")
end

local function OnShow()
    Logger.log("Test1Ctrl => OnShow")
end

local function OnHide()
    Logger.log("Test1Ctrl => OnHide")
end

local function OnDispose()
    Logger.log("Test1Ctrl => OnDispose")
end

Test1Ctrl.OnInit = OnInit
Test1Ctrl.OnStart = OnStart
Test1Ctrl.InitEvent = InitEvent
Test1Ctrl.OnShow = OnShow
Test1Ctrl.OnHide = OnHide
Test1Ctrl.OnDispose = OnDispose

return Test1Ctrl
