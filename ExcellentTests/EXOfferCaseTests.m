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
#import "EXNodeUtil.h"

@interface EXOfferCaseTests : XCTestCase
@property (nonatomic, strong) EXNode         *nodeList;
@end

@implementation EXOfferCaseTests

- (void)setUpNodeList {
    
}

- (void)setUp {
    [super setUp];
    _nodeList = [[EXNode alloc] init];
    _nodeList.iid = @"0";
    
    unsigned int capacity = 2 * 5;
    NSMutableArray* mutArr = [NSMutableArray arrayWithCapacity:capacity];
    for (int i = 1; i < capacity; ++i) {
        [mutArr addObject:@(i)];
    }
    EXNode *curNode = _nodeList;
    for (NSNumber *num in mutArr) {
        EXNode *node = [[EXNode alloc] init];
        node.iid = num.stringValue;
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
    [EXNodeUtil printNodeReversingRecursively:_nodeList];
    printf("\n");
}

- (void)PerformanceExample {
    [self measureBlock:^{
    }];
}

@end
