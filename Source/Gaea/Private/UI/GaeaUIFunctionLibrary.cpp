// Fill out your copyright notice in the Description page of Project Settings.


#include "UI/GaeaUIFunctionLibrary.h"

bool UGaeaUIFunctionLibrary::WithInEditor()
{
#if WITH_EDITOR
    return true;
#else
    return false;
#endif
}
