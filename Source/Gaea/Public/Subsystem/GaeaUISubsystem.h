// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "UI/GaeaUIRoot.h"
#include "UI/GaeaUICtrl.h"
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
	virtual void Initialize(FSubsystemCollectionBase& Collection) override;

	virtual void Deinitialize() override;

	void StartUp();

	void ShutDown();

	void Show(const FString& UIName);

	void Remove(const FString& UIName);

	void Hide(const FString& UIName);

	UFUNCTION(BlueprintCallable, Category = "GaeaUI")
	void ShowUI(const FString& UIName);

	UFUNCTION(BlueprintCallable, Category = "GaeaUI")
	void RemoveUI(const FString& UIName);

	UFUNCTION()
	bool IsShowUI(const FString& UIName) const;

private:
	UPROPERTY()
	UGaeaUIRoot* Root;

	UPROPERTY()
	TMap<FString, UGaeaUICtrl*> UICtrlMap;

	UPROPERTY()
	TMap<FString, const TSubclassOf<UUserWidget>> UIClassMap;

	static const char* RootName;

	static const char* UINamePrefix;

	static const char* UIPath;

	static const char* UIConfig;

	static const char* UILayer;

	static const char* IsCache;

	UGaeaUICtrl* NewUICtrl(const FString& UIName);

	UFUNCTION()
	UGaeaUICtrl* GetUICtrl(const FString& UIName) const;

	TSubclassOf<UUserWidget> GetUIClass(const FString& UIName);

	EGaeaUILayer GetLayer(const FString& UIName);

	bool GetIsCache(const FString& UIName);
};
