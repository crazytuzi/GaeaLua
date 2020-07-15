local Resource = _G.Class("Resource")

local function __init(self)
    self._data = {}
end

Resource.__init = __init

local Resources = Resource.New()

function _G.GetResource(Path)
    local success, result = _G.xpcall(Path.CallBack, _G.CallBackError, Path.Path)

    if success then
        return result
    else
        return nil
    end
end

local _ENV = {
    _G = _ENV._G
}

_G.setmetatable(
    _ENV,
    {
        __index = function(_, k)
            local v = _G[k]

            if v == nil then
                return k
            end

            return v
        end
    }
)

local ResourceLoader = _G.Class("ResourceLoader")

local function __initLoader(self, ResourceClass)
    self.ResourceClass = ResourceClass
end

local function LoadObject(self, Path)
    if not self.ResourceClass then
        _G.Logger.warn("ResourceLoader.LoadObject => self.ResourceClass is not valid")
        return nil
    end

    local Object = _G.slua.loadObject(Path)

    if not _G.IsUValid(Object) then
        _G.Logger.warn("ResourceLoader.LoadObject => Object is not valid")
        return nil
    end

    if not Object:IsA(self.ResourceClass) then
        _G.Logger.warn("ResourceLoader.LoadObject => Object class is not match")
        return nil
    end

    return Object
end

local function Init(self)
    _G.setmetatable(
        self,
        {
            __call = LoadObject
        }
    )
end

ResourceLoader.__init = __initLoader
ResourceLoader.Init = Init

_ENV.GenerateResourceType = function(ResourceType, ClassType)
    if _G.type(ResourceType) ~= "string" then
        _G.Logger.warn("GenerateResourceType => ResourceType is already exist")
        return
    end

    local Loader

    if _G.IsCallable(ClassType) then
        Loader = ClassType
    else
        Loader = ResourceLoader.New(ClassType)

        Loader:Init()
    end

    local ResourceTable = {}

    _G.setmetatable(
        ResourceTable,
        {
            __newindex = function(_, k, v)
                if _G.rawget(Resources._data, k) then
                    _G.Logger.warn("GenerateResourceType => key is already exist")
                    return
                end

                _G.rawset(Resources._data, k, {CallBack = Loader, Path = v})
            end
        }
    )

    _G.rawset(_ENV, ResourceType, ResourceTable)
end

-- Start for Type
GenerateResourceType(UMG, _G.slua.loadUI)

GenerateResourceType(Image, _G.import("Texture2D"))

-- Stop for Type

-- Start for Path

UMG.UIPanelItemBase = "/Game/UI/Test/UIPanelItemBase.UIPanelItemBase"

Image.YuigahamaYui = "/Game/UI/Test/YuigahamaYui"
Image.YukinoshitaYukino = "/Game/UI/Test/YukinoshitaYukino"

-- Stop for Path

_G.setmetatable(
    Resources,
    {
        __index = function(t, k)
            return _G.rawget(t._data, k)
        end,
        __newindex = function()
            _G.Logger.warn("Don't Set ResourcePath, config in Resources")
        end
    }
)

return Resources
