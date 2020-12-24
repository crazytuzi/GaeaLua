local _wrap = coroutine.wrap

local function wrap(f)
    return _wrap(
        function()
            xpcall(f, _G.CallBackError)
        end
    )
end

coroutine.wrap = wrap
