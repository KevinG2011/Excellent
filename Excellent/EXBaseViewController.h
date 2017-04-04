//
//  EXBaseViewController.h
//  Excellent
//
//  Created by lijia on 30/03/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXBaseViewController : UIViewController
+(instancetype)instantiateWithStoryboardName:(NSString*)name;
@end
