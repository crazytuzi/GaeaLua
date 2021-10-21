local Class = require "Utils/Class"

local Logger = require "Logger/Logger"

local Stack = Class("Stack")

local function __init(self)
    self._data = {}
end

local function Push(self, Element)
    if Element == nil then
        Logger.warn("Stack:Push => Element is not valid")
        return
    end

    table.insert(self._data, Element)
end

local function Pop(self)
    if self:IsEmpty() then
        return nil
    end

    table.remove(self._data, self:Num())
end

local function Empty(self)
    self._data = {}
end

local function Top(self)
    if self:IsEmpty() then
        return nil
    end

    return self._data[self:Num()]
end

local function Num(self)
    return #self._data
end

local function IsEmpty(self)
    return self:Num() == 0
end

Stack.__init = __init
Stack.Push = Push
Stack.Pop = Pop
Stack.Empty = Empty
Stack.Top = Top
Stack.Num = Num
Stack.IsEmpty = IsEmpty

return Stack
