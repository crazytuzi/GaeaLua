return {
    HUD = {
        Name = "HUD",
        UIPath = "/Game/UI/HUD/WBP_UIHUD.WBP_UIHUD_C",
        CtrlPath = "Logic/HUD/HUDCtrl",
        UILayer = _G.EGaeaUILayer.HUD,
        bIsCache = false
    },
    Test = {
        Name = "Test",
        UIPath = "/Game/UI/Test/WBP_UITest.WBP_UITest_C",
        CtrlPath = "Logic/Test/TestCtrl",
        UILayer = _G.EGaeaUILayer.Common,
        bIsCache = false
    },
    GM = {
        Name = "GM",
        UIPath = "/Game/UI/GM/WBP_UIGM.WBP_UIGM_C",
        CtrlPath = "Logic/GM/GMCtrl",
        UILayer = _G.EGaeaUILayer.Common,
        bIsCache = true
    }
}
