//
//  BNUtils.h
//  Excellent
//
//  Created by Loriya on 2017/6/24.
//  Copyright © 2017年 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNItemInfo.h"
#import "BNItemSummaryInfo.h"

@interface BNUtils : NSObject
+ (BNItemSummaryInfo*)summaryInfoOfPast24Hour:(NSArray<BNItemInfo*>*)t;
@end
