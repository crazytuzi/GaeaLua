local Pool = _G.Class("Pool")

local PoolItem = _G.Class("PoolItem")

local function __init(self, ClassType, Capacity)
    if ClassType == nil or not ClassType.IsA(PoolItem) then
        _G.Logger.warn("Pool.__init => ClassType is not valid")
        return
    end

    if Capacity == nil or Capacity <= 0 then
        Capacity = 10
    end

    self._pool = _G.Queue(Capacity)

    self._class = ClassType

    self._capacity = Capacity
end

local function IsEmpty(self)
    return self._pool:IsEmpty()
end

local function Num(self)
    return self._pool:Num()
end

local function IsFull(self)
    return Num(self) >= self._capacity
end

local function Push(self, Element)
    if Element == nil then
        _G.Logger.warn("Pool.Push => Element is not valid")
        return
    end

    if Element.__class_type ~= self._class then
        _G.Logger.warn("Pool.Push => Element type is not match")
        return
    end

    if IsFull(self) then
        _G.Logger.warn("Pool.Push => Pool is already full")
    else
        self._pool:Enqueue(Element)
    end
end

local function Pop(self, ...)
    local Element

    if IsEmpty(self) then
        Element = self._class(...)
    else
        Element = self._pool:Peek()

        self._pool:Dequeue()
    end

    return Element
end

local function Empty(self)
    self._pool:Empty()

    self._pool = nil

    self._class = nil

    self._capacity = nil
end

Pool.__init = __init
Pool.Push = Push
Pool.Pop = Pop
Pool.Empty = Empty

return table.pack(Pool, PoolItem)
