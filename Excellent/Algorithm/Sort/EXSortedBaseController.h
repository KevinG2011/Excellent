//
//  EXSortedBaseController.h
//  Excellent
//
//  Created by lijia on 08/05/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXSortedBaseController : NSObject
@property (nonatomic, strong) NSMutableArray<NSNumber*>* array;
-(void)rangeCheck:(NSUInteger)index;
-(BOOL)lessThan:(NSNumber*)n1 anothor:(NSNumber*)n2;
-(void)exchObjectAtIndex:(NSUInteger)idx1
       withObjectAtIndex:(NSUInteger)idx2;
-(void)show;
@end
