local Singleton = _G.Class("Singleton")

local function __init(self)
    assert(rawget(self.__class_type, "Instance") == nil, self.__class_type.__cname .. " to create singleton twice!")

    rawset(self.__class_type, "Instance", self)
end

local function __delete(self)
    rawset(self.__class_type, "Instance", nil)
end

local function GetInstance(self, ...)
    if rawget(self, "Instance") == nil then
        rawset(self, "Instance", self.New(...))
    end

    assert(self.Instance ~= nil)

    return self.Instance
end

Singleton.__init = __init
Singleton.__delete = __delete
Singleton.GetInstance = GetInstance

return Singleton
