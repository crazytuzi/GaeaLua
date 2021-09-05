// Fill out your copyright notice in the Description page of Project Settings.


#include "Player/GaeaCheatManager.h"
#include "Common/GaeaFunctionLibrary.h"
#include "Subsystem/GaeaLuaSubsystem.h"
#include "Subsystem/GaeaUISubsystem.h"

void UGaeaCheatManager::ShowGM() const
{
    if (const auto UISubsystem = UGaeaFunctionLibrary::GetSubsystem<UGaeaUISubsystem>(this))
    {
        UISubsystem->ShowUI("GM");
    }
}

void UGaeaCheatManager::Do(const FString& Str) const
{
    if (const auto LuaSubsystem = UGaeaFunctionLibrary::GetSubsystem<UGaeaLuaSubsystem>(this))
    {
        LuaSubsystem->DoString(TCHAR_TO_UTF8(*Str));
    }
}
