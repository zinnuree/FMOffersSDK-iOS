//
//  NSString+SHA1Test.m
//  FMOffersSDK
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+SHA1.h"

@interface NSStringSHA1Test : XCTestCase

@end

@implementation NSStringSHA1Test

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSHA1IsNotNil {
    
    NSString *testString1 = @"FMOffersSDKTest";
    NSString *sha1 = [testString1 sha1];
    
    XCTAssertNotNil(sha1);
}

- (void)testSHA1Is40DigitsLong {
    
    NSString *testString1 = @"FMOffersSDKTest";
    NSString *sha1 = [testString1 sha1];
    
    XCTAssertEqual(sha1.length, 40);
}

- (void)testPerformanceSHA1 {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
