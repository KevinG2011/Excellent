//
//  EXSortedTests.m
//  Excellent
//
//  Created by lijia on 08/05/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EXSortedController.h"
#import "NSArray+Additions.h"

@interface EXSortedTests : XCTestCase
@property (nonatomic, strong) EXSortedController*   sortedController;
@end

@implementation EXSortedTests

- (void)setUp {
    [super setUp];
    unsigned int capacity = 0.0009 * 10000;
    NSMutableArray* mutArr = [NSMutableArray arrayWithCapacity:capacity];
    for (int i = 0; i < capacity; ++i) {
        [mutArr addObject:@(i)];
    }
    NSMutableArray* arr = [mutArr ex_shuffle];
    self.sortedController = [[EXSortedController alloc] init];
    self.sortedController.array = arr;
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSelection {
    [self measureBlock:^{
        [self.sortedController selectionSorted];
        [self.sortedController show];
    }];
}

- (void)testInsertion {
    [self measureBlock:^{
        [self.sortedController insertionSorted];
        [self.sortedController show];
    }];
}

- (void)testMergeSorted {
    [self measureBlock:^{
        [self.sortedController mergeSorted];
        [self.sortedController show];
    }];
}


@end
