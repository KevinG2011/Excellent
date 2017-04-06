//
//  ExcellentTests.m
//  ExcellentTests
//
//  Created by Loriya on 2017/4/6.
//  Copyright © 2017年 Li Jia. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AlgorithmController.h"

@interface ExcellentTests : XCTestCase
@property (nonatomic, strong) NSArray<NSNumber*>*   arr;
@end

@implementation ExcellentTests

- (void)setUp {
    [super setUp];
    unsigned int capacity = 2000 * 10000;
    NSMutableArray* mutArr = [NSMutableArray arrayWithCapacity:capacity];
    for (int i = 0; i < capacity; ++i) {
        [mutArr addObject:@(i)];
    }
    self.arr = [mutArr copy];
}

- (void)tearDown {
    [super tearDown];
    self.arr = nil;
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    __block int count = 0;
    [self measureBlock:^{
        NSNumber* num = @(7600111);
        NSInteger index = [AlgorithmController ordinarySearch:num inArray:self.arr];
        XCTAssertNotEqual(index, NSNotFound,@"error!");
        ++count;
        NSLog(@"test count %d",count);
    }];
}

@end
