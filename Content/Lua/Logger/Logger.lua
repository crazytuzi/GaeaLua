_G.Logger = _G.Class("Logger")

local print = print

function Logger.log(message)
    print(message)
end

function Logger.warn(message)
    if _G.IsStringNullOrEmpty(message) then
        message = "None"
    end

    message = "Warning: " .. message .. "\n" .. debug.traceback()

    Logger.screen(message, 10, _G.FLinearColor(1.0, 0.0, 0.0, 1.0))
end

function Logger.screen(message, duration, textcolor)
    duration = duration or 2.0

    textcolor = textcolor or _G.FLinearColor(0.0, 0.66, 1.0, 1.0)

    _G.UKismetSystemLibrary.PrintString(_G.GetContextObject(), message, true, true, textcolor, duration)
end
