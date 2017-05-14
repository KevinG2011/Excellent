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

-(void)p__mergeLow:(NSUInteger)lo mid:(NSUInteger)mid high:(NSUInteger)hi inArray:(NSMutableArray*)arr {
    for (NSUInteger i = lo ; i <= hi; ++i) {
        arr[i] = self.array[i];
    }
    
    NSUInteger m = lo , n = mid + 1;
    for (NSUInteger i = lo ; i <= hi; ++i) {
        if (m > mid) {
            self.array[i] = arr[n++];
        } else if (n > hi) {
            self.array[i] = arr[m++];
        } else if ([self lessThan:arr[m] anthor:arr[n]]) {
            self.array[i] = arr[m++];
        } else {
            self.array[i] = arr[n++];
        }
    }
}

- (void)p__mergeSortedLow:(NSUInteger)lo high:(NSUInteger)hi inArray:(NSMutableArray*)arr {
    if (lo >= hi) {
        return;
    }
    NSUInteger mid = lo + (hi - lo) / 2;
    [self p__mergeSortedLow:lo high:mid inArray:arr];    //sorted left
    [self p__mergeSortedLow:mid + 1 high:hi inArray:arr]; //sorted right
    if ([self lessThan:self.array[mid] anthor:self.array[mid + 1]] == NO) {
        [self p__mergeLow:lo mid:mid high:hi inArray:arr];    //merge two part.
    }
}

-(void)mergeSorted {
    NSMutableArray* arrayCopy = [self.array mutableCopy];
    NSUInteger lo = 0, hi = self.array.count - 1;
    [self p__mergeSortedLow:lo high:hi inArray:arrayCopy];
}

-(NSUInteger)p__partitionLow:(NSUInteger)lo high:(NSUInteger)hi {
    NSUInteger i = lo,j = hi;
    NSNumber* v = self.array[lo];
    while (true) {
        while ([self lessThan:self.array[++i] anthor:v]) {
            if (i == j) {
                break;
            }
        }
        while ([self lessThan:v anthor:self.array[j--]]) {
            if (j == i) {
                break;
            }
        }
        
        if (i == j) {
            break;
        }
    }
    [self exchObjectAtIndex:lo withObjectAtIndex:j];
    return j;
}

-(void)p__quickSortedLow:(NSUInteger)lo high:(NSUInteger)hi {
    if (lo >= hi) {
        return;
    }
    NSUInteger j = [self p__partitionLow:lo high:hi];
    [self p__quickSortedLow:lo high:j - 1];
    [self p__quickSortedLow:j + 1 high:hi];
}

-(void)quickSorted {
    NSUInteger lo = 0,hi = self.array.count - 1;
    [self p__quickSortedLow:lo high:hi];
}

@end
