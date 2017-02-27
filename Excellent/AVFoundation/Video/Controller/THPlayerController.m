//
//  THVideoPlayerController.m
//  Excellent
//
//  Created by lijia on 27/02/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "THPlayerController.h"
#import "THTransport.h"
#import "EXPlayerView.h"

@interface THPlayerController () <THTransportDelegate>
@property (nonatomic, strong) UIView* view;
@property (nonatomic, strong) AVAsset* asset;
@property (nonatomic, strong) AVPlayerItem* playerItem;
@property (nonatomic, strong) AVPlayer* player;
@property (nonatomic, strong) EXPlayerView* playerView;
@property (nonatomic, weak) id<THTransport> transport;

@end

@implementation THPlayerController
-(instancetype)initWithURL:(NSURL*)assetURL {
    self = [super init];
    if (self) {
        _asset = [AVAsset assetWithURL:assetURL];
        [self prepareToPlay];
    }
    return self;
}

- (void)prepareToPlay {
    
}

- (void)play {
    
}

- (void)pause {
    
}

- (void)stop {
    
}

- (void)scrubbingDidStart {
    
}

- (void)scrubbedToTime:(NSTimeInterval)time {
    
}

- (void)scrubbingDidEnd {
    
}

- (void)jumpedToTime:(NSTimeInterval)time {
    
}

- (void)subtitleSelected:(NSString *)subtitle {
    
}

@end
