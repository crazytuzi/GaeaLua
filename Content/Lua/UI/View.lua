local View = _G.Class("View")

local function __index(t, k)
    local value = View[k]

    if value then
        return value
    end

    local CacheTable = rawget(t, "_widgetCache")

    if not CacheTable then
        return nil
    end

    value = CacheTable[k]

    if not value then
        local root = rawget(t, "_uiRoot")

        if not _G.IsValid(root) then
            return nil
        end

        value = root:FindWidget(k .. "_lua")

        if not value then
            value = root[k]
        end

        if _G.IsValid(value) and value:IsA(_G.UUserWidget) then
            value = View(value)
        end

        CacheTable[k] = value
    end

    return value
end

local function __init(self, Widget)
    self._uiRoot = Widget

    self._widgetCache = {}

    self:OnInit()
end

local function __create(self)
    setmetatable(
        self,
        {
            __index = __index
        }
    )
end

local function __delete(self)
    self:OnDispose()

    for _, value in pairs(self._widgetCache) do
        if value and type(value) == "table" and _G.IsCallable(value.IsA) and value:IsA(View) then
            value:Delete()
        end
    end

    self._widgetCache = {}

    self._uiRoot = nil
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

View.__init = __init
View.__create = __create
View.__delete = __delete
View.OnInit = OnInit
View.OnDispose = OnDispose
View.FindWidget = FindWidget
View.SetVisibility = SetVisibility
View.RemoveFromParent = RemoveFromParent
View.GetRoot = GetRoot
View.IsValid = IsValid

return View
