local Heap = _G.Class("Heap")

local function __init(self, Cmp)
    if not _G.IsCallable(Cmp) then
        _G.Logger.warn("Heap.__init => Cmp is not callable")
        return
    end

    self._data = {}

    self._cmp = Cmp
end

local function Swap(self, LIndex, RIndex)
    self._data[LIndex], self._data[RIndex] = self._data[RIndex], self._data[LIndex]
end

local function HeapSiftUp(self, Index)
    while Index > 1 do
        local Parent = math.floor(Index / 2)

        if not self._cmp(self._data[Index], self._data[Parent]) then
            break
        end

        Swap(self, Index, Parent)

        Index = Parent
    end
end

local function HeapSiftDown(self, Index)
    if Index >= self:Num() then
        return
    end

    while true do
        local Min = Index

        local Child = 2 * Index

        for i = Child, Child + 1 do
            if i <= self:Num() and self._cmp(self._data[i], self._data[Min]) then
                Min = i
            end
        end

        if Min == Index then
            break
        end

        Swap(self, Index, Min)

        Index = Min
    end
end

local function HeapPush(self, Element)
    table.insert(self._data, self:Num() + 1, Element)

    HeapSiftUp(self, self:Num())
end

local function HeapPop(self)
    if not self:IsEmpty() then
        self._data[1] = self._data[self:Num()]

        table.remove(self._data, self:Num())

        HeapSiftDown(self, 1)
    end
end

local function Empty(self)
    self._data = {}

    self._cmp = nil
end

local function HeapTop(self)
    if not self:IsEmpty() then
        return self._data[1]
    end

    return nil
end

local function Num(self)
    return #self._data
end

local function IsEmpty(self)
    return self:Num() == 0
end

Heap.__init = __init
Heap.HeapPush = HeapPush
Heap.HeapPop = HeapPop
Heap.Empty = Empty
Heap.HeapTop = HeapTop
Heap.Num = Num
Heap.IsEmpty = IsEmpty

return Heap
