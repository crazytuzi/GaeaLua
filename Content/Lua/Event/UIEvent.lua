local _ENV = {
    _G = _ENV._G
}

_G.setmetatable(
    _ENV,
    {
        __index = function(t, k)
            local v = _G[t]

            if v then
                return v
            end

            return k
        end
    }
)

return {
    -- EventBegin --
    EVENT_UI_ON_INIT,
    EVENT_UI_ON_DISPOSE,
    EVENT_UI_TEST_EVENT,
    EVENT_PRE_LOAD_MAP
    -- EventEnd --
}
