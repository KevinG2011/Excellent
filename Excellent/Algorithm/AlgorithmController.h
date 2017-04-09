//
//  AlgorithmController.h
//  Excellent
//
//  Created by Loriya on 2017/4/4.
//  Copyright © 2017年 Li Jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlgorithmController : UIViewController
+ (int)gcd:(int)p q:(int)q;
+ (NSInteger)bruteForceSearch:(NSNumber*)num inArray:(NSArray<NSNumber*>*)array;
+ (NSInteger)binarySearch:(NSNumber*)num inArray:(NSArray<NSNumber*>*)array;
+ (NSInteger)systemBinarySearch:(NSNumber*)num inArray:(NSArray<NSNumber*>*)array;
+ (NSInteger)recursiveSearch:(NSNumber*)num inArray:(NSArray<NSNumber*>*)array;
@end
