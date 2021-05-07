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

#define FIND_FUNCT(img, unq, strt, mx, opt) libundirect_find_with_options(img, unq, sizeof(unq), strt, mx, opt)
#define FIND_MS(unq, strt) FIND_FUNCT(MSIMG, unq, strt, 128, 0)

#define HOOK_FUNCT(x) MSHookFunction(x, (void *)&x##_replaced, (void **)&x##_orig);

#pragma mark USES_TAB_BAR
//sub_100035E64  - iOS 14.3 - ipad style cards
//sub_100040810  - iOS 14.3 - iphone style

unsigned char uses_tab_bar_unique[] =
{
    0x80, 0x04, 0x00, 0x34, 0xE0, 0x03, 0x14, 0xAA
};

#pragma mark SHOW_TAB_BAR
//sub_100037CB8 - iOS 14.3

unsigned char show_tab_bar_unique[] =
{
    0x1F, 0x04, 0x00, 0xF1, 0xA9, 0x00, 0x00, 0x54, 0x33, 0x00, 0x80, 0x52
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
    
    void* uses_tab_bar_func;
    void* show_tab_bar_func;
    
#if __arm64e__
    
    HBLogDebug(@"arm64e");
    uses_tab_bar_func = FIND_MS(uses_tab_bar_unique, PACIBSP);
    show_tab_bar_func = FIND_MS(show_tab_bar_unique, PACIBSP);
    
#else
    
    HBLogDebug(@"arm64");
    uses_tab_bar_func = FIND_MS(uses_tab_bar_unique, 0xE9);
    show_tab_bar_func = FIND_MS(show_tab_bar_unique, 0xF6);
    
#endif
    
    if (uses_tab_bar_func) HOOK_FUNCT(uses_tab_bar_func);
    if (show_tab_bar_func) HOOK_FUNCT(show_tab_bar_func);
}
