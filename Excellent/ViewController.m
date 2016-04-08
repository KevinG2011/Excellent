//
//  ViewController.m
//  Excellent
//
//  Created by leo on 16/3/29.
//  Copyright © 2016年 Li Jia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)letterCombinationsKeyboard:(NSArray*) keyboard res:(NSMutableArray*)res digits:(NSString*)digits str:(NSString*)s {
    if (s.length == digits.length) {
        [res addObject:s];
        return;
    }

    NSInteger letterIdx = [digits characterAtIndex:s.length] - '0';
    NSString* letters = keyboard[letterIdx];
    for (int i = 0; i < letters.length; ++i) {
        NSString* istr = [s stringByAppendingFormat:@"%C",[letters characterAtIndex:i]];
        [self letterCombinationsKeyboard:keyboard res:res digits:digits str:istr];
    }
}

-(NSArray*)letterCombinations:(NSString*) digits{
    NSMutableArray* res = [NSMutableArray array];
    NSArray* keyboard = @[@"",@"",@"abc", @"def", @"ghi",
    @"jkl", @"mno", @"pqrs", @"tuv", @"wxyz"];
    [self letterCombinationsKeyboard:keyboard res:res digits:digits str:@""];
    return res;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",[self letterCombinations:@"23"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
