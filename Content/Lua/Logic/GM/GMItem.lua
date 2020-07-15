local GMItem = _G.Class("GMItem", _G.PanelItemBase)

local function OnClick(self)
    if self.data._data.Ctrl then
        self.data._data.Ctrl:Updata(self.data._data.data)
    else
        xpcall(self.data._data[2], _G.CallBackError)
    end
end

local function InitEvent(self)
    self:RegisterEvent(self.View.btn_click, _G.EWidgetEvent.Button.OnClicked, OnClick, self)
end

local function OnSetData(self)
    if self.data._data.Ctrl then
        self.View.text:SetText(self.data._data.name)
    else
        self.View.text:SetText(self.data._data[1])
    end
end

GMItem.InitEvent = InitEvent
GMItem.OnSetData = OnSetData

return GMItem
