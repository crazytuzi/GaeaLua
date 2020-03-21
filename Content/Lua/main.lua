require("LuaPanda").start("127.0.0.1", 8818)

_G.GaeaGameInstance = nil

local function InitGaeaGameInstance(GameInstance)
    _G.GaeaGameInstance = GameInstance
end

function _G.main(GameInstance)
    InitGaeaGameInstance(GameInstance)
end
