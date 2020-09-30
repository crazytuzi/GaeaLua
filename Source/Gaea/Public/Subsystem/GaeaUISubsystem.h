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
    void Initialize(FSubsystemCollectionBase& Collection) override;

    void Deinitialize() override;

    void StartUp();

    void ShutDown();

    UFUNCTION(BlueprintCallable, Category = "GaeaUI")
    void ShowUI(const FString& UIName);

    UFUNCTION(BlueprintCallable, Category = "GaeaUI")
    void HideUI(const FString& UIName);

    UFUNCTION(BlueprintCallable, Category = "GaeaUI")
    void RemoveUI(const FString& UIName);

    UFUNCTION()
    bool IsShowUI(const FString& UIName) const;

private:
    UPROPERTY()
    UGaeaUIRoot* Root;

    UPROPERTY()
    TMap<FString, UGaeaUICtrl*> UICtrlMap;

    TMap<FString, const TSubclassOf<UUserWidget>> UIClassMap;

    static const char* RootName;

    static const char* UINamePrefix;

    static const char* UIPath;

    static const char* UIConfig;

    static const char* UILayer;

    UGaeaUICtrl* NewUICtrl(const FString& UIName);

    UFUNCTION()
    UGaeaUICtrl* GetUICtrl(const FString& UIName) const;

    TSubclassOf<UUserWidget> GetUIClass(const FString& UIName);

    EGaeaUILayer GetLayer(const FString& UIName);
};
