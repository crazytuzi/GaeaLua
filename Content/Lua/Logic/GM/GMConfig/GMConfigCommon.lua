local Base = require "Logic/GM/GMConfig/GMConfigBase"

local GMConfig = _G.Class("GMConfigCommon", Base)

local function Register(self, Ctrl)
    Base.Register(
        self,
        Ctrl,
        {
            {
                "Unreal GC",
                function()
                    _G.UKismetSystemLibrary.CollectGarbage()
                end
            },
            {
                "Lua GC",
                function()
                    local c = collectgarbage("count")

                    print("Begin gc count = " .. c .. " kb")

                    collectgarbage("collect")

                    c = collectgarbage("count")

                    print("End gc count = " .. c .. " kb")
                end
            }
        }
    )
end

GMConfig.Register = Register

return GMConfig
