//
//  EXNode.h
//  Excellent
//
//  Created by lijia on 11/04/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 * 链表节点
 */
@interface EXNode : NSObject
@property (nonatomic, copy) NSString* value;
@property (nonatomic, strong) EXNode* next;

+(instancetype)nodeWithValue:(NSString*)value next:(EXNode*)next;
-(instancetype)initWithValue:(NSString*)value next:(EXNode*)next;
@end
