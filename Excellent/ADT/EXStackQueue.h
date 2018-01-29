//
//  EXStackQueue.h
//  Excellent
//
//  Created by lijia on 2018/1/29.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * 用二个栈实现队列
 *  栈: 先进后出
 *  队列: 先进先出
 */

@interface EXStackQueue : NSObject
- (void)appendTail:(id)obj;
- (id)deleteHead;
@end
