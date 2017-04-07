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

+ (NSInteger)binarySearch:(NSNumber*)num inArray:(NSArray<NSNumber*>*)array {
    //sort first concurrent
    array = [array sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(NSNumber* n1, NSNumber* n2) {
        return [n1 compare:n2];
    }];
    NSUInteger lo = 0, hi = array.count - 1;
    while (lo <= hi) {
        NSUInteger mid = lo + (hi - lo) / 2;
        NSNumber* midNum = array[mid];
        NSComparisonResult result = [num compare:midNum];
        
        if (result == NSOrderedAscending) {
            hi = mid - 1;
        } else if (result == NSOrderedDescending) {
            lo = mid + 1;
        } else {
            return mid;
        }
    }
    
    return NSNotFound;
}

+ (NSInteger)systemBinarySearch:(NSNumber*)num inArray:(NSArray<NSNumber*>*)array {
    //also needs sort first concurrent
    array = [array sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(NSNumber* n1, NSNumber* n2) {
        return [n1 compare:n2];
    }];
    
    NSRange range = NSMakeRange(0, array.count - 1);
    NSInteger index = [array indexOfObject:num
                             inSortedRange:range
                                   options:NSBinarySearchingFirstEqual
                           usingComparator:^NSComparisonResult(NSNumber* n1, NSNumber* n2) {
                               return [n1 compare:n2];
                           }
                       ];
    return index;
}
@end
