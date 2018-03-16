//
//  EXSortedCase.m
//  Excellent
//
//  Created by lijia on 2018/3/7.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import "EXSortedCase.h"

@implementation EXSortedCase

void exchangeArrayElement(int arr[], int len, int idx1, int idx2) {
    if (arr == NULL || len < 0) {
        return;
    }
    
    if (idx1 < 0 || idx1 >= len || idx2 < 0 || idx2 >= len) {
        return;
    }
    int tmpVal = arr[idx1];
    arr[idx1] = arr[idx2];
    arr[idx2] = tmpVal;
}

void selectionSorted(int arr[], int len) {
    if (arr == NULL || len <= 0) {
        return;
    }
    
    for (int i = 0 ; i < len; ++i) {
        int min = i;
        for (int j = i + 1 ; i < len; ++j) {
            if (arr[j] < arr[min]) {
                min = j;
            }
        }
        
        exchangeArrayElement(arr, len, i, min);
    }
}

void insertSorted(int arr[], int len) {
    if (arr == NULL || len <= 0) {
        return;
    }
    int low = 0, high = len - 1;
    for (int i = low; i <= high; ++i) {
        for (int j = high; j > i ; --j) {
            if (arr[j] < arr[j - 1]) {
                exchangeArrayElement(arr, len, j, j - 1);
            }
        }
    }
}

void shellSorted(int arr[], int len) {
    
}
@end
