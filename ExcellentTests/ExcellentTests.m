//
//  ExcellentTests.m
//  ExcellentTests
//
//  Created by Loriya on 2017/4/6.
//  Copyright © 2017年 Li Jia. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EXAlgorithmViewController.h"
#import "NSArray+Additions.h"

@interface ExcellentTests : XCTestCase
@property (nonatomic, strong) NSArray<NSNumber*>*   arr;
@end

@implementation ExcellentTests

- (void)setUp {
    [super setUp];
    unsigned int capacity = 200 * 10000;
    NSMutableArray* mutArr = [NSMutableArray arrayWithCapacity:capacity];
    for (int i = 0; i < capacity; ++i) {
        [mutArr addObject:@(i)];
    }
    self.arr = [mutArr ex_shuffle];
}

- (void)tearDown {
    self.arr = nil;
    [super tearDown];
}

- (void)testBinarySearch {
    [self measureBlock:^{
        NSNumber* num = @(78000);
        NSInteger index = [EXAlgorithmViewController binarySearch:num inArray:self.arr];
        XCTAssertNotEqual(index, NSNotFound,@"error!");
    }];
}

- (void)testSystemBinarySearch {
    [self measureBlock:^{
        NSNumber* num = @(78000);
        NSInteger index = [EXAlgorithmViewController systemBinarySearch:num inArray:self.arr];
        XCTAssertNotEqual(index, NSNotFound,@"error!");
    }];
}

- (void)testBruteForceSearch {
    [self measureBlock:^{
        NSNumber* num = @(78000);
        NSInteger index = [EXAlgorithmViewController bruteForceSearch:num inArray:self.arr];
        XCTAssertNotEqual(index, NSNotFound,@"error!");
    }];
}

- (void)testRecursiveSearch {
    [self measureBlock:^{
        NSNumber* num = @(78000);
        NSInteger index = [EXAlgorithmViewController recursiveSearch:num inArray:self.arr];
        XCTAssertNotEqual(index, NSNotFound,@"error!");
    }];
}

@end
