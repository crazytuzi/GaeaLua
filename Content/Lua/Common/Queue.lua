local Queue = _G.Class("Queue")

local function __init(self, Capacity)
    if Capacity == nil or Capacity <= 0 then
        Capacity = 10
    end

    self._data = {}

    self._size = 0

    self._head = -1

    self._tail = -1

    self._capacity = Capacity
end

local function Enqueue(self, Element)
    if Element == nil then
        _G.Logger.warn("Queue:Push => Element is not valid")
        return
    end

    if self:IsEmpty() then
        self._head = 0

        self._tail = 1

        self._size = 1

        self._data[self._tail] = Element
    else
        local tail = (self._tail + 1) % self._capacity

        if tail == (self._head + 1) % self._capacity then
            _G.Logger.warn("Queue:Enqueue => Capacity is not enough")
            return
        else
            self._tail = tail
        end

        self._data[self._tail] = Element

        self._size = self._size + 1
    end
end

local function Dequeue(self)
    if self:IsEmpty() then
        return nil
    end

    self._size = self._size - 1

    self._head = (self._head + 1) % self._capacity
end

local function Empty(self)
    self._data = {}

    self._size = 0

    self._head = -1

    self._tail = -1
end

local function Peek(self)
    if self:IsEmpty() then
        return nil
    end

    return self._data[self._head + 1]
end

local function Num(self)
    return self._size
end

local function IsEmpty(self)
    return self:Num() == 0
end

Queue.__init = __init
Queue.Enqueue = Enqueue
Queue.Dequeue = Dequeue
Queue.Empty = Empty
Queue.Peek = Peek
Queue.Num = Num
Queue.IsEmpty = IsEmpty

return Queue
