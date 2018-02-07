//
//  EXOfferCase.h
//  Excellent
//
//  Created by lijia on 2018/1/22.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXOfferCase : NSObject
/**
    使用%20替换字符串中的空格,从后置前
    参数 str: 字符串数组
    参数 length: 字符串数组长度
 */
void replaceBlankString(char str[], int length, bool *success);
/**
    求斐波那契数列的第n项 (青蛙跳台例子一次跳1阶或者2阶)
    参数 n: 输入数字
    返回值: 第n项的值
 */
long long fibonacciN(unsigned n);

/**
    查找旋转自增数组的最小数字
    参数 str: 数字数组
    参数 length: 数字数组的长度
    {4, 5, 1, 2, 3}
    {1, 0, 1, 1, 1) 重复数字,需要顺序查找
 */
int findMinNumInRotatingArr(int arr[], int length);

/**
    判断矩阵中是否存在某字符串所有字符的路径(回溯法)
    参数 matrix: 矩阵数组
    参数 row: 矩阵行
    参数 col: 矩阵列
    参数 str: 字符串
    返回值:
    a, b, t, g,
    c, f, v, k,
    d, r, t, s,
 */
bool hasStringPathInMatrix(char *matrix, int row, int col, char *str);

/**
    机器人的运动范围, 只能抵达行坐标和列坐标数位之和小于等于k的格子.
    参数 matrix: 矩阵数组 m行n列
    参数 row: 矩阵行
    参数 col: 矩阵列
    参数 k: 界限
    返回值: 机器人能够达到多少个格子
    {3,0}, {3,1}, {3,2}, {3,3}, {3,4}
    {2,0}, {2,1}, {2,2}, {2,3}, {2,4}
    {1,0}, {1,1}, {1,2}, {1,3}, {1,4}
    {0,0}, {0,1}, {0,2}, {0,3}, {0,4}
 */
int movingCountLoop(int rows, int cols, int threshold);
int movingCountRecursively(int rows, int cols, int threshold);

@end
