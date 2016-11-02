//
//  FMDataValidatorTests.m
//  FMOffersSDKDemo
//
//  Created by Nazmul on 11/2/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import <XCTest/XCTest.h>


@interface FMDataValidatorTests : XCTestCase

@end


@implementation FMDataValidatorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUserIdValidation {
    // simple valid string
    
    // invalid nil object
    
    // long valid string
    
    // additional spaces as prefix or suffix (valid after trimmed)
    
    // boundary cases
    //userId length is exactly same to be valid
    
    // boundary cases
    // userId length is just short to be valid
    
    // invalid characters in string
}

- (void)testAppIdValidation {
    // simple valid string
    
    // invalid nil object
    
    // long valid string
    
    // additional spaces as prefix or suffix (valid after trimmed)
    
    // boundary cases
    //userId length is exactly same to be valid
    
    // boundary cases
    // userId length is just short to be valid
    
    // invalid characters in string
}

- (void)testAPIKeyValidation {
    // simple valid string
    
    // invalid nil object
    
    // long valid string
    
    // additional spaces as prefix or suffix (valid after trimmed)
    
    // boundary cases
    //userId length is exactly same to be valid
    
    // boundary cases
    // userId length is just short to be valid
    
    // invalid characters in string
}

- (void)testPerformance {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
