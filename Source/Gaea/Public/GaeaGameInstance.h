// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Engine/GameInstance.h"
#include "GaeaGameInstance.generated.h"

/**
 * 
 */
UCLASS()
class GAEA_API UGaeaGameInstance : public UGameInstance
{
	GENERATED_BODY()

public:
	void Init() override;

	void Shutdown() override;
};
