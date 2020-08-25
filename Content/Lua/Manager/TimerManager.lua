local TimerManager = _G.Class("TimerManager", _G.ManagerBase)

local _timeSeconds = 0.0

local _pendingTimers = {}

local _pauseTimers = {}

local _progressingTimers = {}

local TimerHandle = _G.Class("TimerHandle")

local function __init(self, Fun, InRate, InbLoop, InFirstDelay, SelfTable)
    self._Fun = Fun

    self._InRate = InRate

    self._InbLoop = InbLoop

    self._SelfTable = SelfTable

    if InFirstDelay > 0 then
        self._Time = _timeSeconds + InFirstDelay
    else
        self._Time = _timeSeconds + InRate
    end
end

local function __create(self)
    setmetatable(
        self,
        {
            __eq = function(this, other)
                if this._Fun ~= other._Fun then
                    return false
                end

                if this._SelfTable == nil or this._SelfTable == other._SelfTable then
                    return true
                end

                return false
            end,
            __lt = function(this, other)
                return this._Time < other._Time
            end,
            __call = function(this)
                if this._SelfTable then
                    xpcall(this._Fun, _G.CallBackError, this._SelfTable)
                else
                    xpcall(this._Fun, _G.CallBackError)
                end
            end
        }
    )
end

local function __delete(self)
    self._Fun = nil

    self._InRate = nil

    self._InbLoop = nil

    self._SelfTable = nil

    self._Time = nil
end

TimerHandle.__init = __init
TimerHandle.__create = __create
TimerHandle.__delete = __delete

local function Tick(DeltaTime)
    _timeSeconds = _timeSeconds + DeltaTime

    for i = #_pendingTimers, 1, -1 do
        local value = _pendingTimers[i]

        if value._Time <= _timeSeconds then
            value._Time = value._Time + value._InRate

            table.remove(_pendingTimers, i)

            table.insert(_progressingTimers, value)
        else
            break
        end
    end

    for i = #_progressingTimers, 1, -1 do
        local value = _progressingTimers[i]

        if value._Time <= _timeSeconds then
            value()

            if value._InbLoop then
                value._Time = value._Time + value._InRate
            else
                value:Delete()

                table.remove(_progressingTimers, i)
            end
        end
    end
end

local function OnStartUp(self)
    _timeSeconds = 0.0

    _pendingTimers = {}

    _pauseTimers = {}

    _progressingTimers = {}

    self.TickListener = _G.Emitter.Add(_G.EmitterEvent.Tick, Tick)
end

local function OnShutDown(self)
    for i = #_pendingTimers, 1, -1 do
        _pendingTimers[i]:Delete()
    end

    for i = #_pauseTimers, 1, -1 do
        _pauseTimers[i]:Delete()
    end

    for i = #_progressingTimers, 1, -1 do
        _progressingTimers[i]:Delete()
    end

    _timeSeconds = 0.0

    _pendingTimers = {}

    _pauseTimers = {}

    _progressingTimers = {}

    if self.TickListener then
        _G.Emitter.Remove(_G.EmitterEvent.Tick, self.TickListener)

        self.TickListener = nil
    end
end

local function SetTimer(Fun, InRate, InbLoop, InFirstDelay, SelfTable)
    local InHandle = TimerHandle.New(Fun, InRate, InbLoop, InFirstDelay, SelfTable)

    if InFirstDelay > 0 then
        table.insert(_pendingTimers, InHandle)

        table.sort(
            _pendingTimers,
            function(a, b)
                return b < a
            end
        )
    else
        table.insert(_progressingTimers, InHandle)
    end

    return InHandle
end

local function PauseTimer(InHandle)
    for i = #_pendingTimers, 1, -1 do
        if _pendingTimers[i] == InHandle then
            InHandle._Time = InHandle._Time - _timeSeconds + InHandle._InRate

            table.remove(_pendingTimers, i)

            table.insert(_pauseTimers, InHandle)

            return true
        end
    end

    for i = #_progressingTimers, 1, -1 do
        if _progressingTimers[i] == InHandle then
            InHandle._Time = InHandle._Time - _timeSeconds

            table.remove(_progressingTimers, i)

            table.insert(_pauseTimers, InHandle)

            return true
        end
    end

    return false
end

local function UnPauseTimer(InHandle)
    for i = #_pauseTimers, 1, -1 do
        if _pauseTimers[i] == InHandle then
            InHandle._Time = InHandle._Time + _timeSeconds

            table.remove(_pauseTimers, i)

            table.insert(_progressingTimers, InHandle)

            return true
        end
    end

    return false
end

local function ClearTimer(InHandle)
    for i = #_pendingTimers, 1, -1 do
        if _pendingTimers[i] == InHandle then
            table.remove(_pendingTimers, i)

            return true
        end
    end

    for i = #_pauseTimers, 1, -1 do
        if _pendingTimers[i] == InHandle then
            table.remove(_pauseTimers, i)

            return true
        end
    end

    for i = #_progressingTimers, 1, -1 do
        if _progressingTimers[i] == InHandle then
            table.remove(_progressingTimers, i)

            return true
        end
    end

    return false
end

local function IsTimerActive(InHandle)
    for i = #_pendingTimers, 1, -1 do
        if _pendingTimers[i] == InHandle then
            return true
        end
    end

    for i = #_progressingTimers, 1, -1 do
        if _progressingTimers[i] == InHandle then
            return true
        end
    end

    return false
end

local function IsTimerPaused(InHandle)
    for i = #_pauseTimers, 1, -1 do
        if _pauseTimers[i] == InHandle then
            return true
        end
    end

    return false
end

local function IsTimerPending(InHandle)
    for i = #_pendingTimers, 1, -1 do
        if _pendingTimers[i] == InHandle then
            return true
        end
    end

    return false
end

TimerManager.OnStartUp = OnStartUp
TimerManager.OnShutDown = OnShutDown
TimerManager.SetTimer = SetTimer
TimerManager.PauseTimer = PauseTimer
TimerManager.UnPauseTimer = UnPauseTimer
TimerManager.ClearTimer = ClearTimer
TimerManager.IsTimerActive = IsTimerActive
TimerManager.IsTimerPaused = IsTimerPaused
TimerManager.IsTimerPending = IsTimerPending

return TimerManager:GetInstance(TimerManager)
