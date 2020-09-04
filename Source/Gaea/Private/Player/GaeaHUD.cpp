// Copyright 1998-2019 Epic Games, Inc. All Rights Reserved.

#include "Player/GaeaHUD.h"
#include "Engine/Canvas.h"
#include "Engine/Texture2D.h"
#include "TextureResource.h"
#include "CanvasItem.h"
#include "Common/GaeaFunctionLibrary.h"
#include "Kismet/KismetSystemLibrary.h"
#include "Subsystem/GaeaUISubsystem.h"
#include "UObject/ConstructorHelpers.h"

AGaeaHUD::AGaeaHUD()
{
	// Set the crosshair texture
	static ConstructorHelpers::FObjectFinder<UTexture2D> CrosshairTexObj(TEXT("/Game/FirstPerson/Textures/FirstPersonCrosshair"));
	CrosshairTex = CrosshairTexObj.Object;
}

void AGaeaHUD::BeginPlay()
{
	if (!UKismetSystemLibrary::IsDedicatedServer(this))
	{
		const auto World = GetWorld();

		if (World != nullptr && World->PersistentLevel == GetLevel())
		{
			auto UISubsystem = UGaeaFunctionLibrary::GetSubsystem<UGaeaUISubsystem>(this);

			if (UISubsystem != nullptr)
			{
				UISubsystem->StartUp();
			}
			else
			{
				UE_LOG(LogTemp, Warning, TEXT("AGaeaHUD::BeginPlay => UISubsystem is nullptr"));
			}
		}
	}

	Super::BeginPlay();
}

void AGaeaHUD::EndPlay(const EEndPlayReason::Type EndPlayReason)
{
	Super::EndPlay(EndPlayReason);

	if (!UKismetSystemLibrary::IsDedicatedServer(this))
	{
		const auto World = GetWorld();

		if (World != nullptr && World->PersistentLevel == GetLevel())
		{
			auto UISubsystem = UGaeaFunctionLibrary::GetSubsystem<UGaeaUISubsystem>(this);

			if (UISubsystem != nullptr)
			{
				UISubsystem->ShutDown();
			}
			else
			{
				UE_LOG(LogTemp, Warning, TEXT("AGaeaHUD::EndPlay => UISubsystem is nullptr"));
			}
		}
	}
}


void AGaeaHUD::DrawHUD()
{
	Super::DrawHUD();

	// Draw very simple crosshair

	// find center of the Canvas
	const FVector2D Center(Canvas->ClipX * 0.5f, Canvas->ClipY * 0.5f);

	// offset by half the texture's dimensions so that the center of the texture aligns with the center of the Canvas
	const FVector2D CrosshairDrawPosition( (Center.X),
										   (Center.Y + 20.0f));

	// draw the crosshair
	FCanvasTileItem TileItem( CrosshairDrawPosition, CrosshairTex->Resource, FLinearColor::White);
	TileItem.BlendMode = SE_BLEND_Translucent;
	Canvas->DrawItem( TileItem );
}
