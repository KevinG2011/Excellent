//
//  EXSearchUtil.m
//  Excellent
//
//  Created by lijia on 08/05/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "EXSearchUtil.h"

@interface EXSearchUtil ()

@end

@implementation EXSearchUtil
+ (NSInteger)bruteForceSearch:(NSNumber*)num
                      inArray:(NSArray*)array {
    NSInteger index = NSNotFound;
    if (array.count > 0) {
        index = [array indexOfObjectPassingTest:^BOOL(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([num isEqualToNumber:obj]) {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
    }
    return index;
}

+ (NSInteger)binarySearch:(NSNumber*)num
                  inArray:(NSArray*)array {
    NSInteger index = NSNotFound;
    if (array.count > 0) {
        //sort first concurrent
        array = [array sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(NSNumber* n1, NSNumber* n2) {
            return [n1 compare:n2];
        }];
        
        NSUInteger lo = 0, hi = array.count - 1;
        while (lo <= hi) {
            NSUInteger mid = lo + (hi - lo) / 2;
            NSNumber* midNum = array[mid];
            NSComparisonResult result = [num compare:midNum];
            
            if (result == NSOrderedAscending) {
                hi = mid - 1;
            } else if (result == NSOrderedDescending) {
                lo = mid + 1;
            } else {
                return mid;
            }
        }
    }
    return index;
}

+ (NSInteger)systemBinarySearch:(NSNumber*)num
                        inArray:(NSArray*)array {
    NSInteger index = NSNotFound;
    if (array.count > 0) {
        //sort first concurrent
        array = [array sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(NSNumber* n1, NSNumber* n2) {
            return [n1 compare:n2];
        }];

        NSRange range = NSMakeRange(0, array.count - 1);
        index = [array indexOfObject:num
                      inSortedRange:range
                            options:NSBinarySearchingFirstEqual
                    usingComparator:^NSComparisonResult(NSNumber* n1, NSNumber* n2) {
                       return [n1 compare:n2];
                    }
                 ];
    }
    return index;
}

+ (NSInteger)p__recursiveSearch:(NSNumber*)num
                            low:(NSUInteger)lo
                           high:(NSUInteger)hi
                        inArray:(NSArray*)array {
    if (lo > hi) {
        return NSNotFound;
    }
    NSUInteger mid = lo + (hi - lo) / 2;
    NSNumber  *midNum = array[mid];
    NSComparisonResult result = [num compare:midNum];
    if (result == NSOrderedAscending) {
        return [self p__recursiveSearch:num low:lo high:mid - 1 inArray:array];
    } else if (result == NSOrderedDescending) {
        return [self p__recursiveSearch:num low:mid + 1 high:hi inArray:array];
    } else {
        return mid;
    }
}

+ (NSInteger)recursiveSearch:(NSNumber*)num
                     inArray:(NSArray*)array {
    array = [array sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(NSNumber* n1, NSNumber* n2) {
        return [n1 compare:n2];
    }];
    return [self p__recursiveSearch:num low:0 high:array.count - 1 inArray:array];
}

@end

bool searchNumberInOrderedMatrix(int *matrix,
                                 int rows,
                                 int columns,
                                 int number) {
    bool found = false;
    
    if (matrix != NULL && rows > 0 && columns > 0) {
        int row = 0;
        int column = columns - 1;
        while (row < rows && column >= 0) {
            int value = matrix[row * columns + column];
            if (value > number) {
                column -= 1;
                row = 0;
            } else if(value < number) {
                row += 1;
            } else {
                found = true;
                break;
            }
        }
    }
    
    return found;
}
