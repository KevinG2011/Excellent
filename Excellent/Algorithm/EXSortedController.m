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
    for (NSUInteger i = 0; i < self.array.count; ++i) {
        NSUInteger min = i;
        for (NSUInteger j = i + 1; j < self.array.count; ++j) {
            if (self.array[j] < self.array[min]) {
                min = j;
            }
        }
        [self exchObjectAtIndex:i withObjectAtIndex:min];
    }
}

-(void)insertionSorted {
    for (NSUInteger i = 1; i < self.array.count; ++i) {
        for (NSUInteger j = i; j > 0 && self.array[j] < self.array[j - 1]; --j) {
            [self exchObjectAtIndex:j withObjectAtIndex:j - 1];
        }
    }
}

@end
