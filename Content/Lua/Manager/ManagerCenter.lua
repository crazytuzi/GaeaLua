local Class = require "Utils/Class"

local Singleton = require "Utils/Singleton"

local ManagerCenter = Class("ManagerCenter", Singleton)

local _Managers = {}

local function Register(Manager)
    table.insert(_Managers, Manager)
end

local function StartUp()
    for _, Manager in ipairs(_Managers) do
        local Mode = Manager:Get():GetMode()

        if Mode == _G.EManagerMode.All then
            Manager:Get():StartUp()
        elseif Mode == _G.EManagerMode.Clent then
            if not _G.UKismetSystemLibrary.IsDedicatedServer(_G.GetContextObject()) then
                Manager:Get():StartUp()
            end
        elseif Mode == _G.EManagerMode.DedicatedServer then
            if
                _G.UKismetSystemLibrary.IsDedicatedServer(_G.GetContextObject()) or
                    _G.WITH_EDITOR and _G.UKismetSystemLibrary.IsServer(_G.GetContextObject())
             then
                Manager:Get():StartUp()
            end
        end
    end
end

local function ShutDown()
    local num = #_Managers

    for i = num, 1, -1 do
        _Managers[i]:Get():ShutDown()
    end

    _Managers = {}
end

ManagerCenter.Register = Register
ManagerCenter.StartUp = StartUp
ManagerCenter.ShutDown = ShutDown

return ManagerCenter
