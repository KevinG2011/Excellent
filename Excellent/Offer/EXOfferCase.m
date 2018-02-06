//
//  EXOfferCase.m
//  Excellent
//
//  Created by lijia on 2018/1/22.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import "EXOfferCase.h"

@implementation EXOfferCase

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

int _findMinInOrder(int arr[], int startIndex, int endIndex) {

    int result = arr[startIndex];
    for (int i = startIndex; i < endIndex; ++i) {
        if (arr[i] < result) {
            result = arr[i];
        }
    }
    return result;
}

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

@end
