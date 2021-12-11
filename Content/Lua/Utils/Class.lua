local assert = assert

local setmetatable = setmetatable

local string = string

local debug = debug

local type = type

local __class = {}

local Class = {}

setmetatable(
    Class,
    {
        __call = function(_, classname, ...)
            assert(type(classname) == "string" and #classname > 0)

            local class_type = {}

            class_type.__init = false
            class_type.__create = false
            class_type.__delete = false
            class_type.__cname = classname
            class_type.__path =
                string.match(
                debug.getinfo(2, "S")["source"],
                "[^(?:Lua)]+//Lua/([^.]+).lua"
            )
            class_type.__super = table.pack(...)

            class_type.IsA = function(Base)
                if class_type == Base then
                    return true
                end
                for _, v in ipairs(class_type.__super) do
                    if v.IsA(Base) then
                        return true
                    end
                end

                return false
            end

            class_type.Super = {}

            if class_type.__super.n > 0 then
                setmetatable(
                    class_type.Super,
                    {
                        __index = function(_, k)
                            local file = string.match(debug.getinfo(3, "S")["short_src"], ".+/([^/]+)(%.%w+)$")

                            local iclass

                            local Queue = {class_type}

                            while #Queue > 0 do
                                local cclass = table.remove(Queue, 1)

                                if file == cclass.__cname then
                                    iclass = cclass

                                    break
                                else
                                    for _, v in ipairs(cclass.__super) do
                                        table.insert(Queue, v)
                                    end
                                end
                            end

                            if iclass then
                                Queue = {}

                                for _, v in ipairs(iclass.__super) do
                                    table.insert(Queue, v)
                                end

                                while #Queue > 0 do
                                    local _class = table.remove(Queue, 1)

                                    local value = _class[k]

                                    if value then
                                        return value
                                    else
                                        for _, v in ipairs(_class.__super) do
                                            table.insert(Queue, v)
                                        end
                                    end
                                end
                            end

                            return nil
                        end
                    }
                )
            end

            local _new = function(...)
                _G.Classs[classname].total = _G.Classs[classname].total + 1

                _G.Classs[classname].count = _G.Classs[classname].count + 1

                local object = {}

                object.__class_type = class_type

                object.bIsDeleted = false

                object.Super = {}

                if class_type.__super.n > 0 then
                    setmetatable(
                        object.Super,
                        {
                            __index = function(_, k)
                                local value = {class_type.Super[k]}

                                assert(#value > 0 and _G.IsCallable(value[1]))

                                setmetatable(
                                    value,
                                    {
                                        __call = function(_, _, ...)
                                            local param = table.pack(...)

                                            local _, result =
                                                xpcall(
                                                value[1],
                                                _G.CallBackError,
                                                object,
                                                table.unpack(param)
                                            )

                                            return result
                                        end
                                    }
                                )

                                return value
                            end
                        }
                    )
                end

                setmetatable(
                    object,
                    {
                        __index = __class[class_type],
                        __gc = function(this)
                            if _G.IsCallable(this.Delete) then
                                this:Delete()
                            end
                        end
                    }
                )

                do
                    local tb = {}

                    local _init

                    _init = function(class, ...)
                        if class.__super then
                            for _, v in ipairs(class.__super) do
                                if tb[v] == nil then
                                    _init(v, ...)

                                    tb[v] = true
                                end
                            end
                        end

                        if class.__init then
                            class.__init(object, ...)
                        end
                    end

                    _init(class_type, ...)

                    tb = nil
                end

                do
                    local tb = {}

                    local _create

                    _create = function(class, ...)
                        if class.__super then
                            for _, v in ipairs(class.__super) do
                                if tb[v] == nil then
                                    _create(v, ...)

                                    tb[v] = true
                                end
                            end
                        end

                        if class.__create then
                            class.__create(object, ...)
                        end
                    end

                    _create(class_type, ...)

                    tb = nil
                end

                local _delete

                _delete = function(class, tb)
                    local iclass = class

                    tb = tb or {}

                    while iclass do
                        if tb[iclass] then
                            break
                        end

                        if iclass.__delete then
                            iclass.__delete(object)

                            tb[iclass] = true
                        end

                        if iclass.__super then
                            for i = #iclass.__super, 1, -1 do
                                local v = iclass.__super[i]

                                if v and tb[v] == nil then
                                    _delete(v, tb)

                                    tb[v] = true
                                end
                            end
                        end

                        iclass = iclass.__super
                    end
                end

                object.Delete = function(this)
                    this.bIsDeleted = this.bIsDeleted or false

                    if not this.bIsDeleted then
                        _G.Classs[classname].count = _G.Classs[classname].count - 1

                        _delete(this.__class_type)

                        this.bIsDeleted = true
                    end
                end

                object.IsA = function(this, ClassType)
                    return this.__class_type.IsA(ClassType)
                end

                return object
            end

            local vtbl = {}

            __class[class_type] = vtbl

            setmetatable(
                class_type,
                {
                    __index = vtbl,
                    __newindex = function(_, k, v)
                        vtbl[k] = v
                    end,
                    __call = function(_, ...)
                        return _new(...)
                    end
                }
            )

            if class_type.__super.n > 0 then
                setmetatable(
                    vtbl,
                    {
                        __index = function(_, k)
                            for _, v in ipairs(class_type.__super) do
                                if v[k] then
                                    return v[k]
                                end
                            end

                            return nil
                        end
                    }
                )
            end

            return class_type
        end
    }
)

return Class
