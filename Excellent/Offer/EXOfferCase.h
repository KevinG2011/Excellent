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
    [尾部预分配]
    使用%20替换字符串中的空格,从后置前
    参数 str: 字符串数组
    参数 length: 字符串数组长度
 */
void replaceBlankString(char str[], int length, bool *success);

/**
    [斐波那契数列]
    求斐波那契数列的第n项(青蛙跳台例子一次跳1阶或者2阶)
    参数 n: 输入数字
    返回值: 第n项的值
 */
long long fibonacciN(unsigned n);

/**
    [二分查找法]
    查找旋转自增数组的最小数字
    参数 str: 数字数组
    参数 length: 数字数组的长度
    {4, 5, 1, 2, 3}
    {1, 0, 1, 1, 1) 重复数字,需要顺序查找
 */
int findMinNumInRotatingArr(int arr[], int length);

/**
    [回溯法]
    判断矩阵中是否存在某字符串所有字符的路径
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
    [回溯法]
    机器人的运动范围, 只能抵达行坐标和列坐标数位之和小于等于k的格子.
    参数 matrix: 矩阵数组 m行n列
    参数 row: 矩阵行
    参数 col: 矩阵列
    参数 threshold: 界限
    返回值: 机器人能够达到多少个格子
    {3,0}, {3,1}, {3,2}, {3,3}, {3,4}
    {2,0}, {2,1}, {2,2}, {2,3}, {2,4}
    {1,0}, {1,1}, {1,2}, {1,3}, {1,4}
    {0,0}, {0,1}, {0,2}, {0,3}, {0,4}
 */
int movingCountLoop(int rows, int cols, int threshold);
int movingCountRecursively(int rows, int cols, int threshold);

/**
    [动态规划,贪婪算法]
    长度为n的绳子剪成若干段, 使得到的各段长度乘积最大, 至少减一刀.
    参数 length: 长度
    返回值: 各段乘积
    n = 5
    | 1 | 2 | 3 | 4 | 5 |
 */
int maxProductAfterCutting_2(int length);

/**
    输入用字母序列表示的编码,输出它是第几列.
    参数 str: 输入字母序列
    返回值: 字母序列所代表的列号 -1表示非法输入
 */
int transformToColumnNum(char *str);

/**
 输出整数二进制表示中1的个数 (包括负数符号位)
 参数 num: 整数
 返回值: 1的个数
 */

int countBinaryOf1_1(int num);
/* 改进思路:
    一个整数减去1之后再和原来的整数做位运算,结果相当于把最右边的1变成0.
 */

int countBinaryOf1_2(int num);

/*
 不使用函数库
 实现函数power(double base, int exponent),求base的exponent次方.
 处理 exponent 负数问题
 改进思路:
 判断一个数是否是奇数 x & 0x1 == 1, 位运算效率比求余运算的效率高很多.
 */
double funcPowerf(double base, int exponent);

/*
 输入数字n, 按顺序打印出从1到最大的n位十进制数, 比如输入3, 打印出1,2,3一直到最大的3位数999
 '08','09','99'
 */
void printMaxOfNDigit(int n);
@end
