local assert = assert
local setmetatable = setmetatable

-- 保存类类型的虚表
local __class = {}

-- 自定义类型
_G.ClassType = {
    class = 1,
    instance = 2
}

function _G.Class(classname, ...)
    assert(type(classname) == "string" and #classname > 0)

    -- 生成一个类类型
    local class_type = {}

    -- 在创建对象的时候自动调用
    class_type.__init = false
    class_type.__create = false
    class_type.__delete = false
    class_type.__cname = classname
    class_type.__ctype = _G.ClassType.class
    class_type.__super = table.pack(...)

    class_type.IsA = function(BaseClass)
        if class_type == BaseClass then
            return true
        end
        for _, v in ipairs(class_type.__super) do
            if v.IsA(BaseClass) then
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
                    for _, v in ipairs(class_type.__super) do
                        if #v.__super == 0 then
                            return __class[v][k]
                        else
                            for _, vv in ipairs(v.__super) do
                                if __class[vv][k] then
                                    return __class[vv][k]
                                end
                            end
                        end
                    end

                    return nil
                end
            }
        )
    end

    class_type.New = function(...)
        -- 生成一个类对象
        local obj = {}

        obj.__initing = true
        obj.__class_type = class_type
        obj.__ctype = _G.ClassType.instance

        obj.Super = {}

        if obj.__class_type.__super.n > 0 then
            setmetatable(
                obj.Super,
                {
                    __index = function(_, k)
                        local value = nil

                        if obj.__initing then
                            for _, v in ipairs(class_type.__super) do
                                if __class[v][k] then
                                    value = {__class[v][k]}

                                    break
                                end
                            end
                        else
                            value = {obj.__class_type.Super[k]}
                        end

                        if value and #value > 0 then
                            setmetatable(
                                value,
                                {
                                    __call = function(_, ...)
                                        local param = table.pack(...)

                                        if param[1] == obj.Super then
                                            table.remove(param, 1)

                                            local _, result =
                                                xpcall(value[1], _G.CallBackError, obj, table.unpack(param))

                                            return result
                                        else
                                            local _, result = xpcall(value[1], _G.CallBackError, ...)

                                            return result
                                        end
                                    end
                                }
                            )
                        end

                        return value
                    end
                }
            )
        end

        -- 在初始化之前注册基类方法
        setmetatable(
            obj,
            {
                __index = __class[class_type],
                __gc = function(this)
                    this:Delete()
                end
            }
        )

        -- 调用初始化方法
        do
            local tb = {}

            local _init

            _init = function(c, ...)
                if c.__super then
                    for _, v in ipairs(c.__super) do
                        if tb[v] == nil then
                            _init(v, ...)

                            tb[v] = true
                        end
                    end
                end

                if c.__init then
                    c.__init(obj, ...)
                end
            end

            _init(class_type, ...)

            tb = nil
        end

        do
            local tb = {}

            local _create

            _create = function(c, ...)
                if c.__super then
                    for _, v in ipairs(c.__super) do
                        if tb[v] == nil then
                            _create(v, ...)

                            tb[v] = true
                        end
                    end
                end

                if c.__create then
                    c.__create(obj, ...)
                end
            end

            _create(class_type, ...)

            tb = nil
        end

        local _delete

        _delete = function(class, tb)
            local now = class

            tb = tb or {}

            while now do
                if tb[now] then
                    break
                end

                if now.__delete then
                    now.__delete(obj)

                    tb[now] = true
                end

                if now.__super then
                    for i = #now.__super, 1, -1 do
                        local v = now.__super[i]

                        if v and tb[v] == nil then
                            _delete(v, tb)

                            tb[v] = true
                        end
                    end
                end

                now = now.__super
            end
        end

        -- 注册一个delete方法
        obj.Delete = function(self)
            self.bIsDeleted = self.bIsDeleted or false

            if not self.bIsDeleted then
                _delete(self.__class_type)

                self.bIsDeleted = true
            end
        end

        -- 注册一个IsA方法
        obj.IsA = function(self, ClassType)
            return self.__class_type.IsA(ClassType)
        end

        obj.__initing = nil

        return obj
    end

    local vtbl = {}

    __class[class_type] = vtbl

    setmetatable(
        class_type,
        {
            __index = vtbl,
            __newindex = function(_, k, v)
                vtbl[k] = v
            end
        }
    )

    if class_type.__super.n > 0 then
        setmetatable(
            vtbl,
            {
                __index = function(_, k)
                    for _, v in ipairs(class_type.__super) do
                        if __class[v][k] then
                            return __class[v][k]
                        end
                    end

                    return nil
                end
            }
        )
    end

    return class_type
end
