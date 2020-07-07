local ManagerBase = _G.Class("ManagerBase", _G.Singleton)

local function __init(_, Manager)
    _G.ManagerCenter.Register(Manager)
end

local function StartUp(self)
    self:OnStartUp()

    self._hasInit = true
end

local function ShutDown(self)
    if not self._hasInit then
        return
    end

    self._hasInit = false

    self:OnShutDown()
end

local function OnStartUp()
end

local function OnShutDown()
end

ManagerBase.__init = __init
ManagerBase.StartUp = StartUp
ManagerBase.ShutDown = ShutDown
ManagerBase.OnStartUp = OnStartUp
ManagerBase.OnShutDown = OnShutDown

return ManagerBase
