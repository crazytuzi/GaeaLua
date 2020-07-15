local TestPanelItem = _G.Class("TestPanelItem", _G.PanelItemBase)

local function OnClick(self)
    _G.Logger.dump(self.data)
end

local function InitEvent(self)
    self:RegisterEvent(self.View.btn_click, _G.EWidgetEvent.Button.OnClicked, OnClick, self)
end

local function OnSetData(self)
    self.View.text:SetText(self.data._data.Text)

    local Image = _G.GetResource(self.data._data.Image)

    self.View.img:SetBrushFromTexture(Image, false)
end

local function OnDispose(self)
    _G.Logger.log("TestPanelItem.OnDispose =>" .. self.data._data.Text)
end

TestPanelItem.InitEvent = InitEvent
TestPanelItem.OnSetData = OnSetData
TestPanelItem.OnDispose = OnDispose

return TestPanelItem
