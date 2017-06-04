//
//  EXRuntime.m
//  Excellent
//
//  Created by Loriya on 2017/6/3.
//  Copyright © 2017年 Li Jia. All rights reserved.
//

#import "EXRuntime.h"
#import <objc/runtime.h>

@implementation EXRuntime
static inline void ex_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector)
{
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
    }
}
@end
