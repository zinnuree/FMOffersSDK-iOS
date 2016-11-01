//
//  FMOfferManager.m
//  FMOffersSDK
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

// native iOS SDK frameworks
#import <Foundation/Foundation.h>
#import <AdSupport/AdSupport.h>
#import <UIKit/UIKit.h>

// self header
#import "FMOfferManager.h"

// data classes
#import "FMOffer.h"
#import "FMOfferInformation.h"
#import "FMOfferType.h"
#import "FMThumbnail.h"
#import "FMTimeToPayout.h"

// supporting classes
#import "NSString+SHA1.h"


// API constants
#define FMOffersAPIResponseFormat_JSON  @"json"
#define FMOffersAPIResponseFormat_XML   @"xml"

#define FMOffersAPIBaseURLString        @"http://api.fyber.com/feed"
#define FMOffersAPIVersionString        @"v1"
#define FMOffersAPIName                 @"offers"
#define FMOffersAPIResponseFormat       FMOffersAPIResponseFormat_JSON

#define FMOffersAPIRequestParam_AppID                       @"appid"
#define FMOffersAPIRequestParam_UserID                      @"uid"
#define FMOffersAPIRequestParam_IP                          @"ip"
#define FMOffersAPIRequestParam_Locale                      @"locale"
#define FMOffersAPIRequestParam_OSVersion                   @"os_version"
#define FMOffersAPIRequestParam_DeviceID                    @"device_id"
#define FMOffersAPIRequestParam_Timestamp                   @"timestamp"
#define FMOffersAPIRequestParam_OfferTypes                  @"offer_types"
#define FMOffersAPIRequestParam_AppleIDFA                   @"apple_idfa"
#define FMOffersAPIRequestParam_AppleIDFATrackingEnabled    @"apple_idfa_tracking_enabled"
#define FMOffersAPIRequestParam_PSTime                      @"ps_time"
#define FMOffersAPIRequestParam_PageNumber                  @"page"
#define FMOffersAPIRequestParam_DeviceType                  @"device"
#define FMOffersAPIRequestParam_HashKey                     @"hashkey"

#define FMOffersAPIRequestCustomParamPrefix                 @"pub"


static NSString *const ip               = @"109.235.143.113";   // as indicated in the challenge description
static NSString *const locale           = @"DE";                // as indicated in the challenge description
static NSString *const offerTypes       = @"112";               // as indicated in the challenge description
static NSString *const trackingEnabled  = @"true";              // not mentioned about it, but since it is mandatory, set to true

NSString *const FMOfferSDKErrorDomain = @"com.fyber.test.sdkerror";

@interface FMOfferManager ()

@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *userId;

@end


@implementation FMOfferManager

static BOOL initialized = NO;



+ (FMOfferManager *)sharedInstance {
    
    static FMOfferManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FMOfferManager alloc] init];
    });
    return sharedInstance;
}

- (void)initializeWithAppId:(NSString*)appId userId:(NSString*)userId apiKey:(NSString*)apiKey {
    self.appId = appId;
    self.userId = userId;
    self.apiKey = apiKey;
    initialized = YES;
}


- (void)downloadOffersWithCompletionHandler:(FMOfferDownloadCompletionHandler)onComplete {

    if (!initialized) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"SDK not initialized.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"SDK not initialized", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please initialize with appid, userId and apiKey", nil)};
        NSError *error = [NSError errorWithDomain:FMOfferSDKErrorDomain code:-1 userInfo:userInfo];
        
        onComplete(nil, nil, nil, nil, 0, 0, error);
        return;
    }
    
    // the device advertizing identifier
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // the value is in seconds offest from universal reference date
    NSString *timestampStr = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    
    // as explained in the API doc
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    
    // prepare the params dictionary
    NSDictionary *parameters = @{FMOffersAPIRequestParam_AppID                      : self.appId,
                                 FMOffersAPIRequestParam_UserID                     : self.userId,
                                 FMOffersAPIRequestParam_IP                         : ip,
                                 FMOffersAPIRequestParam_Locale                     : locale,
                                 FMOffersAPIRequestParam_OfferTypes                 : offerTypes,
                                 FMOffersAPIRequestParam_AppleIDFA                  : idfa,
                                 FMOffersAPIRequestParam_AppleIDFATrackingEnabled   : trackingEnabled,
                                 FMOffersAPIRequestParam_Timestamp                  : timestampStr,
                                 FMOffersAPIRequestParam_OSVersion                  : osVersion};
    
    // create the hashcode based on params list
    NSString *sha1Hash = [self hashKeyFromParameters:parameters apiKey:self.apiKey];
    
    // prepare params as part of the URL
    NSString *urlParams = [self urlStringWithParameters:parameters hashValue:sha1Hash];
    
    // prepare the URL string
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:FMOffersAPIBaseURLString];
    [urlString appendFormat:@"/%@", FMOffersAPIVersionString];
    [urlString appendFormat:@"/%@.%@", FMOffersAPIName, FMOffersAPIResponseFormat];
    [urlString appendString:@"?"];
    [urlString appendString:urlParams];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:urlString];
    
    void (^completionHandler)(NSData*, NSURLResponse*, NSError*);
    completionHandler = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      
        if (error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                onComplete(nil, nil, nil, nil, 0, 0, error);
            });
            
            return;
        }
        
        if (response == nil) {
            //return error
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Invalid respone.", nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Response is nil", nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please check with API administrator", nil)};
            
            NSError *error = [NSError errorWithDomain:FMOfferSDKErrorDomain code:-2 userInfo:userInfo];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                onComplete(nil, nil, nil, nil, 0, 0, error);
            });
            
            return;
        }
        
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
        long statusCode = urlResponse.statusCode;
        
        if (statusCode != 200) {
            //return error
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Http error.", nil),
                                       NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat: @"HTTP Status Code: %ld", statusCode],
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please check with API administrator", nil)};
            
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:statusCode userInfo:userInfo];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                onComplete(nil, nil, nil, nil, 0, 0, error);
            });
        }
        
        if (data == nil || data.length == 0) {
            
            //200 No Content (correct and successful request, but no offers are available for this user)
            dispatch_async(dispatch_get_main_queue(), ^{
                onComplete(@[], nil, @"OK", @"OK", 0, 0, nil);
            });
            return;
        }
        
        // read signature from header
        NSDictionary *responseHeaders = [urlResponse allHeaderFields];
        NSString *responseSignature = [responseHeaders objectForKey:@"X-Sponsorpay-Response-Signature"];
        NSString *hashKey = [self hashKeyForResponseData:data apiKey:self.apiKey];
        
        if (![responseSignature isEqualToString:hashKey]) {
            //TODO: 
        }
        
        NSError *jsonError = nil;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        if (jsonError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                onComplete(nil, nil, nil, nil, 0, 0, error);
            });
            return;
        }
        
        NSString *code = [jsonObject objectForKey:@"code"];
        NSString *message = [jsonObject objectForKey:@"message"];
        
        int count = [[jsonObject objectForKey:@"count"] intValue];
        int pages = [[jsonObject objectForKey:@"pages"] intValue];
        
        NSDictionary *informationObj = [jsonObject objectForKey:@"information"];
        FMOfferInformation *information = [[FMOfferInformation alloc] initWithJSONObject:informationObj];
        
        NSArray *offersArray = [jsonObject objectForKey:@"offers"];
        NSMutableArray *offers = [[NSMutableArray alloc] init];
        
        for (NSDictionary *offerObj in offersArray) {
            FMOffer *offer = [[FMOffer alloc] initWithJSONObject:offerObj];
            [offers addObject:offer];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // call back with received data
            onComplete([NSArray arrayWithArray:offers],
                       information,
                       code, message,
                       count, pages, nil);
        });
    };
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:completionHandler];
    [dataTask resume];
}

- (void)downloadOffersForPageNumber:(int)pageNumber completionHandler:(FMOfferAppendCompletionHandler)onComplete {
    
    if (!initialized) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"SDK not initialized.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"SDK not initialized", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please initialize with appid, userId and apiKey", nil)};
        NSError *error = [NSError errorWithDomain:FMOfferSDKErrorDomain code:-1 userInfo:userInfo];
        
        // at this stage we are already in main thread
        onComplete(nil, nil, nil, nil, 0, error);
        return;
    }
    
    // the device advertizing identifier
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // the value is in seconds offest from universal reference date
    NSString *timestampStr = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    
    // as explained in the API doc
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    
    // convert pageNumber to string
    NSString *pageNumberStr = [NSString stringWithFormat:@"%d", pageNumber];
    
    // prepare the params dictionary
    NSDictionary *parameters = @{FMOffersAPIRequestParam_AppID                      : self.appId,
                                 FMOffersAPIRequestParam_UserID                     : self.userId,
                                 FMOffersAPIRequestParam_IP                         : ip,
                                 FMOffersAPIRequestParam_Locale                     : locale,
                                 FMOffersAPIRequestParam_OfferTypes                 : offerTypes,
                                 FMOffersAPIRequestParam_AppleIDFA                  : idfa,
                                 FMOffersAPIRequestParam_AppleIDFATrackingEnabled   : trackingEnabled,
                                 FMOffersAPIRequestParam_Timestamp                  : timestampStr,
                                 FMOffersAPIRequestParam_OSVersion                  : osVersion,
                                 FMOffersAPIRequestParam_PageNumber                 : pageNumberStr};
    
    NSString *sha1Hash = [self hashKeyFromParameters:parameters apiKey:self.apiKey];
    NSString *urlParams = [self urlStringWithParameters:parameters hashValue:sha1Hash];
    
    // prepare the URL string
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:FMOffersAPIBaseURLString];
    [urlString appendFormat:@"/%@", FMOffersAPIVersionString];
    [urlString appendFormat:@"/%@.%@", FMOffersAPIName, FMOffersAPIResponseFormat];
    [urlString appendString:@"?"];
    [urlString appendString:urlParams];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // preapare the API call back
    void (^completionHandler)(NSData*, NSURLResponse*, NSError*);
    completionHandler = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                onComplete(nil, nil, nil, nil, 0, error);
            });
            
            return;
        }
        
        if (response == nil) {
            //return error
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Invalid respone.", nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Response is nil", nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please check with API administrator", nil)};
            
            NSError *error = [NSError errorWithDomain:FMOfferSDKErrorDomain code:-2 userInfo:userInfo];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                onComplete(nil, nil, nil, nil, 0, error);
            });
        }
        
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
        long statusCode = urlResponse.statusCode;
        
        if (statusCode != 200) {
            //return error
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Http error.", nil),
                                       NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat: @"HTTP Status Code: %ld", statusCode],
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please check with API administrator", nil)};
            
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:statusCode userInfo:userInfo];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                onComplete(nil, nil, nil, nil, 0, error);
            });
        }
        
        if (data == nil || data.length == 0) {
            
            //200 No Content (correct and successful request, but no offers are available for this user)
            dispatch_async(dispatch_get_main_queue(), ^{
                onComplete(@[], nil, @"OK", @"OK", 0, nil);
            });
            
            return;
        }
        
        // read signature from header
        NSDictionary *responseHeaders = [urlResponse allHeaderFields];
        NSString *responseSignature = [responseHeaders objectForKey:@"X-Sponsorpay-Response-Signature"];
        NSString *hashKey = [self hashKeyForResponseData:data apiKey:self.apiKey];
        
        if (![responseSignature isEqualToString:hashKey]) {
            //TODO:
        }
        
        NSError *jsonError = nil;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        if (jsonError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                onComplete(nil, nil, nil, nil, 0, error);
            });
            
            return;
        }
        
        NSString *code = [jsonObject objectForKey:@"code"];
        NSString *message = [jsonObject objectForKey:@"message"];
        
        int count = [[jsonObject objectForKey:@"count"] intValue];
        
        NSDictionary *informationObj = [jsonObject objectForKey:@"information"];
        FMOfferInformation *information = [[FMOfferInformation alloc] initWithJSONObject:informationObj];
        
        NSArray *offersArray = [jsonObject objectForKey:@"offers"];
        NSMutableArray *offers = [[NSMutableArray alloc] init];
        
        for (NSDictionary *offerObj in offersArray) {
            FMOffer *offer = [[FMOffer alloc] initWithJSONObject:offerObj];
            [offers addObject:offer];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            onComplete([NSArray arrayWithArray:offers],
                       information,
                       code, message,
                       count, nil);
        });
    };
    
    // start API call
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:completionHandler];
    [dataTask resume];
}

- (NSString*)hashKeyForResponseData:(NSData*)data apiKey:(NSString*)apiKey {
    
    NSMutableString *responseString = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [responseString appendString:apiKey];
    
    return [responseString sha1];
}


- (NSString*)urlStringWithParameters:(NSDictionary*)parameters hashValue:(NSString*)sha1 {
    
    // get all the available keys in the parameters dictionary
    NSArray *allKeys = [parameters allKeys];
    
    // Concatenate all pairs using = between key and value and & between the pairs
    NSMutableString *paramsString = [[NSMutableString alloc] init];
    
    BOOL avoidDelimeter = YES;          // the first parameter need not be separated with a delimeter
    for (NSString *key in allKeys) {
        
        if (avoidDelimeter) {           // first time, there is no delimeter, avoid is true
            avoidDelimeter = NO;
        }
        else {
            
            // add delimeter
            [paramsString appendString:@"&"];
        }
        
        // URL encoding is now necessary, and should be applied before hashing
        
        NSString *value = [parameters objectForKey:key];
        NSCharacterSet *allowedCharacters = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *urlEncodedValue = [value stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        
        [paramsString appendFormat:@"%@=%@", key, urlEncodedValue];
    }
    
    // Now add the hashkey as an additional parameter, make sure the hash value is in lowercase
    [paramsString appendFormat:@"&%@=%@", FMOffersAPIRequestParam_HashKey, [sha1 lowercaseString]];
    
    // return a non-mutable version of the prepared string
    return [NSString stringWithString:paramsString];
}


/**
 Creates a SHA1 hash key which is necessary for the Fyber Mobile Offers API
 As explained @ http://developer.fyber.com/content/current/ios/offer-wall/offer-api/

 @param parameters The list of key value pairs as Dictionary
 @param apiKey The Fyber api key also necessary for hashing

 @return The SHA1 hash value
 */
- (NSString*)hashKeyFromParameters:(NSDictionary*)parameters apiKey:(NSString*)apiKey {
    
    // Order theses pairs alphabetically by parameter name (i.e. the the keys in the dictionary)
    
    // get all the available keys in the parameters dictionary
    NSArray *allKeys = [parameters allKeys];
    
    // sort them in alphabetical order
    NSArray *sortedKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *key1 = (NSString*)obj1;
        NSString *key2 = (NSString*)obj2;
        return [key1 compare:key2];
    }];
    
    
    // Concatenate all pairs using = between key and value and & between the pairs
    NSMutableString *paramsString = [[NSMutableString alloc] init];
    
    
    // Get all request parameters and their values. we already have them in the parameters dictionary
    
    BOOL avoidDelimeter = YES;          // the first parameter need not be separated with a delimeter
    for (NSString *key in sortedKeys) {
        
        if (avoidDelimeter) {           // first time, there is no delimeter, avoid is true
            avoidDelimeter = NO;
        }
        else {
            
            // add delimeter
            [paramsString appendString:@"&"];
        }
        
        // URL encoding is not necessary, and should not be applied before hashing
        
        [paramsString appendFormat:@"%@=%@", key, [parameters objectForKey:key]];
    }
    
    // Concatenate the resulting string with & and the API Key handed out to you by Fyber
    [paramsString appendString:@"&"];
    [paramsString appendString:apiKey];
    
    // create and return hash value from param string
    
    return [paramsString sha1];
}


@end
