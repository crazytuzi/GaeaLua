// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "Event/GaeaDispatcher.h"
#include "GaeaEventSubsystem.generated.h"

/**
 * 
 */
UCLASS()
class GAEA_API UGaeaEventSubsystem : public UGameInstanceSubsystem
{
    GENERATED_BODY()

public:
    virtual void Initialize(FSubsystemCollectionBase& Collection) override;

    virtual void Deinitialize() override;

    UGaeaDispatcher* GetGlobalDispatcher() const;

private:
    UPROPERTY()
    UGaeaDispatcher* GlobalDispatcher;
};
