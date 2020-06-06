require("LuaPanda").start("127.0.0.1", 8818)

local GaeaGameInstance = nil

local function InitGaeaGameInstance(GameInstance)
    GaeaGameInstance = GameInstance
end

local function InitGame()
    require "Module"
end

function _G.main(GameInstance)
    InitGaeaGameInstance(GameInstance)

    InitGame()
end

function _G.GetContextObject()
    return GaeaGameInstance
end
