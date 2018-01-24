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

+(EXNode*)findCircleCrossNode:(EXNode*)headNode {
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
    return ([self findCircleCrossNode:headNode] != nil);
}

+(EXNode*)findCircleEnterNode:(EXNode*)headNode crossNode:(EXNode*)crossNode {
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

+(EXNode*)findCircleEnterNode:(EXNode*)headNode {
    EXNode *crossNode = [self findCircleCrossNode:headNode];
    if (crossNode) {
        return [self findCircleEnterNode:headNode crossNode:crossNode];
    }
    return nil;
}

+(void)reversePrintNode:(EXNode*)headNode {
    EXNode *nextNode = headNode;
    if (nextNode) {
        unsigned int len = 128;
        int arr[len];
        int index = len - 1;
        while (nextNode) {
            arr[index] = nextNode.iid.intValue;
            nextNode = nextNode.next;
            --index;
        }
        
        for (int i = index + 1; i < len; ++i) {
            printf("%d, ", arr[i]);
        }
        printf("\n");
    }
}

@end
