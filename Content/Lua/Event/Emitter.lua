local Emitter = _G.Class("Emitter")

local _event = {}

local EmitterListener = _G.Class("EmitterListener")

local function __init(self, Fun, SelfTable)
    self._Fun = Fun

    self._SelfTable = SelfTable
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
            __call = function(this, ...)
                if this._SelfTable then
                    xpcall(this._Fun, _G.CallBackError, this._SelfTable, ...)
                else
                    xpcall(this._Fun, _G.CallBackError, ...)
                end
            end
        }
    )
end

local function __delete(self)
    self._Fun = nil

    self._SelfTable = nil
end

EmitterListener.__init = __init
EmitterListener.__create = __create
EmitterListener.__delete = __delete

local function Add(Event, Fun, SelfTable)
    if not _G.IsCallable(Fun) then
        _G.Logger.warn("Emitter.Add => Fun is not callable")
        return nil
    end

    local Listener = EmitterListener(Fun, SelfTable)

    if not _event[Event] then
        _event[Event] = {Listener}
    else
        table.insert(_event[Event], Listener)
    end

    return Listener
end

local function Emit(Event, ...)
    if type(_event) ~= "table" or type(_event[Event]) ~= "table" then
        return
    end

    for _, value in pairs(_event[Event]) do
        value(...)
    end
end

local function Remove(Event, Listener)
    if type(Listener) ~= "table" then
        _G.Logger.warn("Emitter.Remove => Listener is not a table")
        return
    end

    if type(_event) ~= "table" or type(_event[Event]) ~= "table" then
        return
    end

    for i = #_event[Event], 1, -1 do
        if _event[Event][i] == Listener then
            _event[Event][i]:Delete()

            table.remove(_event[Event], i)

            break
        end
    end
end

local function Clear()
    for i = #_event, 1, -1 do
        _event[i]:Delete()
    end

    _event = {}
end

Emitter.Add = Add
Emitter.Emit = Emit
Emitter.Remove = Remove
Emitter.Clear = Clear

return Emitter
