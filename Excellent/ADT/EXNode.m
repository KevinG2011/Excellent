//
//  EXNode.m
//  Excellent
//
//  Created by lijia on 11/04/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "EXNode.h"
#import "EXNodeUtil.h"

@implementation EXNode
-(NSString *)description {
    EXNode* node = self;
    NSMutableString* desc = [[NSMutableString alloc] init];
    [desc setString:node.iid];
    EXNode *crossNode = [EXNodeUtil getCrossNode:node];
    if (crossNode) {
        EXNode *enterNode = [EXNodeUtil getCircleEnterNode:node crossNode:crossNode];
        unsigned int loopCount = 0;
        while (node.next && loopCount < 2) {
            node = node.next;
            [desc appendFormat:@"->%@",node.iid];
            if (node == enterNode) {
                loopCount += 1;
            }
        }
        [desc appendFormat:@"->@"];
    } else {
        while (node.next) {
            node = node.next;
            [desc appendFormat:@"->%@",node.iid];
        }
    }

    return [desc copy];
}
@end
