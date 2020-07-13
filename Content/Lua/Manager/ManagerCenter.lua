local ManagerCenter = _G.Class("ManagerCenter", _G.Singleton)

local _Managers = {}

local function Register(Manager)
    table.insert(_Managers, Manager)
end

local function StartUp()
    for _, Manager in ipairs(_Managers) do
        Manager:GetInstance():StartUp()
    end
end

local function ShutDown()
    local num = #_Managers
    for i = num, 1, -1 do
        _Managers[i]:GetInstance():ShutDown()
    end
end

ManagerCenter.Register = Register
ManagerCenter.StartUp = StartUp
ManagerCenter.ShutDown = ShutDown

return ManagerCenter:GetInstance()
