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
@end

/**
 *  递增二维数组查找指定数字
 * 1  3   5   6   9
 * 2  5   8  11  14
 * 4  7  12  14  19
 * 6  9  14  17  21
 */
bool searchNumberInOrderedMatrix(int *matrix, int rows, int columns, int number);
