// Fill out your copyright notice in the Description page of Project Settings.


#include "GaeaLuaSubsystem.h"
#include "GaeaGameInstance.h"
#include "Kismet/KismetSystemLibrary.h"

const char* UGaeaLuaSubsystem::MainFile = "main";

const char* UGaeaLuaSubsystem::MainFunction = "main";

static uint8* ReadFile(IPlatformFile& PlatformFile, const FString Path, uint32& Len)
{
    auto FileHandle = PlatformFile.OpenRead(*Path);

    if (FileHandle)
    {
        Len = static_cast<uint32>(FileHandle->Size());

        auto* Buf = new uint8[Len];

        FileHandle->Read(Buf, Len);

        delete FileHandle;

        return Buf;
    }

    return nullptr;
}

uint8* LoadFile(const char* Fn, uint32& Len, FString& FilePath)
{
    auto& PlatformFile = FPlatformFileManager::Get().GetPlatformFile();

    auto Path = FPaths::ProjectContentDir();

    Path += "/Lua/";

    Path += UTF8_TO_TCHAR(Fn);

    static TArray<FString> LuaExtensions = {UTF8_TO_TCHAR(".lua"),UTF8_TO_TCHAR(".luac")};

    for (auto Elem = LuaExtensions.CreateConstIterator(); Elem; ++Elem)
    {
        const auto FullPath = Path + *Elem;

        const auto Buf = ReadFile(PlatformFile, FullPath, Len);

        if (Buf != nullptr)
        {
            FilePath = FullPath;

            return Buf;
        }
    }

    return nullptr;
}

void UGaeaLuaSubsystem::Initialize(FSubsystemCollectionBase& Collection)
{
    Super::Initialize(Collection);

    bHasInit = State.init();

    bHasStart = false;

    State.setLoadFileDelegate(&LoadFile);

    RegisterGlobalMethod();

    RegisterExtensionMethod();
}

void UGaeaLuaSubsystem::Deinitialize()
{
    State.close();

    bHasInit = false;

    bHasStart = false;

    Super::Deinitialize();
}

void UGaeaLuaSubsystem::Start()
{
    if (!bHasInit)
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaLuaSubsystem::Start => Lua has not been init!"));
        return;
    }

    if (bHasStart)
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaLuaSubsystem::Start => Lua already has been started!"));
        return;
    }

    State.doFile(MainFile);

    const auto GameInstance = Cast<UGaeaGameInstance>(GetGameInstance());

    if (GameInstance == nullptr)
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaLuaSubsystem::Start => GameInstance is nullptr!"));
        return;
    }

    State.call(MainFunction, GameInstance);

    bHasStart = true;
}

void UGaeaLuaSubsystem::RegisterGlobalMethod()
{
    using namespace slua;

    const auto L = State.getLuaState();

    if (L == nullptr)
    {
        UE_LOG(LogTemp, Warning, TEXT("UGaeaLuaSubsystem::RegisterGlobalMethod => L is nullptr!"));
        return;
    }

    DefGlobalMethod(IsUValid, &UKismetSystemLibrary::IsValid);
}

void UGaeaLuaSubsystem::RegisterExtensionMethod()
{
}
