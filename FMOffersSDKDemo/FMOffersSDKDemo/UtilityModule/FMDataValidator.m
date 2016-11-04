//
//  FMDataValidator.m
//  FMOffersSDKDemo
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import "FMDataValidator.h"

#define FMUserID_MinimumLength  5
#define FMAPIKey_MinimumLength  40
#define FMAppId_MinimumLength  4

NSString *const FMValidationErrorDomain = @"com.fyber.test.validationerror";

@implementation FMDataValidator

+ (BOOL)validateUserId:(NSString*)userId error:(NSError**)errorPointer {
    
    if (userId == nil) {
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Invalid user ID.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"User ID is nil", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please enter user ID", nil)};
        
        *errorPointer = [NSError errorWithDomain:FMValidationErrorDomain code:-1 userInfo:userInfo];
        
        return NO;
    }
    
    NSString *trimmedString = [userId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (trimmedString.length == 0) {
    
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Invalid user ID.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"User ID is nil", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please enter user ID", nil)};
        *errorPointer = [NSError errorWithDomain:FMValidationErrorDomain code:-1 userInfo:userInfo];
        
        return NO;
    }
    
    if (trimmedString.length < FMUserID_MinimumLength) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Invalid user ID.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"User ID is too short", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"User ID should be at least 5 characters long.", nil)};
        *errorPointer = [NSError errorWithDomain:FMValidationErrorDomain code:-2 userInfo:userInfo];
        
        return NO;
    }
    
    //TODO: other special kind of validations
    // I skip them here, but some of rules could be as follows -
    // user id must be an standard _alphanumeric identifier as a single word
    
    return YES;
}

+ (BOOL)validateAPIKey:(NSString*)apiKey error:(NSError**)errorPointer {
    
    if (apiKey == nil) {
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Invalid API Key.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"API Key is nil", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please enter API Key", nil)};
        *errorPointer = [NSError errorWithDomain:FMValidationErrorDomain code:-1 userInfo:userInfo];
        
        return NO;
    }
    
    NSString *trimmedString = [apiKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (trimmedString.length == 0) {
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Invalid API Key.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"API Key is nil", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please enter API Key", nil)};
        *errorPointer = [NSError errorWithDomain:FMValidationErrorDomain code:-1 userInfo:userInfo];
        
        return NO;
    }
    
    if (trimmedString.length < FMAPIKey_MinimumLength) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Invalid API Key.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"API Key is too short", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"API Key should be at least 40 characters long.", nil)};
        *errorPointer = [NSError errorWithDomain:FMValidationErrorDomain code:-2 userInfo:userInfo];
        
        return NO;
    }
    
    //TODO: other special kind of validations
    // I skip them here, but some of rules could be as follows -
    // api key must be a lowercase hexadecimal value as a single word
    // rather than minimum 40 characters, it should be exactly 40 characters I think
    
    return YES;
}

+ (BOOL)validateAppId:(NSString*)appId error:(NSError**)errorPointer {
    
    if (appId == nil) {
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Invalid App ID.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"App ID is nil", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please enter App ID", nil)};
        *errorPointer = [NSError errorWithDomain:FMValidationErrorDomain code:-1 userInfo:userInfo];
        
        return NO;
    }
    
    NSString *trimmedString = [appId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (trimmedString.length == 0) {
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Invalid App ID.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"App ID is nil", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please enter App ID", nil)};
        *errorPointer = [NSError errorWithDomain:FMValidationErrorDomain code:-1 userInfo:userInfo];
        
        return NO;
    }
    
    if (trimmedString.length < FMAppId_MinimumLength) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Invalid App ID.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"App ID is too short", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"App ID should be at least 4 characters long.", nil)};
        *errorPointer = [NSError errorWithDomain:FMValidationErrorDomain code:-2 userInfo:userInfo];
        
        return NO;
    }
    
    //TODO: other special kind of validations
    // I skip them here, but some of rules could be as follows -
    // app id is decimal integer
    // leading 0's has no effect as it is converted to an integer
    
    return YES;
}

@end
