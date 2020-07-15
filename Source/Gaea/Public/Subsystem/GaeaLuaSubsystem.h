// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "LuaState.h"
#include "GaeaLuaSubsystem.generated.h"

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

    slua::LuaVar GetVar(const char* Key);

    static const char* Config;

private:
    bool bHasInit;

    bool bHasStart;

    NS_SLUA::LuaState State;

    static const char* MainFile;

    static const char* MainFunction;

    void RegisterGlobalMethod();

    static void RegisterExtensionMethod();

    FORCEINLINE bool HasReady() const
    {
        return bHasInit && bHasStart;
    }
};
