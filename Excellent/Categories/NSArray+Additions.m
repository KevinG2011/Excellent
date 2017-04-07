//
//  NSArray+Additions.m
//  Excellent
//
//  Created by lijia on 07/04/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "NSArray+Additions.h"

@implementation NSArray (Additions)
- (NSArray*)ex_shuffle {
    NSMutableArray* shuffleArr = [self mutableCopy];
    uint32_t i = (uint32_t)self.count - 1;
    for (; i > 0 ; --i) {
        NSUInteger n = arc4random_uniform(i);
        [shuffleArr exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    return [shuffleArr copy];
}
@end
