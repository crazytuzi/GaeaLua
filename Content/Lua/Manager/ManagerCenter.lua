ManagerCenter = _G.Class("ManagerCenter", Singleton)

local _Managers = {}

function ManagerCenter.Register(Manager)
    table.insert(_Managers, Manager)
end

function ManagerCenter.Init()
    for _, Manager in ipairs(_Managers) do
        Manager:Init()
    end
end

function ManagerCenter.Reset()
    local num = #_Managers
    for i = num, 1, -1 do
        local v = _Managers[i]

        v:Reset()
    end
end
