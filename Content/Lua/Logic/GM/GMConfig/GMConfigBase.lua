local GMConfigBase = _G.Class("GMConfigBase")

local function Register(_, Ctrl, Name, Config)
    Ctrl:Register(Name, Config)
end

local function __init(self, Ctrl)
    self:Register(Ctrl)
end

GMConfigBase.__init = __init
GMConfigBase.Register = Register

return GMConfigBase
