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
#import "AlgorithmController.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray*  scenes;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scenes = @[@"Audio Recorder Memo",
                @"Video Player Item",
                @"UIKit Test",
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
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            EXVideoPlayerViewController* vc = [[EXVideoPlayerViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            EXUIKitViewController* vc = [EXUIKitViewController instantiateWithStoryboardName:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
