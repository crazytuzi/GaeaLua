local ManagerBase = _G.Class("ManagerBase", _G.Singleton)

local function __init(_, Manager)
    _G.ManagerCenter.Register(Manager)
end

local function Init(self)
    self:OnInit()

    self._hasInit = true
end

local function Reset(self)
    if not self._hasInit then
        return
    end

    self._hasInit = false

    self:OnReset()
end

local function OnInit()
end

local function OnReset()
end

ManagerBase.__init = __init
ManagerBase.Init = Init
ManagerBase.Reset = Reset
ManagerBase.OnInit = OnInit
ManagerBase.OnReset = OnReset

return ManagerBase
