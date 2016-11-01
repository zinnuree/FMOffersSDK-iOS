//
//  FMOfferTableViewCell.h
//  FMOffersSDKDemo
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMOfferTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *thumbnailView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *teaserLabel;
@property (nonatomic, strong) IBOutlet UILabel *payoutLabel;

@end
