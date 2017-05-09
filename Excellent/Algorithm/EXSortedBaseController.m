//
//  EXSortedBaseController.m
//  Excellent
//
//  Created by lijia on 08/05/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "EXSortedBaseController.h"
@interface EXSortedBaseController ()

@end


@implementation EXSortedBaseController
-(void)rangeCheck:(NSUInteger)index {
    NSAssert(index < _array.count,@"IndexOutOfBoundsException");
}

-(BOOL)lessThan:(NSNumber*)n1 anthor:(NSNumber*)n2 {
    return ([n1 compare:n2] == NSOrderedAscending);
}

-(void)exchObjectAtIndex:(NSUInteger)idx1
       withObjectAtIndex:(NSUInteger)idx2 {
    [self rangeCheck:idx1];
    [self rangeCheck:idx2];
    [_array exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

-(void)show {
    NSString* desc = [_array componentsJoinedByString:@" "];
    NSLog(@"%@",desc);
}

@end
