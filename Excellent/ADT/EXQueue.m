//
//  EXQueue.m
//  Excellent
//
//  Created by lijia on 10/04/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "EXQueue.h"
@interface EXQueue()
@property (nonatomic, strong) NSMutableArray*        array;
@end


@implementation EXQueue
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}

- (void)enqueue:(id)obj {
    [self.array addObject:obj];
}

- (id)dequeue {
    id obj = nil;
    if (self.array.count > 0) {
        obj = [self.array objectAtIndex:0];
        [self.array removeObjectAtIndex:0];
    }
    return obj;
}

- (BOOL)isEmpty {
    return (self.array.count == 0);
}

@end
