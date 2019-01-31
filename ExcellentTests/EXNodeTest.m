//
//  EXNodeTest.m
//  Excellent
//
//  Created by lijia on 11/04/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EXNodeCase.h"
#import "EXNode.h"

@interface EXNodeTest : XCTestCase
@property (nonatomic, strong) EXNode*         node;
@property (nonatomic, strong) EXNode*         circleNodeA;
@property (nonatomic, strong) EXNode*         circleNodeB;
@end

@implementation EXNodeTest
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
    currentNode.value = @"1";

    for (int i = 0 ; i < 15; ++i) {
        EXNode* node = [[EXNode alloc] init];
        node.value = [NSString stringWithFormat:@"%d",i + 2];

        currentNode.next = node;
        currentNode = currentNode.next;
    }

    //环形链表A
    self.circleNodeA = [[EXNode alloc] init];
    currentNode = self.circleNodeA;
    currentNode.value = @"1";

    EXNode *enterNode = currentNode;
    EXNode *commonNode = currentNode;
    for (int i = 2 ; i < 17; ++i) {
        EXNode* node = [[EXNode alloc] init];
        node.value = [NSString stringWithFormat:@"%d", i];

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
    NSLog(@"A: %@", self.circleNodeA);

    //环形链表B
    self.circleNodeB = [[EXNode alloc] init];
    currentNode = self.circleNodeB;
    currentNode.value = @"-5";

    for (int i = -4 ; i < 0; ++i) {
        EXNode* node = [[EXNode alloc] init];
        node.value = [NSString stringWithFormat:@"%d",i];

        currentNode.next = node;
        currentNode = currentNode.next;
    }

    currentNode.next = commonNode;
    NSLog(@"B: %@", self.circleNodeB);
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
    NSUInteger len = [EXNodeCase getNodeLength:self.node];
    XCTAssertTrue(len == 16);

}

/**
 *  获取环形链表相遇交点
 */
- (void)testGetCrossNode {
    EXNode *node = [EXNodeCase findCircleCrossNode:self.node];
    XCTAssertNil(node);
    
    EXNode *crossNode = [EXNodeCase findCircleCrossNode:self.circleNodeA];
    XCTAssertNotNil(crossNode);
}

/**
 *  是否是环形链表
 */
- (void)testIsCircleNode {
    BOOL ret = [EXNodeCase isCircleNode:self.node];
    XCTAssertTrue(!ret);
    BOOL isCircle = [EXNodeCase isCircleNode:self.circleNodeA];
    XCTAssertTrue(isCircle);
}

/**
 *  环形列表入口点
 */
- (void)testGetEnterNode {
    EXNode *enterNode = [EXNodeCase findCircleEnterNode:self.node crossNode:self.node];
    XCTAssertNil(enterNode);
    
    EXNode *crossNode = [EXNodeCase findCircleCrossNode:self.circleNodeA];
    XCTAssertNotNil(crossNode);
    
    EXNode *enterANode = [EXNodeCase findCircleEnterNode:self.circleNodeA crossNode:crossNode];
    XCTAssertNotNil(enterANode);
}

/**
 *  环A与环B的交点
 */

- (void)testCircleNodeABCross {
    EXNode *crossA = [EXNodeCase findCircleEnterNode:self.circleNodeA];
    EXNode *crossB = [EXNodeCase findCircleEnterNode:self.circleNodeB];
    if (crossA == crossB) { //入口点相同
        EXNode *circleNode = crossA.next;
        crossA.next = nil;
        //TODO
        EXNode *commonNode = [self findFirstCommonNodeNoCircleWithNode:self.circleNodeA withNode:self.circleNodeB];
        NSLog(@"%@", commonNode);
        crossA.next = circleNode;
    } else { //入口点不同
        
    }
}

- (EXNode*)findFirstCommonNodeNoCircleWithNode:(EXNode*)node1
                                      withNode:(EXNode*)node2 {
    if ([EXNodeCase isCircleNode:node1] || [EXNodeCase isCircleNode:node2]) {
        //任意一个链表是环形链表则忽略
        return nil;
    }
    
    NSUInteger len1 = [EXNodeCase getNodeLength:node1];
    NSUInteger len2 = [EXNodeCase getNodeLength:node2];
    
    EXNode *longNode;
    EXNode *shortNode;
    if (len1 > len2) {
        longNode = node1;
        shortNode = node2;
    } else {
        shortNode = node1;
        longNode = node2;
    }
    NSUInteger step = abs(len1 - len2);
    while (step-- > 0) {
        longNode = longNode.next;
    }
    
    while (longNode != shortNode) {
        longNode = longNode.next;
        shortNode = shortNode.next;
    }
    
    EXNode *commonNode = longNode;
    return commonNode;
}




@end
