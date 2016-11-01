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

+(instancetype)sharedInstance;

-(UIImage*)imageForOfferId:(int)offerId;
-(void)downloadImageForOfferId:(int)offerId url:(NSString*)urlStr completion:(void(^)(UIImage*))onDownloadComplete;

@end
