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
            if ([self lessThan:self.array[j] anthor:self.array[min]]) {
                min = j;
            }
        }
        [self exchObjectAtIndex:i withObjectAtIndex:min];
    }
}

-(void)insertionSorted {
    for (NSUInteger i = 1; i < self.array.count; ++i) {
        for (NSUInteger j = i; j > 0 && [self lessThan:self.array[j] anthor:self.array[j - 1]]; --j) {
            [self exchObjectAtIndex:j withObjectAtIndex:j - 1];
        }
    }
}

-(void)shellSorted {
    int h = 1;
    while (h < self.array.count / 3) {
        h = 3 * h + 1;          //step
    }
    while (h >= 1) {
        for (NSUInteger i = h; i < self.array.count; ++i) {
            for (NSInteger j = i; j > h; j -= h) {
                NSInteger idx = j - h;
                if ([self lessThan:self.array[j] anthor:self.array[idx]]) {
                    [self exchObjectAtIndex:j withObjectAtIndex:idx];
                }
                j -= h;
            }
        }
        h = h / 3;
    }
}

-(void)p__mergeLow:(NSUInteger)low high:(NSUInteger)high {
    
}

-(void)mergeSorted {
    NSArray* cloneArray = [self.array copy];
    NSUInteger lo = 0, hi = self.array.count - 1, mid = hi / 2;
    NSUInteger m = lo , n = mid + 1;
    for (NSUInteger i = 0 ; i < cloneArray.count; ++i) {
        if (m > mid) {
            self.array[i] = cloneArray[n++];
        } else if (n > hi) {
            self.array[i] = cloneArray[m++];
        } else if ([self lessThan:cloneArray[m] anthor:cloneArray[n]]) {
            self.array[i] = cloneArray[m++];
        } else {
            self.array[i] = cloneArray[n++];
        }
    }
}

@end
