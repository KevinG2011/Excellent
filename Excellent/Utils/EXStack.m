//
//  EXStack.m
//  Excellent
//
//  Created by lijia on 10/04/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "EXStack.h"
@interface EXStack()
@property (nonatomic, strong) NSMutableArray*        array;
@end

@implementation EXStack
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}

- (void)push:(id)obj {
    [self.array addObject:obj];
}

- (id)pop {
    id obj = [self.array lastObject];
    [self.array removeLastObject];
    return obj;
}

- (NSUInteger)size {
    return [self.array count];
}

- (BOOL)isEmpty {
    return (self.array.count == 0);
}

- (id)peek {
    return [self.array lastObject];
}

@end
