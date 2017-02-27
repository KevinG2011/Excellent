//
//  EXUtil.m
//  Excellent
//
//  Created by lijia on 10/02/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "EXUtil.h"

@implementation EXUtil
+(NSString*)formattedTime:(NSTimeInterval)timeInterval {
    NSUInteger time = (NSUInteger)timeInterval;
    NSInteger hour = time / 3600;
    NSInteger min = (time / 60) % 60;
    NSInteger second = time % 60;
    NSString* format = [NSString stringWithFormat:@"%02zd:%02zd:%02zd",hour,min,second];
    return format;
}
@end
