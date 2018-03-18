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
#import "EXSearchCase.h"
#import "EXSortedCase.h"

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

- (void)testQuickSort {
    int arr[] = {9, 4, 3, 8, 2, 5, 7, 11, 15, 12, 1};
    int len = sizeof(arr) / sizeof(int);
    quickSort(arr, len);
    for (int i = 0 ; i < len; ++i) {
        printf("%d",arr[i]);
    }
}

- (void)testHasSequencePath {
    char matrix[] = {'k', 'q', 'u', 'i',
                     'e', 't', 's', 'o',
                     'f', 'l', 'h', 'm',
                     'a', 'n', 'v', 'c'};
    
    bool hasPath = hasStringPathInMatrix(matrix, 4, 4, "ustl");
    XCTAssertTrue(hasPath == true);
}

- (void)testmovingCount {
    /*
     {3,0}, {3,1}, {3,2}, {3,3}, {3,4}
     {2,0}, {2,1}, {2,2}, {2,3}, {2,4}
     {1,0}, {1,1}, {1,2}, {1,3}, {1,4}
     {0,0}, {0,1}, {0,2}, {0,3}, {0,4}
     */
    int rows = 3, cols = 3;
    int count = movingCountLoop(rows, cols, 1);
    printf("loop count :%d \n",count);
    count = movingCountRecursively(rows, cols, 1);
    printf("recursively count :%d \n",count);
}

- (void)testMaxProductAfterCutting_2 {
    int product = maxProductAfterCutting_2(4);
    printf("%d\n",product);
}

- (void)testTransformToColumnNum {
    char *charsetSeq = "AAB";
    int column = transformToColumnNum(charsetSeq);
    printf("%d\n",column);
}

- (void)testCountBinary1 {
    int count = countBinaryOf1_2(11);
    printf("count :%d\n",count);
}

- (void)testFuncPower {
    double num = funcPowerf(2, 4);
    printf("abs :%f\n",num);
}

- (void)testPrintMaxOfNDigit {
    /* 递归*/
    printMaxOfNDigit(2, RecursivelyType);
    /* 递增 */
//    printMaxOfNDigit(3, IncreaseType);
}

enum ComparisonResult _compareFunc(int num) {
    if ((num & 0x1) == 1) {
        return OrderedAscending;
    } else {
        return OrderedDescending;
    }
}

- (void)testExchangeOddEven {
    //测试交换奇偶数
    int arr[] = {3, 2, 4, 5, 8, 0, 11, 6, 3, 7};
    int len = sizeof(arr) / sizeof(int);
    exchangeOddEven(arr, len, _compareFunc);
    for (int i = 0 ; i < len; ++i) {
        printf("%d, ",arr[i]);
    }
    printf("\n");
}

- (void)testfindKthNodeToTail {
    EXNode *kNode = findKthNodeToTail(self.nodeList, 2);
    NSLog(@"kNode value :%@",kNode.value);
}

- (void)testSelectionSorted {
    int arr[] = {3, 2, 4, 5, 8, 0, 11, 6, 3, 7};
    int len = sizeof(arr) / sizeof(int);
    selectionSorted(arr, len);
    for (int i = 0 ; i < len; ++i) {
        printf("%d, ",arr[i]);
    }
}

- (void)testInsertSorted {
    int arr[] = {3, 2, 4, 5, 8, 0, 11, 6, 3, 7};
    int len = sizeof(arr) / sizeof(int);
    insertSorted(arr, len);
    for (int i = 0 ; i < len; ++i) {
        printf("%d, ",arr[i]);
    }
}

- (void) testPermutation {
    char str[] = "ab";
    permutation(str, str);
}

- (void)PerformanceExample {
    [self measureBlock:^{
        
    }];
}

@end
