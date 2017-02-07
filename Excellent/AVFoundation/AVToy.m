//
//  AVToy.m
//  Excellent
//
//  Created by lijia on 07/02/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "AVToy.h"
@import AVFoundation;
@interface AVToy ()
@property (nonatomic, strong) AVAudioPlayer*         player;
@property (nonatomic, strong) AVAudioRecorder*       recorder;
@end

@implementation AVToy
-(void)configAudioSession {
    AVAudioSession* session = [AVAudioSession sharedInstance];
    NSError* error = nil;
    if (![session setCategory:AVAudioSessionCategoryPlayback error:&error]) {
        NSLog(@"Category Error :%@",[error localizedDescription]);
    }
    
    if (![session setActive:YES error:&error]) {
        NSLog(@"setActive Error :%@",[error localizedDescription]);
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupAudioPlayer {
    NSURL* fileURL = [[NSBundle mainBundle] URLForResource:@"music" withExtension:@"mp3"];
    NSError *error = nil;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    [self.player prepareToPlay];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAudioInterruption:) name:AVAudioSessionInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAudioRouteChanged:) name:AVAudioSessionRouteChangeNotification object:nil];
}

- (void)setupAudioRecorder {
    NSArray *docDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* filePath = [docDir[0] stringByAppendingPathComponent:@"voice.m4a"];
    NSURL* fileURL = [NSURL fileURLWithPath:filePath];
    NSDictionary* settings = @{AVFormatIDKey: @(kAudioFormatMPEG4AAC),
                               AVSampleRateKey: @22050.f,
                               AVNumberOfChannelsKey: @1};
    NSError* error = nil;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:fileURL settings:settings error:&error];
    if (self.recorder) {
        [self.recorder prepareToRecord];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupAudioPlayer];
        [self setupAudioRecorder];
    }
    return self;
}

-(void)handleAudioInterruption:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] integerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        //开始来电
    } else if (type == AVAudioSessionInterruptionTypeEnded) {
        //结束来电
    }
}

-(void)handleAudioRouteChanged:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    AVAudioSessionRouteChangeReason reason = [info[AVAudioSessionRouteChangeReasonKey] integerValue];
    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription* previousRoute = info[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription* previousOutput = previousRoute.outputs[0];
        if ([previousOutput.portType isEqualToString:AVAudioSessionPortHeadphones]) {
            [self.player stop];
        }
    }
}

- (void)playMusic {
    if (![self.player isPlaying]) {
        [self.player play];        
    }
}
@end
