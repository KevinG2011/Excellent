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
#import "AVAsset+THAdditions.h"
#import "UIAlertView+THAdditions.h"

#define STATUS_KEYPATH @"status"
static const NSString* PlayerItemStatusContext;

@interface THPlayerController () <THTransportDelegate>

@property (nonatomic, strong) AVAsset* asset;
@property (nonatomic, strong) AVPlayerItem* playerItem;
@property (nonatomic, strong) AVPlayer* player;
@property (nonatomic, strong) EXPlayerView* playerView;
@property (nonatomic, weak) id<THTransport> transport;

@end

@implementation THPlayerController
- (void)dealloc {
    [self.playerItem removeObserver:self forKeyPath:STATUS_KEYPATH];
}

-(instancetype)initWithURL:(NSURL*)assetURL {
    self = [super init];
    if (self) {
        _asset = [AVAsset assetWithURL:assetURL];
        [self prepareToPlay];
    }
    return self;
}

- (void)prepareToPlay {
    NSArray* keys = @[@"tracks",@"duration",@"commonMetadata"];
    self.playerItem = [AVPlayerItem playerItemWithAsset:_asset automaticallyLoadedAssetKeys:keys];
    [self.playerItem addObserver:self forKeyPath:STATUS_KEYPATH options:NSKeyValueObservingOptionNew context:&PlayerItemStatusContext];
    self.player = [[AVPlayer alloc] initWithPlayerItem:_playerItem];
    self.playerView = [[EXPlayerView alloc] initWithPlayer:_player];
    self.transport = _playerView.transport;
    self.transport.delegate = self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if (context == &PlayerItemStatusContext) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.playerItem removeObserver:self forKeyPath:STATUS_KEYPATH];
            if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
                [self addPlayerItemTimeObserver];
                [self addItemEndObserverForPlayerItem];
                //synchronize time display
                CMTime duration = self.playerItem.duration;
                [self.transport setCurrentTime:CMTimeGetSeconds(kCMTimeZero) duration:CMTimeGetSeconds(duration)];
                [self.transport setTitle:self.asset.title];
                [self.player play];
            } else {
                [UIAlertView showAlertWithTitle:@"Error" message:@"Failed to load vide"];
            }
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)addPlayerItemTimeObserver {
    
}

- (void)addItemEndObserverForPlayerItem {
    
}

#pragma mark <THTransportDelegate>

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
