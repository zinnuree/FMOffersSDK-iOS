//
//  FMOfferManager.h
//  FMOffersSDK
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMOfferInformation.h"


typedef void (^FMOfferDownloadCompletionHandler)(NSArray*, FMOfferInformation*, NSString*, NSString*, int, int, NSError*);

typedef void (^FMOfferAppendCompletionHandler)(NSArray*, FMOfferInformation*, NSString*, NSString*, int, NSError*);



extern NSString *const FMOfferSDKErrorDomain;


/**
 The central controller of the API calls
 */
@interface FMOfferManager : NSObject {
    
}


/**
 Responsible to create and return the single instance
 This requires no further description, as singleton is an established design pattern

 @return the singleton instance
 */
+ (FMOfferManager *)sharedInstance;

// make the default init unavailable, so that developer must use the singleton approach
//- (id)init __attribute__((unavailable("use sharedInstance")));



/**
 The API call handler needs some basic data before any API can be called using the SDK
 To keep the singleton clean (sharedInstance will be called from many places), this method is introduced.

 @param appId  The application ID provided by fyber
 @param userId The unique user id used to track user activity
 @param apiKey The API Key provided by fyber
 */
- (void)initializeWithAppId:(NSString*)appId
                     userId:(NSString*)userId
                     apiKey:(NSString*)apiKey;


/**
 Initiates the download (api call) for the list of offers for first page. It usually does not require the page number (which id by default 1). The response is also a bit different, since it additionally retuns the total number of pages. This value can be used for the subsequent calls.

 @param onComplete The block to execute when the asynchronous call finishes it's job
 */
- (void)downloadOffersWithCompletionHandler:(FMOfferDownloadCompletionHandler)onComplete;


/**
 Initiates the download (api call) for the list of offers for subsequent pages, should not be used for the first page becuase it is unable to return the total page count.

 @param pageNumber the current page number
 @param onComplete The block to execute when the asynchronous call finishes it's job
 */
- (void)downloadOffersForPageNumber:(int)pageNumber completionHandler:(FMOfferAppendCompletionHandler)onComplete;


@end

