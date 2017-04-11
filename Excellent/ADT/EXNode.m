//
//  EXNode.m
//  Excellent
//
//  Created by lijia on 11/04/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "EXNode.h"

@implementation EXNode
-(NSString *)description {
    EXNode* node = self;
    NSMutableString* desc = [[NSMutableString alloc] init];
    [desc setString:node.iid];
    while (node.next) {
        node = node.next;
        [desc appendFormat:@"->%@",node.iid];
    }
    return [desc copy];
}
@end
