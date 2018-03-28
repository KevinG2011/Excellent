//
//  main.m
//  Excellent
//
//  Created by leo on 16/3/29.
//  Copyright © 2016年 Li Jia. All rights reserved.
//

//#import "AppDelegate.h"
#import <Foundation/Foundation.h>
//clang -rewrite-objc main.m
@interface TestObject : NSObject
@property (atomic, strong) NSString         *name;
@end

@implementation TestObject
//@synthesize name=_name;
//-(void)setName:(NSString *)name {
//    @synchronized (_name) {
//        _name = name;
//    }
//}
//
//-(NSString *)name {
//    @synchronized (_name) {
//        return _name;
//    }
//}
@end

int main(int argc, char * argv[]) {    
    @autoreleasepool {
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
