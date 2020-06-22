ViewBase = _G.Class("ViewBase")

function ViewBase:__init(Widget)
    self._uiRoot = Widget

    self._widgetCache = {}

    self:OnInit()
end

function ViewBase:__delete()
    self:OnDispose()

    self._widgetCache = {}

    self._uiRoot = nil
end

function ViewBase:Init()
    setmetatable(
        self,
        {
            __index = function(t, k)
                local value = ViewBase[k]

                if value then
                    return value
                end

                local CacheTable = rawget(t, "_widgetCache")

                if not CacheTable then
                    Logger.warn("ViewBase.__index => CacheTable is not valid")
                    return nil
                end

                value = CacheTable[k]

                if not value then
                    local root = rawget(t, "_uiRoot")

                    if not _G.IsUValid(root) then
                        Logger.warn("ViewBase.__index => uiRoot not valid")
                        return nil
                    end

                    value = root:FindWidget(k .. "_lua")

                    CacheTable[k] = value
                end

                return value
            end
        }
    )
end

function ViewBase:OnInit()
    -- You need to override this function
end

function ViewBase:OnDispose()
    -- You can override this function
end

function ViewBase:FindWidget(WidgetName)
    if not _G.IsUValid(self._uiRoot) then
        return nil
    end

    return self._uiRoot:FindWidget(WidgetName)
end

function ViewBase:IsValid()
    return _G.IsUValid(self._uiRoot)
end
