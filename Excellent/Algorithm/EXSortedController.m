//
//  EXSortedController.m
//  Excellent
//
//  Created by Loriya on 2017/5/7.
//  Copyright © 2017年 Li Jia. All rights reserved.
//

#import "EXSortedController.h"
@interface EXSortedController ()

@end

@implementation EXSortedController
-(void)selectionSorted {
    NSArray<NSNumber*>* stableArr = self.array;
    for (NSUInteger i = 0; i < stableArr.count; ++i) {
        NSUInteger min = i;
        for (NSUInteger j = i + 1; j < stableArr.count; ++j) {
            if (stableArr[j] < stableArr[i]) {
                min = j;
            }
        }
        [self exchObjectAtIndex:i withObjectAtIndex:min];
    }
}

-(void)insertionSorted {
    NSArray<NSNumber*>* stableArr = self.array;
    for (NSUInteger i = 1; i < stableArr.count; ++i) {
        for (NSUInteger j = i; j > 0 && stableArr[j] < stableArr[j - 1]; --j) {
            [self exchObjectAtIndex:j withObjectAtIndex:j - 1];
        }
    }
}

@end
