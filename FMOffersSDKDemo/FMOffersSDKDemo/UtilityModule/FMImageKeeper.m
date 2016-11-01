//
//  FMStoreImageKeeper.m
//  FMOffersSDKDemo
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import "FMImageKeeper.h"

@implementation FMImageKeeper

+(instancetype)sharedInstance
{
    static FMImageKeeper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FMImageKeeper alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    if (self = [super init]) {
        offerThumbnails = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSString*)imageIdForOfferId:(int)offerId {
    return [NSString stringWithFormat:@"%d", offerId];
}

-(UIImage*)imageForOfferId:(int)offerId {
    NSString *imageId = [self imageIdForOfferId:offerId];
    return [offerThumbnails objectForKey:imageId];
}

-(void)downloadImageForOfferId:(int)offerId url:(NSString *)urlStr completion:(void (^)(UIImage *))onDownloadComplete {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *url = [NSURL URLWithString:urlStr];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        if (image) {
            // cache image silently against store id
            NSString *imageId = [self imageIdForOfferId:offerId];
            [offerThumbnails setObject:image forKey:imageId];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // call back with downloaded image on main thread
            onDownloadComplete(image);
        });
    });
}

@end
