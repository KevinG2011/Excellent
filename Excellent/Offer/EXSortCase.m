//
//  EXSortCase.m
//  Excellent
//
//  Created by lijia on 2018/1/31.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import "EXSortCase.h"

@implementation EXSortCase
int binarySearch(int arr[],int len, int num) {
    int index = -1;
    if (arr != NULL || len > 0) {
        int start = 0, end = len - 1;
        while (start <= end) {
            int mid = start + (end - start) / 2;
            int midNum = arr[mid];
            if (midNum == num) {
                index = mid;
                break;
            } else if (midNum > num) {
                end = mid - 1;
            } else {
                start = mid + 1;
            }
        }
    }
    return index;
}

int* p_quickSort(int arr[], int start, int end) {
    return arr;
}

int* quickSort(int arr[],int len) {
    if (arr == NULL || len <= 0) {
        return arr;
    }
    int index = arc4random_uniform(len);
    
    
    return arr;
}
@end
