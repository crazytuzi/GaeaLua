function _G.CallBackError(e)
    if _G.IsStringNullOrEmpty(e) then
        e = "None"
    end

    _G.Logger.warn("CallBackError => " .. e .. "\n" .. debug.traceback())
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
        _G.Logger.warn("SetCanvasSlotPosition => CanvasSlot is not valid")
    end
end

function _G.SetWidgetVisibility(Widget, IsVisible)
    if _G.IsValid(Widget) then
        IsVisible = IsVisible or false

        IsVisible = (IsVisible and _G.ESlateVisibility.Visible) or _G.ESlateVisibility.Collapsed

        local Visibility = Widget:GetVisibility()

        if IsVisible ~= Visibility then
            Widget:SetVisibility(IsVisible)
        end
    else
        _G.Logger.warn("SetWidgetVisibility => Widget is not valid")
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
