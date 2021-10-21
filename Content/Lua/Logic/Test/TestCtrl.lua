local Class = require "Utils/Class"

local Ctrl = require "UI/Ctrl"

local TestCtrl = Class("TestCtrl", Ctrl)

local TestCtrl1 = require "Logic/Test/TestCtrl1"

local TestCtrl2 = require "Logic/Test/TestCtrl2"

local TestCtrl3 = require "Logic/Test/TestCtrl3"

local TestPanelItem = require "Logic/Test/TestPanelItem"

local Logger = require "Logger/Logger"

local Resources = require "Resource/Resources"

local Events = require "Event/EEvent"

local PanelViewBase = require "UI/PanelViewBase"

local function OnInit(self)
    self:RegisterCtrl(self.View.UITest1, TestCtrl1)

    self:RegisterCtrl(self.View.UITest2, TestCtrl2)

    self:RegisterCtrl(self.View.UITest3, TestCtrl3)
end

local function SendEvent()
    _G.Dispatcher:Dispatch(Events.EVENT_UI_TEST_EVENT, {_G.EEventParamType.EEventParamType_int32, 250})
end

local function OnSubCtrlClick(self, SubCtrl)
    self:ShowCtrl(SubCtrl[1])
end

local function ReceiveEvent(Param)
    Logger.log("TestCtrl:ReceiveEvent => Param:" .. Param)
end

local function InitEvent(self)
    self:RegisterEvent(self.View.btn_close, _G.EWidgetEvent.Button.OnClicked, self.Close, self)

    self:RegisterEvent(self.View.btn_event, _G.EWidgetEvent.Button.OnClicked, SendEvent)

    self:RegisterEvent(self.View.btn_subctrl1, _G.EWidgetEvent.Button.OnClicked, OnSubCtrlClick, self, {TestCtrl1})

    self:RegisterEvent(self.View.btn_subctrl2, _G.EWidgetEvent.Button.OnClicked, OnSubCtrlClick, self, {TestCtrl2})

    self:RegisterEvent(self.View.btn_subctrl3, _G.EWidgetEvent.Button.OnClicked, OnSubCtrlClick, self, {TestCtrl3})

    self:RegisterEvent(_G.Dispatcher, Events.EVENT_UI_TEST_EVENT, ReceiveEvent)
end

local function OnStart(self)
    self.View.btn_subctrl1:SetVisibility(_G.ESlateVisibility.Collapsed)

    self.View.btn_subctrl2:SetVisibility(_G.ESlateVisibility.Collapsed)

    self.View.btn_subctrl3:SetVisibility(_G.ESlateVisibility.Collapsed)

    self.data.PanelView = PanelViewBase(self.View.vb, TestPanelItem, Resources.UIPanelItemBase, 10)

    self.data.PanelView:SetData {
        {
            Text = "Test1",
            Image = Resources.YuigahamaYui
        },
        {
            Text = "Test2",
            Image = Resources.YukinoshitaYukino
        },
        {
            Text = "Test3",
            Image = Resources.YuigahamaYui
        }
    }

    self.data.PanelView:SetData {
        {
            Text = "Test4",
            Image = Resources.YuigahamaYui
        },
        {
            Text = "Test5",
            Image = Resources.YukinoshitaYukino
        },
        {
            Text = "Test6",
            Image = Resources.YuigahamaYui
        },
        {
            Text = "Test7",
            Image = Resources.YukinoshitaYukino
        }
    }

    self.data.PanelView:SetData {
        {
            Text = "Test8",
            Image = Resources.YuigahamaYui
        },
        {
            Text = "Test9",
            Image = Resources.YukinoshitaYukino
        }
    }
end

local function OnDispose(self)
    self.data.PanelView:Delete()
end

TestCtrl.OnInit = OnInit
TestCtrl.InitEvent = InitEvent
TestCtrl.OnStart = OnStart
TestCtrl.OnDispose = OnDispose

return TestCtrl
