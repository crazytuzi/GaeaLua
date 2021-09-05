local SubCtrl = _G.Class("SubCtrl", _G.CtrlBase)

local function __init(self, _, uiName)
    self.uiName = uiName
end

local function __create(self, Widget)
    self.Super:Init(Widget)

    self:SetVisibility(false)
end

local function __delete(self)
end

local function Show(self, Params)
    self:SetVisibility(true)

    self.Super:Show(Params)
end

local function Hide(self, Params)
    self:SetVisibility(false)

    self.Super:Hide(Params)
end

local function OnShow(self)
end

local function OnHide(self)
end

SubCtrl.__init = __init
SubCtrl.__create = __create
SubCtrl.__delete = __delete
SubCtrl.Show = Show
SubCtrl.Hide = Hide
SubCtrl.OnShow = OnShow
SubCtrl.OnHide = OnHide

return SubCtrl
