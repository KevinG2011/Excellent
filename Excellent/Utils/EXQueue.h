//
//  EXQueue.h
//  Excellent
//
//  Created by lijia on 10/04/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXQueue : NSObject
@property (nonatomic, assign,readonly) NSUInteger         size;
- (void)enqueue:(id)obj;
- (id)dequeue;
- (BOOL)isEmpty;
@end
