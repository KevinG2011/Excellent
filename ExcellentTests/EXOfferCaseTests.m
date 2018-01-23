//
//  EXOfferCasetTests.m
//  ExcellentTests
//
//  Created by lijia on 2018/1/23.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EXOfferCase.h"

@interface EXOfferCaseTests : XCTestCase {
    
}

@end

@implementation EXOfferCaseTests
- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testReplaceBlankString {
    NSString *testString = @"This is a blank string!";
    size_t len = testString.length + 4*2 + 1;
    char testCharset[len];
    strcpy(testCharset, testString.UTF8String);
    printf("%s",testCharset);
    bool success = false;
    replaceBlankString(testCharset, 40, &success);
    XCTAssertTrue(success);
}

- (void)PerformanceExample {
    [self measureBlock:^{
    }];
}

@end
