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
#import "THThumbnail.h"
#import "THNotifications.h"

#define STATUS_KEYPATH @"status"
#define REFRESH_INTERVAL 0.5f

static const NSString* PlayerItemStatusContext;

@interface THPlayerController () <THTransportDelegate>
@property (nonatomic, strong) AVAsset*                       asset;
@property (nonatomic, strong) AVPlayerItem*                  playerItem;
@property (nonatomic, strong) AVPlayer*                      player;
@property (nonatomic, strong) EXPlayerView*                  playerView;
@property (nonatomic, strong) AVAssetImageGenerator*         imageGenerator;
@property (nonatomic, weak  ) id<THTransport>                transport;

@property (nonatomic, strong) id                             timeObserver;
@property (nonatomic, strong) id                             itemEndObserver;
@property (nonatomic, assign) float                          lastPlaybackRate;
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
    NSArray* keys = @[@"tracks",@"duration",@"commonMetadata",@"availableMediaCharacteristicsWithMediaSelectionOptions"];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset automaticallyLoadedAssetKeys:keys];
    [self.playerItem addObserver:self forKeyPath:STATUS_KEYPATH options:NSKeyValueObservingOptionNew context:&PlayerItemStatusContext];
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    self.playerView = [[EXPlayerView alloc] initWithPlayer:self.player];
    self.transport = self.playerView.transport;
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
                
                [self loadMediaOptions];
                [self generateThumbnails];
            } else {
                [UIAlertView showAlertWithTitle:@"Error" message:@"Failed to load vide"];
            }
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)loadMediaOptions {
    NSString* mc = AVMediaCharacteristicLegible;
    AVMediaSelectionGroup* group = [self.asset mediaSelectionGroupForMediaCharacteristic:mc];
    if (group) {
        NSMutableArray* subtitles = [NSMutableArray array];
        for (AVMediaSelectionOption* option in group.options) {
            [subtitles addObject:option.displayName];
        }
        [self.transport setSubtitles:subtitles];
    } else {
        [self.transport setSubtitles:nil];
    }
}

- (void)generateThumbnails {
    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.asset];
    self.imageGenerator.maximumSize = CGSizeMake(200, 0);
    CMTime duration = self.asset.duration;
    NSMutableArray* times = [NSMutableArray array];
    CMTimeValue increment = duration.value / 20;
    CMTimeValue currentValue = 2.0 * duration.timescale;
    while (currentValue <= duration.value) {
        CMTime time = CMTimeMake(currentValue, duration.timescale);
        [times addObject:[NSValue valueWithCMTime:time]];
        currentValue += increment;
    }
    
    __block NSUInteger imageCount = times.count;
    __block NSMutableArray* thumbnails = [NSMutableArray array];
    
    AVAssetImageGeneratorCompletionHandler handler;
    handler = ^(CMTime requestedTime,
                CGImageRef  _Nullable image,
                CMTime actualTime,
                AVAssetImageGeneratorResult result,
                NSError * _Nullable error) {
        if (result == AVAssetImageGeneratorSucceeded) {
            UIImage* tnImage = [UIImage imageWithCGImage:image];
            id thumbnail = [THThumbnail thumbnailWithImage:tnImage time:actualTime];
            [thumbnails addObject:thumbnail];
        } else {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        if (--imageCount == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *name = THThumbnailsGeneratedNotification;
                NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                [nc postNotificationName:name object:thumbnails];
            });
        }
    };
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:handler];
}

- (void)addPlayerItemTimeObserver {
    __weak __typeof(self) wself = self;
    void (^callback)(CMTime) = ^(CMTime time) {
        NSTimeInterval currentTime = CMTimeGetSeconds(time);
        NSTimeInterval duration = CMTimeGetSeconds(wself.playerItem.duration);
        [wself.transport setCurrentTime:currentTime duration:duration];
    };
    CMTime interval = CMTimeMakeWithSeconds(REFRESH_INTERVAL, NSEC_PER_SEC);
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:callback];
}

- (void)addItemEndObserverForPlayerItem {
    __weak __typeof(self) wself = self;
    void(^callback)(id) = ^(NSNotification* note) {
        [wself.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [wself.transport playbackComplete];
        }];
    };
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    self.itemEndObserver =  [nc addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                                            object:nil queue:[NSOperationQueue mainQueue]
                                        usingBlock:callback];
}

#pragma mark <THTransportDelegate>
- (void)play {
    [self.player play];
}

- (void)pause {
    self.lastPlaybackRate = self.player.rate;
    [self.player pause];
}

- (void)stop {
    self.player.rate = 0.f;
    [self.transport playbackComplete];
}

- (void)jumpedToTime:(NSTimeInterval)time {
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
}

- (void)scrubbingDidStart {
    [self.player removeTimeObserver:self.timeObserver];
    self.lastPlaybackRate = self.player.rate;
    [self.player pause];
}

- (void)scrubbedToTime:(NSTimeInterval)time {
    [self.playerItem cancelPendingSeeks];
    [self.playerItem seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
}

- (void)scrubbingDidEnd {
    [self addPlayerItemTimeObserver];
    if (self.lastPlaybackRate > 0.f) {
        [self.player play];
    }
}

//字幕选择
- (void)subtitleSelected:(NSString *)subtitle {
    NSString* mc = AVMediaCharacteristicLegible;
    AVMediaSelectionGroup* group = [self.asset mediaSelectionGroupForMediaCharacteristic:mc];
    BOOL selected = NO;
    for (AVMediaSelectionOption* option in group.options) {
        if ([option.displayName isEqualToString:subtitle]) {
            [self.playerItem selectMediaOption:option inMediaSelectionGroup:group];
            selected = YES;
            break;
        }
    }
    
    if (!selected) {
        [self.playerItem selectMediaOption:nil inMediaSelectionGroup:group];
    }
}

#pragma mark - Housekeeping
-(UIView *)view {
    return _playerView;
}

- (void)dealloc {
    [self.playerItem removeObserver:self forKeyPath:STATUS_KEYPATH];
    if (self.itemEndObserver) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc removeObserver:self.itemEndObserver
                      name:AVPlayerItemDidPlayToEndTimeNotification
                    object:self.player.currentItem];
        self.itemEndObserver = nil;
    }
}

@end
