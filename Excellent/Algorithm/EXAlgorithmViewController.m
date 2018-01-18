//
//  AlgorithmController.m
//  Excellent
//
//  Created by Loriya on 2017/4/4.
//  Copyright © 2017年 Li Jia. All rights reserved.
//

#import "EXAlgorithmViewController.h"
#import "EXNode.h"

@interface EXAlgorithmViewController ()
@property (nonatomic, strong) EXNode         *nodeList;
@end

@implementation EXAlgorithmViewController
- (void)setupNodeList {
    EXNode *node = [[EXNode alloc] init];
    node.iid = @"0";
    _nodeList = node;
    for (int i = 1 ; i < 10; ++i) {
        EXNode *nextNode = [[EXNode alloc] init];
        nextNode.iid = [NSString stringWithFormat:@"%d",i];
        node.next = nextNode;
        node = nextNode;
    }
}

-(void)reverseNodeList {
    NSLog(@"%@", _nodeList);
    EXNode* currentNode = _nodeList;
    EXNode* reverseNode = [[EXNode alloc] init];
    reverseNode.iid = currentNode.iid;
    while (currentNode.next) {
        EXNode *nextNode = currentNode.next;
        EXNode *revNextNode = [[EXNode alloc] init];
        revNextNode.iid = nextNode.iid;
        revNextNode.next = reverseNode;
        
        reverseNode = revNextNode;
        currentNode = nextNode;
    }
    NSLog(@"%@", reverseNode);
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setupNodeList];
    [self reverseNodeList];
}
@end
