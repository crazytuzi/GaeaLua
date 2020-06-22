// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "UObject/NoExportTypes.h"
#include "GaeaUICtrl.generated.h"

class UUserWidget;

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

	FName GetUIName() const;

	UFUNCTION()
	UUserWidget* GetWidget() const;

	bool IsShow() const;

	static UGaeaUICtrl* NewUICtrl(UObject* Outer, const FName& UIName, UUserWidget* UserWidget);

private:
	FName Name;

	UPROPERTY()
	UUserWidget* Widget;

	EGaeaUIState State;

	void Init(const FName& UIName, UUserWidget* UserWidget);
};
