local Logger = require "Logger/Logger"

function _G.CallBackError(e)
    if _G.IsStringNullOrEmpty(e) then
        e = "None"
    end

    Logger.warn("CallBackError => " .. e .. "\n", 3)
end

function _G.IsValid(Object)
    if type(Object) ~= "userdata" then
        return false
    end

    return _G.slua.isValid(Object)
end

function _G.SetCanvasSlotPosition(Slot, Position)
    local CanvasSlot = _G.UWidgetLayoutLibrary.SlotAsCanvasSlot(Slot)

    if _G.IsValid(CanvasSlot) then
        CanvasSlot:SetPosition(Position)
    else
        Logger.warn("SetCanvasSlotPosition => CanvasSlot is not valid")
    end
end

function _G.SetWidgetVisibility(Widget, IsVisible)
    if _G.IsValid(Widget) then
        if IsVisible == nil then
            IsVisible = false
        end

        if IsVisible == true or IsVisible == false then
            IsVisible = (IsVisible and _G.ESlateVisibility.Visible) or _G.ESlateVisibility.Collapsed
        end

        local Visibility = Widget:GetVisibility()

        if IsVisible ~= Visibility then
            Widget:SetVisibility(IsVisible)
        end
    else
        Logger.warn("SetWidgetVisibility => Widget is not valid")
    end
end

function _G.GetLocalPlayerController()
    return _G.UGameplayStatics.GetPlayerController(_G.GetContextObject(), 0)
end

function _G.GetLocalPlayerPawn()
    return _G.UGameplayStatics.GetPlayerPawn(_G.GetContextObject(), 0)
end

function _G.GetPlayerCharacter()
    return _G.UGameplayStatics.GetPlayerCharacter(_G.GetContextObject(), 0)
end
