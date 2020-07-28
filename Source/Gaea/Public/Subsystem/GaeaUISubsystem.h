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
    void ShowUI(FName UIName);

    UFUNCTION(BlueprintCallable, Category = "GaeaUI")
    void HideUI(FName UIName);

    UFUNCTION(BlueprintCallable, Category = "GaeaUI")
    void RemoveUI(FName UIName);

    UFUNCTION()
    bool IsShowUI(FName UIName) const;

private:
    UPROPERTY()
    UGaeaUIRoot* Root;

    UPROPERTY()
    TMap<FName, UGaeaUICtrl*> UICtrlMap;

    TMap<FName, const TSubclassOf<UUserWidget>> UIClassMap;

    static const char* RootName;

    static const char* UINamePrefix;

    static const char* UIPath;

    static const char* UIConfig;

    static const char* UILayer;

    UGaeaUICtrl* NewUICtrl(const FName& UIName);

    UFUNCTION()
    UGaeaUICtrl* GetUICtrl(const FName& UIName) const;

    TSubclassOf<UUserWidget> GetUIClass(FName UIName);

    EGaeaUILayer GetLayer(FName UIName);
};
