local ManagerCenter = _G.Class("ManagerCenter", _G.Singleton)

local _Managers = {}

local function __init()
end

local function Register(Manager)
    table.insert(_Managers, Manager)
end

local function Init()
    for _, Manager in ipairs(_Managers) do
        Manager:GetInstance():Init()
    end
end

local function Reset()
    local num = #_Managers
    for i = num, 1, -1 do
        _Managers[i]:GetInstance():Reset()
    end
end

ManagerCenter.__init = __init
ManagerCenter.Register = Register
ManagerCenter.Init = Init
ManagerCenter.Reset = Reset

return ManagerCenter:GetInstance()
