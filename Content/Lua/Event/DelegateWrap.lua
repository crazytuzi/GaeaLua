local Class = require "Utils/Class"

local Logger = require "Logger/Logger"

local DelegateWrap = Class("DelegateWrap")

local function __init(self, LuaFun, SelfTable, ParamTable)
    self.LuaFunWrap = {LuaFun = LuaFun}

    setmetatable(self.LuaFunWrap, {__mode = "v"})

    self.SelfTableWrap = {SelfTable = SelfTable}

    setmetatable(self.SelfTableWrap, {__mode = "v"})

    self.ParamTable = ParamTable
end

local function __delete(self)
    self.LuaFunWrap = nil

    self.SelfTableWrap = nil

    self.ParamTable = nil
end

local function __create(self)
    local mt = getmetatable(self)

    mt.__call = function(this, ...)
        if not _G.IsCallable(this.LuaFunWrap.LuaFun) then
            Logger.warn("DelegateWrap.__call => LuaFun is not callable")
            return
        end

        if this.SelfTableWrap.SelfTable then
            if this.ParamTable then
                xpcall(
                    this.LuaFunWrap.LuaFun,
                    _G.CallBackError,
                    this.SelfTableWrap.SelfTable,
                    this.ParamTable,
                    ...
                )
            else
                xpcall(this.LuaFunWrap.LuaFun, _G.CallBackError, this.SelfTableWrap.SelfTable, ...)
            end
        else
            if this.ParamTable then
                xpcall(this.LuaFunWrap.LuaFun, _G.CallBackError, this.ParamTable, ...)
            else
                xpcall(this.LuaFunWrap.LuaFun, _G.CallBackError, ...)
            end
        end
    end
end

DelegateWrap.__init = __init
DelegateWrap.__delete = __delete
DelegateWrap.__create = __create

return DelegateWrap
