//
//  FMOffer.m
//  FMOffersSDK
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import "FMOffer.h"
#import "FMOfferManager.h"
#import "FMOfferType.h"

@implementation FMOffer

- (id)initWithJSONObject:(NSDictionary*)jsonObject {
    
    if (self = [super init]) {
        self.title              = [jsonObject objectForKey:@"title"];
        self.offerId            = [[jsonObject objectForKey:@"offer_id"] intValue];
        self.teaser             = [jsonObject objectForKey:@"teaser"];
        self.requiredActions    = [jsonObject objectForKey:@"required_actions"];
        self.linkString         = [jsonObject objectForKey:@"link"];
        
        NSArray *offerTypesArray = [jsonObject objectForKey:@"offer_types"];
        NSMutableArray *offerTypes = [[NSMutableArray alloc] init];
        
        for (NSDictionary *offerTypeObj in offerTypesArray) {
            FMOfferType *offerType = [[FMOfferType alloc] initWithJSONObject:offerTypeObj];
            [offerTypes addObject:offerType];
        }
        
        self.offerTypes = offerTypes;
        
        NSDictionary *thumbnailObj = [jsonObject objectForKey:@"thumbnail"];
        self.thumbnail = [[FMThumbnail alloc] initWithJSONObject:thumbnailObj];
        
        self.payout = [[jsonObject objectForKey:@"payout"] intValue];
        
        NSDictionary *payoutObj = [jsonObject objectForKey:@"time_to_payout"];
        self.timeToPayout = [[FMTimeToPayout alloc] initWithJSONObject:payoutObj];
    }
    
    return self;
}

@end
