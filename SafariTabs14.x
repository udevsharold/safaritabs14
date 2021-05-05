//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#include <Foundation/Foundation.h>
#include <HBLog.h>
#include <libundirect/libundirect_dynamic.h>

BOOL (*uses_tab_bar_func_orig)();
BOOL uses_tab_bar_func_replaced(){
    HBLogDebug(@"uses_tab_bar_func_replaced");
    return YES;
}

BOOL (*show_tab_bar_func_orig)();
BOOL show_tab_bar_func_replaced(){
    HBLogDebug(@"show_tab_bar_func_replaced");
    return YES;
}

//sub_100035E64  - iOS 14.3 - ipad style cards
//sub_100040810  - iOS 14.3 - iphone style
unsigned char uses_tab_bar_unique_arm64e[] =
{
    0x01, 0xBD, 0x40, 0xF9, 0x0E, 0x35, 0x05, 0x94,
    0xFD, 0x03, 0x1D, 0xAA, 0x38, 0x35, 0x05, 0x94, 0xF3, 0x03,
    0x00, 0xAA, 0xC8, 0x0E, 0x00, 0xF0, 0x1F, 0x20, 0x03, 0xD5,
    0x02, 0xA5, 0x45, 0xF9
};


//sub_100035920  - iOS 14.3 - ipad style cards
//sub_100037678  - iOS 14.3 - iphone style
unsigned char uses_tab_bar_unique_arm64[] =
{
    0x10, 0x00, 0xB0, 0x01, 0x25,
    0x46, 0xF9, 0x61, 0xE5, 0x04, 0x94, 0xFD, 0x03, 0x1D, 0xAA,
    0x80, 0xE5, 0x04, 0x94, 0xF3, 0x03, 0x00, 0xAA, 0x48, 0x0E,
    0x00, 0x90, 0x1F, 0x20, 0x03, 0xD5, 0x02, 0x2D, 0x40, 0xF9
};

//sub_100037CB8 - iOS 14.3
unsigned char show_tab_bar_unique_arm64e[] =
{
    0xE8, 0x11, 0x00, 0xB0, 0x08, 0xF5, 0x82, 0xB9, 0x60, 0x6A,
    0x68, 0xF8, 0x88, 0x11, 0x00, 0xF0
};

//sub_10003F8B0 - iOS 14.3
unsigned char show_tab_bar_unique_arm64[] =
{
    0x08, 0xC5, 0x8D, 0xB9, 0x60, 0x6A, 0x68, 0xF8, 0xE8, 0x10,
    0x00, 0xF0, 0x01, 0xF5, 0x45, 0xF9
};

%ctor{
    
#if __arm64e__
    HBLogDebug(@"arm64e");
    void* uses_tab_bar_func = libundirect_find(@"MobileSafari", uses_tab_bar_unique_arm64e, sizeof(uses_tab_bar_unique_arm64e), 0x7F);
    void* show_tab_bar_func = libundirect_find(@"MobileSafari", show_tab_bar_unique_arm64e, sizeof(show_tab_bar_unique_arm64e), 0x7F);
#else
    HBLogDebug(@"arm64");
    void* uses_tab_bar_func = libundirect_find(@"MobileSafari", uses_tab_bar_unique_arm64, sizeof(uses_tab_bar_unique_arm64), 0xE9);
    void* show_tab_bar_func = libundirect_find(@"MobileSafari", show_tab_bar_unique_arm64, sizeof(show_tab_bar_unique_arm64), 0xF6);
#endif
    
    if (uses_tab_bar_func){
        MSHookFunction(uses_tab_bar_func, (void *)&uses_tab_bar_func_replaced, (void **)&uses_tab_bar_func_orig);
    }
    
    if (show_tab_bar_func){
        MSHookFunction(show_tab_bar_func, (void *)&show_tab_bar_func_replaced, (void **)&show_tab_bar_func_orig);
    }
}
