// Fill out your copyright notice in the Description page of Project Settings.


#include "GaeaDispatcher.h"

void UDelegateCallBack::Remove(UObject* Caller, const FName FunName)
{
    CallBack.Remove(Caller, FunName);
}

void UDelegateCallBack::Dispatch(const FEventParamWrap& Param) const
{
    if (CallBack.IsBound())
    {
        CallBack.Broadcast(Param);
    }
}

void UGaeaDispatcher::CreateDelegateCallBack(const EGaeaEvent Event)
{
    if (!DelegateMap.Contains(Event))
    {
        const auto CallBackPointer = NewObject<UDelegateCallBack>(this);

        DelegateMap.Add(Event, CallBackPointer);
    }
}

FEventDelegateCallBack* UGaeaDispatcher::GetEventDelegateCallBack(const EGaeaEvent Event)
{
    auto& CallBackPointer = DelegateMap.FindOrAdd(Event);

    if (CallBackPointer == nullptr)
    {
        CallBackPointer = NewObject<UDelegateCallBack>(this);
    }

    return &(CallBackPointer->CallBack);
}

UDelegateCallBack* UGaeaDispatcher::GetDelegateCallBack(const EGaeaEvent Event)
{
    const auto CallBackPointer = DelegateMap.Find(Event);

    return (CallBackPointer == nullptr) ? nullptr : *CallBackPointer;
}

void UGaeaDispatcher::Remove(const EGaeaEvent Event, UObject* Caller, const FName FunName)
{
    const auto CallBackPointer = DelegateMap.Find(Event);

    if (CallBackPointer != nullptr)
    {
        (*CallBackPointer)->Remove(Caller, FunName);
    }
}

void UGaeaDispatcher::Clear(const EGaeaEvent Event)
{
    DelegateMap.Remove(Event);
}

void UGaeaDispatcher::DispatchImp(const EGaeaEvent Event, const FEventParamWrap& Param)
{
    const auto CallBackPointer = DelegateMap.Find(Event);

    if (CallBackPointer != nullptr)
    {
        (*CallBackPointer)->Dispatch(Param);
    }
}

void UGaeaDispatcher::DispatchImp(const EGaeaEvent Event, TArray<FEventParam>& Param)
{
    if (Param.Num() > 0)
    {
        const FEventParamWrap ParamWrap(Param);

        DispatchImp(Event, ParamWrap);
    }
    else
    {
        const FEventParamWrap ParamWrap;

        DispatchImp(Event, ParamWrap);
    }
}
