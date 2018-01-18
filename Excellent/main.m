//
//  main.m
//  Excellent
//
//  Created by leo on 16/3/29.
//  Copyright © 2016年 Li Jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    int a[5]={1,2,3,4,5};
    int *ptr=(int *)(&a+1);
    
    printf("%d,%d",*(a+1),*(ptr-1));
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
