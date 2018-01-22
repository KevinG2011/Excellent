//
//  ExcellentTests.m
//  ExcellentTests
//
//  Created by Loriya on 2017/4/6.
//  Copyright © 2017年 Li Jia. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EXSearchUtil.h"
#import "NSArray+Additions.h"

@interface EXSearchTests : XCTestCase
@property (nonatomic, strong) NSArray         *arr;
@end

@implementation EXSearchTests

- (void)setUp {
    [super setUp];
    unsigned int capacity = 2 * 10000;
    NSMutableArray* mutArr = [NSMutableArray arrayWithCapacity:capacity];
    for (int i = 0; i < capacity; ++i) {
        [mutArr addObject:@(i)];
    }
    self.arr = [mutArr ex_shuffle];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testBinarySearch {
    [self measureBlock:^{
        NSNumber* num = @(78000);
        NSInteger index = [EXSearchUtil binarySearch:num inArray:self.arr];
        XCTAssertNotEqual(index, NSNotFound,@"error!");
    }];
}

- (void)testSystemBinarySearch {
    [self measureBlock:^{
        NSNumber* num = @(78000);
        NSInteger index = [EXSearchUtil systemBinarySearch:num inArray:self.arr];
        XCTAssertNotEqual(index, NSNotFound,@"error!");
    }];
}

- (void)testBruteForceSearch {
    [self measureBlock:^{
        NSNumber* num = @(78000);
        NSInteger index = [EXSearchUtil bruteForceSearch:num inArray:self.arr];
        XCTAssertNotEqual(index, NSNotFound,@"error!");
    }];
}

- (void)testRecursiveSearch {
    [self measureBlock:^{
        NSNumber* num = @(78000);
        NSInteger index = [EXSearchUtil recursiveSearch:num inArray:self.arr];
        XCTAssertNotEqual(index, NSNotFound,@"error!");
    }];
}

- (void)testSearchNumberInOrderedMatrix {
    int arr[] = { 1, 3,  5,  6,  9,
                  2, 5,  8, 11, 14,
                  4, 7, 12, 14, 19,
                  6, 9, 14, 17, 21 };
    bool found = searchNumberInOrderedMatrix(arr, 4, 5, 0);
    XCTAssertTrue(!found);
}

@end
