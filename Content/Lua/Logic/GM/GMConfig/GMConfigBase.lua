local GMConfigBase = _G.Class("GMConfigBase")

local function Register(self, Ctrl, Config)
    Ctrl:Register(string.split(self.__class_type.__cname, "GMConfig")[2], Config)
end

local function __init(self, Ctrl)
    self:Register(Ctrl)
end

GMConfigBase.__init = __init
GMConfigBase.Register = Register

return GMConfigBase
