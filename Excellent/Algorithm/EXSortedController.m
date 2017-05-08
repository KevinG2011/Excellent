//
//  EXSortedController.m
//  Excellent
//
//  Created by Loriya on 2017/5/7.
//  Copyright © 2017年 Li Jia. All rights reserved.
//

#import "EXSortedController.h"
@interface EXSortedController ()
@property (nonatomic, strong) NSMutableArray<NSNumber*>* arr;
-(void)exchObjectAtIndex:(NSUInteger)idx1
       withObjectAtIndex:(NSUInteger)idx2;
@end

@implementation EXSortedController
-(void)selectionSorted {
    NSArray<NSNumber*>* tmpArr = self.array;
    for (NSUInteger i = 0; i < tmpArr.count; ++i) {
        NSUInteger min = i;
        for (NSUInteger j = i + 1; j < tmpArr.count; ++j) {
            if (tmpArr[j] < tmpArr[i]) {
                [self exchObjectAtIndex:min withObjectAtIndex:j];
            }
        }
    }
}

-(void)rangeCheck:(NSUInteger)index {
    NSAssert(index < _arr.count,@"IndexOutOfBoundsException");
}

-(void)exchObjectAtIndex:(NSUInteger)idx1
       withObjectAtIndex:(NSUInteger)idx2 {
    [self rangeCheck:idx1];
    [self rangeCheck:idx2];
    [_arr exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

-(NSArray<NSNumber *> *)array {
    return [_arr copy];
}

-(void)setArray:(NSArray<NSNumber *> *)array {
    _arr = [NSMutableArray arrayWithArray:array];
}

@end
