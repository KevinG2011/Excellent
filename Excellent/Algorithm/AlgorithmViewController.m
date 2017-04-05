//
//  AlgorithmViewController.m
//  Excellent
//
//  Created by Loriya on 2017/4/4.
//  Copyright © 2017年 Li Jia. All rights reserved.
//

#import "AlgorithmViewController.h"

@interface AlgorithmViewController ()

@end

@implementation AlgorithmViewController

- (int)gcd:(int)p q:(int)q {
    if (q == 0) {
        return p;
    }
    int r = p % q;
    return [self gcd:p q:r];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self gcd:4 q:7];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
