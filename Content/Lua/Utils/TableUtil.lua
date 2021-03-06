local _unpack = table.unpack

local function dump(tb, dump_metatable, max_level)
    local lookup_table = {}

    local rep = string.rep

    dump_metatable = dump_metatable or false

    max_level = max_level or 1

    local function _dump(t, level)
        local str = "\n" .. rep("\t", level) .. "{\n"

        for k, v in pairs(t) do
            local k_is_str = type(k) == "string" and 1 or 0

            local v_is_str = type(v) == "string" and 1 or 0

            str =
                str ..
                rep("\t", level + 1) ..
                    "[" .. rep('"', k_is_str) .. (tostring(k) or type(k)) .. rep('"', k_is_str) .. "]" .. " = "

            if type(v) == "table" then
                if not lookup_table[v] and ((not max_level) or level < max_level) then
                    lookup_table[v] = true

                    str = str .. _dump(v, level + 1) .. "\n"
                else
                    str = str .. (tostring(v) or type(v)) .. ",\n"
                end
            else
                str = str .. rep('"', v_is_str) .. (tostring(v) or type(v)) .. rep('"', v_is_str) .. ",\n"
            end
        end

        if dump_metatable then
            local mt = getmetatable(t)

            if mt ~= nil and type(mt) == "table" then
                str = str .. rep("\t", level + 1) .. '["__metatable"]' .. " = "

                if not lookup_table[mt] and ((not max_level) or level < max_level) then
                    lookup_table[mt] = true

                    str = str .. _dump(mt, level + 1) .. "\n"
                end
            end
        end

        str = str .. rep("\t", level) .. "},"

        return str
    end

    print(string.sub(_dump(tb, 0), 1, -2))
end

local function unpack(...)
    if #{...} == 0 then
        return nil
    end

    return _unpack(...)
end

table.dump = dump
table.unpack = unpack
