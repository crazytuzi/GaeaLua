// Fill out your copyright notice in the Description page of Project Settings.


#include "GaeaFunctionLibrary.h"
#include "SubsystemBlueprintLibrary.h"

UGameInstanceSubsystem* UGaeaFunctionLibrary::GetGameInstanceSubsystem(UObject* WorldContextObject,
                                                                       const TSubclassOf<UGameInstanceSubsystem> Class)
{
	return USubsystemBlueprintLibrary::GetGameInstanceSubsystem(WorldContextObject, Class);
}
