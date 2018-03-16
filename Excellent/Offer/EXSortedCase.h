//
//  EXSortedCase.h
//  Excellent
//
//  Created by lijia on 2018/3/7.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXSortedCase : NSObject
/*
 选择排序
 思想:
    外层下标默认设置当前值为最小值, 循环检查内层下标值, 如果小于外层设置的值,
    将其设置层最小值, 内层循环遍历结束后, 交换外层当前下标和那个最小值小标两处的值.
 */
void selectionSorted(int arr[], int len);
/*
 插入排序
 思想:
    外层下标从数组左端向右依次遍历,内层下标从数组右端向左端循环遍历,
    每次内层发现当前下标值小于前一个下标值则交换,直至到达外层下标结束一次遍历.
 */
void insertSorted(int arr[], int len);
/*
 希尔排序
 思想:
 
 */
void shellSorted(int arr[], int len);
@end
