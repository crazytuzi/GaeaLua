// Fill out your copyright notice in the Description page of Project Settings.


#include "Subsystem/GaeaUISubsystem.h"
#include "Blueprint/UserWidget.h"
#include "UI/GaeaUIRoot.h"
#include "UI/GaeaUICtrl.h"
#include "Common/GaeaFunctionLibrary.h"
#include "Subsystem/GaeaEventSubsystem.h"
#include "Subsystem/GaeaLuaSubsystem.h"

const char* UGaeaUISubsystem::UIConfig = "UIConfig";

const char* UGaeaUISubsystem::UIPath = "UIPath";

const char* UGaeaUISubsystem::UILayer = "UILayer";

const char* UGaeaUISubsystem::IsCache = "bIsCache";

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
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::StartUp => Root is already exist"));
		return;
	}

	Root = CreateWidget<UGaeaUIRoot>(GetWorld(), UGaeaUIRoot::StaticClass());

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

	TArray<FString> Keys;

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

void UGaeaUISubsystem::ShowUI(const FString& UIName)
{
	if (const auto& UICtrl = UICtrlMap.FindRef(UIName))
	{
		if (UICtrl->IsHide())
		{
			UICtrl->OnShow();
		}
		else if (UICtrl->IsCache())
		{
			UICtrl->OnShow();

			UGaeaFunctionLibrary::GetGlobalDispatcher(this)->Dispatch(EGaeaEvent::EVENT_UI_ON_INIT, UIName);
		}
	}
	else
	{
		Show(UIName);

		UGaeaFunctionLibrary::GetGlobalDispatcher(this)->Dispatch(EGaeaEvent::EVENT_UI_ON_INIT, UIName);
	}
}

void UGaeaUISubsystem::HideUI(const FString& UIName)
{
	Hide(UIName);

	UGaeaFunctionLibrary::GetGlobalDispatcher(this)->Dispatch(EGaeaEvent::EVENT_UI_ON_HIDE, UIName);
}

void UGaeaUISubsystem::RemoveUI(const FString& UIName)
{
	if (IsShowUI(UIName) || IsHideUI(UIName))
	{
		UGaeaFunctionLibrary::GetGlobalDispatcher(this)->Dispatch(EGaeaEvent::EVENT_UI_ON_DISPOSE, UIName);

		if (GetIsCache(UIName))
		{
			Cache(UIName);
		}
		else
		{
			Remove(UIName);
		}
	}
}

bool UGaeaUISubsystem::IsShowUI(const FString& UIName) const
{
	if (UIName.IsEmpty())
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::IsShowingUI => UIName is empty"));
		return false;
	}

	const auto UICtrl = UICtrlMap.FindRef(UIName);

	return (UICtrl != nullptr && UICtrl->IsShow());
}

bool UGaeaUISubsystem::IsHideUI(const FString& UIName) const
{
	if (UIName.IsEmpty())
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::IsHideUI => UIName is empty"));
		return false;
	}

	const auto UICtrl = UICtrlMap.FindRef(UIName);

	return (UICtrl != nullptr && UICtrl->IsHide());
}

bool UGaeaUISubsystem::IsCacheUI(const FString& UIName) const
{
	if (UIName.IsEmpty())
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::IsCacheUI => UIName is empty"));
		return false;
	}

	const auto UICtrl = UICtrlMap.FindRef(UIName);

	return (UICtrl != nullptr && UICtrl->IsCache());
}

void UGaeaUISubsystem::Show(const FString& UIName)
{
	if (Root == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::Show => Root is nullptr"));
		return;
	}

	if (UIName.IsEmpty())
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::Show => UIName is empty"));
		return;
	}

	const auto& UICtrl = NewUICtrl(UIName);

	if (UICtrl == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::Show => UICtrl is nullptr"));
		return;
	}


	Root->AddChildToRoot(GetLayer(UIName), UICtrl->GetWidget());

	UICtrlMap.Add(UIName, UICtrl);
}

void UGaeaUISubsystem::Hide(const FString& UIName)
{
	if (Root == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::Hide => Root is nullptr"));
		return;
	}

	if (UIName.IsEmpty())
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::Hide => UIName is empty"));
		return;
	}

	const auto& UICtrl = UICtrlMap.FindRef(UIName);

	if (UICtrl == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::Hide => UICtrl is nullptr"));
		return;
	}

	UICtrl->OnHide();
}

void UGaeaUISubsystem::Cache(const FString& UIName)
{
	if (Root == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::Hide => Root is nullptr"));
		return;
	}

	if (UIName.IsEmpty())
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::Hide => UIName is empty"));
		return;
	}

	const auto& UICtrl = UICtrlMap.FindRef(UIName);

	if (UICtrl == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::Hide => UICtrl is nullptr"));
		return;
	}

	UICtrl->OnCache();
}

void UGaeaUISubsystem::Remove(const FString& UIName)
{
	if (Root == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::Remove => Root is nullptr"));
		return;
	}

	if (UIName.IsEmpty())
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::Remove => UIName is none"));
		return;
	}

	const auto& UICtrl = UICtrlMap.FindRef(UIName);

	if (UICtrl == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::Remove => UICtrl is nullptr"));
		return;
	}

	UICtrl->OnRemove();

	UICtrlMap.Remove(UIName);
}

UGaeaUICtrl* UGaeaUISubsystem::NewUICtrl(const FString& UIName)
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

UGaeaUICtrl* UGaeaUISubsystem::GetUICtrl(const FString& UIName) const
{
	if (UIName.IsEmpty())
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::GetUICtrl => UIName is empty"));
		return nullptr;
	}
	return UICtrlMap.FindRef(UIName);
}

TSubclassOf<UUserWidget> UGaeaUISubsystem::GetUIClass(const FString& UIName)
{
	if (UIName.IsEmpty())
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::GetUIClass => UIName is empty"));
		return nullptr;
	}

	auto WidgetClass = UIClassMap.FindRef(UIName);

	if (WidgetClass != nullptr)
	{
		return WidgetClass;
	}

	const auto& Path = GetUIPath(UIName);

	WidgetClass = LoadClass<UUserWidget>(nullptr, *Path);

	if (WidgetClass != nullptr)
	{
		UIClassMap.Add(UIName, WidgetClass);
	}

	return WidgetClass;
}

FString UGaeaUISubsystem::GetUIPath(const FString& UIName)
{
	const auto LuaSubsystem = UGaeaFunctionLibrary::GetSubsystem<UGaeaLuaSubsystem>(this);

	if (LuaSubsystem == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::GetUIPath => LuaSubsystem is nullptr"));
		return FString();
	}

	const auto& Config = UGaeaLuaSubsystem::Config + FString(".") + UIConfig + "." + UIName + "." + UIPath;

	auto const& Path = LuaSubsystem->GetVar(TCHAR_TO_ANSI(*Config));

	if (Path.isString())
	{
		return Path.asString();
	}

	return FString();;
}

EGaeaUILayer UGaeaUISubsystem::GetLayer(const FString& UIName)
{
	const auto LuaSubsystem = UGaeaFunctionLibrary::GetSubsystem<UGaeaLuaSubsystem>(this);

	if (LuaSubsystem == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::GetLayer => LuaSubsystem is nullptr"));
		return EGaeaUILayer::Common;
	}

	const auto& Config = UGaeaLuaSubsystem::Config + FString(".") + UIConfig + "." + UIName + "." + UILayer;

	auto const& Layer = LuaSubsystem->GetVar(TCHAR_TO_ANSI(*Config));

	if (Layer.isInt())
	{
		return static_cast<EGaeaUILayer>(Layer.asInt());
	}

	return EGaeaUILayer::Common;
}

bool UGaeaUISubsystem::GetIsCache(const FString& UIName)
{
	const auto LuaSubsystem = UGaeaFunctionLibrary::GetSubsystem<UGaeaLuaSubsystem>(this);

	if (LuaSubsystem == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUISubsystem::GetIsCache => LuaSubsystem is nullptr"));
		return false;
	}

	const auto& Config = UGaeaLuaSubsystem::Config + FString(".") + UIConfig + "." + UIName + "." + IsCache;

	auto const& bIsCache = LuaSubsystem->GetVar(TCHAR_TO_ANSI(*Config));

	if (bIsCache.isBool())
	{
		return bIsCache.asBool();
	}

	return false;
}
