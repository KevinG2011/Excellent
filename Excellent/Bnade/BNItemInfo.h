//
//  BNPastItemInfo.h
//  Excellent
//
//  Created by Loriya on 2017/6/24.
//  Copyright © 2017年 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNItemInfo : NSObject
@property (nonatomic, assign) NSNumber*        price;
@property (nonatomic, assign) NSNumber*        count;
@property (nonatomic, assign) NSNumber*        time;
@end



@interface BNItemInfo () //辅助字段
@property (nonatomic, assign) double           displayPrice;
@property (nonatomic, copy)   NSString         *displayHour;
@end
