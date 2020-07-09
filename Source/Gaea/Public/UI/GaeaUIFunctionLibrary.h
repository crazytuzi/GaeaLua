// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Kismet/BlueprintFunctionLibrary.h"
#include "GaeaUIFunctionLibrary.generated.h"

/**
 * 
 */
UCLASS()
class GAEA_API UGaeaUIFunctionLibrary : public UBlueprintFunctionLibrary
{
    GENERATED_BODY()

public:
    UFUNCTION()
    static bool WithInEditor();
};
