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
            Logger.warn("EventParamToTable => Fun is not found")
        else
            local Param = Fun(Element)

            table.insert(EventParamTable, Param)
        end
    end

    return EventParamTable
end

local LuaDispatcherWarp = _G.Class("LuaDispatcherWarp")

function LuaDispatcherWarp:__init(LuaFun, SelfTable, ParamTable)
    self._luaFun = LuaFun

    self._selfTable = SelfTable

    self._paramTable = ParamTable
end

function LuaDispatcherWarp:DelegateTrigger(EventParam)
    local Param = EventParamToTable(EventParam)

    if not _G.IsCallable(self._luaFun) then
        Logger.warn("LuaDispatcherInfo.DelegateTrigger => _luaFun is not found")
    else
        if self._selfTable then
            table.insert(Param, 1, self._selfTable)
        end

        table.insert(Param, self._paramTable)

        xpcall(self._luaFun, _G.CallbackError, table.unpack(Param))
    end
end

local LuaDispatcher = _G.Class("LuaDispatcher")

function LuaDispatcher:__init(Dispatcher)
    self.RawDispatcher = Dispatcher
end

function LuaDispatcher:Add(EventId, LuaFun, SelfTable, ParamTable)
    if type(EventId) ~= "number" then
        Logger.warn("LuaDispatcher:Dispatch => EventId is illegal")
        return
    end

    if not _G.IsUValid(self.RawDispatcher) then
        Logger.warn("LuaDispatcher:Add => RawDispatcher is nil")
        return nil
    end

    local Delegate = self.RawDispatcher:GetDelegateCallBack(EventId)

    if not _G.IsUValid(Delegate) then
        self.RawDispatcher:CreateDelegateCallBack(EventId)

        Delegate = self.RawDispatcher:GetDelegateCallBack(EventId)

        if not _G.IsUValid(Delegate) then
            Logger.warn("LuaDispatcher:Add --> GetDelegateByEvent failed")
            return nil
        end
    end

    local Info = LuaDispatcherWarp.New(LuaFun, SelfTable, ParamTable)

    return EventHelper.Add(Delegate, "callback", Info.DelegateTrigger, Info)
end

function LuaDispatcher:Remove(EventId, LuaDelegate)
    if type(EventId) ~= "number" then
        Logger.warn("LuaDispatcher:Remove => EventId is illegal")
        return
    end

    if not _G.IsUValid(self.RawDispatcher) then
        Logger.warn("LuaDispatcher:Remove => RawDispatcher is nil")
        return
    end

    local Delegate = self.RawDispatcher:GetDelegateCallBack(EventId)

    if not _G.IsUValid(Delegate) then
        Logger.warn("LuaDispatcher:Remove => GetDelegateByEvent failed")
        return
    end

    return EventHelper.Remove(Delegate, "callback", LuaDelegate)
end

function LuaDispatcher:Dispatch(EventId, ...)
    if type(EventId) ~= "number" then
        Logger.warn("LuaDispatcher:Dispatch => EventId is illegal")
        return
    end

    if not _G.IsUValid(self.RawDispatcher) then
        Logger.warn("LuaDispatcher:Dispatch => RawDispatcher is nil")
        return
    end

    local EventParam = {...}

    local EventParamTArray = UGaeaEventFunctionLibrary.ConstructEventParamTArray()

    for i = 1, #EventParam do
        local Element = EventParam[i]

        local ParamType = Element[1]

        local ParamValue = Element[2]

        if ParamType == nil or ParamValue == nil then
            Logger.warn("LuaDispatcher:Dispatch => ParamType or ParamValue is nil")
            return
        end

        local FunName = UGaeaEventFunctionLibrary.GetSFunNameByType(ParamType)

        local Fun = UGaeaEventFunctionLibrary[FunName]

        if not _G.IsCallable(Fun) then
            Logger.warn("LuaDispatcher:Dispatch => Fun is not found")
        else
            local Param = _G.FEventParam()

            Param = Fun(Param, ParamValue)

            EventParamTArray:Add(Param)
        end
    end

    self.RawDispatcher:DispatchImp(EventId, EventParamTArray)
end

_G.Dispatcher = LuaDispatcher.New(_G.UGaeaFunctionLibrary.GetGlobalDispatcher(_G.GetContextObject()))
