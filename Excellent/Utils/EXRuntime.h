//
//  EXRuntime.h
//  Excellent
//
//  Created by Loriya on 2017/6/3.
//  Copyright © 2017年 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXRuntime : NSObject
static inline void ex_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector);
@end
