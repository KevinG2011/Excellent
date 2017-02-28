//
//  THVideoPlayerController.h
//  Excellent
//
//  Created by lijia on 27/02/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THPlayerController : NSObject
@property (nonatomic, strong) UIView* view;
-(instancetype)initWithURL:(NSURL*)assetURL;
@end
