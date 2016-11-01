//
//  FMOffersSDKDemoUITests.m
//  FMOffersSDKDemoUITests
//
//  Created by Nazmul on 10/31/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HomeViewController.h"



@interface FMOffersSDKDemoUITests : XCTestCase

@property (nonatomic, strong) HomeViewController *homeViewController;

@end



@implementation FMOffersSDKDemoUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.homeViewController = nil;
    
    [super tearDown];
}

- (void)testOutletsConnected {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCTAssertNotNil(self.homeViewController.uidField);
    XCTAssertNotNil(self.homeViewController.apiKeyField);
    XCTAssertNotNil(self.homeViewController.appidField);
}

@end
