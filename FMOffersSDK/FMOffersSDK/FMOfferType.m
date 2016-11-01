//
//  FMOfferType.m
//  FMOffersSDK
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import "FMOfferType.h"

@implementation FMOfferType

- (id)initWithJSONObject:(NSDictionary *)jsobObject {
    if (self = [super init]) {
        self.offerTypeId    = [[jsobObject objectForKey:@"offer_type_id"] intValue];
        self.readable       = [jsobObject objectForKey:@"readable"];
    }
    
    return self;
}

@end
