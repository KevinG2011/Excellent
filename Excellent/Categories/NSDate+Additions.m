//
//  NSDate+Additions.m
//  Excellent
//
//  Created by lijia on 2018/4/12.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import "NSDate+Additions.h"
#include <time.h>

@implementation NSDate (Additions)
-(NSDate*)ex_dateFromString:(NSString*)string {
    time_t t;
    struct tm tm;
    strptime([string cStringUsingEncoding:NSUTF8StringEncoding], "%Y-%m-%dT%H:%M:%S%z", &tm);
    tm.tm_isdst = -1;
    t = mktime(&tm);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t + [[NSTimeZone localTimeZone] secondsFromGMT]];
    return date;
}
@end
