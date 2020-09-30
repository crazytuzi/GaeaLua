local SubCtrlBase = _G.Class("SubCtrlBase", _G.AbstractCtrl)

local function __init(self, Widget)
    self.Super:Init(Widget)

    self:SetVisibility(false)
end

local function __delete()
end

local function Show(self)
    self:SetVisibility(true)

    self:OnShow()
end

local function Hide(self)
    self:SetVisibility(false)

    self:OnHide()
end

local function OnShow()
end

local function OnHide()
end

SubCtrlBase.__init = __init
SubCtrlBase.__delete = __delete
SubCtrlBase.Show = Show
SubCtrlBase.Hide = Hide
SubCtrlBase.OnShow = OnShow
SubCtrlBase.OnHide = OnHide

return SubCtrlBase
