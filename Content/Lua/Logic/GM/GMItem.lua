local GMItem = _G.Class("GMItem", _G.PanelItemBase)

local function __init(self, Ctrl)
    self.data.Ctrl = Ctrl
end

local function OnClick(self)
    if _G.IsCallable(self.data._data[2]) then
        xpcall(self.data._data[2], _G.CallBackError)
    else
        self.data.Ctrl:Forward(self.data._data[2])
    end
end

local function InitEvent(self)
    self:RegisterEvent(self.View.btn_click, _G.EWidgetEvent.Button.OnClicked, OnClick, self)
end

local function OnSetData(self)
    self.View.text:SetText(self.data._data[1])
end

GMItem.__init = __init
GMItem.InitEvent = InitEvent
GMItem.OnSetData = OnSetData

return GMItem
