// Fill out your copyright notice in the Description page of Project Settings.


#include "GaeaLevelScriptActor.h"
#include "GaeaFunctionLibrary.h"
#include "GaeaLuaSubsystem.h"
#include "GaeaUISubsystem.h"

void AGaeaLevelScriptActor::BeginPlay()
{
	Super::BeginPlay();

	auto LuaSubsystem = UGaeaFunctionLibrary::GetSubsystem<UGaeaLuaSubsystem>(this);

	if (LuaSubsystem != nullptr)
	{
		LuaSubsystem->Start();
	}
	else
	{
		UE_LOG(LogTemp, Warning, TEXT("AGaeaLevelScriptActor::BeginPlay => LuaSubsystem is nullptr"));
	}

	auto UISubsystem = UGaeaFunctionLibrary::GetSubsystem<UGaeaUISubsystem>(this);

	if (UISubsystem != nullptr)
	{
		UISubsystem->Start();

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
