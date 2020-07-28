// Fill out your copyright notice in the Description page of Project Settings.


#include "LevelScriptActor/GaeaLevelScriptActor.h"
#include "Common/GaeaFunctionLibrary.h"
#include "Subsystem/GaeaLuaSubsystem.h"
#include "Subsystem/GaeaUISubsystem.h"

void AGaeaLevelScriptActor::BeginPlay()
{
	Super::BeginPlay();

	auto LuaSubsystem = UGaeaFunctionLibrary::GetSubsystem<UGaeaLuaSubsystem>(this);

	if (LuaSubsystem != nullptr)
	{
		LuaSubsystem->StartUp();
	}
	else
	{
		UE_LOG(LogTemp, Warning, TEXT("AGaeaLevelScriptActor::BeginPlay => LuaSubsystem is nullptr"));
	}

	auto UISubsystem = UGaeaFunctionLibrary::GetSubsystem<UGaeaUISubsystem>(this);

	if (UISubsystem != nullptr)
	{
		UISubsystem->StartUp();

		UISubsystem->ShowUI("HUD");
	}
	else
	{
		UE_LOG(LogTemp, Warning, TEXT("AGaeaLevelScriptActor::BeginPlay => UISubsystem is nullptr"));
	}
}

void AGaeaLevelScriptActor::Destroyed()
{
	Super::Destroyed();
}
