local ViewBase = _G.Class("ViewBase")

local function __init(self, Widget)
    self._uiRoot = Widget

    self._widgetCache = {}

    self:OnInit()
end

local function __delete(self)
    self:OnDispose()

    self._widgetCache = {}

    self._uiRoot = nil
end

local function __index(t, k)
    local value = ViewBase[k]

    if value then
        return value
    end

    local CacheTable = rawget(t, "_widgetCache")

    if not CacheTable then
        _G._Logger.warn("ViewBase.__index => CacheTable is not valid")
        return nil
    end

    value = CacheTable[k]

    if not value then
        local root = rawget(t, "_uiRoot")

        if not _G.IsValid(root) then
            _G._Logger.warn("ViewBase.__index => uiRoot not valid")
            return nil
        end

        value = root:FindWidget(k .. "_lua")

        CacheTable[k] = value
    end

    return value
end

local function Init(self)
    setmetatable(
        self,
        {
            __index = __index
        }
    )
end

local function OnInit()
    -- You need to override this function
end

local function OnDispose()
    -- You can override this function
end

local function FindWidget(self, WidgetName)
    if not _G.IsValid(self._uiRoot) then
        return nil
    end

    return self._uiRoot:FindWidget(WidgetName)
end

local function SetVisibility(self, bIsVisible)
    if self:IsValid() then
        self._uiRoot:SetVisibility(bIsVisible)
    end
end

local function RemoveFromParent(self)
    if self:IsValid() then
        self._uiRoot:RemoveFromParent()
    end
end

local function GetRoot(self)
    return self._uiRoot
end

local function IsValid(self)
    return _G.IsValid(self._uiRoot)
end

ViewBase.__init = __init
ViewBase.__delete = __delete
ViewBase.Init = Init
ViewBase.OnInit = OnInit
ViewBase.OnDispose = OnDispose
ViewBase.FindWidget = FindWidget
ViewBase.SetVisibility = SetVisibility
ViewBase.RemoveFromParent = RemoveFromParent
ViewBase.GetRoot = GetRoot
ViewBase.IsValid = IsValid

return ViewBase
