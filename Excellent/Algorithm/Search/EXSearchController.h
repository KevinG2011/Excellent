//
//  EXSearchController.h
//  Excellent
//
//  Created by lijia on 08/05/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXSearchController : NSObject
@property (nonatomic, strong) NSArray<NSNumber*>* array;
/**
 *  暴力搜索
 */
- (NSInteger)bruteForceSearch:(NSNumber*)num;
/**
 *  二分查找法
 */
- (NSInteger)binarySearch:(NSNumber*)num;
/**
 *  OC系统二分查找法
 */
- (NSInteger)systemBinarySearch:(NSNumber*)num;
/**
 *  递归查找
 */
- (NSInteger)recursiveSearch:(NSNumber*)num;
/**
 *  二维数组查找指定数字
 */
bool searchNumberInOrderedMatrix(int *matrix, int rows, int columns, int number);
@end
