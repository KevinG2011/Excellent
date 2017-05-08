//
//  EXSortedBaseController.m
//  Excellent
//
//  Created by lijia on 08/05/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "EXSortedBaseController.h"
@interface EXSortedBaseController ()
@property (nonatomic, strong) NSMutableArray<NSNumber*>* arr;
@end


@implementation EXSortedBaseController
-(void)rangeCheck:(NSUInteger)index {
    NSAssert(index < _arr.count,@"IndexOutOfBoundsException");
}

-(void)exchObjectAtIndex:(NSUInteger)idx1
       withObjectAtIndex:(NSUInteger)idx2 {
    [self rangeCheck:idx1];
    [self rangeCheck:idx2];
    [_arr exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

-(void)show {
    NSString* desc = [self.array componentsJoinedByString:@" "];
    NSLog(@"%@",desc);
}


-(NSArray<NSNumber *> *)array {
    return [_arr copy];
}

-(void)setArray:(NSArray<NSNumber *> *)array {
    _arr = [NSMutableArray arrayWithArray:array];
}

@end
