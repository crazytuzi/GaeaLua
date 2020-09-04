// Fill out your copyright notice in the Description page of Project Settings.


#include "Player/GaeaCheatManager.h"
#include "Common/GaeaFunctionLibrary.h"
#include "Subsystem/GaeaUISubsystem.h"

void UGaeaCheatManager::ShowGM() const
{
    const auto UISubsystem = UGaeaFunctionLibrary::GetSubsystem<UGaeaUISubsystem>(this);

    if (UISubsystem != nullptr)
    {
        UISubsystem->ShowUI("GM");
    }
}
