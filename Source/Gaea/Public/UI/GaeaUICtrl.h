// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "UObject/NoExportTypes.h"
#include "Blueprint/UserWidget.h"
#include "GaeaUICtrl.generated.h"

enum class EGaeaUIState
{
    None,
    Show,
    Hide,
    Remove
};

/**
 * 
 */
UCLASS()
class GAEA_API UGaeaUICtrl : public UObject
{
    GENERATED_BODY()

public:
    UGaeaUICtrl();

    void OnShow();

    void OnHide();

    void OnRemove();

    FString GetUIName() const;

    UFUNCTION()
    UUserWidget* GetWidget() const;

    bool IsShow() const;

    static UGaeaUICtrl* NewUICtrl(UObject* Outer, const FString& UIName, UUserWidget* UserWidget);

private:
    FString Name;

    UPROPERTY()
    UUserWidget* Widget;

    EGaeaUIState State;

    void Init(const FString& UIName, UUserWidget* UserWidget);
};
