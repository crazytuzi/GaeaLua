local Class = require "Utils/Class"

local Ctrl = require "UI/Ctrl"

local GMCtrl = Class("GMCtrl", Ctrl)

local GMItem = require "Logic/GM/GMItem"

local Common = require "Logic/GM/GMConfig/GMConfigCommon"

local Test = require "Logic/GM/GMConfig/GMConfigTest"

local Stack = require "Common/Stack"

local Resources = require "Resource/Resources"

local PanelViewBase = require "UI/PanelViewBase"

local function Register(self, Name, Data)
    table.insert(self.data.configs, {Name, Data})
end

local function Update(self)
    self.View.btn_back:SetVisibility(
        (self.data.Stack:Num() > 1 and _G.ESlateVisibility.Visible) or _G.ESlateVisibility.Collapsed
    )

    local Top = self.data.Stack:Top()

    self.data.PanelView:SetData(Top)
end

local function Forward(self, Next)
    self.data.Stack:Push(Next)

    Update(self)
end

local function Backward(self)
    self.data.Stack:Pop()

    Update(self)
end

local function OnInit(self)
    self.data.Stack = Stack()

    self.data.configs = {}

    Common(self)

    Test(self)

    self.data.PanelView = PanelViewBase(self.View.vb, GMItem, Resources.UIGMItem, 15, {self})
end

local function InitEvent(self)
    self:RegisterEvent(self.View.btn_close, _G.EWidgetEvent.Button.OnClicked, self.Close, self)

    self:RegisterEvent(self.View.btn_back, _G.EWidgetEvent.Button.OnClicked, Backward, self)
end

local function OnStart(self)
    Forward(self, self.data.configs)
end

local function OnDispose(self)
    self.data.PanelView:Delete()
end

GMCtrl.Register = Register
GMCtrl.Forward = Forward
GMCtrl.Backward = Backward
GMCtrl.OnInit = OnInit
GMCtrl.InitEvent = InitEvent
GMCtrl.OnStart = OnStart
GMCtrl.OnDispose = OnDispose

return GMCtrl
