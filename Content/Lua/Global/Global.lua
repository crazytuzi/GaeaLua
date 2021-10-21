local LuaDispatcher = require "Event/Dispatcher"

local UIManager = require "Manager/UIManager"

local TimerManager = require "Manager/TimerManager"

_G.WITH_EDITOR = _G.UGaeaUIFunctionLibrary.WithInEditor()

_G.INDEX_NONE = -1

_G.Dispatcher = LuaDispatcher(_G.UGaeaFunctionLibrary.GetGlobalDispatcher(_G.GetContextObject()))

_G.UIManager = UIManager

_G.TimerManager = TimerManager
