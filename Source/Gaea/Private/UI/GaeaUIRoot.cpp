// Fill out your copyright notice in the Description page of Project Settings.


#include "UI/GaeaUIRoot.h"
#include "Blueprint/WidgetTree.h"
#include "Components/CanvasPanel.h"
#include "Components/CanvasPanelSlot.h"

constexpr uint32 UGaeaUIRoot::ZOrderRatio = 10;

bool UGaeaUIRoot::Initialize()
{
	Super::Initialize();

	const auto Root = GetRootWidget();

	if (Root != nullptr || RootCanvas != nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUIRoot::Initialize => Root is already exist"));
		return false;
	}

	RootCanvas = WidgetTree->ConstructWidget<UCanvasPanel>(UCanvasPanel::StaticClass());

	if (RootCanvas == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUIRoot::Initialize => RootCanvas is nullptr"));
		return false;
	}

	RootCanvas->SetVisibility(ESlateVisibility::SelfHitTestInvisible);

	WidgetTree->RootWidget = RootCanvas;

	if (!InitCanvasPanels())
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUIRoot::Initialize => InitCanvasPanels failed"));
		return false;
	}

	return true;
}

bool UGaeaUIRoot::AddChildToRoot(const EGaeaUILayer Layer, UUserWidget* Widget) const
{
	if (Widget == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUIRoot::AddChild => UserWidget is nullptr"));
		return false;
	}

	if (!CanvasPanels.Contains(Layer))
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUIRoot::AddChild => Layer:%d is not exist"), Layer);
		return false;
	}

	auto CanvasPanel = CanvasPanels.FindRef(Layer);

	if (CanvasPanel == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUIRoot::AddChild => CanvasPanel is nullptr"));
		return false;
	}

	const auto CanvasPanelSlot = CanvasPanel->AddChildToCanvas(Widget);

	if (CanvasPanelSlot == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUIRoot::AddChild => CanvasPanelSlot is nullptr"));
		return false;
	}

	CanvasPanelSlot->SetAnchors(FAnchors(0, 0, 1, 1));

	CanvasPanelSlot->SetOffsets(FMargin());

	return true;
}

bool UGaeaUIRoot::InitCanvasPanels()
{
	if (WidgetTree == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUIRoot::InitCanvasPanels => WidgetTree is nullptr"));
		return false;
	}

	if (RootCanvas == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUIRoot::InitCanvasPanels => RootCanvas is nullptr"));
		return false;
	}

	const auto LayerEnum = StaticEnum<EGaeaUILayer>();

	if (LayerEnum == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUIRoot::InitCanvasPanels => LayerEnum is nullptr"));
		return false;
	}

	for (auto i = 0; i < LayerEnum->NumEnums(); ++i)
	{
		CreateCanvas(static_cast<EGaeaUILayer>(LayerEnum->GetValueByIndex(i)));
	}

	return true;
}

bool UGaeaUIRoot::CreateCanvas(const EGaeaUILayer Layer)
{
	if (CanvasPanels.Contains(Layer))
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUIRoot::CreateCanvas => CanvasPanels already contains Layer:%d"), Layer);
		return false;
	}

	if (WidgetTree == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUIRoot::CreateCanvas => WidgetTree is nullptr"));
		return false;
	}

	if (RootCanvas == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUIRoot::CreateCanvas => RootCanvas is nullptr"));
		return false;
	}

	const auto CanvasPanel = WidgetTree->ConstructWidget<UCanvasPanel>(UCanvasPanel::StaticClass());

	if (CanvasPanel == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUIRoot::CreateCanvas => CanvasPanel is nullptr"));
		return false;
	}

	CanvasPanels.Add(Layer, CanvasPanel);

	CanvasPanel->SetVisibility(ESlateVisibility::SelfHitTestInvisible);

	auto CanvasPanelSlot = RootCanvas->AddChildToCanvas(CanvasPanel);

	if (CanvasPanelSlot == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaUIRoot::CreateCanvas => CanvasPanelSlot is nullptr"));
		return false;
	}

	CanvasPanelSlot->SetZOrder(GetZOrderByLayer(Layer));

	CanvasPanelSlot->SetAnchors(FAnchors(0, 0, 1, 1));

	CanvasPanelSlot->SetOffsets(FMargin());

	return true;
}

uint32 UGaeaUIRoot::GetZOrderByLayer(EGaeaUILayer Layer)
{
	return static_cast<uint32>(Layer) * ZOrderRatio;
}
