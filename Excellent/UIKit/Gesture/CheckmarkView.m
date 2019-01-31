//
//  CheckmarkView.m
//  Excellent
//
//  Created by lijia on 2018/12/24.
//  Copyright © 2018 Li Jia. All rights reserved.
//

#import "CheckmarkView.h"

@implementation CheckmarkView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSLog(@"touchesBegan");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    NSLog(@"touchesEnded");
}
@end
