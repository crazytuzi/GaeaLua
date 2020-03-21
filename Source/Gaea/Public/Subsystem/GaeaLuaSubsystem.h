// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "LuaState.h"
#include "GaeaLuaSubsystem.generated.h"

#ifndef LUA_MAIN_FILE
#define LUA_MAIN_FILE "main"
#endif

#ifndef LUA_MAIN_FUNCTION
#define LUA_MAIN_FUNCTION "main"
#endif

/**
 * 
 */
UCLASS()
class GAEA_API UGaeaLuaSubsystem : public UGameInstanceSubsystem
{
	GENERATED_BODY()

public:
	void Initialize(FSubsystemCollectionBase& Collection) override;

	void Deinitialize() override;

	void Start();

private:
	bool bHasInit;

	bool bHasStart;

	NS_SLUA::LuaState State;

	void RegisterGlobalMethod();

	void RegisterExtensionMethod();

	FORCEINLINE bool HasReady() const
	{
		return bHasInit && bHasStart;
	}
};
