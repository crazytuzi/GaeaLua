local HUDCtrl = _G.Class("HUDCtrl", _G.Ctrl)

local function Timer1(self)
    print("xxxxxxxxxxxxx")
end

local Count = 1

local function Timer2(self)
    print("yyyyyyyyyyyyy")

    Count = Count + 1

    if Count > 3 then
        _G.TimerManager.ClearTimer(self.data.Timer2Handle)

        self.data.Timer2Handle = nil
    end
end

local function Timer3(self)
    print("zzzzzzz")
end

local function OnInit()
end

local function OnTestBtnClick()
    _G.UIManager:Show(_G.Config.UIConfig.GM)
end

local function InitEvent(self)
    self:RegisterEvent(self.View.btn_test, _G.EWidgetEvent.Button.OnClicked, OnTestBtnClick)

    _G.TimerManager.SetTimer(Timer1, 0.5, false, 1, self)

    self.data.Timer2Handle = _G.TimerManager.SetTimer(Timer2, 0.2, true, 0, self)

    _G.TimerManager.SetTimer(Timer3, 0.3, true, 0, self)
end

local function OnStart()
end

local function OnDispose()
end

HUDCtrl.OnInit = OnInit
HUDCtrl.InitEvent = InitEvent
HUDCtrl.OnStart = OnStart
HUDCtrl.OnDispose = OnDispose

return HUDCtrl
