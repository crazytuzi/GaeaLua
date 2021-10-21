local Class = require "Utils/Class"

local Logger = require "Logger/Logger"

local function GetResource(Path)
    local success, result = _G.xpcall(Path.CallBack, _G.CallBackError, Path.Path)

    if success then
        return result
    else
        return nil
    end
end

local Resources = Class("Resources")

local function __register(self)
    _G.setmetatable(
        Resources,
        {
            __index = function(_, k)
                local v = _G.rawget(self, k)

                if v then
                    return v
                else
                    v = _G.rawget(self, "data")

                    if v then
                        return v[k]
                    end
                end

                return nil
            end,
            __newindex = function()
                Logger.warn("Don't Set ResourcePath, config in Resources")
            end
        }
    )
end

_G.rawset(Resources, "data", {})
_G.rawset(Resources, "GetResource", GetResource)
_G.rawset(Resources, "__register", __register)

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

local ResourceLoader = Class("ResourceLoader")

local function __init(self, ResourceClass)
    self.ResourceClass = ResourceClass
end

local function LoadObject(self, Path)
    if not self.ResourceClass then
        Logger.warn("ResourceLoader.LoadObject => self.ResourceClass is not valid")
        return nil
    end

    local Object = _G.slua.loadObject(Path)

    if not _G.IsValid(Object) then
        Logger.warn("ResourceLoader.LoadObject => Object is not valid")
        return nil
    end

    if not Object:IsA(self.ResourceClass) then
        Logger.warn("ResourceLoader.LoadObject => Object class is not match")
        return nil
    end

    return Object
end

local function __create(self)
    _G.setmetatable(
        self,
        {
            __call = LoadObject
        }
    )
end

ResourceLoader.__init = __init
ResourceLoader.__create = __create

_ENV.GenerateResourceType = function(ResourceType, ClassType)
    if _G.type(ResourceType) ~= "string" then
        Logger.warn("GenerateResourceType => ResourceType is already exist")
        return
    end

    local Loader

    if _G.IsCallable(ClassType) then
        Loader = ClassType
    else
        Loader = ResourceLoader(ClassType)
    end

    local ResourceTable = {}

    _G.setmetatable(
        ResourceTable,
        {
            __newindex = function(_, k, v)
                if _G.rawget(Resources.data, k) then
                    Logger.warn("GenerateResourceType => key is already exist")
                    return
                end

                _G.rawset(Resources.data, k, {CallBack = Loader, Path = v})
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
UMG.UIGMItem = "/Game/UI/GM/UIGMItem.UIGMItem"

Image.YuigahamaYui = "/Game/UI/Test/YuigahamaYui"
Image.YukinoshitaYukino = "/Game/UI/Test/YukinoshitaYukino"

-- Stop for Path

return Resources
