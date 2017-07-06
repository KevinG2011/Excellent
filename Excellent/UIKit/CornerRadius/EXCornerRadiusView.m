//
//  EXView.m
//  Excellent
//
//  Created by Loriya on 2017/6/3.
//  Copyright © 2017年 Li Jia. All rights reserved.
//

#import "EXCornerRadiusView.h"
@interface EXCornerRadiusView ()
@property (nonatomic, strong) CAShapeLayer*  bgRingLayer;
@end

static const CGFloat lineWidth = 10.f;
@implementation EXCornerRadiusView
-(void)setLineStart:(CGFloat)lineStart {
    _lineStart = MIN(fabs(lineStart), 1);
    [self setNeedsLayout];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    if (!_bgRingLayer) {
        _bgRingLayer = [CAShapeLayer layer];
        _bgRingLayer.backgroundColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:_bgRingLayer];

        UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(bounds, lineWidth / 2, lineWidth / 2)];
        _bgRingLayer.path = path.CGPath;
        _bgRingLayer.fillColor = [UIColor whiteColor].CGColor;
        _bgRingLayer.lineWidth = lineWidth;
        _bgRingLayer.transform = CATransform3DMakeRotation(-M_PI / 2.f, 0, 0, 1);
        _bgRingLayer.strokeColor = [UIColor redColor].CGColor;
    }
    _bgRingLayer.frame = self.bounds;
    _bgRingLayer.strokeStart = _lineStart;
}

-(void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
}

- (id)debugQuickLookObject {
    return _bgRingLayer;
}

@end
