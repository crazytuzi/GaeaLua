local UGaeaEventFunctionLibrary = _G.UGaeaEventFunctionLibrary

local function EventParamToTable(EventParam)
    if not EventParam then
        return nil
    end

    local EventParamTable = {}

    local Num = UGaeaEventFunctionLibrary.GetEventParamNum(EventParam)

    for i = 0, Num - 1 do
        local Element = UGaeaEventFunctionLibrary.GetEventParamByIndex(EventParam, i)

        local FunName = UGaeaEventFunctionLibrary.GetGFunNameByType(Element.EventParamType)

        local Fun = UGaeaEventFunctionLibrary[FunName]

        if not _G.IsCallable(Fun) then
            _G.Logger.warn("EventParamToTable => Fun is not found")
        else
            local Param = Fun(Element)

            table.insert(EventParamTable, Param)
        end
    end

    return EventParamTable
end

local LuaDispatcherWarp = _G.Class("LuaDispatcherWarp")

local function __initWarp(self, LuaFun, SelfTable, ParamTable)
    self._luaFun = LuaFun

    self._selfTable = SelfTable

    self._paramTable = ParamTable
end

local function DelegateTrigger(self, EventParam)
    local Param = EventParamToTable(EventParam)

    if not _G.IsCallable(self._luaFun) then
        _G.Logger.warn("LuaDispatcherInfo.DelegateTrigger => _luaFun is not found")
    else
        if self._selfTable then
            table.insert(Param, 1, self._selfTable)
        end

        table.insert(Param, self._paramTable)

        xpcall(self._luaFun, _G.CallBackError, table.unpack(Param))
    end
end

LuaDispatcherWarp.__init = __initWarp
LuaDispatcherWarp.DelegateTrigger = DelegateTrigger

local LuaDispatcher = _G.Class("LuaDispatcher")

local function __init(self, Dispatcher)
    self.RawDispatcher = Dispatcher
end

local function Add(self, EventId, LuaFun, SelfTable, ParamTable)
    if type(EventId) ~= "number" then
        _G.Logger.warn("LuaDispatcher:Dispatch => EventId is illegal")
        return
    end

    if not _G.IsValid(self.RawDispatcher) then
        _G.Logger.warn("LuaDispatcher:Add => RawDispatcher is nil")
        return nil
    end

    local Delegate = self.RawDispatcher:GetDelegateCallBack(EventId)

    if not _G.IsValid(Delegate) then
        self.RawDispatcher:CreateDelegateCallBack(EventId)

        Delegate = self.RawDispatcher:GetDelegateCallBack(EventId)

        if not _G.IsValid(Delegate) then
            _G.Logger.warn("LuaDispatcher:Add --> GetDelegateByEvent failed")
            return nil
        end
    end

    local Info = LuaDispatcherWarp.New(LuaFun, SelfTable, ParamTable)

    return _G.EventHelper.Add(Delegate, "callback", Info.DelegateTrigger, Info)
end

local function Remove(self, EventId, LuaDelegate)
    if type(EventId) ~= "number" then
        _G.Logger.warn("LuaDispatcher:Remove => EventId is illegal")
        return
    end

    if not _G.IsValid(self.RawDispatcher) then
        _G.Logger.warn("LuaDispatcher:Remove => RawDispatcher is nil")
        return
    end

    local Delegate = self.RawDispatcher:GetDelegateCallBack(EventId)

    if not _G.IsValid(Delegate) then
        _G.Logger.warn("LuaDispatcher:Remove => GetDelegateByEvent failed")
        return
    end

    return _G.EventHelper.Remove(Delegate, "callback", LuaDelegate)
end

local function Dispatch(self, EventId, ...)
    if type(EventId) ~= "number" then
        _G.Logger.warn("LuaDispatcher:Dispatch => EventId is illegal")
        return
    end

    if not _G.IsValid(self.RawDispatcher) then
        _G.Logger.warn("LuaDispatcher:Dispatch => RawDispatcher is nil")
        return
    end

    local EventParam = {...}

    local EventParamTArray = UGaeaEventFunctionLibrary.ConstructEventParamTArray()

    for i = 1, #EventParam do
        local Element = EventParam[i]

        local ParamType = Element[1]

        local ParamValue = Element[2]

        if ParamType == nil or ParamValue == nil then
            _G.Logger.warn("LuaDispatcher:Dispatch => ParamType or ParamValue is nil")
            return
        end

        local FunName = UGaeaEventFunctionLibrary.GetSFunNameByType(ParamType)

        local Fun = UGaeaEventFunctionLibrary[FunName]

        if not _G.IsCallable(Fun) then
            _G.Logger.warn("LuaDispatcher:Dispatch => Fun is not found")
        else
            local Param = _G.FEventParam()

            Param = Fun(Param, ParamValue)

            EventParamTArray:Add(Param)
        end
    end

    self.RawDispatcher:DispatchImp(EventId, EventParamTArray)
end

LuaDispatcher.__init = __init
LuaDispatcher.Add = Add
LuaDispatcher.Remove = Remove
LuaDispatcher.Dispatch = Dispatch

return LuaDispatcher.New(_G.UGaeaFunctionLibrary.GetGlobalDispatcher(_G.GetContextObject()))
