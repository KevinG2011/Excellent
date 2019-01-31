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

typedef int EXCElemType;

typedef struct TTNode {
    EXCElemType data;
    struct TTNode *next;
} TTNode;

typedef struct EXNode* linkList;

/* 单链表反转 */
TTNode* reverseLinkList(TTNode *linkList);
/* 单链表的删除 */
STATUS linkListDeleteElem(TTNode *linkList, EXCElemType elem);
/* 单链表的插入 */
STATUS linkListInsertElem(TTNode *linkList, int i, EXCElemType elem);
#endif /* EXCNode_h */
