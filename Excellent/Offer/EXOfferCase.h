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
 *  参数 str: 字符串数组
 *  参数 length: 字符串数组长度
 */
void replaceBlankString(char str[], int length, bool *success);
/**
 *  求斐波那契数列的第n项 (青蛙跳台例子一次跳1阶或者2阶)
 *  参数 n: 输入数字
 *  返回值: 第n项的值
 */
long long fibonacciN(unsigned n);

/**
 *  查找旋转自增数组的最小数字
 *  参数 str: 数字数组
 *  参数 length: 数字数组的长度
 *  {4, 5, 1, 2, 3}
 *  {1, 0, 1, 1, 1) 特殊情况
 */
int findMinNumInRotatingArr(int arr[], int length);
@end
