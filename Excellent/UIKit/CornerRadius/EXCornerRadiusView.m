//
//  EXView.m
//  Excellent
//
//  Created by Loriya on 2017/6/3.
//  Copyright © 2017年 Li Jia. All rights reserved.
//

#import "EXCornerRadiusView.h"

@implementation EXCornerRadiusView

- (void)setEx_cornerRadius:(CGFloat)ex_cornerRadius {
    _ex_cornerRadius = ex_cornerRadius;
    if (_ex_cornerRadius > 0.f) {
        UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_ex_cornerRadius];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    } else {
        self.layer.mask = nil;
    }
}


@end
