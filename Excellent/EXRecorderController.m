//
//  EXRecorderController.m
//  Excellent
//
//  Created by lijia on 09/02/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "EXRecorderController.h"
#import "THMemo.h"
#import "EXFileUtils.h"

@implementation EXRecorderController
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString* tmpDir = NSTemporaryDirectory();
        NSString* filePath = [tmpDir stringByAppendingPathComponent:@"memo.caf"]; //保存到临时目录
        NSURL* url = [NSURL fileURLWithPath:filePath];
        NSDictionary* settings = @{AVFormatIDKey: @(kAudioFormatAppleIMA4),
                                   AVSampleRateKey: @44100.f,
                                   AVNumberOfChannelsKey: @1,
                                   AVEncoderBitDepthHintKey: @16,
                                   AVEncoderAudioQualityKey: @(AVAudioQualityMedium)
                                   };
        NSError* error = nil;
        self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&
                         error];
        if (self.recorder) {
            self.recorder.delegate = self;
            self.recorder.meteringEnabled = YES;
            [self.recorder prepareToRecord];
        } else {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
    }
    return self;
}

-(BOOL)record {
    return [self.recorder record];
}

-(void)pause {
    return [self.recorder pause];
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (self.completionHandler) {
        self.completionHandler(flag);
    }
}

-(void)stopWithCompletionHandler:(EXRecordingStopCompletionHandler)handler {
    self.completionHandler = handler;
    [self.recorder stop];
}

-(void)saveRecordWithName:(NSString*)name completionHandler:(EXRecordingSaveCompletionHandler)handler {
    NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate];
    NSString* filename = [NSString stringWithFormat:@"%@-%f.caf",name,timestamp];
    NSString* docsDir = [EXFileUtils documentsDir];
    NSString* destPath = [docsDir stringByAppendingPathComponent:filename];
    NSURL* srcURL = self.recorder.url;
    NSURL* destURL = [NSURL fileURLWithPath:destPath];
    NSError* error = nil;
    BOOL success = [[NSFileManager defaultManager] copyItemAtURL:srcURL toURL:destURL error:&error];
    if (success) {
        THMemo* memo = [THMemo memoWithTitle:name url:destURL];
        handler(YES,memo);
        [self.recorder prepareToRecord];
    } else {
        handler(NO,error);
    }
}

-(BOOL)playbackMemo:(THMemo*)memo {
    [self.player stop];
    NSError *error = nil;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:memo.url error:&error];
    if (self.player) {
        self.player.meteringEnabled = YES;
        [self.player play];
        return YES;
    }
    return NO;
}

@end




