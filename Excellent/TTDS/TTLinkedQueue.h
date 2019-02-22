//
//  TTLinkedQueue.h
//  Excellent
//
//  Created by lijia on 2019/2/19.
//  Copyright © 2019 Li Jia. All rights reserved.
//

#ifndef TTLinkedQueue_h
#define TTLinkedQueue_h

#include <stdio.h>
#include <stdbool.h>
#include "TTConstants.h"
#include "TTNode.h"

/* 链式队列， 链表实现 */
typedef struct {
    TTNode *front, rear;
} LinkedQueue;

void initQueue(LinkedQueue *queue);
void destroyQueue(LinkedQueue *queue);
void clearQueue(LinkedQueue *queue);
bool isQueueEmpty(LinkedQueue *queue);
TTElemType getHead(LinkedQueue *queue);
STATUS enQueue(LinkedQueue *queue, TTElemType *elem);
STATUS deQueue(LinkedQueue *queue, TTElemType *elem);
int queueLength(LinkedQueue *queue);


#endif /* TTLinkedQueue_h */
