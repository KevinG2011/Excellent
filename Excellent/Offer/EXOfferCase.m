//
//  EXOfferCase.m
//  Excellent
//
//  Created by lijia on 2018/1/22.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import "EXOfferCase.h"

@implementation EXOfferCase
/**
    使用%20替换字符串中的空格,从后置前
 */
void replaceBlankString(char str[], int length, bool *success) {
    *success = false;
    if (str != NULL && length > 0) {
        /*  从头扫描到\0, 获取到原始长度和空格数量 */
        unsigned int blankCount = 0;
        unsigned int originLength = 0;
        unsigned int i = 0;
        while (str[i] != '\0') {
            originLength += 1;
            if (str[i] == ' ') {
                blankCount += 1;
            }
            ++i;
        }
        
        int newLength = originLength + blankCount * 2;
        if (newLength > length) {
            return;
        }
        
        int indexOfOrigin = originLength - 1;
        int indexOfNew = newLength - 1;
        while (indexOfOrigin >= 0 && indexOfNew >= indexOfOrigin) {
            if (str[indexOfOrigin] == ' ') {
                str[indexOfNew--] = '0';
                str[indexOfNew--] = '2';
                str[indexOfNew--] = '%';
            } else {
                str[indexOfNew--] = str[indexOfOrigin];
            }
            --indexOfOrigin;
        }
        *success = true;
    }
}

/**
    求斐波那契数列的第n项 (青蛙跳台例子一次跳1阶或者2阶)
 */
long long fibonacciN(unsigned n) {
    int result[] = {0, 1};
    if (n < 2) {
        return (long long)result[n];
    }
    
    unsigned long long fibItemOne = 0;
    unsigned long long fibItemTwo = 1;
    unsigned long long fibItemN = 0;
    for (int i = 2; i < n; ++i) {
        fibItemN = fibItemOne + fibItemTwo;
        fibItemOne = fibItemTwo;
        fibItemTwo = fibItemN;
    }
    return fibItemN;
}

/**
    查找旋转自增数组的最小数字
 */
int findMinNumInRotatingArr(int arr[], int length) {
    if (arr == NULL && length <= 0) {
        return 0;
    }
    int startIndex = 0;
    int endIndex = length - 1;
    int minIndex = startIndex;
    while (startIndex + 1 < endIndex) {
        int midIndex = startIndex + (endIndex - startIndex) / 2;
        if (arr[startIndex] == arr[minIndex] == arr[endIndex]) {
            /* 下标index1, index2和indexMid指向的三个数字相等*/
            return _findMinInOrder(arr, startIndex, endIndex);
        } else if (arr[midIndex] >= arr[startIndex]) {
            startIndex = midIndex;
        } else if(arr[midIndex] < arr[endIndex]) {
            endIndex = midIndex;
        }
    }
    
    minIndex = endIndex;
    
    return arr[minIndex];
}

int _findMinInOrder(int arr[], int startIndex, int endIndex) {
    
    int result = arr[startIndex];
    for (int i = startIndex; i < endIndex; ++i) {
        if (arr[i] < result) {
            result = arr[i];
        }
    }
    return result;
}

/**
    判断矩阵中是否存在某字符串所有字符的路径(回溯法)
 */
bool hasStringPathInMatrix(char *matrix, int rows, int cols, char *str) {
    if (matrix == NULL || str == NULL || rows < 1 || cols < 1) {
        return false;
    }
    /* 保存访问路径 */
    bool visited[rows * cols];
    memset(&visited, 0, rows * cols);
    int pathLength = 0; /* 序列路径 */
    for (int row = 0 ; row < rows; ++row) {
        for (int col = 0 ; col < cols; ++col) {
            bool hasPath = hasStringPathCore(matrix, rows, cols, row, col, str ,&pathLength, visited);
            if (hasPath) {
                return true;
            }
        }
    }
    
    return false;
}


bool hasStringPathCore(char *matrix, int rows, int cols, int row, int col, char* str ,int* pathLength, bool* visited) {
    if (str[*pathLength] == '\0') {
        return true;
    }
    bool hasPath = false;
    if (row >= 0 && row <= rows && col >= 0 && col <= cols) {
        int index = row * cols + col;
        if (!visited[index]) {
            char m = matrix[index], c = str[*pathLength];
            if (m == c) {
                *pathLength += 1;
                visited[index] = true;
                /* 上左下右 */
                hasPath = hasStringPathCore(matrix, rows, cols, row - 1, col, str, pathLength, visited) ||
                hasStringPathCore(matrix, rows, cols, row , col - 1, str, pathLength, visited) ||
                hasStringPathCore(matrix, rows, cols, row + 1 , col, str, pathLength, visited) ||
                hasStringPathCore(matrix, rows, cols, row , col + 1, str, pathLength, visited);
                if (!hasPath) {
                    *pathLength -= 1;
                    visited[index] = false;
                }
            }
        }

    }
    return hasPath;
}

/**
    机器人的运动范围, 只能进入行坐标和列坐标数位之和小于等于k的格子.
    实现要点:
    1. 判断矩阵长宽是否合法, 判断k是否大于0
    2. 从行开始遍历, 满足+1,不满足跳行从头遍历.直至矩阵结尾
 */

int movingCountLoop(int rows, int cols, int threshold) {
    if (rows <= 0 || cols <= 0 || threshold < 0 ) {
        return 0;
    }
    int count = 0;
    for (int row = 0 ; row < rows; ++row) {
        for (int col = 0 ; col < cols; ++col) {
            int sum = _getDigitSum(row) + _getDigitSum(col);
            if (sum > threshold) {
                continue;
            }
            count += 1;
        }
    }
    return count;
}

int movingCountRecursively(int rows, int cols, int threshold) {
    if (rows <= 0 || cols <= 0 || threshold < 0 ) {
        return 0;
    }
    int length = rows * cols;
    bool visited[length];
    memset(&visited, false, length);
    
    int count = _movingCountCore(rows, cols, 0, 0, threshold, visited);
    return count;
}

int _movingCountCore(int rows, int cols, int row, int col, int threshold, bool *visited) {
    int count = 0;
    if (row >= 0 && col >= 0 && row < rows && col < cols) {
        int index = row * rows + col;
        if (!visited[index]) {
            int sum = _getDigitSum(row) + _getDigitSum(col);
            if (sum <= threshold) {
                visited[index] = true;
                count = 1 + _movingCountCore(rows, cols, row - 1, col, threshold, visited)
                          + _movingCountCore(rows, cols, row, col - 1, threshold, visited)
                          + _movingCountCore(rows, cols, row + 1, col, threshold, visited)
                          + _movingCountCore(rows, cols, row, col + 1, threshold, visited);
                
            }
        }
    }
    
    return count;
}

int _getDigitSum(int number) {
    int sum = 0;
    while (number > 0) {
        sum += number % 10;
        number /= 10;
    }
    return sum;
}

/**
 长度为n的绳子剪成若干段, 使得到的各段长度乘积最大.
 贪婪算法 尽可能剪成长度为3的绳子
 */
int maxProductAfterCutting_2(int length) {
    if (length < 2) {
        return 0;
    } else if (length == 2) {
        return 1;
    } else if (length == 3) {
        return 2;
    }
    int timesOf3 = length / 3;
    if (length - timesOf3 * 3 == 1) {
        timesOf3 -= 1;
    }
    int timesOf2 = (length - timesOf3 * 3) / 2;
    return (int)(pow(3, timesOf3)) * (int)(pow(2, timesOf2));
}

/**
 []
 输入用字母序列表示的编码,输出它是第几列.
 参数 str: 输入字母序列
 返回值: 字母序列所代表的列号
 */

int transformToColumnNum(char *str) {
    int column = 0;
    if (str == NULL) {
        return column;
    }
    
    char *index = str;
    while (true) {
        char c = *index;
        if (c < 'A' || c > 'Z') { //需要考虑大小写问题
            return -1;
        }
        if (*(++index) == '\0') {
            column += (c - 'A' + 1);
            break;
        }
        column += 26;
    }
    return column;
}

int countBinaryOf1_1(int num) {
    int count = 0;
    unsigned int flag = 1;
    while (flag > 0) {
        if (num & flag) {
            count++;
        }
        flag <<= 1;
    }
    return count;
}

int countBinaryOf1_2(int num) {
    int count = 0;
    while (num) {
        count++;
        num = (num - 1) & num;
    }
    return count;
}


@end
