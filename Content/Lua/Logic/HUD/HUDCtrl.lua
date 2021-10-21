local Class = require "Utils/Class"

local Ctrl = require "UI/Ctrl"

local UIConfig = require "Config/UIConfig"

local HUDCtrl = Class("HUDCtrl", Ctrl)

local function OnInit()
end

local function OnTestBtnClick()
    _G.UIManager:Get():Show(UIConfig.Test)
end

local function InitEvent(self)
    self:RegisterEvent(self.View.btn_test, _G.EWidgetEvent.Button.OnClicked, OnTestBtnClick)
end

local function OnStart()
end

local function OnDispose()
end

HUDCtrl.OnInit = OnInit
HUDCtrl.InitEvent = InitEvent
HUDCtrl.OnStart = OnStart
HUDCtrl.OnDispose = OnDispose

return HUDCtrl
