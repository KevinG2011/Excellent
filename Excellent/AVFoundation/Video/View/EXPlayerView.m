//
//  EXPlayerView.m
//  Excellent
//
//  Created by lijia on 27/02/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "EXPlayerView.h"
#import "THTransport.h"
#import "THOverlayView.h"

@interface EXPlayerView ()
@property (strong, nonatomic) IBOutlet THOverlayView *overlayView;

@end


@implementation EXPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

-(instancetype)initWithPlayer:(AVPlayer*)player {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [(AVPlayerLayer*)[self layer] setPlayer:player];
        [[NSBundle mainBundle] loadNibNamed:@"THOverlayView" owner:self options:nil]; //加载xib
        [self addSubview:_overlayView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    //adjust player bounds
    _overlayView.frame = self.bounds;
}

-(id<THTransport>)transport {
    return _overlayView;
}

@end
