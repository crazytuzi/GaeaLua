local Class = require "Utils/Class"

local Base = require "Logic/GM/GMConfig/GMConfigBase"

local Logger = require "Logger/Logger"

local GMConfig = Class("GMConfigTest", Base)

local function Register(self, Ctrl)
    self.Super:Register(
        Ctrl,
        string.split(self.__class_type.__cname, "GMConfig")[2],
        {
            {
                "Log",
                function()
                    Logger.log("Test")
                end
            },
            {
                "Warn",
                function()
                    Logger.warn("Test")
                end
            }
        }
    )
end

GMConfig.Register = Register

return GMConfig
