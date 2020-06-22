function _G.CallbackError(e)
    if _G.IsStringNullOrEmpty(e) then
        e = "None"
    end

    Logger.warn("CallbackError => " .. e .. "\n" .. debug.traceback())
end
