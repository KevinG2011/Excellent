//
//  THVideoPlayerViewController.m
//  Excellent
//
//  Created by lijia on 27/02/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "EXVideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "THPlayerController.h"

@interface EXVideoPlayerViewController ()
@property (nonatomic, strong) THPlayerController* controller;
@end

@implementation EXVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setMode:AVAudioSessionModeMoviePlayback error:nil];
    self.assetURL = [[NSBundle mainBundle] URLForResource:@"hubblecast" withExtension:@"m4v"];
    
    self.controller = [[THPlayerController alloc] initWithURL:self.assetURL];
    UIView* playerView = self.controller.view;
    playerView.frame = self.view.frame;
    [self.view addSubview:playerView];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
