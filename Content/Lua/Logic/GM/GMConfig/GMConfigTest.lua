local Base = require "Logic/GM/GMConfig/GMConfigBase"

local GMConfig = _G.Class("GMConfigTest", Base)

local function Register(self, Ctrl)
    self.Super:Register(
        Ctrl,
        {
            {
                "Log",
                function()
                    _G.Logger.log("Test")
                end
            },
            {
                "Warn",
                function()
                    _G.Logger.warn("Test")
                end
            }
        }
    )
end

GMConfig.Register = Register

return GMConfig
