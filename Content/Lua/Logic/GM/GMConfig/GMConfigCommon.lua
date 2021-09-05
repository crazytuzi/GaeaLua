local Base = require "Logic/GM/GMConfig/GMConfigBase"

local GMConfig = _G.Class("GMConfigCommon", Base)

local function Register(self, Ctrl)
    self.Super:Register(
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
            },
            {
                "HotReload",
                function()
                    dofile("Test")
                end
            },
            {
                "Classs",
                function()
                    table.sort(
                        _G.Classs,
                        function(a, b)
                            if a.total == b.total then
                                return a.count > b.count
                            end

                            return a.total > b.total
                        end
                    )

                    _G.Logger.dump(_G.Classs)
                end
            }
        }
    )
end

GMConfig.Register = Register

return GMConfig
