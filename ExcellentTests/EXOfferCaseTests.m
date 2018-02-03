//
//  EXOfferCasetTests.m
//  ExcellentTests
//
//  Created by lijia on 2018/1/23.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EXOfferCase.h"
#import "EXNode.h"
#import "EXNodeCase.h"
#import "EXSortCase.h"

@interface EXOfferCaseTests : XCTestCase
@property (nonatomic, strong) EXNode         *nodeList;
@end

@implementation EXOfferCaseTests

- (void)setUpNodeList {
    
}

- (void)setUp {
    [super setUp];
    _nodeList = [[EXNode alloc] init];
    _nodeList.value = @"0";
    
    unsigned int capacity = 2 * 5;
    NSMutableArray* mutArr = [NSMutableArray arrayWithCapacity:capacity];
    for (int i = 1; i < capacity; ++i) {
        [mutArr addObject:@(i)];
    }
    EXNode *curNode = _nodeList;
    for (NSNumber *num in mutArr) {
        EXNode *node = [[EXNode alloc] init];
        node.value = num.stringValue;
        curNode.next = node;
        curNode = node;
    }
    NSLog(@"%@",_nodeList);
}

- (void)tearDown {
    [super tearDown];
}

- (void)testReplaceBlankString {
    NSString *testString = @"This is a blank string!";
    size_t len = testString.length + 4*2 + 1;
    char testCharset[len];
    strcpy(testCharset, testString.UTF8String);
    printf("before: %s\n",testCharset);
    bool success = false;
    replaceBlankString(testCharset, 40, &success);
    printf("after: %s\n",testCharset);
    XCTAssertTrue(success);
}

- (void)testReversePrintNode {
//    [EXNodeUtil printNodeReversingly:_nodeList];
    [EXNodeCase printNodeReversingRecursively:_nodeList];
    printf("\n");
}

- (void)testConstructBinaryTree {
    //    [EXNodeUtil printNodeReversingly:_nodeList];
    int preorderArr[] = {1, 2, 4, 7, 3, 5, 6, 8};
    int inorderArr[] = {4, 7, 2, 1, 5, 3, 8, 6};
    
    EXBinaryTreeNode *binaryTree = constructBinaryTree(preorderArr, inorderArr, 8);
    recursivePrintTree(binaryTree);
}

- (void)testFibonacciN {
    long long n = fibonacciN(6);
    printf("fibonacciN :%lld \n",n);
}

- (void)testMinNumInRotatingArr {
    int numArr[] = { 7, 8 ,9, 5, 6 };
    int length = sizeof(numArr) / sizeof(int);
    int minNum = findMinNumInRotatingArr(numArr, length);
    XCTAssertTrue(minNum == 5);
}

- (void)testBinarySearch {
    int arr[] = {1, 2, 5, 7, 8, 9, 11, 14, 18, 20, 24};
    int len = sizeof(arr) / sizeof(int);
    int index = binarySearch(arr, len, 10);
    XCTAssertTrue(index < 0);
}

- (void)PerformanceExample {
    [self measureBlock:^{
    }];
}

@end
