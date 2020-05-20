// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GaeaDispatcher.h"
#include "ObjectMacros.h"
#include "Kismet/BlueprintFunctionLibrary.h"
#include "GaeaEventFunctionLibrary.generated.h"

/**
 * 
 */
UCLASS()
class GAEA_API UGaeaEventFunctionLibrary : public UBlueprintFunctionLibrary
{
    GENERATED_BODY()

public:
    UFUNCTION()
    static FString GetEventParamFString(const FEventParam& Param);

    UFUNCTION()
    static void SetEventParamFString(FEventParam& Param, FString Value);

    UFUNCTION()
    static bool GetEventParambool(const FEventParam& Param);

    UFUNCTION()
    static void SetEventParambool(FEventParam& Param, bool Value);

    UFUNCTION()
    static int8 GetEventParamint8(const FEventParam& Param);

    UFUNCTION()
    static void SetEventParamint8(FEventParam& Param, int8 Value);

    UFUNCTION()
    static uint8 GetEventParamuint8(const FEventParam& Param);

    UFUNCTION()
    static void SetEventParamuint8(FEventParam& Param, uint8 Value);

    UFUNCTION()
    static int32 GetEventParamint32(const FEventParam& Param);

    UFUNCTION()
    static void SetEventParamint32(FEventParam& Param, int32 Value);

    UFUNCTION()
    static uint32 GetEventParamuint32(const FEventParam& Param);

    UFUNCTION()
    static void SetEventParamuint32(FEventParam& Param, uint32 Value);

    UFUNCTION()
    static int64 GetEventParamint64(const FEventParam& Param);

    UFUNCTION()
    static void SetEventParamint64(FEventParam& Param, int64 Value);

    UFUNCTION()
    static uint64 GetEventParamuint64(const FEventParam& Param);

    UFUNCTION()
    static void SetEventParamuint64(FEventParam& Param, uint64 Value);

    UFUNCTION()
    static float GetEventParamfloat(const FEventParam& Param);

    UFUNCTION()
    static void SetEventParamfloat(FEventParam& Param, float Value);

    UFUNCTION()
    static uint64 GetEventParamRawPointer(const FEventParam& Param);

    UFUNCTION()
    static void SetEventParamRawPointer(FEventParam& Param, uint64 Value);

    UFUNCTION()
    static UObject* GetEventParamUObject(const FEventParam& Param);

    UFUNCTION()
    static void SetEventParamUObject(FEventParam& Param, UObject* Value);

    UFUNCTION()
    static FName GetGFunNameByType(EEventParamType Type);

    UFUNCTION()
    static FName GetSFunNameByType(EEventParamType Type);

    UFUNCTION()
    static uint32 GetEventParamNum(const FEventParamWrap& EventParamWrap);

    UFUNCTION()
    static FEventParam GetEventParamByIndex(const FEventParamWrap& EventParamWrap, int32 ParamIndex);

    UFUNCTION()
    static TArray<FEventParam> ConstructEventParamTArray();
};
