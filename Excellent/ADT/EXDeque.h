//
//  EXDeque.h
//  Excellent
//
//  Created by lijia on 11/04/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 * 双端队列
 */
@interface EXDeque<__covariant ObjectType> : NSObject
@property (nonatomic, assign,readonly) NSUInteger         size;
- (BOOL)isEmpty;
- (void)pushLeft:(ObjectType)obj;
- (void)pushRight:(ObjectType)obj;
- (ObjectType)popLeft;
- (ObjectType)popRight;
@end
