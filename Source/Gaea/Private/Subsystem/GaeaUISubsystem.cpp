// Fill out your copyright notice in the Description page of Project Settings.


#include "Subsystem/GaeaUISubsystem.h"
#include "Blueprint/UserWidget.h"
#include "UI/GaeaUIRoot.h"
#include "UI/GaeaUICtrl.h"
#include "Common/GaeaFunctionLibrary.h"
#include "Subsystem/GaeaEventSubsystem.h"
#include "Subsystem/GaeaLuaSubsystem.h"

const char* UGaeaUISubsystem::RootName = "GaeaUIRoot";

const char* UGaeaUISubsystem::UINamePrefix = "WBP_UI";

const char* UGaeaUISubsystem::UIPath = "UI/";

const char* UGaeaUISubsystem::UIConfig = "UIConfig";

const char* UGaeaUISubsystem::UILayer = "UILayer";

void UGaeaUISubsystem::Initialize(FSubsystemCollectionBase& Collection)
{
    Super::Initialize(Collection);
}

void UGaeaUISubsystem::Deinitialize()
{
    Super::Deinitialize();
}

void UGaeaUISubsystem::StartUp()
{
    if (Root != nullptr)
    {
        ShutDown();
    }

    Root = CreateWidget<UGaeaUIRoot>(GetWorld(), UGaeaUIRoot::StaticClass(), RootName);

    if (Root == nullptr)
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::StartUp => Root is nullptr"));
        return;
    }

    Root->AddToViewport();
}

void UGaeaUISubsystem::ShutDown()
{
    if (Root == nullptr)
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::ShutDown => Root is nullptr"));
        return;
    }

    TArray<FName> Keys;

    UICtrlMap.GetKeys(Keys);

    for (const auto& Key : Keys)
    {
        RemoveUI(Key);
    }

    UICtrlMap.Empty();

    UIClassMap.Empty();

    Root->MarkPendingKill();

    Root = nullptr;
}

void UGaeaUISubsystem::ShowUI(const FName UIName)
{
    if (Root == nullptr)
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::ShowUI => Root is nullptr"));
        return;
    }

    if (UIName.IsNone())
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::ShowUI => UIName is none"));
        return;
    }

    if (IsShowUI(UIName))
    {
        return;
    }

    const auto UICtrl = NewUICtrl(UIName);

    if (UICtrl == nullptr)
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::ShowUI => UICtrl is nullptr"));
        return;
    }

    Root->AddChildToRoot(GetLayer(UIName), UICtrl->GetWidget());

    UICtrlMap.Add(UIName, UICtrl);

    UGaeaFunctionLibrary::GetGlobalDispatcher(this)->
        Dispatch(EGaeaEvent::EVENT_UI_ON_INIT, UIName.ToString());
}

void UGaeaUISubsystem::HideUI(const FName UIName)
{
    // @TODO
}

void UGaeaUISubsystem::RemoveUI(const FName UIName)
{
    if (Root == nullptr)
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::RemoveUI => Root is nullptr"));
        return;
    }

    if (UIName.IsNone())
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::RemoveUI => UIName is none"));
        return;
    }

    const auto UICtrl = UICtrlMap.FindRef(UIName);

    if (UICtrl == nullptr)
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::RemoveUI => UICtrl is nullptr"));
        return;
    }

    auto Widget = UICtrl->GetWidget();

    if (Widget != nullptr)
    {
        UGaeaFunctionLibrary::GetGlobalDispatcher(this)->Dispatch(EGaeaEvent::EVENT_UI_ON_DISPOSE, UIName.ToString());

        Widget->RemoveFromParent();

        UICtrl->OnRemove();
    }
    else
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::RemoveUI => Widget is nullptr"));
        return;
    }

    UICtrlMap.Remove(UIName);
}

bool UGaeaUISubsystem::IsShowUI(const FName UIName) const
{
    if (UIName.IsNone())
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::IsShowingUI => UIName is none"));
        return false;
    }

    const auto UICtrl = UICtrlMap.FindRef(UIName);

    return (UICtrl != nullptr && UICtrl->IsShow());
}

UGaeaUICtrl* UGaeaUISubsystem::NewUICtrl(const FName& UIName)
{
    if (Root == nullptr)
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::NewUICtrl => Root is nullptr"));
        return nullptr;
    }

    const auto WidgetClass = GetUIClass(UIName);

    if (WidgetClass == nullptr)
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::NewUICtrl => WidgetClass is nullptr"));
        return nullptr;
    }

    const auto Widget = CreateWidget(GetWorld(), WidgetClass);

    if (Widget == nullptr)
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::NewUICtrl => Widget is nullptr"));
        return nullptr;
    }

    const auto UICtrl = UGaeaUICtrl::NewUICtrl(this, UIName, Widget);

    if (UICtrl == nullptr)
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::NewUICtrl => UICtrl is nullptr"));
        return nullptr;
    }

    return UICtrl;
}

UGaeaUICtrl* UGaeaUISubsystem::GetUICtrl(const FName& UIName) const
{
    if (UIName.IsNone())
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::GetUICtrl => UIName is none"));
        return nullptr;
    }
    return UICtrlMap.FindRef(UIName);
}

TSubclassOf<UUserWidget> UGaeaUISubsystem::GetUIClass(const FName UIName)
{
    if (UIName.IsNone())
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::GetUIClass => UIName is none"));
        return nullptr;
    }

    auto WidgetClass = UIClassMap.FindRef(UIName);

    if (WidgetClass != nullptr)
    {
        return WidgetClass;
    }

    const auto UIFullName = UINamePrefix + UIName.ToString();

    const auto UIFullPath = FPaths::ProjectContentDir() + UIPath + UIName.ToString() + "/" + UIFullName
        + ".uasset";

    auto& PlatformFile = FPlatformFileManager::Get().GetPlatformFile();

    if (!PlatformFile.FileExists(*UIFullPath))
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::GetUIClass => %s is not exists"), *UIFullPath);
        return nullptr;
    }

    const auto UI_BP_FullPath = FString("/Game/") + UIPath + UIName.ToString() + "/" + UIFullName + "." + UIFullName +
        "_C";

    WidgetClass = LoadClass<UUserWidget>(nullptr, *UI_BP_FullPath);

    if (WidgetClass != nullptr)
    {
        UIClassMap.Add(UIName, WidgetClass);
    }

    return WidgetClass;
}

EGaeaUILayer UGaeaUISubsystem::GetLayer(const FName UIName)
{
    const auto LuaSubsystem = UGaeaFunctionLibrary::GetSubsystem<UGaeaLuaSubsystem>(this);

    if (LuaSubsystem == nullptr)
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::GetLayer => LuaSubsystem is nullptr"));
        return EGaeaUILayer::Common;
    }

    const auto Config = UGaeaLuaSubsystem::Config + FString(".") + UIConfig + "." + UIName.ToString() + "." + UILayer;

    auto const Layer = LuaSubsystem->GetVar(TCHAR_TO_ANSI(*Config));

    if (Layer.isInt())
    {
        return static_cast<EGaeaUILayer>(Layer.asInt());
    }

    return EGaeaUILayer::Common;
}
