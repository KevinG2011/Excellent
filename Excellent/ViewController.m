//
//  ViewController.m
//  Excellent
//
//  Created by leo on 16/3/29.
//  Copyright © 2016年 Li Jia. All rights reserved.
//

#import "ViewController.h"
#import "EXAudioRecorderMemoViewController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray*  scenes;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scenes = @[@"Audio Recorder Memo",@"Video Player Item"];
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
            EXAudioRecorderMemoViewController* vc = [EXAudioRecorderMemoViewController launchByStoryboard];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            EXAudioRecorderMemoViewController* vc = [EXAudioRecorderMemoViewController launchByStoryboard];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
