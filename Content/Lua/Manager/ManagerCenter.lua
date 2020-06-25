ManagerCenter = _G.Class("ManagerCenter", Singleton)

local _Managers = {}

function ManagerCenter.__init()
end

function ManagerCenter.Register(Manager)
    table.insert(_Managers, Manager)
end

function ManagerCenter.Init()
    for _, Manager in ipairs(_Managers) do
        Manager:GetInstance():Init()
    end
end

function ManagerCenter.Reset()
    local num = #_Managers
    for i = num, 1, -1 do
        _Managers[i]:GetInstance():Reset()
    end
end

return ManagerCenter:GetInstance()
