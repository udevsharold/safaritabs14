//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.
//
//
//  Credits - @johnzarodev for offsets and insights

#include <Foundation/Foundation.h>
#include <HBLog.h>
#include <libundirect/libundirect_dynamic.h>

#define MSIMG @"MobileSafari"
#define PACIBSP 0x7F

#define FIND_FUNCT(x, y, z) libundirect_find(x, y, sizeof(y), z)
#define FIND_MS(x, y) FIND_FUNCT(MSIMG, x, y)

#define HOOK_FUNCT(x) MSHookFunction(x, (void *)&x##_replaced, (void **)&x##_orig);

#pragma mark USES_TAB_BAR arm64e
//unique all across binaries (requires libundirect update)
//0x80, 0x04, 0x00, 0x34, 0xE0, 0x03, 0x14, 0xAA

//sub_100035E64  - iOS 14.3 - ipad style cards
//sub_100040810  - iOS 14.3 - iphone style
// >=14.0
unsigned char uses_tab_bar_unique_ios14_0_arm64e[] =
{
    0x6D, 0xF6, 0x57, 0x01, 0xA9, 0xF4, 0x4F, 0x02, 0xA9, 0xFD, 0x7B, 0x03, 0xA9, 0xFD, 0xC3, 0x00, 0x91, 0x80
};

#pragma mark USES_TAB_BAR arm64
//sub_100035920  - iOS 14.3 - ipad style cards
//sub_100037678  - iOS 14.3 - iphone style
// >=14.0
unsigned char uses_tab_bar_unique_ios_14_0_arm64[] =
{
    0xFD, 0xC3, 0x00, 0x91, 0x80, 0x08, 0x00, 0xB4, 0xF4, 0x03, 0x00, 0xAA
};


#pragma mark SHOW_TAB_BAR arm64e
//unique all across binaries (requires libundirect update)
//0x1F, 0x04, 0x00, 0xF1, 0xA9, 0x00, 0x00, 0x54, 0x33, 0x00, 0x80, 0x52

//sub_100037CB8 - iOS 14.3
// >=14.4.1
unsigned char show_tab_bar_unique_ios14_4_1_arm64e[] =
{
    0xF3, 0x03, 0x00, 0xAA, 0x80, 0x04, 0x00, 0xB4, 0xC8, 0x11, 0x00, 0x90
};

// >=14.2.1
unsigned char show_tab_bar_unique_ios14_2_1_arm64e[] =
{
    0xF3, 0x03, 0x00, 0xAA, 0x80, 0x04, 0x00, 0xB4, 0xE8, 0x11, 0x00, 0xB0
};

// >=14.2
unsigned char show_tab_bar_unique_ios14_2_arm64e[] =
{
    0xF3, 0x03, 0x00, 0xAA, 0x80, 0x04, 0x00, 0xB4, 0xE8, 0x11, 0x00, 0x90
};

// >=14.0
unsigned char show_tab_bar_unique_ios14_0_arm64e[] =
{
    0xF3, 0x03, 0x00, 0xAA, 0x80, 0x04, 0x00, 0xB4, 0xA8, 0x11, 0x00, 0xB0
};


#pragma mark SHOW_TAB_BAR arm64
//sub_10003F8B0 - iOS 14.3
// >=14.4.1
unsigned char show_tab_bar_unique_ios_14_4_1_arm64[] =
{
    0xF3, 0x03, 0x00, 0xAA, 0x80, 0x04, 0x00, 0xB4, 0x28, 0x11, 0x00, 0xB0
};

// >=14.0
unsigned char show_tab_bar_unique_ios_14_0_arm64[] =
{
    0xF3, 0x03, 0x00, 0xAA, 0x80, 0x04, 0x00, 0xB4, 0x48, 0x11, 0x00, 0xB0
};


#pragma mark USES_TAB_BAR_FUNC
BOOL (*uses_tab_bar_func_orig)();
BOOL uses_tab_bar_func_replaced(){
    HBLogDebug(@"uses_tab_bar_func_replaced");
    return YES;
}

#pragma mark SHOW_TAB_BAR_FUNC
BOOL (*show_tab_bar_func_orig)();
BOOL show_tab_bar_func_replaced(){
    HBLogDebug(@"show_tab_bar_func_replaced");
    return YES;
}

#pragma mark ctor
%ctor{
    
#if __arm64e__
    
    HBLogDebug(@"arm64e");
    void* uses_tab_bar_func = FIND_MS(uses_tab_bar_unique_ios14_0_arm64e, PACIBSP);
    
    void* show_tab_bar_func;
    if (@available(iOS 14.4.1, *)){
        show_tab_bar_func = FIND_MS(show_tab_bar_unique_ios14_4_1_arm64e, PACIBSP);
    }else if (@available(iOS 14.2.1, *)){
        show_tab_bar_func = FIND_MS(show_tab_bar_unique_ios14_2_1_arm64e, PACIBSP);
    }else if (@available(iOS 14.2, *)){
        show_tab_bar_func = FIND_MS(show_tab_bar_unique_ios14_2_arm64e, PACIBSP);
    }else{
        show_tab_bar_func = FIND_MS(show_tab_bar_unique_ios14_0_arm64e, PACIBSP);
    }
    
#else
    
    HBLogDebug(@"arm64");
    void* uses_tab_bar_func = FIND_MS(uses_tab_bar_unique_ios_14_0_arm64, 0xE9);
    
    void* show_tab_bar_func;
    if (@available(iOS 14.4.1, *)){
        show_tab_bar_func = FIND_MS(show_tab_bar_unique_ios_14_4_1_arm64, 0xF6);
    }else{
        show_tab_bar_func = FIND_MS(show_tab_bar_unique_ios_14_0_arm64, 0xF6);
    }
    
    
#endif
    
    if (uses_tab_bar_func){
        HOOK_FUNCT(uses_tab_bar_func);
    }
    
    if (show_tab_bar_func){
        HOOK_FUNCT(show_tab_bar_func);
    }
}
