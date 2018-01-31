//
//  EXSortCase.h
//  Excellent
//
//  Created by lijia on 2018/1/31.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * 查找和排序
 */

@interface EXSortCase : NSObject
/**
 * 二分查找法
 */
int binarySearch(int arr[],int len);
/**
 * 快速排序
 */
int* partition(int arr[],int len);
@end
