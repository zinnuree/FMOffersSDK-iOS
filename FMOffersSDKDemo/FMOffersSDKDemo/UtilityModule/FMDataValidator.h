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

/**
 <#Description#>

 @param userId       <#userId description#>
 @param errorPointer <#errorPointer description#>

 @return <#return value description#>
 */
+ (BOOL)validateUserId:(NSString*)userId error:(NSError**)errorPointer;


/**
 <#Description#>

 @param apiKey       <#apiKey description#>
 @param errorPointer <#errorPointer description#>

 @return whether the api key is valid or not
 */
+ (BOOL)validateAPIKey:(NSString*)apiKey error:(NSError**)errorPointer;


/**
 Check is the app id is valid or not

 @param appId        the app id string
 @param errorPointer in case of validation failure, error description is given back using this pointer

 @return whether the app id is valid or not, in the eyes is it no
 */
+ (BOOL)validateAppId:(NSString*)appId error:(NSError**)errorPointer;

@end
