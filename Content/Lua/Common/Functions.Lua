function _G.CallBackError(e)
    if _G.IsStringNullOrEmpty(e) then
        e = "None"
    end

    _G.Logger.warn("CallBackError => " .. e .. "\n" .. debug.traceback())
end

function _G.IsValid(Object)
    if type(Object) ~= "userdata" then
        return false
    end

    return _G.slua.isValid(Object)
end
