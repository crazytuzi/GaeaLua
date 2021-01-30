local SubCtrl = _G.Class("SubCtrl", _G.CtrlBase)

local function __init(self, Widget)
    self.Super:Init(Widget)

    self:SetVisibility(false)
end

local function __delete()
end

local function Show(self, ...)
    self:SetVisibility(true)

    self:OnShow(...)
end

local function Hide(self, ...)
    self:SetVisibility(false)

    self:OnHide(...)
end

local function OnShow()
end

local function OnHide()
end

SubCtrl.__init = __init
SubCtrl.__delete = __delete
SubCtrl.Show = Show
SubCtrl.Hide = Hide
SubCtrl.OnShow = OnShow
SubCtrl.OnHide = OnHide

return SubCtrl
