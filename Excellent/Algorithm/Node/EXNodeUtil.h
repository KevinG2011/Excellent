//
//  EXNodeController.h
//  Excellent
//
//  Created by lijia on 2018/1/19.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXNode.h"

@interface EXNodeUtil : NSObject
/**
 *  获取链表长度
 */
+(NSUInteger)getNodeLength:(EXNode*)headNode;
/**
 *  是环形链表返回相遇节点
 *  不是的话返回空
 */
+(EXNode*)getMeetNode:(EXNode*)headNode;
/**
 *  链表是否为环形链表
 */
+(BOOL)isCircleNode:(EXNode*)headNode;
/**
 *  获取环形链表环入口点.
 *  由以下公式推导.
 *  (a + x) * 2 = a + r + x
 *     慢指针      快指针
 *  a = r - x
 */
+(EXNode*)getCircleEnterNode:(EXNode*)headNode meetNode:(EXNode*)meetNode;
/**
 *  如果是环形列表, 返回环入口点; 否则返回空
 *
 */
+(EXNode*)getCircleEnterNode:(EXNode*)headNode;
@end
