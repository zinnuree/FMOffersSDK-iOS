//
//  FMOfferInformation.h
//  FMOffersSDK
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMOfferInformation : NSObject

@property (nonatomic, strong) NSString *appName;
@property (nonatomic) int appId;
@property (nonatomic, strong) NSString *virtualCurrency;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *supportUrlString;

@end
