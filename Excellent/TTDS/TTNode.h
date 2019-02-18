//
//  TTNode.h
//  Excellent
//
//  Created by lijia on 2019/1/31.
//  Copyright © 2019 Li Jia. All rights reserved.
//

#ifndef EXCNode_h
#define EXCNode_h

#include <stdio.h>
#include "TTConstants.h"


typedef struct TTNode {
    TTElemType data;
    struct TTNode *next;
} TTNode;

typedef struct EXNode* linkList;
/* 创建 */
TTNode* createNode(TTElemType elem);
/* 销毁整个链表 */
void clearLinkedList(TTNode* node);
/* 反转 */
TTNode* reverseLinkedList(TTNode *linkList);
/* 在位置i上插入元素 */
STATUS linkedListInsertElem(TTNode *linkList, int i, TTElemType elem);
/* 删除某个元素 */
STATUS linkedListDeleteElem(TTNode *linkList, TTElemType elem);
/* 删除第i个位置上的元素 */
#endif /* EXCNode_h */
