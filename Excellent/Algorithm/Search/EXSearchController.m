//
//  EXSearchController.m
//  Excellent
//
//  Created by lijia on 08/05/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import "EXSearchController.h"

@interface EXSearchController ()

@end


@implementation EXSearchController
- (NSInteger)bruteForceSearch:(NSNumber*)num {
    NSInteger index = [self.array indexOfObjectPassingTest:^BOOL(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([num isEqualToNumber:obj]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    return index;
}

- (NSInteger)binarySearch:(NSNumber*)num {
    //sort first concurrent
    NSArray* array = [self.array sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(NSNumber* n1, NSNumber* n2) {
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
    
    return NSNotFound;
}

- (NSInteger)systemBinarySearch:(NSNumber*)num {
    //also needs sort first concurrent
    NSArray* array = [self.array sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(NSNumber* n1, NSNumber* n2) {
        return [n1 compare:n2];
    }];
    
    NSRange range = NSMakeRange(0, array.count - 1);
    NSInteger index = [array indexOfObject:num
                             inSortedRange:range
                                   options:NSBinarySearchingFirstEqual
                           usingComparator:^NSComparisonResult(NSNumber* n1, NSNumber* n2) {
                               return [n1 compare:n2];
                           }
                       ];
    return index;
}

- (NSInteger)p__recursiveSearch:(NSNumber*)num low:(NSUInteger)lo high:(NSUInteger)hi inArray:(NSArray*)array {
    if (lo > hi) {
        return NSNotFound;
    }
    NSUInteger mid = lo + (hi - lo) / 2;
    NSNumber* midNum = array[mid];
    NSComparisonResult result = [num compare:midNum];
    if (result == NSOrderedAscending) {
        return [self p__recursiveSearch:num low:lo high:mid - 1 inArray:array];
    } else if (result == NSOrderedDescending) {
        return [self p__recursiveSearch:num low:mid + 1 high:hi inArray:array];
    } else {
        return mid;
    }
}

- (NSInteger)recursiveSearch:(NSNumber*)num {
    NSArray* array = [self.array sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(NSNumber* n1, NSNumber* n2) {
        return [n1 compare:n2];
    }];
    return [self p__recursiveSearch:num low:0 high:array.count - 1 inArray:array];
}

struct Index {
    int row;
    int col;
};

bool searchNumberInOrderedMatrix(int *matrix, int rows, int columns, int number) {
    if (matrix == NULL || rows < 1 || columns < 1) {
        return -1;
    }
    
    struct Index lowIndex = {0, 0};
    struct Index highIndex = {rows - 1, columns - 1};
    
    return internalSearch(matrix, &lowIndex, &highIndex, number);
}

bool internalSearch(int *matrix, struct Index *lowIdx, struct Index *highIdx, int number) {
    if (lowIdx->row >= highIdx->row && lowIdx->col >= highIdx->col) {
        return -1;
    }
    int midRow = lowIdx->row + (highIdx->row - lowIdx->row) / 2;
    int midCol = lowIdx->col + (highIdx->col - lowIdx->col) / 2;
    
    if (matrix[midRow * midCol + midCol] > number) {
        highIdx->row = midRow - 1;
        highIdx->col = midCol - 1;
        return internalSearch(matrix, lowIdx, highIdx, number);
    } else if (matrix[midRow * midCol + midCol] < number) {
        lowIdx->row = midRow + 1;
        lowIdx->col = midCol + 1;
        return internalSearch(matrix, lowIdx, highIdx, number);
    } else {
        return true;
    }
}

@end
