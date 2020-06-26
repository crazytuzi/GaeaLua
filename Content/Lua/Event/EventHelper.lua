local EventHelper = _G.Class("EventHelper")

local function Add(UObject, EventName, LuaFun, SelfTable, ParamTable)
    if not _G.IsUValid(UObject) then
        _G.Logger.warn("EventHelper.Add => UObject is not valid")
        return nil
    end

    if _G.IsStringNullOrEmpty(EventName) then
        _G.Logger.warn("EventHelper.Add => EventName is illegal")
        return nil
    end

    if not _G.IsCallable(LuaFun) then
        _G.Logger.warn("EventHelper.Add => LuaFun is not callable")
        return nil
    end

    local Event = UObject[EventName]

    if Event == nil then
        _G.Logger.warn("EventHelper.Add => Event is nil")
        return nil
    end

    if SelfTable ~= nil and type(SelfTable) ~= "table" then
        _G.Logger.warn("EventHelper.Add => SelfTable is illegal")
        return nil
    end

    if ParamTable ~= nil and type(ParamTable) ~= "table" then
        _G.Logger.warn("EventHelper.Add => ParamTable is illegal")
        return nil
    end

    return Event:Add(LuaFun, SelfTable, ParamTable)
end

local function Remove(UObject, EventName, LuaDelegate)
    if not _G.IsUValid(UObject) then
        _G.Logger.warn("EventHelper.Remove => UObject is not valid")
        return
    end

    if _G.IsStringNullOrEmpty(EventName) then
        _G.Logger.warn("EventHelper.Remove => EventName is not illegal")
        return
    end

    if not _G.IsUValid(LuaDelegate) then
        _G.Logger.warn("EventHelper.Remove => LuaDelegate is not illegal")
        return
    end

    local Event = UObject[EventName]

    if Event == nil then
        _G.Logger.warn("EventHelper.Remove => Event is nil")
        return
    end

    Event:Remove(LuaDelegate)
end

local function Clear(UObject, EventName)
    if not _G.IsUValid(UObject) then
        _G.Logger.warn("EventHelper.Clear => UObject is not valid")
        return
    end

    if _G.IsStringNullOrEmpty(EventName) then
        _G.Logger.warn("EventHelper.Clear --> EventName is illegal")
        return
    end

    local Event = UObject[EventName]

    if Event == nil then
        _G.Logger.warn("EventHelper.Clear => Event is nil")
        return
    end

    Event:Clear()
end

EventHelper.Add = Add
EventHelper.Remove = Remove
EventHelper.Clear = Clear

return EventHelper
