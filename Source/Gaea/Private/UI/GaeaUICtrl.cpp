// Fill out your copyright notice in the Description page of Project Settings.


#include "UI/GaeaUICtrl.h"

UGaeaUICtrl::UGaeaUICtrl()
{
	State = EGaeaUIState::None;
}

void UGaeaUICtrl::OnShow()
{
	if (Widget == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUICtrl::OnShow => Widget is nullptr"));

		return;
	}

	Widget->SetVisibility(ESlateVisibility::SelfHitTestInvisible);

	State = EGaeaUIState::Show;
}

void UGaeaUICtrl::OnHide()
{
	if (Widget == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUICtrl::OnHide => Widget is nullptr"));

		return;
	}

	Widget->SetVisibility(ESlateVisibility::Collapsed);

	State = EGaeaUIState::Hide;
}

void UGaeaUICtrl::OnCache()
{
	if (Widget == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUICtrl::OnCache => Widget is nullptr"));

		return;
	}

	Widget->SetVisibility(ESlateVisibility::Collapsed);

	State = EGaeaUIState::Cache;
}

void UGaeaUICtrl::OnRemove()
{
	if (Widget == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUICtrl::OnRemove => Widget is nullptr"));

		return;
	}

	Widget->RemoveFromParent();

	State = EGaeaUIState::Remove;
}

FString UGaeaUICtrl::GetUIName() const
{
	return Name;
}

UUserWidget* UGaeaUICtrl::GetWidget() const
{
	return Widget;
}

bool UGaeaUICtrl::IsShow() const
{
	if (Widget == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUICtrl::IsShow => Widget is nullptr"));
		return false;
	}

	return State == EGaeaUIState::Show;
}

bool UGaeaUICtrl::IsHide() const
{
	if (Widget == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUICtrl::IsHide => Widget is nullptr"));
		return false;
	}

	return State == EGaeaUIState::Hide;
}

bool UGaeaUICtrl::IsCache() const
{
	if (Widget == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUICtrl::IsCache => Widget is nullptr"));
		return false;
	}

	return State == EGaeaUIState::Cache;
}

UGaeaUICtrl* UGaeaUICtrl::NewUICtrl(UObject* Outer, const FString& UIName, UUserWidget* UserWidget)
{
	if (Outer == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUICtrl::NewUICtrl => Outer is nullptr"));
		return nullptr;
	}

	if (UIName.IsEmpty())
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUICtrl::NewUICtrl => UIName is empty"));
		return nullptr;
	}

	if (UserWidget == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUICtrl::NewUICtrl => UserWidget is nullptr"));
		return nullptr;
	}

	auto UICtrl = NewObject<UGaeaUICtrl>(Outer);

	if (UICtrl == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUICtrl::NewUICtrl => UICtrl is nullptr"));
		return nullptr;
	}

	UICtrl->Init(UIName, UserWidget);

	return UICtrl;
}

void UGaeaUICtrl::Init(const FString& UIName, UUserWidget* UserWidget)
{
	if (UIName.IsEmpty())
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUICtrl::NewUICtrl => UIName is empty"));
		return;
	}

	if (UserWidget == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUICtrl::NewUICtrl => UserWidget is nullptr"));
		return;
	}

	Name = UIName;

	Widget = UserWidget;

	OnShow();
}
