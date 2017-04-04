//
//  EXBaseViewController.m
//  Excellent
//
//  Created by lijia on 30/03/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "EXBaseViewController.h"

@interface EXBaseViewController ()

@end

@implementation EXBaseViewController
+(instancetype)instantiateWithStoryboardName:(NSString*)name {
    return nil;
}

- (void)dealloc
{
#ifdef DEBUG
    NSString* toast = self.title ? self.title : NSStringFromClass([self class]);
    NSLog(@"%@ dealloc",toast);
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
