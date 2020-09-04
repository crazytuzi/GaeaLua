// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/PlayerController.h"
#include "GaeaPlayerController.generated.h"

/**
 * 
 */
UCLASS()
class GAEA_API AGaeaPlayerController : public APlayerController
{
    GENERATED_UCLASS_BODY()

public:
    virtual void BeginPlay() override;
};
