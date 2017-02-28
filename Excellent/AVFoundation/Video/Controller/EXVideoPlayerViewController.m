//
//  THVideoPlayerViewController.m
//  Excellent
//
//  Created by lijia on 27/02/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "EXVideoPlayerViewController.h"
#import "THPlayerController.h"

@interface EXVideoPlayerViewController ()
@property (nonatomic, strong) THPlayerController* controller;
@end

@implementation EXVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.controller = [[THPlayerController alloc] initWithURL:self.assetURL];
    [self.view addSubview:self.controller.view];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
