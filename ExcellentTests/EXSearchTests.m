//
//  ExcellentTests.m
//  ExcellentTests
//
//  Created by Loriya on 2017/4/6.
//  Copyright © 2017年 Li Jia. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EXSearchController.h"
#import "NSArray+Additions.h"

@interface EXSearchTests : XCTestCase
@property (nonatomic, strong) EXSearchController*   searchController;
@end

@implementation EXSearchTests

- (void)setUp {
    [super setUp];
//    unsigned int capacity = 200 * 10000;
//    NSMutableArray* mutArr = [NSMutableArray arrayWithCapacity:capacity];
//    for (int i = 0; i < capacity; ++i) {
//        [mutArr addObject:@(i)];
//    }
//    NSMutableArray* arr = [mutArr ex_shuffle];
    self.searchController = [[EXSearchController alloc] init];
//    self.searchController.array = arr;
}

- (void)tearDown {
    self.searchController = nil;
    [super tearDown];
}

- (void)testBinarySearch {
    [self measureBlock:^{
        NSNumber* num = @(78000);
        NSInteger index = [self.searchController binarySearch:num];
        XCTAssertNotEqual(index, NSNotFound,@"error!");
    }];
}

- (void)testSystemBinarySearch {
    [self measureBlock:^{
        NSNumber* num = @(78000);
        NSInteger index = [self.searchController systemBinarySearch:num];
        XCTAssertNotEqual(index, NSNotFound,@"error!");
    }];
}

- (void)testBruteForceSearch {
    [self measureBlock:^{
        NSNumber* num = @(78000);
        NSInteger index = [self.searchController bruteForceSearch:num];
        XCTAssertNotEqual(index, NSNotFound,@"error!");
    }];
}

- (void)testRecursiveSearch {
    [self measureBlock:^{
        NSNumber* num = @(78000);
        NSInteger index = [self.searchController recursiveSearch:num];
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
