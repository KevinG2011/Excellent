//
//  EXStackQueue.m
//  Excellent
//
//  Created by lijia on 2018/1/29.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import "EXStackQueue.h"
#import "EXStack.h"

@interface EXStackQueue ()
@property (nonatomic, strong) EXStack         *stack1;
@property (nonatomic, strong) EXStack         *stack2;
@end

@implementation EXStackQueue
- (instancetype)init
{
    self = [super init];
    if (self) {
        _stack1 = [[EXStack alloc] init];
        _stack2 = [[EXStack alloc] init];
    }
    return self;
}

- (void)appendTail:(id)obj {
    [_stack1 push:obj];
}

- (id)deleteHead {
    if ([_stack2 isEmpty]) {
        while (![_stack1 isEmpty]) {
            [_stack2 push:[_stack1 pop]];
        }
    }
    return [_stack2 pop];
}

- (BOOL)isEmpty {
    return [_stack2 isEmpty] && [_stack1 isEmpty];
}
@end
