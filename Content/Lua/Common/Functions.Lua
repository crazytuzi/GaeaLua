function _G.CallBackError(e)
    if _G.IsStringNullOrEmpty(e) then
        e = "None"
    end

    _G.Logger.warn("CallBackError => " .. e .. "\n" .. debug.traceback())
end
