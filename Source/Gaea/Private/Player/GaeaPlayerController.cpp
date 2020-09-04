// Fill out your copyright notice in the Description page of Project Settings.


#include "Player/GaeaPlayerController.h"
#include "Player/GaeaCheatManager.h"

AGaeaPlayerController::AGaeaPlayerController(const FObjectInitializer& ObjectInitializer) : Super(ObjectInitializer)
{
    CheatClass = UGaeaCheatManager::StaticClass();
}

void AGaeaPlayerController::BeginPlay()
{
    Super::BeginPlay();

    AddCheats(true);
}
