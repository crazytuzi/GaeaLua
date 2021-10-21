local Class = require "Utils/Class"

local Logger = Class("Logger")

local print = print

local function log(message)
    print(message)
end

local function screen(message, duration, textcolor)
    duration = duration or 2.0

    textcolor = textcolor or _G.FLinearColor(0.0, 0.66, 1.0, 1.0)

    _G.UKismetSystemLibrary.PrintString(_G.GetContextObject(), message, true, true, textcolor, duration)
end

local function warn(message, level)
    if _G.IsStringNullOrEmpty(message) then
        message = "None"
    end

    level = level or 2

    message = "Warning: " .. message .. "\n" .. debug.traceback(_, level)

    screen(message, 10, _G.FLinearColor(1.0, 0.0, 0.0, 1.0))
end

local function dump(t, dump_metatable, max_level)
    table.dump(t, dump_metatable, max_level)
end

Logger.log = log
Logger.warn = warn
Logger.screen = screen
Logger.dump = dump

return Logger
