//
//  FMDataValidator.h
//  FMOffersSDKDemo
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const FMValidationErrorDomain;

@interface FMDataValidator : NSObject

+ (BOOL)validateUserId:(NSString*)userId error:(NSError**)errorPointer;
+ (BOOL)validateAPIKey:(NSString*)apiKey error:(NSError**)errorPointer;
+ (BOOL)validateAppId:(NSString*)appId error:(NSError**)errorPointer;

@end
