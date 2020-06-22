ManagerBase = _G.Class("ManagerBase", Singleton)

function ManagerBase:__init()
    _G.ManagerCenter:GetInstance().Register(self)
end

function ManagerBase:Init()
    self:OnInit()

    self._hasInit = true
end

function ManagerBase:Reset()
    if not self._hasInit then
        return
    end

    self._hasInit = false

    self:OnReset()
end

function ManagerBase:OnInit()
end

function ManagerBase:OnReset()
end