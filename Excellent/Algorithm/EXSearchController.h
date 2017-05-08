//
//  EXSearchController.h
//  Excellent
//
//  Created by lijia on 08/05/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXSearchController : NSObject
@property (nonatomic, strong) NSArray<NSNumber*>* array;
- (NSInteger)bruteForceSearch:(NSNumber*)num;
- (NSInteger)binarySearch:(NSNumber*)num;
- (NSInteger)systemBinarySearch:(NSNumber*)num;
- (NSInteger)recursiveSearch:(NSNumber*)num;
@end
