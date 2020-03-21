// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Engine/LevelScriptActor.h"
#include "GaeaLevelScriptActor.generated.h"

/**
 * 
 */
UCLASS()
class GAEA_API AGaeaLevelScriptActor : public ALevelScriptActor
{
	GENERATED_BODY()

public:
	void BeginPlay() override;

	void Destroyed() override;
};
