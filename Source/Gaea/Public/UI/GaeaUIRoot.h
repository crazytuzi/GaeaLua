// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Blueprint/UserWidget.h"
#include "GaeaUIRoot.generated.h"

class UUserWidget;
class UCanvasPanel;

UENUM()
enum class EGaeaUILayer : uint8
{
	HUD,
	Common,
	Tip,
	Alert
};

/**
 * 
 */
UCLASS()
class GAEA_API UGaeaUIRoot : public UUserWidget
{
	GENERATED_BODY()

public:
	bool Initialize() override;

	bool AddChildToRoot(EGaeaUILayer Layer, UUserWidget* Widget) const;

	static const char* RootCanvasName;

	static const char* LayerNamePrefix;

	static const uint32 ZOrderRatio;

private:
	UCanvasPanel* RootCanvas;

	TMap<EGaeaUILayer, UCanvasPanel*> CanvasPanels;

	bool InitCanvasPanels();

	bool CreateCanvas(EGaeaUILayer Layer, FName LayerName);

	static uint32 GetZOrderByLayer(EGaeaUILayer Layer);
};
