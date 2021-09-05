local import = _G.import

-- Import From Engine --
_G.ESlateVisibility = import("ESlateVisibility")
-- Import From Engine --

-- Import From Project --
_G.EEventParamType = import("EEventParamType")
_G.EGaeaUILayer = import("EGaeaUILayer")
-- Import From Project --

-- Enums only used in Lua --
_G.EWidgetEvent = {
    Button = {
        OnClicked = "OnClicked",
        OnPressed = "OnPressed",
        OnReleased = "OnReleased",
        OnHovered = "OnHovered",
        OnUnhovered = "OnUnhovered"
    }
}

_G.EManagerMode = {
    All = 0,
    DedicatedServer = 1,
    Clent = 2
}
-- Enums only used in Lua --
