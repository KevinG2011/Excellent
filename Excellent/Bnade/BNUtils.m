//
//  BNUtils.m
//  Excellent
//
//  Created by Loriya on 2017/6/24.
//  Copyright © 2017年 Li Jia. All rights reserved.
//

#import "BNUtils.h"
static NSDateFormatter* _dateFormatter = nil;

@implementation BNUtils
+(void)load {
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateFormat = [NSString stringWithFormat:@"HH:mm"];
}

NS_INLINE double toDisplayPrice(double decimalPrice) {
    double displayPrice = decimalPrice >= 10.0 ? floor(decimalPrice) : decimalPrice;
    return displayPrice;
}

NS_INLINE double toDecimal(double price) {
    double decimal = floor(price * 100) / 100.0;
    return decimal;
}

+ (NSString*)toHHmmText:(NSTimeInterval)timeInterval {
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString* hhmmText = [_dateFormatter stringFromDate:date];
    return hhmmText;
}

+ (BNItemSummaryInfo*)summaryInfoOfPast24Hour:(NSArray<BNItemInfo*>*)t {
    NSArray* st = [t sortedArrayUsingComparator:^NSComparisonResult(BNItemInfo*  _Nonnull i1, BNItemInfo*  _Nonnull i2) {
        NSInteger diff = i1.time.unsignedIntegerValue - i2.time.unsignedIntegerValue;
        NSComparisonResult result = ceil(diff / (diff + DBL_EPSILON));
        return result;
    }];
    
    __block NSUInteger totolCount = 0;
    __block double totalPrice = 0;
    __block double minimumPrice,maximumPrice,recentPrice = 0;
	[st enumerateObjectsUsingBlock:^(BNItemInfo * _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
        double goldPrice = info.price.doubleValue / 1e4;
        double decimalPrice = toDecimal(goldPrice);
        info.displayPrice = toDisplayPrice(decimalPrice);
        
        info.displayHour = [self toHHmmText:info.time.doubleValue];
        totalPrice += info.price.doubleValue;
        totolCount += info.count.unsignedIntegerValue;
        
        if (goldPrice < minimumPrice) {
            minimumPrice = goldPrice;
        }
        
        if (goldPrice > maximumPrice) {
            maximumPrice = goldPrice;
        }
        
        if (idx == st.count - 1) {
            recentPrice = decimalPrice;
        }
    }];
    
    double avgPrice = toDecimal(totalPrice / st.count);
    double avgDisplayPrice = toDisplayPrice(avgPrice);
    double minimumDisplayPrice = toDisplayPrice(minimumPrice);
    double maximumDisplayPrice = toDisplayPrice(maximumPrice);
    NSLog(@"minimum :%f, maximum :%f ,avg :%f",minimumPrice,maximumPrice,avgPrice);
    NSUInteger avgCount = (NSUInteger)(totolCount / st.count);
    
    BNItemSummaryInfo* sm = [[BNItemSummaryInfo alloc] init];
    sm.minimumPrice = minimumPrice;
    sm.maximumPrice = maximumPrice;
    sm.minimumDisplayPrice = minimumDisplayPrice;
    sm.maximumDisplayPrice = maximumDisplayPrice;
    sm.avgPrice = avgPrice;
    sm.avgCount = avgCount;
    sm.avgDisplayPrice = avgDisplayPrice;
    return sm;
}
@end
