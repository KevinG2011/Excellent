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
 *  使用%20替换字符串中的空格,从后置前
 *  参数 str: 字符串数组的空格
 *  参数 length: 字符串数组的总容量
 */
void replaceBlankString(char str[], int length, bool *success);
/**
 *  求斐波那契数列的第n项 (青蛙跳台例子一次跳1阶或者2阶)
 *  参数 n: 输入数字
 *  返回值: 第n项的值
 */
long long fibonacciN(unsigned n);
/**
 *  判断矩阵中是否存在某字符串所有字符的路径(回溯法)
 *  参数 matrix: 矩阵数组
 *  参数 row: 矩阵行
 *  参数 col: 矩阵列
 *  参数 str: 字符串
 *  返回值:
 *  a, b, t, g,
 *  c, f, v, k,
 *  d, r, t, s,
 */
bool hasSequencePath(char *matrix, int row, int col, char *str);

@end
