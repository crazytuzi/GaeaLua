local PanelViewBase = _G.Class("PanelViewBase")

local function __init(self, Root, ClassType, Path, Capacity)
    if not _G.IsUValid(Root) then
        _G.Logger.warn("PanelViewBase.__init => Root is not valid")
        return
    end

    if ClassType == nil or not ClassType.IsA(_G.PanelItemBase) then
        _G.Logger.warn("PanelViewBase.__init => ClassType is not valid")
        return
    end

    self._root = Root

    self._path = Path

    self._items = {}

    self._pool = _G.Pool.New(ClassType, Capacity)
end

local function GetNewWidget(self)
    if not _G.IsUValid(self._root) then
        return nil
    end

    if not self._path then
        return nil
    end

    return _G.GetResource(self._path)
end

local function SetData(self, Data)
    if Data == nil then
        _G.Logger.warn("PanelViewBase.SetData => Data is nil")
        return
    end

    self._root:ClearChildren()

    local Index = 1

    for _, v in ipairs(Data) do
        local Item = self._items[Index]

        if Item == nil then
            Item = self._pool:Pop()

            if not Item:IsValid() then
                Item:Empty()

                local Widget = GetNewWidget(self)

                if _G.IsUValid(Widget) then
                    Item:Init(Widget)
                end
            end

            if Item:IsValid() then
                self._root:AddChild(Item:GetRoot())
            else
                _G.Logger.warn("PanelViewBase.SetData => Item root is nil")
            end

            table.insert(self._items, Item)
        end

        if Item:IsValid() then
            self._root:AddChild(Item:GetRoot())

            Item:SetData(v)

            Index = Index + 1
        end
    end

    while true do
        local Item = self._items[Index]

        if Item == nil then
            break
        end

        Item:Empty()

        self._pool:Push(Item)

        table.remove(self._items, Index)
    end
end

local function __delete(self)
    for _, v in ipairs(self._items) do
        v:Delete()
    end

    if _G.IsUValid(self._root) then
        self._root:ClearChildren()
    end

    self._pool:Empty()

    self._root = nil

    self._path = nil

    self._items = {}
end

PanelViewBase.__init = __init
PanelViewBase.SetData = SetData
PanelViewBase.__delete = __delete

return PanelViewBase
