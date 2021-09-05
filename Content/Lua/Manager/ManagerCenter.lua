local ManagerCenter = _G.Class("ManagerCenter", _G.Singleton)

local _Managers = {}

local function Register(Manager)
    table.insert(_Managers, Manager)
end

local function StartUp()
    for _, Manager in ipairs(_Managers) do
        local Instance = Manager:GetInstance()

        local Mode = Instance:GetMode()

        if Mode == _G.EManagerMode.All then
            Instance:StartUp()
        elseif Mode == _G.EManagerMode.Clent then
            if not _G.UKismetSystemLibrary.IsDedicatedServer(_G.GetContextObject()) then
                Instance:StartUp()
            end
        elseif Mode == _G.EManagerMode.DedicatedServer then
            if
                _G.UKismetSystemLibrary.IsDedicatedServer(_G.GetContextObject()) or
                    _G.WITH_EDITOR and _G.UKismetSystemLibrary.IsServer(_G.GetContextObject())
             then
                Instance:StartUp()
            end
        end
    end
end

local function ShutDown()
    local num = #_Managers

    for i = num, 1, -1 do
        _Managers[i]:GetInstance():ShutDown()
    end

    _Managers = {}
end

ManagerCenter.Register = Register
ManagerCenter.StartUp = StartUp
ManagerCenter.ShutDown = ShutDown

return ManagerCenter:GetInstance()
