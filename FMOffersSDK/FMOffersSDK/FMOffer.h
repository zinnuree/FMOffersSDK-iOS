//
//  FMOffer.h
//  FMOffersSDK
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMThumbnail.h"
#import "FMTimeToPayout.h"

@interface FMOffer : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic) int offerId;
@property (nonatomic, strong) NSString *teaser;
@property (nonatomic, strong) NSString *requiredActions;
@property (nonatomic, strong) NSURL *link;
@property (nonatomic, strong) NSArray *offerTypes;
@property (nonatomic, strong) FMThumbnail *thumbnail;
@property (nonatomic) int payout;
@property (nonatomic, strong) FMTimeToPayout *timeToPayout;

@end
