// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "GaeaUIRoot.h"
#include "GaeaUICtrl.h"
#include "Blueprint/UserWidget.h"
#include "GaeaUISubsystem.generated.h"

/**
 * 
 */
UCLASS()
class GAEA_API UGaeaUISubsystem : public UGameInstanceSubsystem
{
	GENERATED_BODY()

public:
	void Initialize(FSubsystemCollectionBase& Collection) override;

	void Deinitialize() override;

	void Start();

	UFUNCTION(BlueprintCallable, Category = "GaeaUI")
	void ShowUI(FName UIName);

	UFUNCTION(BlueprintCallable, Category = "GaeaUI")
	void HideUI(FName UIName);

	UFUNCTION(BlueprintCallable, Category = "GaeaUI")
	void RemoveUI(FName UIName);

	UFUNCTION()
	bool IsShowUI(FName UIName) const;

	static const char* RootName;

	static const char* UINamePrefix;

	static const char* UIPath;

private:
	UPROPERTY()
	UGaeaUIRoot* Root;
	
	UPROPERTY()
	TMap<FName, UGaeaUICtrl*> UICtrlMap;

	TMap<FName, const TSubclassOf<UUserWidget>> UIClassMap;

	UGaeaUICtrl* NewUICtrl(const FName& UIName);

	UFUNCTION()
	UGaeaUICtrl* GetUICtrl(const FName& UIName) const;

	TSubclassOf<UUserWidget> GetUIClass(FName UIName);

	static EGaeaUILayer GetLayerByUIName(FName UIName);
};
