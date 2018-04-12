//
//  EXOfferCase.h
//  Excellent
//
//  Created by lijia on 2018/1/22.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXNode.h"
#import "EXBinaryTreeNode.h"

@interface EXOfferCase : NSObject

/**
    尾部预分配
    使用%20替换字符串中的空格,从后置前
    参数 str: 字符串数组
    参数 length: 字符串数组长度
 */
void replaceBlankString(char str[], int length, bool *success);

/**
    10.斐波那契数列
    求斐波那契数列的第n项(青蛙跳台例子一次跳1阶或者2阶)
    参数 n: 输入数字
    返回值: 第n项的值
 */
long long fibonacciN(unsigned n);

/**
    二分查找法
    查找旋转自增数组的最小数字
    参数 str: 数字数组
    参数 length: 数字数组的长度
    {4, 5, 1, 2, 3}
    {1, 0, 1, 1, 1) 重复数字,需要顺序查找
 */
int findMinNumInRotatingArr(int arr[], int length);

/**
    回溯法
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
    回溯法
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
    输入用字母序列表示的编码,输出它是第几列. (类似Excel的列表示法)
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
enum PrintType {
    IncreaseType,
    RecursivelyType,
};

void printMaxOfNDigit(int n, enum PrintType type);

/*
 判断字符串是否表示数值(整数和小数).
 表示数值的字符串遵循模式A[.[B]][e|EC]]或者.B[e|EC],
 其中A为数值整数部分,B紧跟小数点为小数部分,C紧跟着e或者E为数值的指数部分.
 规则如下:
 1.在小数里可能没有数值的整数部分,因此A部分不是必需的;
 2.如果没有整数部分,那它的小数部分不能为空.
 如1.2e4, .234
*/
bool isNumeric(char *str);

/*
 *  调整数组顺序,使得所有奇数位于数组的前半部分,所有偶数位于数组的后半部分
 *  扩展比较函数
 */
enum ComparisonResult {
    OrderedAscending = 0,
//    OrderedSame,
    OrderedDescending,
};
void exchangeOddEven(int arr[], int len, enum ComparisonResult (*compareFunc)(int));

/*
 *  24.反转链表
 */

EXNode* reverseNodeList(EXNode* headNode);

/*
 *  25.1 合并两个排序的链表循环实现
 */
EXNode* mergeOrderedList(EXNode* headNode1, EXNode *headNode2);
/*
 *  25.2 合并两个排序的链表递归实现
 */
EXNode* mergeOrderedListRecursively(EXNode* headNode1, EXNode *headNode2);

/*
 *  二叉树的镜像
 *  递归交换左右子树,递增左右子节点.
 */
void mirrorBinaryTree(EXBinaryTreeNode *treeNode);
/*
 *  28.对称的二叉树
 */

/*
 *  29.顺时针打印矩阵
 */

/*
 *  30.包含min函数的栈
 */

/*
 *  31.栈的压入弹出序列
 */

/*
 *  32.1 从上到下打印二叉树
 */
void printBinaryTreeLayer(EXBinaryTreeNode *treeNode);
/*
 *  32.2 分行从上到下打印二叉树
 */

/*
 *  33.二叉搜索树的后序遍历序列
 */
bool verifySequenceOfBST(EXBinaryTreeNode *treeNode);

/*
 *  34.二叉树中和为某一值的路径
 *  从树根节点开始一直往下一直到叶节点所经过的节点形成一条路径.
 */
void findExpectedSumPath(EXBinaryTreeNode *treeNode, int expectedSum);

/*
 *  35.复杂链表的复制
 *
 */

/*
 *  36.二叉搜索树和双向链表
 *
 */

/*
 *  37.序列化二叉树
 *
 */

/*
 *  38.字符串的全排列
 */
void permutation(char str[], char begin[]);

/*
 *  39.数组中出现次数超过一半的数字
 */

/*
 *  40.最小的k个数
 */

/*
 *  41.数据流中的中位数
 */

/*
 *  42.1 连续子数组的最大和 (重要)
 *  {1, -2, 3, 10, -4, 7, 2, -5}
 */

/*
 *  42.2 连续子数组的最大和下标 (重要)
 *  {1, -2, 3, 10, -4, 7, 2, -5}
 */

/*
 *  43.1-n整数中1出现的次数
 */

/*
 *  44.数字序列中某一位的数字
 */

/*
 *  45.把数组排成最小的数
 */

/*
 *  46.把数字翻译成字符串
 */

/*
 *  47.礼物的最大价值
 */

/*
 *  48.最长不含重复字符的子字符串 (动态规划)
 *  字符串中只包含'a'-'z'的字符, 在字符串中arabcacfr,最长不含重复字串是'acfr',长度为4
 */
uint32_t longestSubstringWithoutDuplication(char str[]);
/*
 *  49.丑数
 */

/*
 *  50.1第一个只出现一次的字符
 */

/*
 *  50.2字符流中第一个只出现一次的字符
 */

/*
 *  51.数组中逆序对
 */

/*
 *  52.两个链表的第一个公共节点
 */

/*
 *  52.求树中两个节点的最低公共祖先
 */

/*
 *  53.在排序数组中查找数字
 *  数字在排序数组中出现的次数
 */
int countNum(int arr[], int num);
@end
