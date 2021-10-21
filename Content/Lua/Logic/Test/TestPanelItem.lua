local Class = require "Utils/Class"

local PanelItemBase = require "UI/PanelItemBase"

local Logger = require "Logger/Logger"

local TestPanelItem = Class("TestPanelItem", PanelItemBase)

local Resources = require "Resource/Resources"

local function OnClick(self)
    Logger.dump(self.data)
end

local function InitEvent(self)
    self:RegisterEvent(self.View.btn_click, _G.EWidgetEvent.Button.OnClicked, OnClick, self)
end

local function OnSetData(self)
    self.View.text:SetText(self.data._data.Text)

    local Image = Resources.GetResource(self.data._data.Image)

    self.View.img:SetBrushFromTexture(Image, false)
end

local function OnDispose(self)
end

TestPanelItem.InitEvent = InitEvent
TestPanelItem.OnSetData = OnSetData
TestPanelItem.OnDispose = OnDispose

return TestPanelItem
