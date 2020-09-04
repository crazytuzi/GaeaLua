// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/CheatManager.h"
#include "GaeaCheatManager.generated.h"

/**
 * 
 */
UCLASS()
class GAEA_API UGaeaCheatManager : public UCheatManager
{
	GENERATED_BODY()

	UFUNCTION(Exec)
    void ShowGM() const;
};
