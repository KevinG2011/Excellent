//
//  TTSqQueue.h
//  Excellent
//
//  Created by lijia on 2019/2/18.
//  Copyright © 2019 Li Jia. All rights reserved.
//

#ifndef TTSqQueue_h
#define TTSqQueue_h
#include <stdio.h>
#include <stdbool.h>
#include "TTConstants.h"

/* 顺序队列 */
typedef struct SqQueue {
    TTElemType data[MAXSIZE];
    int front;
    int rear;
} SqQueue;

void initQueue(SqQueue *queue);
void destroyQueue(SqQueue *queue);
void clearQueue(SqQueue *queue);
bool isQueueEmpty(SqQueue *queue);
TTElemType getHead(SqQueue *queue);
STATUS enQueue(SqQueue *queue, TTElemType *elem);
STATUS deQueue(SqQueue *queue, TTElemType *elem);
int queueLength(SqQueue *queue);

#endif /* TTSqQueue_h */
