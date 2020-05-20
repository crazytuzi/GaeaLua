// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "ObjectMacros.h"
#include "UObject/NoExportTypes.h"
#include "GaeaEvent.h"
#include "GaeaDispatcher.generated.h"


UENUM()
enum class EEventParamType : uint8
{
    EEventParamType_None,
    EEventParamType_bool,
    EEventParamType_int8,
    EEventParamType_uint8,
    EEventParamType_int32,
    EEventParamType_uint32,
    EEventParamType_int64,
    EEventParamType_uint64,
    EEventParamType_float,
    EEventParamType_FString,
    EEventParamType_RawPointer,
    EEventParamType_UObject
};


#define EventParamAccessors(K, V)\
    template<>\
    inline K FEventParam::GetEventParamImp<K>() const\
    {\
        return V;\
    }\
    template<>\
    inline void FEventParam::SetEventParamImp<K>(K k)\
    {\
        V = k;\
        EventParamType = EEventParamType::EEventParamType_##K;\
    }


USTRUCT()
struct FEventParam
{
    GENERATED_BODY()

public:
    UPROPERTY()
    EEventParamType EventParamType = EEventParamType::EEventParamType_None;

    template <typename T>
    std::enable_if_t<!std::is_pointer<T>::value, T> GetEventParam() const
    {
        return GetEventParamImp<T>();
    }

    template <typename T>
    std::enable_if_t<std::is_pointer<T>::value, T> GetEventParam() const
    {
        auto Ptr = GetEventParamImp<void*>();

        return static_cast<T>(Ptr);
    }

    template <typename T>
    void SetEventParam(std::enable_if_t<!std::is_pointer<T>::value, T> Value)
    {
        SetEventParamImp<T>(Value);
    }

    template <typename T>
    void SetEventParam(
        std::enable_if_t<std::is_pointer<T>::value && !std::is_base_of<UObject, std::remove_pointer_t<T>>::value, T>
        Value)
    {
        SetEventParamImp<void*>(Value);
    }

    template <typename T>
    void SetEventParam(
        std::enable_if_t<std::is_pointer<T>::value && std::is_base_of<UObject, std::remove_pointer_t<T>>::value, T>
        Value)
    {
        SetEventParamImp<UObject*>(Value);
    }

private:
    FString sVal;

    union
    {
        bool bVal;

        int8 i8Val;

        uint8 ui8Val;

        int32 i32Val;

        uint32 ui32Val;

        int64 i64Val;

        uint64 ui64Val;

        float fVal;

        void* pointer;
    };

    template <typename T>
    T GetEventParamImp() const
    {
        static_assert(std::is_pointer<T>::value,"This parameter is not registered");

        return T{};
    }

    template <typename T>
    void SetEventParamImp(T)
    {
        static_assert(std::is_pointer<T>::value,"This parameter is not registered");
    }
};


EventParamAccessors(FString, sVal)

EventParamAccessors(bool, bVal)

EventParamAccessors(int8, i8Val)

EventParamAccessors(uint8, ui8Val)

EventParamAccessors(int32, i32Val)

EventParamAccessors(uint32, ui32Val)

EventParamAccessors(int64, i64Val)

EventParamAccessors(uint64, ui64Val)

EventParamAccessors(float, fVal)

template <>
inline void* FEventParam::GetEventParamImp<void*>() const
{
    return pointer;
}

template <>
inline void FEventParam::SetEventParamImp<void*>(void* Value)
{
    pointer = Value;

    EventParamType = EEventParamType::EEventParamType_RawPointer;
}

template <>
inline void FEventParam::SetEventParamImp<UObject*>(UObject* Value)
{
    pointer = Value;

    EventParamType = EEventParamType::EEventParamType_UObject;
}

USTRUCT()
struct FEventParamWrap
{
    GENERATED_BODY()

    using IndexType = size_t;

public:
    /* Don't use default constructor, just for CDO */
    FEventParamWrap(): EventParams(nullptr)
    {
    }

    explicit FEventParamWrap(TArray<FEventParam>& Param): EventParams(&Param)
    {
    }

    FEventParam Get(const IndexType ParamIndex) const
    {
        if (EventParams == nullptr)
        {
            UE_LOG(LogTemp, Error, TEXT("FEventParamWrap::Get => EventParams is nullptr"));

            return FEventParam();
        }

        if (!EventParams->IsValidIndex(ParamIndex))
        {
            UE_LOG(LogTemp, Error, TEXT("FEventParamWrap::Get => ParamIndex is not valid"));

            return FEventParam();
        }

        return (*EventParams)[ParamIndex];
    }

    template <typename T>
    T GetByIndex(const IndexType ParamIndex) const
    {
        return Get(ParamIndex).GetEventParam<T>();
    }

    template <typename T>
    T Pop()
    {
        return GetByIndex<T>(++Index);
    }

    void Reset()
    {
        Index = 0;
    }

    IndexType Num() const
    {
        return (EventParams == nullptr) ? 0 : EventParams->Num();
    }

private:

    IndexType Index = 0;

    TArray<FEventParam>* EventParams;
};

DECLARE_DYNAMIC_MULTICAST_DELEGATE_OneParam(FEventDelegateCallBack, FEventParamWrap, Param);

#define ADDLISTENER(Dispatch, Event, This, Fun) Dispatch->GetEventDelegateCallBack(Event)->AddUniqueDynamic(This, Fun);

#define REMOVELISTENER(Dispatch, Event, This, Fun) Dispatch->GetEventDelegateCallBack(Event)->RemoveDynamic(This, Fun);

UCLASS()
class GAEA_API UDelegateCallBack : public UObject
{
    GENERATED_BODY()

public:
    UPROPERTY()
    FEventDelegateCallBack CallBack;

    UFUNCTION()
    void Dispatch(const FEventParamWrap& Param) const;
};

/**
 * 
 */
UCLASS()
class GAEA_API UGaeaDispatcher : public UObject
{
    GENERATED_BODY()

public:
    UFUNCTION()
    void CreateDelegateCallBack(EGaeaEvent Event);

    FEventDelegateCallBack* GetEventDelegateCallBack(EGaeaEvent Event);

    UFUNCTION()
    UDelegateCallBack* GetDelegateCallBack(EGaeaEvent Event);

    void Clear();

    void DispatchImp(EGaeaEvent Event, const FEventParamWrap& Param);

    UFUNCTION()
    void DispatchImp(EGaeaEvent Event, TArray<FEventParam>& Param);

    template <typename ...ARGS>
    void Dispatch(const EGaeaEvent Event, ARGS&& ...Args)
    {
        TArray<FEventParam> Params;

        PushArg(Params, std::forward<ARGS>(Args)...);

        DispatchImp(Event, Params);
    }

private:
    template <typename T, typename ...ARGS>
    static void PushArg(TArray<FEventParam>& Params, T t, ARGS&& ...Args)
    {
        FEventParam EventParam;

        EventParam.SetEventParam<std::remove_reference_t<T>>(t);

        Params.Add(EventParam);

        PushArg(Params, std::forward<ARGS>(Args)...);
    }

    static void PushArg(TArray<FEventParam>& Params)
    {
    }

    UPROPERTY()
    TMap<EGaeaEvent, UDelegateCallBack*> DelegateMap;
};
