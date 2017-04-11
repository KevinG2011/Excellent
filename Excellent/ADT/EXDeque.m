//
//  EXDeque.m
//  Excellent
//
//  Created by lijia on 11/04/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "EXDeque.h"
@interface EXDeque()
@property (nonatomic, strong) NSMutableArray*        array;
@end


@implementation EXDeque
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}

- (void)pushLeft:(id)obj {
    [self.array insertObject:obj atIndex:0];
}

- (void)pushRight:(id)obj {
    [self.array addObject:obj];
}

- (id)popLeft {
    id obj = nil;
    if (self.array.count > 0) {
        obj = [self.array objectAtIndex:0];
        [self.array removeObjectAtIndex:0];
    }
    return obj;
}

- (id)popRight {
    id obj = nil;
    if (self.array.count > 0) {
        obj = [self.array lastObject];
        [self.array removeLastObject];
    }
    return obj;
}

- (BOOL)isEmpty {
    return (self.array.count == 0);
}

@end
