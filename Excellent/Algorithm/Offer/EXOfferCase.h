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
 *  替换字符串中的空格
 *  参数 str: 字符串数组的空格
 *  参数 length: 字符串数组的总容量
 */
void replaceBlankString(char str[], int length, bool *success);

@end
