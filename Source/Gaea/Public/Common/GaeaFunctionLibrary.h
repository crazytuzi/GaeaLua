// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Kismet/BlueprintFunctionLibrary.h"
#include "Kismet/GameplayStatics.h"
#include "GaeaGameInstance.h"
#include "GaeaFunctionLibrary.generated.h"

/**
 * 
 */
UCLASS()
class GAEA_API UGaeaFunctionLibrary : public UBlueprintFunctionLibrary
{
	GENERATED_BODY()

public:
	template <typename T>
	static T* GetSubsystem(const UObject* WorldContextObject)
	{
		const auto GameInstance = Cast<UGaeaGameInstance>(UGameplayStatics::GetGameInstance(WorldContextObject));

		if (GameInstance != nullptr)
		{
			return GameInstance->GetSubsystem<T>();
		}

		UE_LOG(LogTemp, Warning, TEXT("UGaeaFunctionLibrary::GetSubsystem => GameInstance is nullptr"));

		return nullptr;
	}
};
