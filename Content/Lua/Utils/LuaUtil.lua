function _G.IsStringNullOrEmpty(str)
    if type(str) ~= "string" then
        return true
    elseif string.len(str) == 0 then
        return true
    elseif string.len(string.gsub(str, "%s", "")) == 0 then
        return true
    end

    return false
end

function _G.IsCallable(target)
    if target == nil then
        return false
    end

    if type(target) == "function" then
        return true
    end

    if type(target) == "table" then
        local mt = getmetatable(target)

        if mt ~= nil then
            return (mt.__call ~= nil)
        end
    end

    return false
end

function _G.DeepCopy(Object)
    local lookup_table = {}

    local _copy

    _copy = function(PObject)
        if type(PObject) ~= "table" then
            return PObject
        elseif lookup_table[PObject] then
            return lookup_table[PObject]
        end

        local new_table = {}

        lookup_table[PObject] = new_table

        for index, value in pairs(PObject) do
            new_table[_copy(index)] = _copy(value)
        end

        return setmetatable(new_table, getmetatable(PObject))
    end

    return _copy(Object)
end
