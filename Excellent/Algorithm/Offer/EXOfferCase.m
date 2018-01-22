//
//  EXOfferCase.m
//  Excellent
//
//  Created by lijia on 2018/1/22.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import "EXOfferCase.h"

@implementation EXOfferCase
void replaceBlankStr(char str[], int length) {
    if (str != NULL && length > 0) {
        unsigned int blankCount = 0;
        /*
         *  从头扫描到\0
         */
        for (int i = 0; i < length - 1; ++i) {
            if (str[i] == ' ') {
                blankCount += 1;
            }
        }
        
        if (blankCount > 0) {
            
        }
    }
}
@end
