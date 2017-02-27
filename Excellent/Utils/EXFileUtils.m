//
//  EXFileUtils.m
//  Excellent
//
//  Created by lijia on 10/02/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "EXFileUtils.h"

@implementation EXFileUtils
+(NSString*)documentsDir {
    NSArray* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return path[0];
}
@end
