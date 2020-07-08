// Fill out your copyright notice in the Description page of Project Settings.


#include "UI/GaeaUICtrl.h"

UGaeaUICtrl::UGaeaUICtrl()
{
	State = EGaeaUIState::None;
}

void UGaeaUICtrl::OnShow()
{
	State = EGaeaUIState::Show;
}

void UGaeaUICtrl::OnHide()
{
	State = EGaeaUIState::Hide;
}

void UGaeaUICtrl::OnRemove()
{
	State = EGaeaUIState::Remove;
}

FName UGaeaUICtrl::GetUIName() const
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

	return (State == EGaeaUIState::Show);
}

UGaeaUICtrl* UGaeaUICtrl::NewUICtrl(UObject* Outer, const FName& UIName, UUserWidget* UserWidget)
{
	if (Outer == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUICtrl::NewUICtrl => Outer is nullptr"));
		return nullptr;
	}

	if (UIName.IsNone())
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUICtrl::NewUICtrl => UIName is none"));
		return nullptr;
	}

	if (UserWidget == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUICtrl::NewUICtrl => UserWidget is none"));
		return nullptr;
	}

	auto UICtrl = NewObject<UGaeaUICtrl>(Outer, UIName);

	if (UICtrl == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUICtrl::NewUICtrl => UICtrl is none"));
		return nullptr;
	}

	UICtrl->Init(UIName, UserWidget);

	return UICtrl;
}

void UGaeaUICtrl::Init(const FName& UIName, UUserWidget* UserWidget)
{
	if (UIName.IsNone())
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUICtrl::NewUICtrl => UIName is none"));
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
