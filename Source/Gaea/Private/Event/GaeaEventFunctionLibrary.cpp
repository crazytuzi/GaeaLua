// Fill out your copyright notice in the Description page of Project Settings.


#include "GaeaEventFunctionLibrary.h"

#define EVENTPARAM_STR(Str) #Str

#define EVENTPARAM_GET_FUN(Type) GetEventParam##Type

#define EVENTPARAM_GET_FUN_NAME(Type) case EEventParamType::EEventParamType_##Type: return FName(EVENTPARAM_STR(GetEventParam##Type));

#define EVENTPARAM_GET(Type)\
Type UGaeaEventFunctionLibrary::EVENTPARAM_GET_FUN(Type)(const FEventParam& Param)\
{\
return Param.GetEventParam<Type>();\
}

#define EVENTPARAM_SET_FUN(Type) SetEventParam##Type

#define EVENTPARAM_SET_FUN_NAME(Type) case EEventParamType::EEventParamType_##Type: return FName(EVENTPARAM_STR(SetEventParam##Type));

#define EVENTPARAM_SET(Type)\
void UGaeaEventFunctionLibrary::EVENTPARAM_SET_FUN(Type)(FEventParam& Param, Type Value)\
{\
    Param.SetEventParam<Type>(Value);\
}

#define EVENTPARAM_ACCESSORS(Type)\
        EVENTPARAM_GET(Type)\
        EVENTPARAM_SET(Type)

EVENTPARAM_ACCESSORS(FString)

EVENTPARAM_ACCESSORS(bool)

EVENTPARAM_ACCESSORS(int8)

EVENTPARAM_ACCESSORS(uint8)

EVENTPARAM_ACCESSORS(int32)

EVENTPARAM_ACCESSORS(uint32)

EVENTPARAM_ACCESSORS(int64)

EVENTPARAM_ACCESSORS(uint64)

EVENTPARAM_ACCESSORS(float)

uint64 UGaeaEventFunctionLibrary::GetEventParamRawPointer(const FEventParam& Param)
{
    return Param.GetEventParam<uint64>();
}

void UGaeaEventFunctionLibrary::SetEventParamRawPointer(FEventParam& Param, uint64 Value)
{
    Param.SetEventParam<void*>(reinterpret_cast<void*>(Value));
}

UObject* UGaeaEventFunctionLibrary::GetEventParamUObject(const FEventParam& Param)
{
    return Param.GetEventParam<UObject*>();
}

void UGaeaEventFunctionLibrary::SetEventParamUObject(FEventParam& Param, UObject* Value)
{
    Param.SetEventParam<UObject*>(Value);
}

FName UGaeaEventFunctionLibrary::GetGFunNameByType(const EEventParamType Type)
{
    switch (Type)
    {
    EVENTPARAM_GET_FUN_NAME(FString)
    EVENTPARAM_GET_FUN_NAME(bool)
    EVENTPARAM_GET_FUN_NAME(int8)
    EVENTPARAM_GET_FUN_NAME(uint8)
    EVENTPARAM_GET_FUN_NAME(int32)
    EVENTPARAM_GET_FUN_NAME(uint32)
    EVENTPARAM_GET_FUN_NAME(int64)
    EVENTPARAM_GET_FUN_NAME(uint64)
    EVENTPARAM_GET_FUN_NAME(float)
    EVENTPARAM_GET_FUN_NAME(UObject)
    EVENTPARAM_GET_FUN_NAME(RawPointer)
    default:
        return FName("");
    }
}

FName UGaeaEventFunctionLibrary::GetSFunNameByType(const EEventParamType Type)
{
    switch (Type)
    {
    EVENTPARAM_SET_FUN_NAME(FString)
    EVENTPARAM_SET_FUN_NAME(bool)
    EVENTPARAM_SET_FUN_NAME(int8)
    EVENTPARAM_SET_FUN_NAME(uint8)
    EVENTPARAM_SET_FUN_NAME(int32)
    EVENTPARAM_SET_FUN_NAME(uint32)
    EVENTPARAM_SET_FUN_NAME(int64)
    EVENTPARAM_SET_FUN_NAME(uint64)
    EVENTPARAM_SET_FUN_NAME(float)
    EVENTPARAM_SET_FUN_NAME(UObject)
    EVENTPARAM_SET_FUN_NAME(RawPointer)
    default:
        return FName("");
    }
}

uint32 UGaeaEventFunctionLibrary::GetEventParamNum(const FEventParamWrap& EventParamWrap)
{
    return EventParamWrap.Num();
}

FEventParam UGaeaEventFunctionLibrary::GetEventParamByIndex(const FEventParamWrap& EventParamWrap,
                                                            const int32 ParamIndex)
{
    return EventParamWrap.Get(ParamIndex);
}

TArray<FEventParam> UGaeaEventFunctionLibrary::ConstructEventParamTArray()
{
    return TArray<FEventParam>();
}
