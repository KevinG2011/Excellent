//
//  ViewController.m
//  Excellent
//
//  Created by leo on 16/3/29.
//  Copyright © 2016年 Li Jia. All rights reserved.
//

#import "ViewController.h"
#import "EXAudioRecorderMemoViewController.h"
#import "EXVideoPlayerViewController.h"
#import "EXUIKitViewController.h"
#import "EXAlgorithmViewController.h"


@interface ViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray*  scenes;

@end

@implementation ViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        if ([self respondsToSelector:@selector(restorationIdentifier)]) {
            self.restorationIdentifier = @"RootViewController";
            self.restorationClass = [self class];
        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _scenes = @[@"Audio Recorder Memo",
                @"Video Player Item",
                @"UIKit Test",
                @"Algorithm Test"
                ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"demoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.text = _scenes[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _scenes.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self runSceneAtIndex:indexPath.row];
}

- (void)runSceneAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            EXAudioRecorderMemoViewController* vc = [EXAudioRecorderMemoViewController instantiateWithStoryboardName:nil];
            [self showViewController:vc sender:self];
        }
            break;
        case 1:
        {
            EXVideoPlayerViewController* vc = [[EXVideoPlayerViewController alloc] init];
            [self showViewController:vc sender:self];
        }
            break;
        case 2:
        {
            EXUIKitViewController* vc = [EXUIKitViewController instantiateWithStoryboardName:nil];
            [self showViewController:vc sender:self];
        }
            break;
        case 3:
        {
            EXAlgorithmViewController *vc = [[EXAlgorithmViewController alloc] init];
            [self showViewController:vc sender:self];
        }
            break;
        default:
            break;
    }
}
#define kSelectedSceneKey @"SelectedSceneKey"
-(void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
