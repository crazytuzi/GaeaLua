// Fill out your copyright notice in the Description page of Project Settings.


#include "Subsystem/GaeaLuaSubsystem.h"
#include "GaeaGameInstance.h"
#include "Common/GaeaFunctionLibrary.h"
#include "Kismet/KismetSystemLibrary.h"

const char* UGaeaLuaSubsystem::MainFile = "main";

const char* UGaeaLuaSubsystem::MainFunction = "main";

const char* UGaeaLuaSubsystem::TickFunction = "Tick";

const char* UGaeaLuaSubsystem::Config = "Config";

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
	ShutDown();

	Super::Deinitialize();
}

void UGaeaLuaSubsystem::StartUp()
{
	if (!bHasInit)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaLuaSubsystem::StartUp => Lua has not been init!"));
		return;
	}

	if (bHasStart)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaLuaSubsystem::StartUp => Lua already has been started!"));
		return;
	}

	State.doFile(MainFile);

	const auto GameInstance = Cast<UGaeaGameInstance>(GetGameInstance());

	if (GameInstance == nullptr)
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaLuaSubsystem::StartUp => GameInstance is nullptr!"));
		return;
	}

	State.call(MainFunction, GameInstance);

	bHasStart = true;

	State.setTickFunction(GetVar(TickFunction));

	PreLoadMapDelegateHandle = FCoreUObjectDelegates::PreLoadMap.AddUObject(this, &UGaeaLuaSubsystem::PreLoadMap);
}

void UGaeaLuaSubsystem::ShutDown()
{
	State.close();

	bHasInit = false;

	bHasStart = false;

	FCoreUObjectDelegates::PreLoadMap.Remove(PreLoadMapDelegateHandle);
}

slua::LuaVar UGaeaLuaSubsystem::GetVar(const char* Key)
{
	if (!HasReady())
	{
		UE_LOG(LogTemp, Warning, TEXT("UGaeaLuaSubsystem::GetVar => Lua has not been ready!"));
		return slua::LuaVar();
	}

	return State.get(Key);
}

void UGaeaLuaSubsystem::PreLoadMap(const FString& MapName) const
{
	UGaeaFunctionLibrary::GetGlobalDispatcher(this)->Dispatch(EGaeaEvent::EVENT_PRE_LOAD_MAP);
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
}

void UGaeaLuaSubsystem::RegisterExtensionMethod()
{
	using namespace slua;

	REG_EXTENSION_METHOD_IMP(
		UObject,
		"IsA",
		{
		CheckUD(UObject, L, 1);

		UClass* Class = LuaObject::checkValueOpt<UClass*>(L, 2, nullptr);

		return LuaObject::push(L, UD->IsA(Class));
		}
	);
}
