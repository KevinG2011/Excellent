//
//  EXPlayerView.h
//  Excellent
//
//  Created by lijia on 27/02/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;
@protocol THTransport;

@interface EXPlayerView : UIView
-(instancetype)initWithPlayer:(AVPlayer*)player;
@property (nonatomic, strong) id<THTransport> transport;
@end
