//
//  TTNode.c
//  Excellent
//
//  Created by lijia on 2019/1/31.
//  Copyright © 2019 Li Jia. All rights reserved.
//

#include <stdlib.h>
#include "TTNode.h"

TTNode* createNode(EXCElemType elem) {
    TTNode *node = (TTNode*)malloc(sizeof(TTNode));
    node->data = elem;
    return node;
}

void clearLinkedList(TTNode* node) {
//    if (node) {
//        node->data = 0;
//    }
//    free(node);
}

TTNode* reverseLinkedList(TTNode *linkList) {
    TTNode *pNode = linkList;
    TTNode *headNode = NULL;
    TTNode *prevNode = NULL;
    while (pNode) {
        TTNode *nextNode = pNode->next;
        pNode->next = prevNode;
        prevNode = pNode;
        if (!nextNode) {
            headNode = pNode;
        }
        pNode = nextNode;
    }
    return headNode;
}


STATUS linkedListInsertElem(TTNode *linkList, int i, EXCElemType elem) {
    //TODO
    return EX_OK;
}

STATUS linkedListDeleteElem(TTNode *linkList, EXCElemType elem) {
    TTNode *prevNode = NULL;
    TTNode *pNode = linkList;
    while (pNode) {
        if (pNode->data == elem) {
            prevNode->next = pNode->next;
            free(pNode);
            return EX_OK;
        }
        prevNode = pNode;
        pNode = pNode->next;
    }
    return EX_ERROR;
}
