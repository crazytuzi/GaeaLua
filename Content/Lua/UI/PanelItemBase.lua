local PanelItemBase = _G.Class("PanelItemBase", _G.AbstractCtrl, _G.PoolItem)

local function SetItemData(self, Data)
    self.data._data = Data

    self:OnSetData()
end

local function OnSetData()
end

local function Empty(self)
    self.data._data = nil

    if self.View then
        self.View:RemoveFromParent()
    end
end

local function IsValid(self)
    return self.View and self.View:IsValid()
end

local function __delete(self)
    if self:IsValid() then
        self.View:RemoveFromParent()
    end
end

PanelItemBase.SetData = SetItemData
PanelItemBase.OnSetData = OnSetData
PanelItemBase.Empty = Empty
PanelItemBase.IsValid = IsValid
PanelItemBase.__delete = __delete

return PanelItemBase
