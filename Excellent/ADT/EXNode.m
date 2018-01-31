//
//  EXNode.m
//  Excellent
//
//  Created by lijia on 11/04/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "EXNode.h"
#import "EXNodeCase.h"

@implementation EXNode
-(NSString *)description {
    EXNode* node = self;
    NSMutableString* desc = [[NSMutableString alloc] init];
    [desc setString:node.value];
    /* 判断链表是否带环, 如果带环则返回快慢指针交点 */
    EXNode *crossNode = [EXNodeCase findCircleCrossNode:node];
    if (crossNode) {
        /* 查找环入口节点 */
        EXNode *enterNode = [EXNodeCase findCircleEnterNode:node crossNode:crossNode];
        unsigned int loopCount = 0;
        while (node.next) {
            node = node.next;
            [desc appendFormat:@"->%@",node.value];
            if (node == enterNode) {
                loopCount += 1;
                /* 遍历环一圈, 第二圈退出 */
                if (loopCount >= 2) {
                    break;
                }
            }
        }
        [desc appendFormat:@"->@"];
    } else {
        while (node.next) {
            node = node.next;
            [desc appendFormat:@"->%@",node.value];
        }
    }

    return [desc copy];
}
@end
