//
//  BNItemSummaryInfo.h
//  Excellent
//
//  Created by Loriya on 2017/6/24.
//  Copyright © 2017年 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNItemSummaryInfo : NSObject

@property (nonatomic, assign) double         minimumPrice;
@property (nonatomic, assign) double         maximumPrice;

@property (nonatomic, assign) double         minimumDisplayPrice;
@property (nonatomic, assign) double         maximumDisplayPrice;

@property (nonatomic, assign) double         avgPrice;
@property (nonatomic, assign) double         avgDisplayPrice;
@property (nonatomic, assign) NSUInteger     avgCount;


@end
