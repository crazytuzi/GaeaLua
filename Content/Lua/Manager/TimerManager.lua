local Class = require "Utils/Class"

local ManagerBase = require "Manager/ManagerBase"

local TimerManager = Class("TimerManager", ManagerBase)

local _timeSeconds = 0.0

local _pendingTimers = {}

local _pauseTimers = {}

local _progressingTimers = {}

local _lock = false

local _delayOperations = {}

local Heap = require "Common/Heap"

local EmitterEvent = require "Event/EmitterEvent"

local Emitter = require "Event/Emitter"

local TimerHandle = Class("TimerHandle")

local function __init(self, Fun, InRate, InbLoop, InFirstDelay, SelfTable, ParamTable)
    self._Fun = Fun

    self._InRate = InRate

    self._InbLoop = InbLoop

    self._SelfTable = SelfTable

    self._ParamTable = ParamTable

    if InFirstDelay > 0 then
        self._Time = _timeSeconds + InFirstDelay
    else
        self._Time = _timeSeconds + InRate
    end
end

local function __create(self)
    local mt = getmetatable(self)

    mt.__eq = function(this, other)
        if this._Fun ~= other._Fun then
            return false
        end

        if this._SelfTable == nil or this._SelfTable == other._SelfTable then
            return true
        end

        return false
    end

    mt.__lt = function(this, other)
        return this._Time < other._Time
    end

    mt.__call = function(this)
        if this._SelfTable then
            xpcall(this._Fun, _G.CallBackError, this._SelfTable, this._ParamTable)
        else
            xpcall(this._Fun, _G.CallBackError, this._ParamTable)
        end
    end
end

local function __delete(self)
    self._Fun = nil

    self._InRate = nil

    self._InbLoop = nil

    self._SelfTable = nil

    self._ParamTable = nil

    self._Time = nil
end

TimerHandle.__init = __init
TimerHandle.__create = __create
TimerHandle.__delete = __delete

local function Tick(DeltaTime)
    _lock = true

    _timeSeconds = _timeSeconds + DeltaTime

    for i = #_pendingTimers, 1, -1 do
        local value = _pendingTimers[i]

        if value._Time <= _timeSeconds then
            value._Time = value._Time + value._InRate

            table.remove(_pendingTimers, i)

            _progressingTimers:HeapPush(value)
        else
            break
        end
    end

    while true do
        local value = _progressingTimers:HeapTop()

        if value and value._Time <= _timeSeconds then
            _progressingTimers:HeapPop()

            value()

            if value._InbLoop then
                value._Time = value._Time + value._InRate

                _progressingTimers:HeapPush(value)
            else
                value:Delete()
            end
        else
            break
        end
    end

    _lock = false

    for _, Operation in pairs(_delayOperations) do
        Operation()
    end

    _delayOperations = {}
end

local function OnStartUp(self)
    _timeSeconds = 0.0

    _pendingTimers = {}

    _pauseTimers = {}

    _progressingTimers =
        Heap(
        function(a, b)
            return a < b
        end
    )

    self.TickListener = Emitter.Add(EmitterEvent.Tick, Tick)
end

local function OnShutDown(self)
    for i = #_pendingTimers, 1, -1 do
        _pendingTimers[i]:Delete()
    end

    for i = #_pauseTimers, 1, -1 do
        _pauseTimers[i]:Delete()
    end

    while true do
        local Value = _progressingTimers:HeapTop()

        if Value then
            _progressingTimers:HeapPop()

            Value:Delete()
        else
            break
        end
    end

    _timeSeconds = 0.0

    _pendingTimers = {}

    _pauseTimers = {}

    _progressingTimers:Empty()

    _progressingTimers = {}

    if self.TickListener then
        Emitter.Remove(EmitterEvent.Tick, self.TickListener)

        self.TickListener = nil
    end
end

local function SetTimer(Fun, InRate, InbLoop, InFirstDelay, SelfTable, ParamTable)
    local InHandle = TimerHandle(Fun, InRate, InbLoop, InFirstDelay, SelfTable, ParamTable)

    if _lock then
        table.insert(
            _delayOperations,
            function()
                SetTimer(InRate, InbLoop, InFirstDelay, SelfTable, ParamTable)
            end
        )

        return InHandle
    end

    if InFirstDelay > 0 then
        table.insert(_pendingTimers, InHandle)

        table.sort(
            _pendingTimers,
            function(a, b)
                return b < a
            end
        )
    else
        _progressingTimers:HeapPush(InHandle)
    end

    return InHandle
end

local function PauseTimer(InHandle)
    if _lock then
        table.insert(
            _delayOperations,
            function()
                PauseTimer(InHandle)
            end
        )

        return true
    end

    for i = #_pendingTimers, 1, -1 do
        if _pendingTimers[i] == InHandle then
            InHandle._Time = InHandle._Time - _timeSeconds + InHandle._InRate

            table.remove(_pendingTimers, i)

            table.insert(_pauseTimers, InHandle)

            return true
        end
    end

    local Index = _progressingTimers:Find(InHandle)

    if _progressingTimers:HeapRemoveAt(Index) then
        table.insert(_pauseTimers, InHandle)

        return true
    end

    return false
end

local function UnPauseTimer(InHandle)
    if _lock then
        table.insert(
            _delayOperations,
            function()
                UnPauseTimer(InHandle)
            end
        )

        return true
    end

    for i = #_pauseTimers, 1, -1 do
        if _pauseTimers[i] == InHandle then
            InHandle._Time = InHandle._Time + _timeSeconds

            table.remove(_pauseTimers, i)

            _progressingTimers:HeapPush(InHandle)

            return true
        end
    end

    return false
end

local function ClearTimer(InHandle)
    if _lock then
        table.insert(
            _delayOperations,
            function()
                ClearTimer(InHandle)
            end
        )

        return true
    end

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

    local Index = _progressingTimers:Find(InHandle)

    return _progressingTimers:HeapRemoveAt(Index)
end

local function IsTimerActive(InHandle)
    for i = #_pendingTimers, 1, -1 do
        if _pendingTimers[i] == InHandle then
            return true
        end
    end

    return _progressingTimers:Find(InHandle) ~= _G.INDEX_NONE
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

return TimerManager
