//
//  FMTimeToPayout.m
//  FMOffersSDK
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import "FMTimeToPayout.h"

@implementation FMTimeToPayout


- (id)initWithJSONObject:(NSDictionary *)jsonObject {
    
    if (self = [super init]) {
        self.amount     = [[jsonObject objectForKey:@"amount"] intValue];
        self.readable   = [jsonObject objectForKey:@"readable"];
    }
    
    return self;
}

@end
