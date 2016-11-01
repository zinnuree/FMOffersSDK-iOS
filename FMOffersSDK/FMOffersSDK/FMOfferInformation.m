//
//  FMOfferInformation.m
//  FMOffersSDK
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import "FMOfferInformation.h"

@implementation FMOfferInformation


- (id)initWithJSONObject:(NSDictionary *)jsonObject {
    
    if (self = [super init]) {
        self.appName            = [jsonObject objectForKey:@"app_name"];
        self.appId              = [[jsonObject objectForKey:@"appid"] intValue];
        self.virtualCurrency    = [jsonObject objectForKey:@"virtual_currency"];
        self.country            = [jsonObject objectForKey:@"country"];
        self.language           = [jsonObject objectForKey:@"language"];
        self.supportUrlString   = [jsonObject objectForKey:@"support_url"];
    }
    
    return self;
}

@end
