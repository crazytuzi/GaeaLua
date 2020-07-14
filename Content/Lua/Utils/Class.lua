local assert = assert
local setmetatable = setmetatable

-- 保存类类型的虚表
local _class = {}

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
    class_type.__delete = false
    class_type.__cname = classname
    class_type.__ctype = _G.ClassType.class

    class_type.super = table.pack(...)

    class_type.IsA = function(BaseClass)
        for _, v in ipairs(class_type.super) do
            if v == BaseClass then
                return true
            end
        end

        return false
    end

    class_type.New = function(...)
        -- 生成一个类对象
        local obj = {}
        obj._class_type = class_type
        obj.__ctype = _G.ClassType.instance

        -- 在初始化之前注册基类方法
        setmetatable(
            obj,
            {
                __index = _class[class_type]
            }
        )

        -- 调用初始化方法
        do
            local tb = {}

            local _create

            _create = function(c, ...)
                if c.super then
                    for _, v in ipairs(c.super) do
                        if tb[v] == nil then
                            _create(v, ...)

                            tb[v] = true
                        end
                    end
                end

                if c.__init then
                    c.__init(obj, ...)
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

                if now.super then
                    for i = #now.super, 1, -1 do
                        local v = now.super[i]

                        if v and tb[v] == nil then
                            _delete(v, tb)

                            tb[v] = true
                        end
                    end
                end

                now = now.super
            end
        end

        -- 注册一个delete方法
        obj.Delete = function(self)
            _delete(self._class_type)
        end

        -- 注册一个IsA方法
        obj.IsA = function(self, ClassType)
            return self._class_type.IsA(ClassType)
        end

        return obj
    end

    local vtbl = {}

    _class[class_type] = vtbl

    setmetatable(
        class_type,
        {
            __index = vtbl,
            __newindex = function(_, k, v)
                vtbl[k] = v
            end
        }
    )

    if class_type.super then
        setmetatable(
            vtbl,
            {
                __index = function(_, k)
                    for _, v in ipairs(class_type.super) do
                        if _class[v][k] then
                            return _class[v][k]
                        end
                    end

                    return nil
                end
            }
        )
    end

    return class_type
end
