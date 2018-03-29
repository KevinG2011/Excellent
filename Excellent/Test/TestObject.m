//
//  TestObject.m
//  Excellent
//
//  Created by lijia on 2018/3/29.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import "TestObject.h"
#import <objc/runtime.h>

@implementation TestObject
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.op = [NSOperation new];
        NSLog(@"%@", object_getClass(self.op));
        [self.op addObserver:self forKeyPath:@"finished" options:NSKeyValueObservingOptionNew context:NULL];
        NSLog(@"%@", object_getClass(self.op));
        
        [TestSubObject sendMsg];
    }
    return self;
}

+(void)sendMsg {
    NSLog(@"1111");
}
@end



@implementation TestSubObject
+(void)sendMsg {
    NSLog(@"2222");
}
@end
