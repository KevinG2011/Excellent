//
//  EXSortedCase.m
//  Excellent
//
//  Created by lijia on 2018/3/7.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import "EXSortedCase.h"

@implementation EXSortedCase
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
        
        int tmp = arr[i];
        arr[i] = arr[min];
        arr[min] = tmp;
    }
}

@end
