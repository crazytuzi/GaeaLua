require("LuaPanda").start("127.0.0.1", 8818)

local EmitterEvent = require "Event/EmitterEvent"

local Emitter = require "Event/Emitter"

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
    local _require = require

    _G.Classs = {}

    setmetatable(
        _G.Classs,
        {
            __index = function(t, k)
                for _, value in pairs(t) do
                    if value.name == k then
                        return value
                    end
                end

                table.insert(
                    t,
                    {
                        name = k,
                        total = 0,
                        count = 0
                    }
                )

                return t[#t]
            end
        }
    )

    _G.require = function(modname)
        local mode = _require(modname)

        if type(mode) == "table" then
            if not rawget(_G.Classs, mode.__cname) then
                table.insert(
                    _G.Classs,
                    {
                        name = mode.__cname,
                        total = 0,
                        count = 0
                    }
                )

                if type(mode.__register) == "function" then
                    mode:__register()
                end
            end
        end

        return mode
    end

    require "Module"
end

local function StartGame()
    ProtectGlobalTable()

    local ManagerCenter = require "Manager/ManagerCenter"

    ManagerCenter:Get().StartUp()
end

function _G.main(GameInstance)
    InitGameInstance(GameInstance)

    InitGame()

    StartGame()
end

function _G.Tick(DeltaTime)
    Emitter.Emit(EmitterEvent.Tick, DeltaTime)
end

function _G.GetContextObject()
    return _GameInstance
end
