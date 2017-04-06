//
//  AlgorithmController.m
//  Excellent
//
//  Created by Loriya on 2017/4/4.
//  Copyright © 2017年 Li Jia. All rights reserved.
//

#import "AlgorithmController.h"

@interface AlgorithmController ()

@end

@implementation AlgorithmController
//最大公约数
+ (int)gcd:(int)p q:(int)q {
    if (q == 0) {
        return p;
    }
    int r = p % q;
    return [self gcd:p q:r];
}

//查找法
+ (NSInteger)ordinarySearch:(NSNumber*)num inArray:(NSArray<NSNumber*>*)array {
    NSInteger index = [array indexOfObjectPassingTest:^BOOL(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([num isEqualToNumber:obj]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    return index;
}

@end