//
//  EXCNodeTest.m
//  ExcellentTests
//
//  Created by lijia on 2019/1/31.
//  Copyright © 2019 Li Jia. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TTNode.h"

@interface TTNodeTest : XCTestCase {
    TTNode *_linkList;
}

@end

@implementation TTNodeTest

- (void)setUp {
    TTNode *headNode = NULL;
    TTNode *node = NULL;
    int i = 0;
    while (i < 8) {
        TTNode *aNode = malloc(sizeof(TTNode*));
        aNode->next = NULL;
        aNode->data = i;
        if (!headNode) {
            headNode = aNode;
        }
        if (node) {
            node->next = aNode;
        }
        node = aNode;
        ++i;
    }
    _linkList = headNode;
}

- (void)tearDown {
    
}

void printLinkList(TTNode* linkList) {
    TTNode *node = linkList;
    while (node) {
        printf("%i", node->data);
        node = node->next;
        if (node) {
            printf("->");
        }
    }
    printf("\n");
}

- (void)testNodeReverse {
    printLinkList(_linkList);
    TTNode *rHeadNode = reverseLinkedList(_linkList);
    printLinkList(rHeadNode);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
