// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "GaeaDispatcher.h"
#include "GaeaEventSubsystem.generated.h"

/**
 * 
 */
UCLASS()
class GAEA_API UGaeaEventSubsystem : public UGameInstanceSubsystem
{
    GENERATED_BODY()

public:
    void Initialize(FSubsystemCollectionBase& Collection) override;

    void Deinitialize() override;

    UGaeaDispatcher* GetGlobalDispatcher() const;

private:
    UPROPERTY()
    UGaeaDispatcher* GlobalDispatcher;
};
