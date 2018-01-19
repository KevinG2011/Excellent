//
//  EXNodeViewController.m
//  Excellent
//
//  Created by lijia on 2018/1/19.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import "EXNodeUtil.h"

@interface EXNodeUtil ()

@end

@implementation EXNodeUtil

+(NSUInteger)getNodeLength:(EXNode*)headNode {
    if (headNode == nil) {
        return 0;
    }
    NSUInteger len = 1;
    while (headNode.next) {
        headNode = headNode.next;
        len += 1;
    }
    return len;
}

+(EXNode*)getCrossNode:(EXNode*)headNode {
    if (headNode == nil) {
        return nil;
    }
    
    EXNode *fastNode = headNode;
    EXNode *slowNode = headNode;
    while (fastNode.next) {
        fastNode = fastNode.next.next;
        slowNode = slowNode.next;
        if (fastNode == slowNode) {
            return fastNode;
        }
    }
    
    return nil;
}

+(BOOL)isCircleNode:(EXNode*)headNode {
    return ([self getCrossNode:headNode] != nil);
}

+(EXNode*)getCircleEnterNode:(EXNode*)headNode crossNode:(EXNode*)crossNode {
    if (headNode == crossNode) {
        return nil;
    }
    
    if (headNode == nil || crossNode == nil) {
        return nil;
    }
    EXNode *p1 = headNode, *p2 = crossNode;
    while (p1 != p2) {
        p1 = p1.next;
        p2 = p2.next;
    }
    return p1;
}

+(EXNode*)getCircleEnterNode:(EXNode*)headNode {
    EXNode *crossNode = [self getCrossNode:headNode];
    if (crossNode) {
        return [self getCircleEnterNode:headNode crossNode:crossNode];
    }
    return nil;
}
@end
