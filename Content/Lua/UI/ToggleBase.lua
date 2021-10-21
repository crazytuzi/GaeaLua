local Class = require "Utils/Class"

local ToggleBase = Class("ToggleBase")

local function __init(self, Params)
    local Root, Object, Data = table.unpack(Params)

    self._root = Root

    self._object = Object

    self._data = Data

    self._group = nil

    self._isOn = true
end

local function OnOperate()
end

local function OnValueChanged(self)
end

local function GetIsOn(self)
    return self._isOn
end

local function SetIsOn(self, IsOn)
    if self:GetIsOn() ~= IsOn then
        self._isOn = IsOn

        self:OnValueChanged()
    end
end

local function GetIndex(self)
    return self._index
end

local function GetRoot(self)
    return self._root
end

local function GetObject(self)
    return self._object
end

local function GetData(self)
    return self._data
end

local function GetGroup(self)
    return self._group
end

local function OnToggleRegister(self)
end

local function ToggleRegister(self, Params)
    self._group, self._index = table.unpack(Params)

    self:OnToggleRegister()
end

local function __delete(self)
    self._root = nil

    self._object = nil

    self._group = nil
end

ToggleBase.__init = __init
ToggleBase.OnOperate = OnOperate
ToggleBase.OnValueChanged = OnValueChanged
ToggleBase.GetIsOn = GetIsOn
ToggleBase.SetIsOn = SetIsOn
ToggleBase.GetIndex = GetIndex
ToggleBase.GetRoot = GetRoot
ToggleBase.GetObject = GetObject
ToggleBase.GetData = GetData
ToggleBase.GetGroup = GetGroup
ToggleBase.OnToggleRegister = OnToggleRegister
ToggleBase.ToggleRegister = ToggleRegister
ToggleBase.__delete = __delete

return ToggleBase
