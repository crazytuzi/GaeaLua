local Class = require "Utils/Class"

local Singleton = require "Utils/Singleton"

local ManagerCenter = require "Manager/ManagerCenter"

local ManagerBase = Class("ManagerBase", Singleton)

local function __register(self)
    self._mode = _G.EManagerMode.All

    ManagerCenter:Get().Register(self)
end

local function GetMode(self)
    return self._mode
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

ManagerBase.__register = __register
ManagerBase.GetMode = GetMode
ManagerBase.StartUp = StartUp
ManagerBase.ShutDown = ShutDown
ManagerBase.OnStartUp = OnStartUp
ManagerBase.OnShutDown = OnShutDown

return ManagerBase
