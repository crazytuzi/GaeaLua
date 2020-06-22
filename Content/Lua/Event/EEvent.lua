local UIEvent = require "Event/UIEvent"

local function CreateEnum(t, index)
    index = index or 0
    for key, value in ipairs(t) do
        rawset(_G.Events, value, index + key)
    end
end

CreateEnum(UIEvent, 1000)
