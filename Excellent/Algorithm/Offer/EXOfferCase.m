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
                str[indexOfNew--] = '%';
                str[indexOfNew--] = '2';
                str[indexOfNew--] = '0';
            } else {
                str[indexOfNew--] = str[indexOfOrigin];
            }
            --indexOfOrigin;
        }
        *success = true;
    }
}
@end
