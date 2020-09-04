// Copyright 1998-2019 Epic Games, Inc. All Rights Reserved.

#include "GaeaGameMode.h"
#include "UObject/ConstructorHelpers.h"

AGaeaGameMode::AGaeaGameMode()
	: Super()
{
	// set default pawn class to our Blueprinted character
	static ConstructorHelpers::FClassFinder<APawn> PlayerPawnClassFinder(TEXT("/Game/FirstPersonCPP/Blueprints/FirstPersonCharacter"));
	DefaultPawnClass = PlayerPawnClassFinder.Class;
}
