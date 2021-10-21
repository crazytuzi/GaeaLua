local Class = require "Utils/Class"

local ToggleGroupBase = Class("ToggleGroupBase")

local UButton = _G.import("Button")

local UImage = _G.import("Image")

local UCheckBox = _G.import("CheckBox")

local EventHelper = require "Event/EventHelper"

local function __init(self, Params)
    local MinOn, MaxOn = table.unpack(Params)

    self._minOn = MinOn or 1

    self._maxOn = MaxOn or 1

    self._toggles = {}

    self._activeToggles = {}

    self._delegates = {}
end

local function GetToggle(self, Index)
    return self._toggles[Index]
end

local function HasToggle(self, Index)
    return GetToggle(self, Index) ~= nil
end

local function GetActiveToggleKey(self, Index)
    for key, value in pairs(self._activeToggles) do
        if value == Index then
            return key
        end
    end

    return nil
end

local function GetActiveToggle(self, Index)
    return self._activeToggles[Index]
end

local function AddActiveToggle(self, Index)
    table.insert(self._activeToggles, Index)
end

local function RemoveActiveToggle(self, Index)
    table.remove(self._activeToggles, Index)
end

local function IsToggleActive(self, Index)
    return GetActiveToggle(self, Index) ~= nil
end

local function GetActiveToggleNum(self)
    return #self._activeToggles
end

local function ActiveToggleImplementation(self, Index)
    if self._maxOn == 0 then
        return
    end

    if self._maxOn == 1 then
        local PreToggle = GetToggle(self, GetActiveToggle(self, 1))

        if PreToggle then
            PreToggle:SetIsOn(false)

            RemoveActiveToggle(self, 1)
        end
    else
        if self:GetActiveToggleNum() == self._maxOn then
            return
        end
    end

    local Toggle = GetToggle(self, Index)

    if Toggle then
        AddActiveToggle(self, Index)

        Toggle:SetIsOn(true)
    end
end

local function InactiveToggleImplementation(self, Index)
    if self:GetActiveToggleNum() - 1 < self._minOn then
        return
    end

    RemoveActiveToggle(self, GetActiveToggleKey(self, Index))

    local Toggle = GetToggle(self, Index)

    if Toggle then
        Toggle:SetIsOn(false)
    end
end

local function OperateToggleImplementation(self, Index)
    if IsToggleActive(self, GetActiveToggleKey(self, Index)) then
        InactiveToggleImplementation(self, Index)
    else
        ActiveToggleImplementation(self, Index)
    end
end

local function OperateToggle(self, Index)
    if not HasToggle(self, Index) then
        return
    end

    OperateToggleImplementation(self, Index)
end

local function Operate(self, Toggle)
    Toggle:OnOperate()

    OperateToggle(self, Toggle:GetIndex())
end

local function RegisterToggle(self, Toggle)
    local Object = Toggle:GetObject()

    local EventName

    local Fun

    if Object:IsA(UButton) then
        EventName = _G.EWidgetEvent.Button.OnClicked

        Fun = function(this, _Toggle)
            Operate(this, _Toggle)
        end
    elseif Object:IsA(UImage) then
        EventName = _G.EWidgetEvent.Image.OnMouseButtonDown

        Fun = function(this, _, _, _Toggle)
            Operate(this, _Toggle)
        end
    elseif Object:IsA(UCheckBox) then
        EventName = _G.EWidgetEvent.CheckBox.OnCheckStateChanged

        Fun = function(this, _, _Toggle)
            Operate(this, _Toggle)
        end
    end

    local Delegate = EventHelper.Add(Object, EventName, Fun, self, Toggle)

    table.insert(self._delegates, {Object = Object, EventName = EventName, Delegate = Delegate})

    table.insert(self._toggles, Toggle)

    Toggle:ToggleRegister({self, #self._toggles})

    Toggle:SetIsOn(false)
end

local function GetToggles(self)
    return self._toggles
end

local function GetActiveToggles(self)
    local Toggles = {}

    for _, value in pairs(self._activeToggles) do
        table.insert(Toggles, self._toggles[value])
    end

    return Toggles
end

local function __delete(self)
    for _, value in pairs(self._delegates) do
        EventHelper.Remove(value.Object, value.EventName, value.Delegate)
    end

    self._delegates = {}

    self._toggles = {}

    self._activeToggles = {}
end

ToggleGroupBase.__init = __init
ToggleGroupBase.GetActiveToggleNum = GetActiveToggleNum
ToggleGroupBase.OperateToggle = OperateToggle
ToggleGroupBase.RegisterToggle = RegisterToggle
ToggleGroupBase.GetToggles = GetToggles
ToggleGroupBase.GetActiveToggles = GetActiveToggles
ToggleGroupBase.__delete = __delete

return ToggleGroupBase
