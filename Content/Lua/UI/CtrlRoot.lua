local CtrlRoot = _G.Class("CtrlRoot")

local function __init(self)
    self._Ctrls = {}
end

local function __delete(self)
    self._Ctrls = {}
end

local function SetCtrl(self, UIName)
    local Ctrl = self._Ctrls[UIName]

    if not Ctrl then
        Ctrl = require(_G.Config.UIConfig[UIName].CtrlPath)(UIName)

        self._Ctrls[UIName] = {Ctrl = Ctrl, Param = nil}
    end
end

local function GetCtrl(self, UIName)
    SetCtrl(self, UIName)

    return self._Ctrls[UIName].Ctrl
end

local function SetParam(self, UIName, Param)
    SetCtrl(self, UIName)

    self._Ctrls[UIName].Param = Param
end

local function GetParam(self, UIName)
    SetCtrl(self, UIName)

    return self._Ctrls[UIName].Param
end

CtrlRoot.__init = __init
CtrlRoot.__delete = __delete
CtrlRoot.GetCtrl = GetCtrl
CtrlRoot.SetParam = SetParam
CtrlRoot.GetParam = GetParam

return CtrlRoot
