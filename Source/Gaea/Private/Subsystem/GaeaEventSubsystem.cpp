// Fill out your copyright notice in the Description page of Project Settings.


#include "GaeaEventSubsystem.h"
#include "Engine/World.h"

void UGaeaEventSubsystem::Initialize(FSubsystemCollectionBase& Collection)
{
    Super::Initialize(Collection);

    GlobalDispatcher = NewObject<UGaeaDispatcher>(this);
}

void UGaeaEventSubsystem::Deinitialize()
{
    if (GlobalDispatcher != nullptr)
    {
        GlobalDispatcher->Clear();

        GlobalDispatcher = nullptr;
    }

    Super::Deinitialize();
}

UGaeaDispatcher* UGaeaEventSubsystem::GetGlobalDispatcher() const
{
    return GlobalDispatcher;
}
