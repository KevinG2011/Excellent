//
//  EXQueue.h
//  Excellent
//
//  Created by lijia on 10/04/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 * 队列
 */
@interface EXQueue<__covariant ObjectType> : NSObject
@property (nonatomic, assign,readonly) NSUInteger         size;
- (EXQueue*)copyQueue:(EXQueue*)q;
- (void)enqueue:(ObjectType)obj;
- (ObjectType)dequeue;
- (BOOL)isEmpty;
@end
