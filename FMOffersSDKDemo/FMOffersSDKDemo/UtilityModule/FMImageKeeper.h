//
//  FMStoreImageKeeper.h
//  FMOffersSDKDemo
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FMImageKeeper : NSObject {
    NSMutableDictionary *offerThumbnails;
}


/**
 Singleton object generator

 @return FMImageKeeper singleton object
 */
+(instancetype)sharedInstance;



/**
 Finds an image mapped with a specific offer id

 @param offerId used as cache mapping unique id

 @return the cached image if available, otherwise nil
 */
-(UIImage*)imageForOfferId:(int)offerId;


/**
 Initiates the image download process

 @param offerId            used as cache mapping unique id
 @param urlStr             image source
 @param onDownloadComplete call back function
 */
-(void)downloadImageForOfferId:(int)offerId url:(NSString*)urlStr completion:(void(^)(UIImage*))onDownloadComplete;


@end

