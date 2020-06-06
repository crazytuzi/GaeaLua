_G.Logger = _G.Class("Logger")

local print = print
local error = error

function Logger.log(message)
    print(message)
end

function Logger.warn(message)
    error(message)
end
