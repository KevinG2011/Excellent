//
//  CollectionTest.m
//  Excellent
//
//  Created by lijia on 11/04/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EXNodeUtil.h"
#import "EXNode.h"

@interface NodeTest : XCTestCase
@property (nonatomic, strong) EXNode*         node;
@property (nonatomic, strong) EXNode*         circleNodeA;
@property (nonatomic, strong) EXNode*         circleNodeB;
@end

@implementation NodeTest
- (void)tearDown {
    self.node = nil;
    self.circleNodeA = nil;
    self.circleNodeB = nil;
    [super tearDown];
}

- (void)setUp {
    [super setUp];
    //线性链表
    self.node = [[EXNode alloc] init];
    EXNode* currentNode = self.node;
    currentNode.iid = @"1";
    
    for (int i = 0 ; i < 15; ++i) {
        EXNode* node = [[EXNode alloc] init];
        node.iid = [NSString stringWithFormat:@"%d",i + 2];
        
        currentNode.next = node;
        currentNode = currentNode.next;
    }
    
    //环形链表A
    self.circleNodeA = [[EXNode alloc] init];
    currentNode = self.circleNodeA;
    currentNode.iid = @"1";
    
    EXNode *enterNode = currentNode;
    EXNode *commonNode = currentNode;
    for (int i = 2 ; i < 17; ++i) {
        EXNode* node = [[EXNode alloc] init];
        node.iid = [NSString stringWithFormat:@"%d", i];
        
        currentNode.next = node;
        currentNode = currentNode.next;
        
        if (i == 4) {
            commonNode = currentNode;
        }
        if (i == 9) {
            enterNode = currentNode;
        }
    }
    
    currentNode.next = enterNode;
    
    //环形链表B
    self.circleNodeB = [[EXNode alloc] init];
    currentNode = self.circleNodeB;
    currentNode.iid = @"-5";
    
    for (int i = -4 ; i < 0; ++i) {
        EXNode* node = [[EXNode alloc] init];
        node.iid = [NSString stringWithFormat:@"%d",i];
        
        currentNode.next = node;
        currentNode = currentNode.next;
    }
    
    currentNode.next = commonNode;
    NSLog(@"%@", self.circleNodeB);
}

- (void)testNodeDelete {
    int k = 3;
    int i = 1;
    EXNode* node = self.node;
    while (node.next) {
        if (i == k - 1) {
            EXNode* next = node.next.next;
            node.next = next;
            break;
        }
        node = node.next;
        i++;
    }
    NSLog(@"%@",self.node);
}

/**
 *  测试链表长度
 */
- (void)testNodeLength {
    NSUInteger len = [EXNodeUtil getNodeLength:self.node];
    XCTAssertTrue(len == 16);

}

/**
 *  获取环形链表相遇交点
 */
- (void)testGetCrossNode {
    EXNode *node = [EXNodeUtil getCrossNode:self.node];
    XCTAssertNil(node);
    
    EXNode *crossNode = [EXNodeUtil getCrossNode:self.circleNodeA];
    XCTAssertNotNil(crossNode);
}

/**
 *  是否是环形链表
 */
- (void)testIsCircleNode {
    BOOL ret = [EXNodeUtil isCircleNode:self.node];
    XCTAssertTrue(!ret);
    BOOL isCircle = [EXNodeUtil isCircleNode:self.circleNodeA];
    XCTAssertTrue(isCircle);
}

/**
 *  环形列表入口点
 */
- (void)testGetEnterNode {
    EXNode *enterNode = [EXNodeUtil getCircleEnterNode:self.node crossNode:self.node];
    XCTAssertNil(enterNode);
    
    EXNode *crossNode = [EXNodeUtil getCrossNode:self.circleNodeA];
    XCTAssertNotNil(crossNode);
    
    EXNode *enterANode = [EXNodeUtil getCircleEnterNode:self.circleNodeA crossNode:crossNode];
    XCTAssertNotNil(enterANode);
}

@end
