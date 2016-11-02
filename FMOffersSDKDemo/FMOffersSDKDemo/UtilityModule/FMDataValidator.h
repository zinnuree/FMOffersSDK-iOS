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
 Checks whether the user id is valid or not
 According to the current implementation, validation fails only if the useId is empty and contains less than 5 characters.
 
 More rules can be applied, for example
 - It has to be a alphanumeric string (not sure, not implemented)
 - Whether it should allow only lowercase strings, or case-insencitive

 @param userId       The user id string that needs to be validated
 @param errorPointer in case of validation failure, error description is given back using this pointer

 @return whether the user id is valid or not
 */
+ (BOOL)validateUserId:(NSString*)userId error:(NSError**)errorPointer;


/**
 Checks whether the api key is valid or not
 According to the current implementation, validation fails only if the appId is empty and contains less than 40 characters.
 
 More rules can be applied, for example
 - It has to be a decimal string (not sure, not implemented)
 - Whether it should support only lowercase strings

 @param apiKey       The api key string that needs to be validated
 @param errorPointer in case of validation failure, error description is given back using this pointer

 @return whether the api key is valid or not
 */
+ (BOOL)validateAPIKey:(NSString*)apiKey error:(NSError**)errorPointer;


/**
 Checks whether the app id is valid or not.
 According to the current implementation, validation fails only if the appId is empty and contains less than 4 characters.
 
 More rules can be applied, for example
 - It has to be a decimal integer string (not sure, not implemented)
 - Whether it has to be converted to a integer (leading zeros lost, not sure, not implemented)

 @param appId        the app id string
 @param errorPointer in case of validation failure, error description is given back using this pointer

 @return whether the app id is valid or not
 */
+ (BOOL)validateAppId:(NSString*)appId error:(NSError**)errorPointer;


@end


