return {
    ExecuteConsoleCommand = function(Command, ...)
        _G.UKismetSystemLibrary.ExecuteConsoleCommand(_G.GetContextObject(), Command, nil, ...)
    end
}
