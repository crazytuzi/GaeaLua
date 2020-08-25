require("LuaPanda").start("127.0.0.1", 8818)

local _GameInstance = nil

local function InitGameInstance(GameInstance)
    _GameInstance = GameInstance
end

local function ProtectGlobalTable()
    setmetatable(
        _G,
        {
            __index = function(t, k)
                local WarnFun = rawget(t, "Logger.warn")

                if WarnFun ~= nil then
                    WarnFun(
                        "Attempting to access nil value by name {" .. k .. "}. Check your spelling or declaration.",
                        2
                    )
                end
            end,
            __newindex = function(t, k, _)
                local WarnFun = rawget(t, "Logger.warn")

                if WarnFun ~= nil then
                    WarnFun(
                        "Attempting to create new global variable. Name is {" ..
                            k .. "}. Check if missing keyword 'local'.",
                        2
                    )
                end
            end
        }
    )
end

local function InitGame()
    require "Module"
end

local function StartGame()
    ProtectGlobalTable()

    _G.ManagerCenter.StartUp()
end

function _G.main(GameInstance)
    InitGameInstance(GameInstance)

    InitGame()

    StartGame()
end

function _G.Tick(DeltaTime)
    _G.Emitter.Emit(_G.EmitterEvent.Tick, DeltaTime)
end

function _G.GetContextObject()
    return _GameInstance
end
