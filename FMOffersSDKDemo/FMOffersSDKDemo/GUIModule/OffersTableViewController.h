//
//  OffersTableViewController.h
//  FMOffersSDKDemo
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffersTableViewController : UITableViewController {
    
    BOOL initialLoadingInProgress;
    BOOL initialLoadingFailed;
    
    BOOL appendingInProgress;
    BOOL appendingFailed;
    
    int currentPage;
    NSMutableArray *offers;
}

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *appId;

@property (nonatomic, strong) IBOutlet UIView *footerView;
@property (nonatomic, strong) IBOutlet UILabel *footerLabel;

@end
