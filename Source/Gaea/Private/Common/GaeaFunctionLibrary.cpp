// Fill out your copyright notice in the Description page of Project Settings.


#include "Common/GaeaFunctionLibrary.h"
#include "Subsystems/SubsystemBlueprintLibrary.h"
#include "Subsystem/GaeaEventSubsystem.h"

UGameInstanceSubsystem* UGaeaFunctionLibrary::GetGameInstanceSubsystem(UObject* WorldContextObject,
                                                                       const TSubclassOf<UGameInstanceSubsystem> Class)
{
    return USubsystemBlueprintLibrary::GetGameInstanceSubsystem(WorldContextObject, Class);
}

UGaeaDispatcher* UGaeaFunctionLibrary::GetGlobalDispatcher(const UObject* WorldContextObject)
{
    const auto EventSubsystem = GetSubsystem<UGaeaEventSubsystem>(WorldContextObject);

    if (EventSubsystem != nullptr)
    {
        return EventSubsystem->GetGlobalDispatcher();
    }
    else
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaFunctionLibrary::GetGlobalDispatcher => EventSubsystem is nullptr"));

        return nullptr;
    }
}


