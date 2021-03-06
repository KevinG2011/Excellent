//
//  Global.h
//  Excellent
//
//  Created by leo on 16/3/29.
//  Copyright © 2016年 Li Jia. All rights reserved.
//

#ifndef Global_h
#define Global_h

#define APP_OBJ                 [UIApplication sharedApplication]
#define APP_DELEGATE            ((AppDelegate *)[APP_OBJ delegate])
#define APP_KEYWIN              (((AppDelegate *)[UIApplication sharedApplication].delegate).window)

#define _IMAGE(n)               [UIImage imageNamed:(n)]
#define _FONT(n)                [UIFont systemFontOfSize:(n)]
#define _FONT_B(n)              [UIFont boldSystemFontOfSize:(n)]

#define _LS(n)                  NSLocalizedStringFromTable(n, @"living", nil)
#define _COLOR_HEX(c)           [UIColor colorForHex:@#c]
#define _COLOR(c)               [UIColor c ## Color]
#define _COLOR_RGBA(r,g,b,a)    [UIColor colorWithRed:r green:g blue:b alpha:a]
#define _COLOR_WHITEA(w,a)      [UIColor colorWithWhite:w alpha:a]

#define kScreenBounds           [[UIScreen mainScreen] bounds]
#define kScreenWidth            kScreenBounds.size.width
#define kScreenHeight           kScreenBounds.size.height

#define C_ASSERT(test) \
    switch(0) {\
        case 0:\
        case test:;\
    }

#define keypath2(OBJ, PATH) \
(((void)(NO && ((void)OBJ.PATH, NO)), # PATH))

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#endif /* Global_h */
