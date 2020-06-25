Singleton = _G.Class("Singleton")

function Singleton:__init()
    assert(rawget(self._class_type, "Instance") == nil, self._class_type.__cname .. " to create singleton twice!")

    rawset(self._class_type, "Instance", self)
end

function Singleton:__delete()
    rawset(self._class_type, "Instance", nil)
end

function Singleton:GetInstance(...)
    if rawget(self, "Instance") == nil then
        rawset(self, "Instance", self.New(...))
    end

    assert(self.Instance ~= nil)

    return self.Instance
end

function Singleton:Delete()
    self.Instance = nil
end
