//
//  FMTimeToPayout.h
//  FMOffersSDK
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMTimeToPayout : NSObject

@property (nonatomic) int amount;
@property (nonatomic, strong) NSString *readable;


- (id)initWithJSONObject:(NSDictionary*)jsonObject;

@end
