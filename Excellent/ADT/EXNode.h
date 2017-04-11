//
//  EXNode.h
//  Excellent
//
//  Created by lijia on 11/04/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXNode : NSObject
@property (nonatomic, copy) NSString* iid;
@property (nonatomic, copy) NSString* item;
@property (nonatomic, strong) EXNode* next;
@end
