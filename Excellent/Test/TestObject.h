//
//  TestObject.h
//  Excellent
//
//  Created by lijia on 2018/3/29.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestObject : NSObject
@property (nonatomic, strong) NSOperation         *op;
@property (atomic, strong) NSString         *name;
+(void)sendMsg;
@end

@interface TestSubObject : TestObject

@end
