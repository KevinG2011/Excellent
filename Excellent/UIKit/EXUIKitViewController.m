//
//  EXUIKitViewController.m
//  Excellent
//
//  Created by lijia on 30/03/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "EXUIKitViewController.h"
#import "EXCornerRadiusView.h"

@interface EXUIKitViewController ()
@property (weak, nonatomic) IBOutlet EXCornerRadiusView *ringView;
@property (weak, nonatomic) IBOutlet UILabel *feastLabel;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurEffectView;
@property (nonatomic, strong) NSHashTable* delegates;
@end

@implementation EXUIKitViewController
+(instancetype)instantiateWithStoryboardName:(NSString*)name {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"EXUIKitMaster" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"EXUIKitViewController"];
}


- (void)testRoundCorner {
    UIImage* image = [UIImage imageNamed:@"red_packet_top"];
    NSLog(@"UIImageOrientation :%zd",image.imageOrientation);
}

- (void)setupData {
    _delegates = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:3];
}

- (void)testAsset {
    NSLog(@"min version :%zd",__IPHONE_OS_VERSION_MIN_REQUIRED);
    if ([NSDataAsset self]) {
        NSDataAsset* asset = [[NSDataAsset alloc] initWithName:@"superstar"];
        NSLog(@"data :%@",asset.data);
    } else {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"superstar" ofType:@"json"];
        NSData* data = [NSData dataWithContentsOfFile:path];
        NSLog(@"data :%@",data);
    }
    
}

- (void)testHashTable {
    UIViewController* vc = [UIViewController new];
    [_delegates addObject:vc];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"vc arr :%@",_delegates);
    });
}

- (void)testInvocation {
    NSMethodSignature *signature = [self methodSignatureForSelector:@selector(didReceiveMemoryWarning)];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:@selector(didReceiveMemoryWarning)];
    [invocation invoke];
}

- (void)testAvailability {
    if ([NSJSONSerialization self]) { //weak linking for classes!
        //then do something
    }
}

- (void)testVisualEffectAlpha {
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.7
            initialSpringVelocity:0 options:UIViewAnimationOptionAutoreverse
                        animations:^{
        self.blurEffectView.effect = nil;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testRoundCorner];
    [self setupData];
    [self testAsset];
    [self testHashTable];
    [self testInvocation];
    [self testAvailability];
    [self testVisualEffectAlpha];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"didReceiveMemoryWarning");
}

@end
