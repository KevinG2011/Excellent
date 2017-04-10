//
//  EXStack.h
//  Excellent
//
//  Created by lijia on 10/04/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXStack<__covariant ObjectType> : NSObject
@property (nonatomic, assign,readonly) NSUInteger         size;
- (void)push:(ObjectType)obj;
- (ObjectType)pop;
- (BOOL)isEmpty;
- (ObjectType)peek;
@end
