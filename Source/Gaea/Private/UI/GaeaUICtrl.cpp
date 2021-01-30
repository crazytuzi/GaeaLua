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

	auto UICtrl = NewObject<UGaeaUICtrl>(Outer, *UIName);

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
