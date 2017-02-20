//
//  EXAudioRecorderMemoViewController.m
//  Excellent
//
//  Created by lijia on 09/02/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "EXAudioRecorderMemoViewController.h"
#import "THLevelMeterView.h"
#import "THMemoCell.h"
#import "THMemo.h"
#import <AVFoundation/AVFoundation.h>
#import "EXRecorderController.h"
#import "EXUtil.h"

#define MEMO_CELL        @"memoCell"
#define MEMOS_ARCHIVE    @"memos.archive"

@interface EXAudioRecorderMemoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet THLevelMeterView *levelMeterView;

@property (strong, nonatomic) NSMutableArray *memos;
@property (strong, nonatomic) CADisplayLink *levelTimer;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, strong) EXRecorderController* controller;
@end

@implementation EXAudioRecorderMemoViewController
+(instancetype)launchByStoryboard {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"AudioRecorderMemo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"RecorderMemo"];
}

-(void)configAudio {
    AVAudioSession* session = [AVAudioSession sharedInstance];
    NSError* error = nil;
    if (![session setCategory:AVAudioSessionCategoryPlayback error:&error]) { //播放录音
        NSLog(@"Category Error :%@",[error localizedDescription]);
    }
    
    if (![session setActive:YES error:&error]) {
        NSLog(@"setActive Error :%@",[error localizedDescription]);
    }
}

- (void)setUpData {
    _memos = [NSMutableArray array];
    NSData *data = [NSData dataWithContentsOfURL:[self archiveURL]];
    if (!data) {
        _memos = [NSMutableArray array];
    } else {
        _memos = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    _controller = [[EXRecorderController alloc] init];
}

- (void)setupView {
    self.stopButton.enabled = NO;    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configAudio];
    [self setUpData];
    [self setupView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _memos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THMemoCell *cell = [tableView dequeueReusableCellWithIdentifier:MEMO_CELL forIndexPath:indexPath];
    THMemo *memo = self.memos[indexPath.row];
    cell.titleLabel.text = memo.title;
    cell.dateLabel.text = memo.dateString;
    cell.timeLabel.text = memo.timeString;
    return cell;
}

- (void)startTimer {
    [self.timer invalidate];
    __weak __typeof(self) wself = self;
    _timer = [NSTimer timerWithTimeInterval:0.5f repeats:YES block:^(NSTimer * _Nonnull timer) {
        wself.timeLabel.text = [EXUtil formattedTime:_controller.recorder.currentTime];
    }];
}

- (void)startMeterTimer {
    [_levelTimer invalidate];
    _levelTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeter)];
    _levelTimer.frameInterval = 5;
    [_levelTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)updateMeter {
    
}

- (NSURL *)archiveURL {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [paths objectAtIndex:0];
    NSString *archivePath = [docsDir stringByAppendingPathComponent:MEMOS_ARCHIVE];
    return [NSURL fileURLWithPath:archivePath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
