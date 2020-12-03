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
    virtual void Initialize(FSubsystemCollectionBase& Collection) override;

    virtual void Deinitialize() override;

    void StartUp();

    void ShutDown();

    slua::LuaVar GetVar(const char* Key);

    static const char* Config;

    template <typename ...ARGS>
    slua::LuaVar Call(const char* Key, ARGS&& ...Args)
    {
        if (!HasReady())
        {
            UE_LOG(LogTemp, Error, TEXT("UGaeaLuaSubsystem::Call => State is not ready"));

            return slua::LuaVar();
        }

        return State.call(Key, Args...);
    }

    FORCEINLINE bool HasReady() const
    {
        return bHasInit && bHasStart;
    }

private:
    bool bHasInit;

    bool bHasStart;

    NS_SLUA::LuaState State;

    static const char* MainFile;

    static const char* MainFunction;

    static const char* TickFunction;

    void RegisterGlobalMethod();

    static void RegisterExtensionMethod();
};
