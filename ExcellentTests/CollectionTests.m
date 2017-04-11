//
//  CollectionTest.m
//  Excellent
//
//  Created by lijia on 11/04/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EXNode.h"

@interface CollectionTest : XCTestCase
@property (nonatomic, strong) EXNode*         node;
@end

@implementation CollectionTest

- (void)setUp {
    [super setUp];
    self.node = [[EXNode alloc] init];
    self.node.iid = @"1";
    
    int k = 1;
    EXNode* root = self.node;
    while (k < 5) {
        EXNode* node = [[EXNode alloc] init];
        node.iid = [NSString stringWithFormat:@"%d",k + 1];
        
        root.next = node;
        root = root.next;
        k++;
    }
    
}

- (void)tearDown {
    self.node = nil;
    [super tearDown];
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

@end
