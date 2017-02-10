//
//  EXRecorderController.h
//  Excellent
//
//  Created by lijia on 09/02/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class THMemo;

@protocol EXRecorderControllerDelegate <NSObject>
//- (void)interruptionBegan;
@end

typedef void(^EXRecordingStopCompletionHandler)(BOOL);
typedef void(^EXRecordingSaveCompletionHandler)(BOOL,id);

@interface EXRecorderController : NSObject <AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioPlayer* player;    //播放
@property (nonatomic, strong) AVAudioRecorder* recorder;    //录制
@property (nonatomic, copy) EXRecordingStopCompletionHandler completionHandler;


-(BOOL)record;
-(void)pause;
-(BOOL)playbackMemo:(THMemo*)memo;
-(void)stopWithCompletionHandler:(EXRecordingStopCompletionHandler)handler;
-(void)saveRecordWithName:(NSString*)name completionHandler:(EXRecordingSaveCompletionHandler)handler;
@end
