//
//  FMThumbnail.m
//  FMOffersSDK
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import "FMThumbnail.h"

@implementation FMThumbnail

- (id)initWithJSONObject:(NSDictionary *)jsonObject {
    if (self = [super init]) {
        self.lowResolutionURLString     = [jsonObject objectForKey:@"lowres"];
        self.highResolutionURLString    = [jsonObject objectForKey:@"hires"];
    }
    
    return self;
}

@end
