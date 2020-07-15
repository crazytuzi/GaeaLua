local GMCtrl = _G.Class("GMCtrl", _G.CtrlBase)

local GMItem = require "Logic/GM/GMItem"

local Common = require "Logic/GM/GMConfig/GMConfigCommon"

local Test = require "Logic/GM/GMConfig/GMConfigTest"

local function Register(self, Name, Data)
    table.insert(self.data.configs, {name = Name, data = Data, Ctrl = self})
end

local function Updata(self, config)
    self.View.btn_back:SetVisibility((config and _G.ESlateVisibility.Visible) or _G.ESlateVisibility.Collapsed)

    config = config or self.data.configs

    self.data.PanelView:SetData(config)
end

local function OnBackClick(self)
    self:Updata()
end

local function OnInit(self)
    self.data.configs = {}

    Common.New(self)

    Test.New(self)

    self.data.PanelView = _G.PanelViewBase.New(self.View.vb, GMItem, _G.Resources.UIGMItem, 15)
end

local function InitEvent(self)
    self:RegisterEvent(self.View.btn_close, _G.EWidgetEvent.Button.OnClicked, self.Close, self)

    self:RegisterEvent(self.View.btn_back, _G.EWidgetEvent.Button.OnClicked, OnBackClick, self)
end

local function OnStart(self)
    self:Updata()
end

local function OnDispose(self)
    self.data.PanelView:Delete()
end

GMCtrl.Register = Register
GMCtrl.Updata = Updata
GMCtrl.OnInit = OnInit
GMCtrl.InitEvent = InitEvent
GMCtrl.OnStart = OnStart
GMCtrl.OnDispose = OnDispose

return GMCtrl.New()
