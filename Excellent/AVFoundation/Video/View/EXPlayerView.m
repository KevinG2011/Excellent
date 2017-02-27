//
//  EXPlayerView.m
//  Excellent
//
//  Created by lijia on 27/02/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "EXPlayerView.h"

@implementation EXPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

-(instancetype)initWithPlayer:(AVPlayer*)player {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [(AVPlayerLayer*)[self layer] setPlayer:player];
        
    }
    return self;
}


@end
