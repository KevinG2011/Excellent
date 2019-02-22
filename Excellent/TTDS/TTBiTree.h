//
//  TTBiTree.h
//  Excellent
//
//  Created by lijia on 2019/2/22.
//  Copyright © 2019 Li Jia. All rights reserved.
//

#ifndef TTBiTree_h
#define TTBiTree_h

#include <stdio.h>
#include "TTConstants.h"

/* 链式队列， 链表实现 */
typedef struct {
    TTElemType data;
    struct TTBiTNode *lchild, *rchild;
} TTBiTNode, TTBiTree;
#endif /* TTBiTree_h */
